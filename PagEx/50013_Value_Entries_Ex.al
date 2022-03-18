pageextension 50013 "Value_Entries_Ext" extends "Value Entries"
{
    layout
    {
        addafter(Description)
        {

            field(UnitPrice; UnitPrice)
            {
                ApplicationArea = all;

                trigger OnValidate()
                var

                begin


                end;
            }



        }


    }

    trigger OnAfterGetRecord()
    var

    begin
        if Rec."Invoiced Quantity" <> 0 then
            UnitPrice := -Rec."Sales Amount (Actual)" / Rec."Invoiced Quantity";
    end;

    var
        UnitPrice: Decimal;

}