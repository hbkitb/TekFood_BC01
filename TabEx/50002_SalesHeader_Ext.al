tableextension 50002 "Sales Header ITB" extends "Sales Header"
{
    fields
    {
        field(50000; EANNr; Text[50])
        {
            Caption = 'EANNr';
            trigger OnValidate()
            var

            begin

            end;


        }


    }

    var

}