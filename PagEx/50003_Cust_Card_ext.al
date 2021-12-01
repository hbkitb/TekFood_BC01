pageextension 50004 "Customer Card ITB" extends "Customer Card"
{
    layout
    {

    }

    actions
    {
        addfirst(processing)
        {
            action(ACPayment)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'AC Betaling';
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                //ShortCutKey = 'F9';
                ToolTip = '';

                trigger OnAction()

                var
                    Cust: Record Customer;

                begin
                    //Måske skal det køres fra page
                    Cust.Reset;
                    Cust.SetRange("No.", Rec."No.");

                    if Cust.FindSet then
                        Page.Run(Page::ITB_TEST_Ind_Bar, Cust);

                    /*
                    CurrentJnlBatchName := GetRangeMax("Journal Batch Name");
                    if IsSimplePage then
                        if GeneralLedgerSetup."Post with Job Queue" then
                            NewDocumentNo()
                        else
                            SetDataForSimpleModeOnPost;
                    SetJobQueueVisibility();
                    CurrPage.Update(false);
                    */
                end;
            }
        }
    }

    var

}

