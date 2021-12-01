codeunit 50004 "Dimensions"
{
    trigger OnRun()
    begin

    end;

    var

    procedure InsertDefaultDimension(DimensionCode: Code[20]; DimensionValueCode: Code[20]; MandDimension: Text[10]; EntryNo: Code[20]; TableId: Integer);
    var
        "Default Dimension": Record "Default Dimension";
        "Dimension Value": Record "Dimension Value";

    begin
        If (DimensionCode <> '') or (MandDimension = '1') then begin
            "Default Dimension".Init();
            "Default Dimension"."Table ID" := TableId;
            "Default Dimension"."No." := EntryNo;
            "Default Dimension"."Dimension Code" := DimensionCode;
            "Default Dimension"."Dimension Value Code" := DimensionValueCode;
            IF MandDimension = '1' then
                "Default Dimension"."Value Posting" := "Default Dimension"."Value Posting"::"Code Mandatory";
            "Default Dimension".Insert();
        end;
    end;

    procedure InsertDefaultDimensionBase(DimensionCode: Code[20]; DimensionValueCode: Code[20]; EntryNo: Code[20]; TableId: Integer);
    var
        "Default Dimension": Record "Default Dimension";
        "Dimension Value": Record "Dimension Value";

    begin
        If (DimensionCode <> '') then begin
            "Default Dimension".Init();
            "Default Dimension"."Table ID" := TableId;
            "Default Dimension"."No." := EntryNo;
            "Default Dimension"."Dimension Code" := DimensionCode;
            "Default Dimension"."Dimension Value Code" := DimensionValueCode;
        end;
    end;

    procedure InsertDimensionEntrySetId(DimensionCode: Code[20]; DimensionValueCode: Code[20]; TableId: Integer);
    var
        DV: Record "Dimension Value";
        DVCreate: Record "Dimension Value";
        DB: Record "Dimension Buffer";
        DS: Record "Dimension Set Entry" temporary;

    begin

        DB.Init();
        DB."Table ID" := TableId;
        DB."Entry No." := 1;
        DB."Dimension Code" := DimensionCode;
        DB."Dimension Value Code" := DimensionValueCode;
        DB.Insert();

        DVCreate.SetFilter("Dimension Code", '%1', DimensionCode);
        DVCreate.SetFilter(Code, '%1', DimensionValueCode);
        if not DVCreate.FindSet() then begin
            DVCreate.Init();
            DVCreate."Dimension Code" := DimensionCode;
            DVCreate.Code := DimensionValueCode;
            DVCreate.Name := 'C5 Konvertering';
            DVCreate.Insert();
        end;

        DS.Init;
        DS."Dimension Code" := DimensionCode;
        DS."Dimension Value Code" := DimensionValueCode;
        DV.SetFilter(DV."Dimension Code", DimensionCode);
        DV.SetFilter(DV.Code, DimensionValueCode);
        if DV.FindSet() then
            DS."Dimension Value ID" := DV."Dimension Value ID";
        DS.Insert();
    end;

}
