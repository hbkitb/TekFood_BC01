xmlport 50149 "50149_Posting_Setup_ERPG"
{
    // version ITB.Imp_Bogf._Setup_C5

    // Diverse opdateringer bogføringsopsætninger
    // HBK - 110917 m.v.

    Caption = 'LagImport';
    DefaultFieldsValidation = false;
    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = ';';
    FileName = 'F:\PBS\DEB\*.DK';
    Format = VariableText;
    Permissions =;
    TextEncoding = WINDOWS;
    UseRequestPage = false;

    schema
    {

        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'Resource';
                UseTemporary = true;
                textelement(Felt01)
                {
                }
                textelement(Felt02)
                {
                }
                textelement(Felt03)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt04)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt05)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt06)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt07)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt08)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt09)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt10)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt11)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt12)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt13)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt14)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt15)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt16)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt17)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt18)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt19)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt20)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt21)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt22)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt23)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt24)
                {
                    MinOccurs = Zero;
                }
                textelement(Felt25)
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                var
                //counter: Integer;

                begin

                    Counter := Counter + 1;   // pga fejl i indsæt på temp. tabel integer.
                    Integer.Number := Counter;


                    //Behandling af records - Debitorer - opdateringer og nye
                    //IF Felt01 <> '' THEN
                    //   DebUpdate1;   //Det var det med bogf.grp på sagsposter

                    IF Felt01 <> '' THEN begin
                        /*
                          IF STRLEN(Felt01) = 1 THEN
                            Felt01 := '00'+Felt01;
                          IF STRLEN(Felt01) = 2 THEN
                            Felt01 := '0'+Felt01;
                         */

                        //Det var det med kostpriser på sagsposter
                        //;
                        //230719   
                        GenPostSetupImp;  //bogopsæt

                        /* Lager 250719
                        Item.Reset();
                        //item.SetRange("No.",Felt01);
                        if item.Get(Felt01) then begin
                            Evaluate(item.MinPris, Felt02);
                            item.P1 := Felt03;
                            item.P2 := felt04;
                            Evaluate(Item.StrPrKs, Felt05);
                            Item.Short := Felt06;
                            if Felt07 = '0' then
                                Item.PaySaldo := false
                            else
                                Item.PaySaldo := true;
                            if Felt08 = '0' then
                                Item.NoInnoItem := false
                            else
                                Item.NoInnoItem := true;
                            item.UnNumber := Felt09;
                            if Felt10 = '0' then
                                Item.Farlig := false
                            else
                                Item.Farlig := true;
                            Item.ItemName1 := Felt11;

                            Item.Modify();
                        end;
                        lager 250719 */


                        /* Debitor 250719 
                        DebKart.Reset();
                        //item.SetRange("No.",Felt01);
                        if DebKart.Get(Felt01) then begin
                            if (Felt02 <> '0') and (DebKart.GLN <> '') then
                                DebKart.GLN := Felt02;
                            if Felt03 = '0' then
                                DebKart.PDFfaktura := false
                            else
                                DebKart.PDFfaktura := true;
                            DebKart.Bogholder := Felt04;
                            if Felt05 = '0' then
                                DebKart.UNuse := false
                            else
                                DebKart.UNuse := true;

                            DebKart.Modify();
                        end;
                        Debitor 250719 */

                        /* medarbejder 310719 
                        Employee.Reset();
                        //item.SetRange("No.",Felt01);
                        if Employee.Get(Felt01) then begin
                            Employee.InnoPassword := Felt02;
                            Employee.Land_ := Felt03;

                            Employee.Modify();
                        end;
                         medarbejder 310719 */

                        /* notater 020819 
                        ComLine.Reset();
                        //item.SetRange("No.",Felt01);
                        //if ComLine.Get(Felt01) then begin
                        ComLine.Init();
                        ComLine."Table Name" := 1;  //1=Debitor, 2=Kreditor,3=Item
                        ComLine."No." := Felt01;  //kontonummer/vare

                        Evaluate(LineNo, Felt02);
                        if LineNo = LineNoOld then
                            LineNo := LineNo + 0.0001;
                        ComLine."Line No." := LineNo * 10000;
                        ComLine.Comment := copystr(Felt03, 1, 80);
                        LineNoOld := LineNo;
                        ComLine.Insert();
                        //end;
                         notater 020819 */
                    end;


                end;
            }
        }
    }

    requestpage
    {
        //* h
        //DataCaptionFields = "Sales Code", "Sales Type";
        DataCaptionFields = "Price List Code", "Source Type";

        //SourceTable = "Sales Price";
        SourceTable = "Price List Line";

        //SourceTableView = SORTING("Source Type", "Price List Code","Item No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
        SourceTableView = SORTING("Source Type", "Price List Code", "Source No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
                          ORDER(Ascending)
                          WHERE(//230719 "Sales Code"=FILTER(magasin),
                             "Source Type" = FILTER("Customer Price Group"));
        // h */
        layout
        {
        }

        actions
        {
        }
    }
    trigger OnInitXmlPort()
    begin
        /* 020819
        ComLine.Reset();
        //item.SetRange("No.",Felt01);
        //if ComLine.Get(Felt01) then begin
        comline.SetRange("Table Name", 1);
        if ComLine.FindSet() then
            repeat
                ComLine.Delete();
            until ComLine.Next() = 0;
            020819 */
    end;

    trigger OnPostXmlPort()
    begin
        MESSAGE('Import er færdig !');  //
    end;

    var
        /* 230719*/

        Item: Record Item;
        //h 
        //SalesPrice: Record "Sales Price";
        SalesPrice: Record "Price List Line";
        Counter: Integer;
        NoInd: Integer;
        COOPSign: Integer;
        OrdKart: Record "Sales Header";
        OrdLinie: Record "Sales Line";
        DebKart: Record Customer;
        FakKart: Record Customer;
        LagKart: Record Item;
        OrdNum: Text[20];
        Dag: Integer;
        "Måned": Integer;
        "År": Integer;
        DebKonto: Text[20];
        FakKonto: Text[20];
        PgBestil: Text[20];
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        PrepmtMgt: Codeunit "Prepayment Mgt.";
        HideValidationDialog: Boolean;
        SalesSetup: Record "Sales & Receivables Setup";
        ArchiveManagement: Codeunit ArchiveManagement;
        LinieNo: Decimal;
        LagKonto: Text[20];
        //h
        //SalesPriceFind: Codeunit "Sales Price Calc. Mgt.";
        SalesPriceFind: Codeunit "Price Calculation Mgt.";  //081020
        PostNr: Integer;
        SagsPost: Record "Job Ledger Entry";
        "Løbenummer": Integer;
        Dato: Date;
        KostPris: Decimal;
        KostPrisRV: Decimal;
        "KostBeløb": Decimal;
        "KostBeløbRV": Decimal;
        GenPostSetup: Record "General Posting Setup";
        GenVareSetup: Record "Inventory Posting Setup";
        VendPost: Record "Vendor Posting Group";
        CustPost: Record "Customer Posting Group";
        Employee: Record Employee;
        ComLine: Record "Comment Line";
        LineNo: Decimal;
        LineNoOld: Decimal;
    /*230719 */

    local procedure DebUpdate()
    begin

        /*
        EVALUATE(Dag,COPYSTR(Felt02,1,2));
        EVALUATE(Måned,COPYSTR(Felt02,4,2));
        EVALUATE(År,COPYSTR(Felt02,7,4));
        Dato := DMY2DATE(Dag,Måned,År);  //Dato oprettet
        
        EVALUATE(Løbenummer,Felt01);
        
        SagsPost.RESET;
        SagsPost.SETRANGE(SagsPost."Entry No.",Løbenummer);
        SagsPost.SETRANGE(SagsPost."Posting Date",Dato);
        SagsPost.SETRANGE(SagsPost."Job No.",Felt05);
        SagsPost.SETRANGE(SagsPost."Document No.",Felt04);
        SagsPost.SETRANGE(SagsPost."Job Task No.",Felt06);
        
        //MESSAGE(FORMAT(Løbenummer) + ' - ' + Felt02);
        IF SagsPost.FINDSET THEN BEGIN
           //MESSAGE('Inde1: ' + Felt02);
           IF SagsPost."Gen. Prod. Posting Group" = '' THEN BEGIN
              SagsPost."Gen. Prod. Posting Group" := Felt11;
              SagsPost.MODIFY;
           END;
        
           IF SagsPost."Job Posting Group" = '' THEN BEGIN
              SagsPost."Job Posting Group" := Felt12;
              SagsPost.MODIFY;
           END;
        
        END;
        */

        /*
        EVALUATE(Dag,COPYSTR(Felt10,7,2));
        EVALUATE(Måned,COPYSTR(Felt10,5,2));
        EVALUATE(År,COPYSTR(Felt10,1,4));
        OrdKart."Order Date" := DMY2DATE(Dag,Måned,År);  //Dato oprettet
        
        EVALUATE(Dag,COPYSTR(Felt12,7,2));
        EVALUATE(Måned,COPYSTR(Felt12,5,2));
        EVALUATE(År,COPYSTR(Felt12,1,4));
        OrdKart."Shipment Date" := DMY2DATE(Dag,Måned,År);  //Dato oprettet
        */


        LinieNo := 0;  //Forbered linietæller til opret ordrelinier

    end;

    local procedure JobUpdate1()
    begin

        /*
        EVALUATE(Dag,COPYSTR(Felt02,1,2));
        EVALUATE(Måned,COPYSTR(Felt02,4,2));
        EVALUATE(År,COPYSTR(Felt02,7,4));
        Dato := DMY2DATE(Dag,Måned,År);  //Dato oprettet
        
        EVALUATE(Løbenummer,Felt01);
        
        EVALUATE(KostPris,Felt15);
        EVALUATE(KostPrisRV,Felt16);
        EVALUATE(KostBeløb,Felt17);
        EVALUATE(KostBeløbRV,Felt18);
        
        SagsPost.RESET;
        SagsPost.SETRANGE(SagsPost."Entry No.",Løbenummer);
        SagsPost.SETRANGE(SagsPost."Posting Date",Dato);
        SagsPost.SETRANGE(SagsPost."Job No.",Felt05);
        SagsPost.SETRANGE(SagsPost."Document No.",Felt04);
        SagsPost.SETRANGE(SagsPost."Job Task No.",Felt06);
        
        //MESSAGE(FORMAT(Løbenummer) + ' - ' + Felt02);
        IF SagsPost.FINDSET THEN BEGIN
           //MESSAGE('Inde1: ' + Felt02);
           IF SagsPost."Unit Cost (LCY)" = 0 THEN BEGIN
              SagsPost."Unit Cost (LCY)" := KostPrisRV;
              SagsPost.MODIFY;
           END;
        
           IF SagsPost."Total Cost (LCY)" = 0 THEN BEGIN
              SagsPost."Total Cost (LCY)" := KostBeløbRV;
              SagsPost.MODIFY;
           END;
        
           IF SagsPost."Unit Cost" = 0 THEN BEGIN
              SagsPost."Unit Cost" := KostPris;
              SagsPost.MODIFY;
           END;
        
           IF SagsPost."Total Cost" = 0 THEN BEGIN
              SagsPost."Total Cost" := KostBeløb;
              SagsPost.MODIFY;
           END;
        
        
        END;
        */
        LinieNo := 0;  //Forbered linietæller til opret ordrelinier

    end;

    local procedure GenPostSetupImp()
    begin
        //Kørt 021118
        //Debitor
        /*
        GenPostSetup.RESET;
        GenPostSetup.SETRANGE("Gen. Bus. Posting Group", Felt01);

        IF GenPostSetup.FINDSET THEN
            REPEAT


                /ud
                      IF STRLEN(Felt02) = 4 THEN
                            Felt02 := '0' + Felt02;
                      GenPostSetup."Sales Account" := Felt02;
                      IF STRLEN(Felt09) = 4 THEN
                         Felt09 := '0' + Felt09;
                      GenPostSetup."Sales Line Disc. Account" := Felt09;
                      IF STRLEN(Felt04) = 4 THEN
                         Felt04 := '0' + Felt04;
                      GenPostSetup."Sales Inv. Disc. Account" := Felt04;
                      IF STRLEN(Felt02) = 4 THEN
                         Felt02 := '0' + Felt02;
                      GenPostSetup."Sales Credit Memo Account" := Felt02;
                ud/

                IF STRLEN(Felt02) = 4 THEN
                    Felt02 := '0' + Felt02;
                IF GenPostSetup."Sales Line Disc. Account" = '' THEN
                    GenPostSetup."Sales Line Disc. Account" := Felt02;

                GenPostSetup.MODIFY;
            UNTIL GenPostSetup.NEXT = 0;
        */

        /*kørt 021118*/
        //Lager og Kreditor
        GenPostSetup.RESET;
        GenPostSetup.SETRANGE("Gen. Prod. Posting Group", Felt01);
        //250718 GenPostSetup.SETRANGE("Gen. Bus. Posting Group",Felt01);

        IF GenPostSetup.FINDSET THEN
            REPEAT
                //hIF STRLEN(Felt02) = 4 THEN
                //h   Felt02 := '0' + Felt02;
                //hIF STRLEN(Felt02) = 5 THEN
                GenPostSetup."Sales Account" := Felt02;
                GenPostSetup."Purch. Account" := '13800';
                //hIF STRLEN(Felt09) = 4 THEN
                //h   Felt09 := '0' + Felt09;
                //hIF STRLEN(Felt09) = 5 THEN
                GenPostSetup."Purch. Line Disc. Account" := Felt09;
                GenPostSetup."Purch. Credit Memo Account" := '13800';
                //hIF STRLEN(Felt03) = 4 THEN
                //h   Felt03 := '0' + Felt03;
                //hIF STRLEN(Felt03) = 5 THEN
                GenPostSetup."COGS Account" := Felt03;
                //hIF STRLEN(Felt07) = 4 THEN
                //h   Felt07 := '0' + Felt07;
                //hIF STRLEN(Felt07) = 5 THEN
                GenPostSetup."Inventory Adjmt. Account" := Felt07;
                GenPostSetup."Direct Cost Applied Account" := '13800';  //modkonto køb
                GenPostSetup."Overhead Applied Account" := '13800';     //modkonto køb
                GenPostSetup."Purchase Variance Account" := '13800';    //Købsafvigelse
                GenPostSetup.MODIFY;
            UNTIL GenPostSetup.NEXT = 0;
        /**/

        /*kørt 021118*/
        GenVareSetup.RESET;
        GenVareSetup.SETRANGE(GenVareSetup."Invt. Posting Group Code", Felt01);

        IF GenVareSetup.FINDSET THEN
            REPEAT
                //hIF STRLEN(Felt05) = 4 THEN
                //h   Felt05 := '0' + Felt05;
                //hGenVareSetup."Inventory Account" := Felt05;
                GenVareSetup."Inventory Account" := Felt06;
                GenVareSetup.MODIFY;
            UNTIL GenVareSetup.NEXT = 0;
        /**/

        /*Kørt 021118
        VendPost.RESET;
        VendPost.SETRANGE(Code,Felt01);
        
        IF VendPost.FINDSET THEN
           REPEAT
              IF STRLEN(Felt04) = 4 THEN
                 Felt04 := '0' + Felt04;
              VendPost."Service Charge Acc." := Felt04;
              IF STRLEN(Felt03) = 4 THEN
                 Felt03 := '0' + Felt03;
              VendPost."Payment Disc. Debit Acc." := Felt03;
              VendPost."Payment Disc. Credit Acc." := Felt03;
        
              VendPost."Invoice Rounding Account" := '03520';
              VendPost."Debit Curr. Appln. Rndg. Acc." := '03520';
              VendPost."Credit Curr. Appln. Rndg. Acc." := '03520';
              VendPost."Debit Rounding Account" := '03520';
              VendPost."Credit Rounding Account" := '03520';
              VendPost."Payment Tolerance Debit Acc." := '03520';
        
              VendPost.MODIFY;
           UNTIL VendPost.NEXT = 0;
          */

        /*250718 kørt 021118
        CustPost.RESET;
        CustPost.SETRANGE(Code,Felt01);
        
        IF CustPost.FINDSET THEN
           REPEAT
              IF STRLEN(Felt05) = 4 THEN
                 Felt05 := '0' + Felt05;
              CustPost."Service Charge Acc." := Felt05;
              IF STRLEN(Felt04) = 4 THEN
                 Felt04 := '0' + Felt04;
             CustPost."Payment Disc. Debit Acc." := Felt04;
             CustPost."Payment Disc. Credit Acc." := Felt04;
        
             CustPost."Interest Account" := '06001';
             CustPost."Additional Fee Account" := '06001';
        
             CustPost."Invoice Rounding Account" := '03520';
             CustPost."Debit Curr. Appln. Rndg. Acc." := '03520';
             CustPost."Credit Curr. Appln. Rndg. Acc." := '03520';
             CustPost."Debit Rounding Account" := '03520';
             CustPost."Credit Rounding Account" := '03520';
             CustPost."Payment Tolerance Debit Acc." := '03520';
             CustPost."Payment Tolerance Credit Acc." := '03520';
        
             CustPost.MODIFY;
           UNTIL CustPost.NEXT = 0
        
        ELSE BEGIN
              CustPost.INIT;
              CustPost.Code := Felt01;
              IF STRLEN(Felt05) = 4 THEN
                 Felt05 := '0' + Felt05;
              CustPost."Service Charge Acc." := Felt05;
              IF STRLEN(Felt04) = 4 THEN
                 Felt04 := '0' + Felt04;
             CustPost."Payment Disc. Debit Acc." := Felt04;
             CustPost."Payment Disc. Credit Acc." := Felt04;
        
             CustPost."Interest Account" := '06001';
             CustPost."Additional Fee Account" := '06001';
        
             CustPost."Invoice Rounding Account" := '03520';
             CustPost."Debit Curr. Appln. Rndg. Acc." := '03520';
             CustPost."Credit Curr. Appln. Rndg. Acc." := '03520';
             CustPost."Debit Rounding Account" := '03520';
             CustPost."Credit Rounding Account" := '03520';
             CustPost."Payment Tolerance Debit Acc." := '03520';
             CustPost."Payment Tolerance Credit Acc." := '03520';
             CustPost.INSERT;
        
        END;
        250718*/

    end;


}

