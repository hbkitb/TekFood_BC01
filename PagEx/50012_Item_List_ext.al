pageextension 50012 "Item_List_Ext" extends "Item List"
{
    layout
    {
        addafter(Description)
        {

            field(Mangde; Rec.Mangde)
            {
                ApplicationArea = all;

                trigger OnValidate()
                var

                begin


                end;
            }



        }


    }

}
