pageextension 50011 "ITB_Activities_Cue" extends "O365 Activities"
{
    layout
    {
        //addlast("Ongoing Sales")
        addafter("Ongoing Sales Quotes")
        {
            /* 111021
             field("Ongoing WEB-Orders"; Rec."Ongoing e-Orders")
             {
                 //ApplicationArea = all;
                 ApplicationArea = Basic, Suite;
                 Caption = 'DANVA WEB-Ordrer';
                 DrillDownPageID = ITB_IND_SIM_Ordrer;
                 ToolTip = 'WEB Ordrer med status ankommet og accepter';
             }
             111021  */
        }

        /*
                addafter("Ongoing Sales Invoices")
                {
                    field("Ongoing Sales Credit Memos"; Rec."Ongoing Sales Credit Memos")
                    {
                        //ApplicationArea = all;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Kreditnotaer';
                        DrillDownPageID = "Sales Credit Memos";
                        ToolTip = 'Kreditnotaer som ikke er bogfÃ¸rt';
                    }
                }
                */
    }

    actions
    {

    }

    var

}