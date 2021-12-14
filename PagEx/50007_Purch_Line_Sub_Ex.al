pageextension 50007 "Purch Lines Subform ITB" extends "Purchase Order Subform"
{
    layout
    {


        addafter(Type)
        {
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
                    //PantLine: Record "Sales Line";
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
                        EanItem.Reset;
                        EanItem.SetRange(EANNr, Rec.EANNr);
                        if EanItem.FindSet then begin



                            SalesItemNo := EanItem02."No.";

                            Rec."No." := EanItem02."No.";
                            if Rec."Direct Unit Cost" <> 0 then begin
                                Rec."Direct Unit Cost" := EanItem02."Last Direct Cost";
                                rec."Unit Cost" := EanItem02."Last Direct Cost";
                            end;
                            Rec.Validate("No.", EanItem02."No.");
                            //Rec.Mangde := EanItem02.Mangde;  //HBK / ITB - 091221

                            Colli := EanItem02.KartAntal;

                            if Colli <> 0 then begin

                                Rec.QtyColli := 1;  //1 pr. 121121 Colli;
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




                        end;

                        //Rec.EANNr := EanTemp;//
                    end
                    else begin
                        EanItem.Reset;
                        EanItem.SetRange(EANNr, Rec.EANNr);

                        if EanItem.FindSet then begin
                            //pant
                            //clear(PantLine);
                            LineNo := 10;

                            Rec."No." := EanItem."No.";
                            if Rec."Direct Unit Cost" <> 0 then begin
                                Rec."Direct Unit Cost" := EanItem."Last Direct Cost";
                                rec."Unit Cost" := EanItem."Last Direct Cost";
                            end;
                            Rec.Validate("No.", EanItem."No.");
                            //Rec.Mangde := EanItem.Mangde;  //HBK / ITB - 091221


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



                        end
                        //121121
                        //121121
                        else begin
                            //Message('1111');
                            EanItem.Reset;
                            EanItem.SetRange("No.", Rec.EANNr);
                            if EanItem.FindSet then begin
                                //clear(PantLine);
                                LineNo := 10;
                                //Message('00');
                                Rec."No." := EanItem."No.";
                                if Rec."Direct Unit Cost" <> 0 then begin
                                    Rec."Direct Unit Cost" := EanItem."Last Direct Cost";
                                    rec."Unit Cost" := EanItem."Last Direct Cost";
                                    Rec."Unit Cost (LCY)" := EanItem."Last Direct Cost";
                                    //Rec.Validate("Unit Cost (LCY)", EanItem."Last Direct Cost");
                                    Rec.Validate("Unit Cost");
                                    Rec.Validate("Unit Cost (LCY)");
                                    rec.Validate("Direct Unit Cost");

                                end;
                                Rec.Validate("No.", EanItem."No.");
                                //Rec.Mangde := EanItem.Mangde;  //HBK / ITB - 091221

                                //Message('01');
                                //if Rec.Quantity = 0 then
                                rec.Validate(Quantity, 1);
                                //Message('02');
                                rec.QtyColli := 0;
                                //NoOnAfterValidate();
                                //UpdateEditableOnRow();
                                //ShowShortcutDimCode(ShortcutDimCode);

                                //QuantityOnAfterValidate();
                                //UpdateTypeText();
                                //DeltaUpdateTotals();
                                Rec.EANNr := EanItem.EANNr;
                                CurrPage.Update();
                                //Message('03');

                            end;
                        end;
                        //121121                          

                        //121121

                    end;
                    //end; testing 121021
                end;

            }

            //131221


        }

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

            //131221



        }
    }

    actions
    {

    }

    var

}



