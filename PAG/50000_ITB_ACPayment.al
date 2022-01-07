page 50000 "ITB_TEST_Ind_Bar"
{

    PageType = List;
    SourceTable = Customer;
    Caption = 'AC Betaling';
    DelayedInsert = true;
    InsertAllowed = false;
    //ApplicationArea = All;
    //UsageCategory = Lists;

    layout
    {
        area(content)
        {

            repeater(Generel)
            {

                field(PayInvoice; PayInvoice)
                {
                    ApplicationArea = All;
                    Caption = 'KONTANT';

                    trigger OnValidate()
                    begin
                        if PayInvoice <> 0 then
                            PayCard := 0;
                    end;

                }


                field(PayCard; PayCard)
                {
                    ApplicationArea = All;
                    Caption = 'DANKORT';

                    trigger OnValidate()
                    begin
                        if PayCard <> 0 then
                            PayInvoice := 0;
                    end;

                }

                field(Rest; Rest)
                {
                    ApplicationArea = All;
                    Caption = 'REST';
                    Editable = false;
                    //Visible = false;


                }



            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                action(ACPayment)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'AC Betaling';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ToolTip = '';

                    trigger OnAction()
                    var
                        GenJnlBatch: Record "Gen. Journal Batch";
                        NoSeriesMgt: Codeunit NoSeriesManagement;
                        Betal: Decimal;
                        BetalDAN: Decimal;
                    begin
                        if (PayInvoice <> 0) OR (PayCard <> 0) then begin
                            Betal := PayInvoice;
                            BetalDAN := PayCard;
                            PayInvoice := 0;
                            PayCard := 0;
                            //Måske skal det køres fra page
                            if (Betal <> 0) or (BetalDAN <> 0) then begin
                                PayJour.Reset;
                                PayJour.Init;
                                PayJour."Journal Template Name" := 'AC01';
                                PayJour."Journal Batch Name" := 'AC01';
                                PayJour."Document Type" := PayJour."Document Type"::Payment;
                                if (Betal < 0) or (BetalDAN < 0) then
                                    PayJour."Document Type" := PayJour."Document Type"::" ";
                                PayJour."Line No." := PayLine + 10000;
                                PayLine := PayLine + 10000;
                                PayJour."Account Type" := PayJour."Account Type"::Customer;
                                PayJour."Account No." := Rec."No.";
                                PayJour.Description := 'AC Betaling-' + Rec.Name;
                                PayJour."Posting Date" := Today;

                                GenJnlBatch.GET(PayJour."Journal Template Name", PayJour."Journal Batch Name");
                                IF GenJnlBatch."No. Series" <> '' THEN BEGIN
                                    CLEAR(NoSeriesMgt);
                                    PayJour."Document No." := NoSeriesMgt.TryGetNextNo(GenJnlBatch."No. Series", PayJour."Posting Date");
                                END;

                                //PayJour.Validate("Document No.");
                                PayJour."Document Date" := PayJour."Posting Date";
                                PayJour."Source Code" := 'KASSEKLD';
                                PayJour."Bal. Account Type" := PayJour."Bal. Account Type"::"G/L Account";

                                if Betal <> 0 then begin
                                    PayJour."Bal. Account No." := '18100';   //Kasse
                                    PayJour."Amount (LCY)" := -Betal;
                                    PayJour.Amount := -Betal;
                                end
                                else begin
                                    PayJour."Bal. Account No." := '18150';   //Kasse
                                    PayJour."Amount (LCY)" := -BetalDAN;
                                    PayJour.Amount := -BetalDAN
                                end;


                                PayJour.Insert;

                                CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", PayJour);
                            end;



                        end //Payinvoice større end 0
                        else
                            Message('Bløb SKAL være større end 0 !');

                        Rec.CalcFields("Balance (LCY)");
                        Rest := Rec."Balance (LCY)";

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
    }

    trigger OnOpenPage()

    var
        CustSaldo: Record Customer;

    begin
        //Her kommer beregning af saldo
        /*
        CustSaldo.Reset;
        CustSaldo.SetRange("No.", Rec."Bill-to Customer No.");
        if CustSaldo.FindSet then begin
            CustSaldo.CalcFields("Balance (LCY)");
            Rest := CustSaldo."Balance (LCY)";
        end;
        */
        Rec.CalcFields("Balance (LCY)");
        Rest := Rec."Balance (LCY)";




    end;

    var
        Rest: Decimal;
        PayInvoice: Decimal;
        PayCard: Decimal;

        PayJour: Record "Gen. Journal Line";
        PayLine: Integer;


}