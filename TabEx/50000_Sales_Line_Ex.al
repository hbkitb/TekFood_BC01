tableextension 50000 "Sales Line ITB" extends "Sales Line"
{
    fields
    {
        field(50000; EANNr; Text[50])
        {
            Caption = 'EANNr';
            trigger OnValidate()
            var
                item: Record Item;
            begin
                if type = Type::Item then begin


                end;
            end;


        }

        field(50001; QtyColli; Decimal)
        {
            Caption = 'AntalColli';
            trigger OnValidate()
            var
            //item: Record Item;
            begin
                if type = Type::Item then begin


                end;
            end;


        }

        field(50002; Mangde; Text[20])
        {
            Caption = 'Mængde';
            trigger OnValidate()
            var
            //item: Record Item;
            begin
                //if type = Type::Item then begin


                //end;
            end;


        }

        field(50003; PantLineNo; Integer)
        {
            Caption = 'Pant LinieNr';
            trigger OnValidate()
            var
            //item: Record Item;
            begin
                //if type = Type::Item then begin


                //end;
            end;


        }


    }

    trigger OnAfterInsert()

    var

    begin

    end;

    trigger OnAfterModify()

    var
        pantLine: Record "Sales Line";

    begin
        if Rec.PantLineNo <> 0 then begin
            pantLine.Reset;
            pantLine.SetRange("Document No.", Rec."Document No.");
            pantLine.SetRange("Document Type", Rec."Document Type");
            pantLine.SetRange("Line No.", Rec.PantLineNo);
            if pantLine.FindSet then begin
                if pantLine.Quantity <> Rec.Quantity then begin
                    pantLine.validate(Quantity, Rec.Quantity);
                    pantLine.Modify;
                end;
            end;
        end;
    end;

    trigger OnAfterDelete()

    var
        pantLine: Record "Sales Line";
    begin
        if Rec.PantLineNo <> 0 then begin
            pantLine.Reset;
            pantLine.SetRange("Document No.", Rec."Document No.");
            pantLine.SetRange("Document Type", Rec."Document Type");
            pantLine.SetRange("Line No.", Rec.PantLineNo);
            if pantLine.FindSet then begin
                pantLine.Delete;
            end;

        end;
    end;


    var


}