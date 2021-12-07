pageextension 50008 "Purch ReqLines Subform ITB" extends "Purchase Quote Subform"
{
    layout
    {
        //addlast(Content)
        addafter(Type)
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



                end;
            }


        }
    }

    actions
    {

    }

    var

}