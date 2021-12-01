tableextension 50003 "Purch Line ITB" extends "Purchase Line"
{
    fields
    {


    }

    trigger OnAfterInsert()

    var
        ItemDC: Record Item;
        InDirect: Decimal;
        ExchRate: Decimal;
        UnitCostBefore: Decimal;
        UnitCostLCYBefore: Decimal;
    begin
        ItemDC.Reset;
        ItemDC.SetRange("No.", Rec."No.");
        if ItemDC.FindSet then begin
            if (ItemDC.FreightCost <> 0) or (ItemDC.FeeCost <> 0) or (ItemDC.DivCost <> 0) then begin
                if Rec."Unit Cost" <> 0 then
                    ExchRate := Rec."Unit Cost (LCY)" / Rec."Unit Cost"
                else
                    ExchRate := 1;
                if (ExchRate <> 1) and (ExchRate <> 0) then begin
                    UnitCostBefore := rec."Unit Cost";
                    UnitCostLCYBefore := rec."Unit Cost (LCY)";
                    //Rec."Unit Cost" := 0;
                    //Rec."Unit Cost (LCY)" := 0;
                    InDirect := ItemDC.FreightCost + ItemDC.FeeCost + ItemDC.DivCost;
                    rec."Unit Cost (LCY)" := UnitCostLCYBefore + InDirect;
                    InDirect := InDirect / ExchRate;
                    rec."Unit Cost" := UnitCostBefore + InDirect;
                    Rec."Indirect Cost %" := (rec."Unit Cost" - "Direct Unit Cost") / "Direct Unit Cost" * 100;
                    Rec.Validate(Quantity);
                    Rec.Modify;
                end
                else begin
                    UnitCostBefore := rec."Unit Cost";
                    UnitCostLCYBefore := rec."Unit Cost (LCY)";
                    //Rec."Unit Cost" := 0;
                    //Rec."Unit Cost (LCY)" := 0;
                    InDirect := ItemDC.FreightCost + ItemDC.FeeCost + ItemDC.DivCost;
                    rec."Unit Cost (LCY)" := UnitCostLCYBefore + InDirect;
                    InDirect := InDirect; //* ExchRate;
                    rec."Unit Cost" := UnitCostBefore + InDirect;
                    Rec."Indirect Cost %" := (rec."Unit Cost" - "Direct Unit Cost") / "Direct Unit Cost" * 100;
                    Rec.Validate(Quantity);
                    Rec.Modify;
                end;
            end;
        end;
    end;


    trigger OnAfterModify()

    var

    begin

    end;



    trigger OnAfterDelete()

    var

    begin


    end;


    var


}