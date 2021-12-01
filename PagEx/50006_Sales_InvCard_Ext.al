pageextension 50006 "Sales InvCard ITB" extends "Sales Invoice"
{
    layout
    {
        //addlast(Content)
        addafter("Work Description")
        {
            /*
            field(EANNr; Rec.EANNr)
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
                    SalesLine: Record "Sales Line";
                    LineNo: Decimal;

                begin
                    SalesLine.Reset;
                    SalesLine.SetRange("Document No.", Rec."No.");
                    SalesLine.SetRange("Document Type", Rec."Document Type");
                    if SalesLine.FindSet then
                        repeat
                            if LineNo <= SalesLine."Line No." then
                                LineNo := SalesLine."Line No.";
                        until SalesLine.Next = 0;

                    Robert := '';
                    SalesItemNo := '';
                    EanTemp := Rec.EANNr;
                    EanItem.Reset;
                    EanItem.SetRange(EANNr, Rec.EANNr);
                    if EanItem.FindSet then
                        SalesItemNo := EanItem."No."
                    else begin

                        EanItem.Reset;
                        EanItem.SetRange(EANNr02, Rec.EANNr);
                        if EanItem.FindSet then
                            SalesItemNo := EanItem."No."

                    end;

                    if SalesItemNo = '' then begin
                        if ((StrLen(Rec.EANNr) >= 15) and (CopyStr(Rec.EANNr, 1, 1) = 'ù')) then
                            IF CopyStr(Rec.EANNr, 1, 2) = 'ùC' THEN begin
                                Robert := copystr(Rec.EanNr, 4, 20);
                                Rec.EanNr := CopyStr(Rec.EanNr, 4, 16);
                            end
                            else begin
                                Robert := CopyStr(Rec.EanNr, 2, 20);
                                Rec.EanNr := CopyStr(Rec.EanNr, 2, 16);
                            end
                        else begin
                            IF ((StrLen(Rec.EANNr) > 15) and (CopyStr(Rec.EANNr, 1, 1) = ']')) then begin
                                IF CopyStr(Rec.EANNr, 1, 2) = ']C' THEN begin
                                    Robert := copystr(Rec.EanNr, 4, 20);
                                    Rec.EanNr := CopyStr(Rec.EanNr, 4, 16);
                                end
                                else begin
                                    Robert := CopyStr(Rec.EanNr, 2, 20);
                                    Rec.EanNr := CopyStr(Rec.EanNr, 2, 16);
                                end
                            end
                            else begin
                                IF StrLen(Rec.EANNr) > 15 THEN begin
                                    Robert := CopyStr(Rec.EanNr, 1, 20);
                                    Rec.EanNr := CopyStr(Rec.EanNr, 1, 16);

                                end;
                            end;
                        end;

                    end;

                    if SalesItemNo = '' then begin
                        IF StrLen(Rec.EANNr) = 16 then
                            Rec.EANNr := Robert;
                        //SubStr(SalesLine.EANNr,1,StrLen(SalesLine.EANNr)-4)
                    end;
                    EanTemp := Rec.EANNr;  //Så skal varenummer mv på linien og valideres mv

                    //else begin  testing 121021
                    EanItem02.Reset;
                    EanItem02.SetRange(EANNr02, Rec.EANNr);

                    if EanItem02.FindSet then begin
                        //Rec."No." := EanItem."No.";
                        EanItem.Reset;
                        EanItem.SetRange(EANNr, Rec.EANNr);
                        if EanItem.FindSet then begin
                            SalesItemNo := EanItem02."No.";
                            Clear(SalesLine);

                            LineNo := LineNo + 10000;
                            SalesLine.Validate("Line No.", LineNo);

                            SalesLine.Validate("Document Type", Rec."Document Type");
                            SalesLine.Validate("Document No.", Rec."No.");

                            SalesLine.Type := SalesLine.Type::Item;
                            SalesLine.Validate("No.", EanItem02."No.");

                            Colli := EanItem02.KartAntal;

                            if Colli <> 0 then begin

                                SalesLine.QtyColli := Colli;
                                SalesLine.Validate(Quantity, Colli);

                            end
                            else begin
                                SalesLine.QtyColli := 0;
                                SalesLine.Validate(Quantity, 1);
                            end;
                            //NoOnAfterValidate();
                            //UpdateEditableOnRow();
                            //ShowShortcutDimCode(ShortcutDimCode);

                            //QuantityOnAfterValidate();
                            //UpdateTypeText();
                            //DeltaUpdateTotals();
                            SalesLine.EANNr := EanItem02.EANNr;
                            SalesLine.Insert(true);



                            CurrPage.Update();

                            //rec.FindLast;



                            //rec.SetRange("Line No.", 0);
                            //rec.FindFirst;
                            //rec.Reset;


                        end;

                        //Rec.EANNr := EanTemp;
                    end
                    else begin
                        EanItem.Reset;
                        EanItem.SetRange(EANNr, Rec.EANNr);

                        if EanItem.FindSet then begin
                            Clear(SalesLine);

                            LineNo := LineNo + 10000;
                            SalesLine.Validate("Line No.", LineNo);

                            SalesLine.Validate("Document Type", Rec."Document Type");
                            SalesLine.Validate("Document No.", Rec."No.");

                            SalesLine.Type := SalesLine.Type::Item;
                            SalesLine.Validate("No.", EanItem."No.");

                            //if Rec.Quantity = 0 then
                            SalesLine.Validate(Quantity, 1);
                            SalesLine.QtyColli := 0;
                            //NoOnAfterValidate();
                            //UpdateEditableOnRow();
                            //ShowShortcutDimCode(ShortcutDimCode);

                            //QuantityOnAfterValidate();
                            //UpdateTypeText();
                            //DeltaUpdateTotals();
                            SalesLine.EANNr := EanItem.EANNr;

                            SalesLine.Insert(true);



                            CurrPage.Update();

                            //rec.FindLast;
                            //rec.Next;


                            //rec.SetRange("Line No.", rec."Line No." + 10000);
                            //rec.FindFirst;
                            //rec.Reset;



                        end;

                    end;
                    //end; testing 121021
                end;
                    
            }
            */


        }
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
                ShortCutKey = 'F9';
                ToolTip = '';

                trigger OnAction()

                var
                    Cust: Record Customer;

                begin
                    //Måske skal det køres fra page
                    Cust.Reset;
                    Cust.SetRange("No.", Rec."Bill-to Customer No.");

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

