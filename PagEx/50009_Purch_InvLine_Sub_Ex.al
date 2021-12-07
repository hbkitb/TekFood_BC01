pageextension 50009 "Purch InvLines Subform ITB" extends "Purch. Invoice Subform"
{
    layout
    {
        //addlast(Content)
        addafter("No.")
        {


            field(QtyColli; Rec.QtyColli)
            {
                ApplicationArea = all;

                trigger OnValidate()
                var
                    EanItem: Record Item;
                    EanItem02: Record Item;
                    EanTemp: Text[50];
                    SalesItemNo: Code[20];
                    Robert: Text[30];
                    Colli: Decimal;

                begin
                    Robert := '';
                    SalesItemNo := '';
                    //EanTemp := Rec.EANNr;
                    EanItem.Reset;
                    EanItem.SetRange("No.", Rec."No.");
                    if EanItem.FindSet then begin
                        if ((EanItem.KartAntal <> 0) and (EanItem.EANNr02 <> '')) then
                            Rec.validate(Quantity, rec.QtyColli * EanItem.KartAntal)
                        else
                            rec.validate(Quantity, rec.QtyColli);
                    end
                    else
                        rec.validate(Quantity, rec.QtyColli);

                    Rec.Validate("Unit Cost");
                    Rec.Validate("Unit Cost (LCY)");
                    rec.Validate("Direct Unit Cost");

                end;
            }


        }
    }

    actions
    {

    }

    var

}