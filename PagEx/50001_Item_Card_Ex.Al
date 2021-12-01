pageextension 50001 "Item_Card ITB" extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            field(EANNr; Rec.EANNr)
            {
                ApplicationArea = all;

                trigger OnValidate()

                var

                begin
                    IF (StrLen(Rec.EANNr) >= 15) AND (Copystr(Rec.EANNr, 1, 1) = 'ù') THEN
                        IF Copystr(Rec.EANNr, 1, 2) = 'ùC' THEN
                            Rec.EanNr := Copystr(Rec.EanNr, 4, 16)
                        ELSE
                            Rec.EanNr := Copystr(Rec.EanNr, 2, 16);

                    CurrPage.Update();

                end;

            }

            field(EANNr02; Rec.EANNr02)
            {
                ApplicationArea = all;
                trigger OnValidate()

                var

                begin
                    IF (StrLen(Rec.EANNr02) >= 15) AND (Copystr(Rec.EANNr02, 1, 1) = 'ù') THEN
                        IF Copystr(Rec.EANNr02, 1, 2) = 'ùC' THEN
                            Rec.EANNr02 := Copystr(Rec.EANNr02, 4, 16)
                        ELSE
                            Rec.EANNr02 := Copystr(Rec.EANNr02, 2, 16);

                    CurrPage.Update();

                end;


            }

            field(KartAntal; Rec.KartAntal)
            {
                ApplicationArea = all;
            }
            field(Mangde; Rec.Mangde)
            {
                ApplicationArea = all;

                trigger OnValidate()
                var

                begin


                end;
            }

            field(PantItem; Rec.PantItem)
            {
                ApplicationArea = all;
            }

        }

        addafter("Indirect Cost %")
        {
            field(FreightCost; Rec.FreightCost)
            {
                ApplicationArea = all;
            }

            field(FeeCost; Rec.FeeCost)
            {
                ApplicationArea = all;
            }

            field(DivCost; Rec.DivCost)
            {
                ApplicationArea = all;
            }
            field(TotalCost; Rec.TotalCost)
            {
                ApplicationArea = all;

            }
            field(TotalDG; Rec.TotalDG)
            {
                ApplicationArea = all;
            }

        }



        addafter(InventoryGrp)
        {
            group(TEKFood)

            {
                /*
                field(StkKrt; Rec.StkKrt)
                {
                    ApplicationArea = all;
                    ToolTip = 'Antal stk. der indgår i en karton';

                    //trigger OnValidate()
                    //begin
                    //    UpdateSalesHeadertEXPO();
                    //end;
                }
                field(Trykfarve1; Rec.Trykfarve1)
                {
                    ApplicationArea = all;
                    ToolTip = 'Trykfarve1';

                    trigger OnValidate()
                    begin
                        //UpdateSalesHeadertEXPO();
                    end;
                }
                field(Trykfarve2; Rec.Trykfarve2)
                {
                    ApplicationArea = all;
                    ToolTip = 'Trykfarve2';

                    trigger OnValidate()
                    begin
                        //UpdateSalesHeadertEXPO();
                    end;
                }
                field(Trykfarve3; Rec.Trykfarve3)
                {
                    ApplicationArea = all;
                    ToolTip = 'Trykfarve3';

                    trigger OnValidate()
                    begin
                        //UpdateSalesHeadertEXPO();
                    end;
                }
                field(Trykfarve4; Rec.Trykfarve4)
                {
                    ApplicationArea = all;
                    ToolTip = 'Trykfarve4';

                    trigger OnValidate()
                    begin
                        //UpdateSalesHeadertEXPO();
                    end;
                }
                field(KvalFarve; Rec.KvalFarve)
                {
                    ApplicationArea = all;
                    ToolTip = 'Kvalitet / Farve';

                    trigger OnValidate()
                    begin
                        //UpdateSalesHeadertEXPO();
                    end;
                }
                field(TrykLgd; Rec.TrykLgd)
                {
                    ApplicationArea = all;
                    ToolTip = 'Tryklængde';

                    trigger OnValidate()
                    begin
                        //UpdateSalesHeadertEXPO();
                    end;
                }
                field(KlicheNr; Rec.KlicheNr)
                {
                    ApplicationArea = all;
                    ToolTip = 'Kliche nummer';

                    trigger OnValidate()
                    begin
                        //UpdateSalesHeadertEXPO();
                    end;
                }
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = all;
                    ToolTip = 'Type vare / Bemærkning';

                    trigger OnValidate()
                    begin
                        //UpdateSalesHeadertEXPO();
                    end;
                }
                field(Type_; Rec.Type_)
                {
                    ApplicationArea = all;
                    ToolTip = 'Type vare';

                    trigger OnValidate()
                    begin
                        //UpdateSalesHeadertEXPO();
                    end;
                }
                field(AfrulningsRetning; Rec.AfrulningsRetning)
                {
                    ApplicationArea = all;
                    ToolTip = 'Afrulningsretning';

                    trigger OnValidate()
                    begin
                        //UpdateSalesHeadertEXPO();
                    end;

                }

*/

            }
        }
        // Add changes to page layout here
    }

    actions
    {

        addlast(Processing)
        {
            /*    action(xmltest)
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ous: OutStream;
                        x: XmlPort "_Inventable ERPG";
                        xml: XmlDocument;
                    begin

                        Xmlport.Run(50102, false, false);
                    end;
                }*/
        }
        addlast(Reporting)
        {
            action("ERP-TEST")
            {
                Caption = 'ERP-I-konti';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Message('dette er ok');
                    //Codeunit.Run(50149);  //50149 "50149_Diverse_OP_ERPG"
                    Codeunit.Run(Codeunit::"50151_Diverse_OP_ERPG");
                end;
            }

            action("ENV_DEB")
            {
                Caption = 'TF IMP/DEB';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Message('TF deb/imp');
                    //Codeunit.Run(50149);  //50149 "50149_Diverse_OP_ERPG"
                    Xmlport.Run(xmlport::"50000_Imp_ENV_Medlem");

                end;
            }
            //50000 "50000_Imp_ENV_Medlem"

            action("ENV_KUR")
            {
                Caption = 'TF IMP/KURSUS';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Message('Envina Kursus/imp');
                    //Codeunit.Run(50149);  //50149 "50149_Diverse_OP_ERPG"
                    Xmlport.Run(xmlport::"50001_Imp_ENV_Kursus");

                end;
            }

            action("ITB_Logic")
            {
                Caption = 'ITB_TIL_LOGIC';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Message('dette er LOGIC ok');
                    //Codeunit.Run(50149);  //50149 "50149_Diverse_OP_ERPG"
                    //Codeunit.Run(Codeunit::"50001_ITB_UD_SIM");
                end;
            }

            action("SIM_Ledtrans")
            {
                Caption = 'SIM_Ledtrans';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Message('dette er SIM_Ledtrans ok');
                    //Codeunit.Run(50149);  //50149 "50149_Diverse_OP_ERPG"
                    //Page.Run(Page::ITB_TEST);
                end;
            }

            action("SIM_LedTable")
            {
                Caption = 'ACU_Finkart';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Message('dette er ACU_Finkart ok');
                    //Codeunit.Run(50149);  //50149 "50149_Diverse_OP_ERPG"
                    //Page.Run(Page::ITB_TEST_FinKart);
                end;
            }

            action("SIM_LedTable_OK")
            {
                Caption = 'SIM_Finkart';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Message('dette er SIM_Finkart ok');
                    //Codeunit.Run(50149);  //50149 "50149_Diverse_OP_ERPG"
                    //Page.Run(Page::ITB_TEST_FinKart_SIM);
                end;
            }

            action("ITB_Acu_Logic")
            {
                Caption = 'ITB_ACU_LOGIC';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Message('dette er Acubiz ok');
                    //Codeunit.Run(50149);  //50149 "50149_Diverse_OP_ERPG"
                    //Codeunit.Run(Codeunit::"50002_ITB_UD_Acubiz");
                end;
            }

            action("ITB_test_ind_bar")
            {
                Caption = 'ITB_test_ind_bar';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Message('dette er bærer sk. ok');
                    //Codeunit.Run(50149);  //50149 "50149_Diverse_OP_ERPG"
                    //Page.Run(Page::ITB_TEST_Ind_Bar);
                end;
            }
            action("ITB_DimEntry")
            {
                Caption = 'ITB_DimEntry';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Message('dette er DIMENTRY sk. ok');
                    //Codeunit.Run(50149);  //50149 "50149_Diverse_OP_ERPG"
                    //Page.Run(Page::ITB_DimEntry);
                end;
            }
        }

    }


    var

    local procedure UpdateSalesHeadertEXPO()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Item: Record Item;
        found: Boolean;

    begin
        if Rec."Assembly BOM" = true then begin
            SalesHeader.Reset;
            SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
            SalesHeader.SetRange(Status, SalesHeader.Status::Open);

            if SalesHeader.FindSet then begin
                message('01');
                repeat
                    found := false;
                    SalesLine.Reset;
                    SalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
                    SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                    SalesLine.SetRange("Document No.", SalesHeader."No.");
                    SalesLine.SetRange(Type, SalesLine.Type::Item);
                    if SalesLine.FindSet then begin
                        Message('02');
                        repeat
                            Item.Reset;
                            Item.SetRange("No.", SalesLine."No.");
                            if Item.FindFirst then begin
                                Item.CalcFields("Assembly BOM");
                                Message('03');
                                //Message(SalesLine."Document No.");
                                //Message(Item."No.");
                                if Item."Assembly BOM" = true then begin
                                    Message('04');
                                    if found = false then begin
                                        found := true;
                                        Message('05');
                                        if SalesLine."No." = Rec."No." then begin
                                            Message('06');
                                            /*
                                            if Dialog.Confirm('Ændre farve mv på salgsordre ' + SalesHeader."No." + ' Debitor: ' + SalesHeader."Sell-to Customer Name") then begin
                                                Salesheader.Trykfarve1 := Item.Trykfarve1;
                                                Salesheader.Trykfarve2 := Item.Trykfarve2;
                                                Salesheader.Trykfarve3 := Item.Trykfarve3;
                                                Salesheader.Trykfarve4 := Item.Trykfarve4;
                                                Salesheader.BrtWeight := Item."Gross Weight";
                                                Salesheader.KvalFarve := Item.KvalFarve;
                                                Salesheader.TrykLgd := Item.TrykLgd;
                                                Salesheader.KlicheNr := Item.KlicheNr;
                                                Salesheader.Remark := Item.Remark;
                                                Salesheader.Type_ := Item.Type_;
                                                Salesheader.AfrulningsRetning := Item.AfrulningsRetning;
                                                Salesheader.Volume := Item."Unit Volume";

                                                SalesHeader.Modify;
                                            end;
                                            */
                                        end;  //Found
                                    end;
                                end;


                            end;
                        until SalesLine.Next = 0;

                    end;

                until SalesHeader.Next = 0;
            end;
        end;
    end;
}