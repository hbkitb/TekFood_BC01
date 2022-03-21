pageextension 50005 "Sales InvLines Subform ITB" extends "Sales Invoice Subform"
{
    layout
    {
        //addlast(Content)
        addafter(Type)
        {
            field(EANNr; Rec.EANNr)
            {
                ApplicationArea = all;

                //TableRelation = Item."No.";

                trigger OnValidate()
                var
                    EanItem: Record Item;
                    EanItem02: Record Item;
                    EanTemp: Text[50];
                    SalesItemNo: Code[20];
                    Robert: Text[30];
                    Colli: Decimal;
                    PantLine: Record "Sales Line";
                    LineNo: Decimal;

                begin
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
                        //141221 EanItem.Reset;
                        //141221 EanItem.SetRange(EANNr, Rec.EANNr);
                        //141221 if EanItem.FindSet then begin



                        SalesItemNo := EanItem02."No.";

                        Rec.Validate("No.", EanItem02."No.");
                        Rec.Mangde := EanItem02.Mangde;  //HBK / ITB - 091221

                        Colli := EanItem02.KartAntal;

                        if Colli <> 0 then begin

                            Rec.QtyColli := 1;  //1 pr 121121 Colli;
                            rec.Validate(Quantity, Colli);

                        end
                        else begin
                            Rec.QtyColli := 0;
                            rec.Validate(Quantity, 1);
                        end;
                        //NoOnAfterValidate();
                        //UpdateEditableOnRow();
                        //ShowShortcutDimCode(ShortcutDimCode);

                        //QuantityOnAfterValidate();
                        //UpdateTypeText();
                        //DeltaUpdateTotals();
                        Rec.EANNr := EanItem02.EANNr;

                        CurrPage.Update();

                        //Pantlinie
                        if StrLen(EanItem02.PantItem) > 2 then begin
                            Clear(PantLine);

                            LineNo := Rec."Line No." - 500;
                            PantLine.Validate("Line No.", LineNo);

                            PantLine.Validate("Document Type", Rec."Document Type");
                            PantLine.Validate("Document No.", Rec."Document No.");

                            PantLine.Type := PantLine.Type::Item;
                            PantLine.Validate("No.", EanItem02.PantItem);

                            PantLine.Validate(Quantity, Rec.Quantity);
                            PantLine.QtyColli := 0;

                            //141221 PantLine.EANNr := EanItem.EANNr;
                            PantLine.EANNr := EanItem02.EANNr;  //141221

                            PantLine.Insert(true);

                            Rec.PantLineNo := PantLine."Line No.";
                            //PantLinie                            

                            CurrPage.Update();
                        end;  //if pantitem


                        //141221 end;

                        //Rec.EANNr := EanTemp;//
                    end
                    else begin
                        EanItem.Reset;
                        EanItem.SetRange(EANNr, Rec.EANNr);

                        if EanItem.FindSet then begin
                            //pant
                            clear(PantLine);
                            LineNo := 10;

                            Rec.Validate("No.", EanItem."No.");
                            Rec.Mangde := EanItem.Mangde;  //HBK / ITB - 091221

                            //if Rec.Quantity = 0 then
                            rec.Validate(Quantity, 1);
                            rec.QtyColli := 0;
                            //NoOnAfterValidate();
                            //UpdateEditableOnRow();
                            //ShowShortcutDimCode(ShortcutDimCode);

                            //QuantityOnAfterValidate();
                            //UpdateTypeText();
                            //DeltaUpdateTotals();
                            Rec.EANNr := EanItem.EANNr;
                            CurrPage.Update();

                            //Pantlinie
                            If StrLen(EanItem.PantItem) > 2 then begin
                                Clear(PantLine);

                                LineNo := Rec."Line No." - 500;
                                PantLine.Validate("Line No.", LineNo);

                                PantLine.Validate("Document Type", Rec."Document Type");
                                PantLine.Validate("Document No.", Rec."Document No.");

                                PantLine.Type := PantLine.Type::Item;
                                PantLine.Validate("No.", EanItem.PantItem);

                                PantLine.Validate(Quantity, Rec.Quantity);
                                PantLine.QtyColli := 0;

                                PantLine.EANNr := EanItem.EANNr;

                                PantLine.Insert(true);
                                //PantLinie                            
                                Rec.PantLineNo := PantLine."Line No.";

                                CurrPage.Update();
                            end;  //if pantitem                        

                        end
                        //121121
                        //121121
                        else begin
                            EanItem.Reset;
                            EanItem.SetRange("No.", Rec.EANNr);
                            if EanItem.FindSet then begin
                                clear(PantLine);
                                LineNo := 10;

                                Rec.Validate("No.", EanItem."No.");
                                Rec.Mangde := EanItem.Mangde;  //HBK / ITB - 091221

                                //if Rec.Quantity = 0 then
                                rec.Validate(Quantity, 1);
                                rec.QtyColli := 0;
                                //NoOnAfterValidate();
                                //UpdateEditableOnRow();
                                //ShowShortcutDimCode(ShortcutDimCode);

                                //QuantityOnAfterValidate();
                                //UpdateTypeText();
                                //DeltaUpdateTotals();
                                Rec.EANNr := EanItem.EANNr;
                                CurrPage.Update();

                                //Pantlinie
                                If StrLen(EanItem.PantItem) > 2 then begin
                                    Clear(PantLine);

                                    LineNo := Rec."Line No." - 500;
                                    PantLine.Validate("Line No.", LineNo);

                                    PantLine.Validate("Document Type", Rec."Document Type");
                                    PantLine.Validate("Document No.", Rec."Document No.");

                                    PantLine.Type := PantLine.Type::Item;
                                    PantLine.Validate("No.", EanItem.PantItem);

                                    PantLine.Validate(Quantity, Rec.Quantity);
                                    PantLine.QtyColli := 0;

                                    PantLine.EANNr := EanItem.EANNr;

                                    PantLine.Insert(true);
                                    //PantLinie                            
                                    Rec.PantLineNo := PantLine."Line No.";

                                    CurrPage.Update();
                                end;
                            end;
                        end;
                        //121121    

                    end;
                    //end; testing 121021
                end;

            }

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
                    EanTemp := Rec.EANNr;
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

    actions
    {
        addlast("Related Information")
        {

            action(VareLinier)
            {
                ApplicationArea = All;
                Caption = 'Varelinier';
                Image = Inventory;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Value Entries";
                //RunObject = page "Sales Invoice Subform";
                //RunPageLink = "Bill-to Customer No." = field("Bill-to Customer No."), "No." = field("No.");  //, "Item Ledger Entry Type" = filter(1);
                //RunPageView = SORTING("Document No.", "Line No.", "Document Type")
                //              ORDER(Ascending);

                RunPageLink = "Source No." = field("Bill-to Customer No."), "Item No." = field("No."), "Item Ledger Entry Type" = filter(1), "Document Type" = filter(2), Adjustment = filter(0);
                RunPageView = SORTING("Item Ledger Entry Type", "Posting Date", "Item No.", "Inventory Posting Group", "Dimension Set ID")
                              ORDER(Descending);


                ShortCutKey = 'Ctrl+D';
                ToolTip = 'Vis alle varelinier.';
            }
            /*     action("ERP-TEST")//
                 {
                     Caption = 'ERP';
                     ApplicationArea = All;

                     trigger OnAction()
                     begin
                         Message('dette er ok');
                     end;
                 }*/
        }

    }

    var

}

