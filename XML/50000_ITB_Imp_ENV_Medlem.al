xmlport 50000 "50000_Imp_ENV_Medlem"
{
    //Import af ekstra felter fra C5 Lagerkart

    Caption = 'Import Envina Medlem/Debitor';
    DefaultFieldsValidation = false;
    Direction = Import;
    FieldDelimiter = '"'; //<None>';
    FieldSeparator = ';';
    FileName = 'S:\C5WIN\Envina\*.csv';
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
                XmlName = 'ImpDebKart_ENV';
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


                trigger OnBeforeInsertRecord()
                var
                //counter: Integer;

                begin

                    Counter := Counter + 1;   // pga fejl i indsæt på temp. tabel integer.
                    Integer.Number := Counter;


                    IF Felt01 <> '' THEN begin

                        GenPostSetupImp;  //bogopsæt
                        Lin1 := false;

                    end;


                end;
            }
        }
    }

    requestpage
    {

    }

    trigger OnInitXmlPort()
    begin
        Lin1 := true;
    end;

    trigger OnPostXmlPort()
    begin
        MESSAGE('Import er færdig !');  //
    end;

    var
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
        ComLine: Record "Sales Comment Line";
        LineNo: Decimal;
        LineNoOld: Decimal;
        KreKart: Record Vendor;
        AMedlem: Boolean;
        btoA: Boolean;
        BUdenFak: Boolean;
        Lin1: Boolean;
        Deb03: Record Customer;
        DebStd: Record Customer;

    /*
    EVALUATE(Dag,COPYSTR(Felt02,1,2));
    EVALUATE(Måned,COPYSTR(Felt02,4,2));
    EVALUATE(År,COPYSTR(Felt02,7,4));
    Dato := DMY2DATE(Dag,Måned,År);  //Dato oprettet

    EVALUATE(Løbenummer,Felt01);
    */


    local procedure GenPostSetupImp()

    var

    begin
        if StrPos(Felt07, 'A - Medlem') > 0 then
            AMedlem := true
        else
            AMedlem := false;

        BUdenFak := false;
        btoA := false;

        if Lin1 = false then begin
            DebKart.RESET;
            DebKart.SetRange("No.", Felt01);
            //250718 GenPostSetup.SETRANGE("Gen. Bus. Posting Group",Felt01);

            IF DebKart.FINDSET then begin //rediger eksisterende
                                          //150921 repeat
                if (DebKart."Gen. Bus. Posting Group" = '02') and (AMedlem = true) then
                    btoA := true;

                if AMedlem = true then
                    DebKart."Gen. Bus. Posting Group" := '01'
                else
                    DebKart."Gen. Bus. Posting Group" := '02';

                DebKart."Customer Posting Group" := DebKart."Gen. Bus. Posting Group";
                DebKart."VAT Bus. Posting Group" := 'INDENLANDS';

                if StrLen(Felt06) <= 9 then begin
                    DebKart."Document Sending Profile" := '';
                    DebKart.GLN := '';
                    DebKart."OIOUBL-Profile Code" := '''';
                end
                else begin

                    DebKart."Document Sending Profile" := 'OIOUBL_KOPI';
                    DebKart.GLN := Felt06;
                    DebKart."OIOUBL-Profile Code" := 'BILSIM';
                end;
                DebKart."VAT Registration No." := Felt10;
                //Så kommer check på om der eksist. deb. grp. 03 med samme ean/momsnr
                FakKonto := '';
                if strlen(DebKart.GLN) > 9 then begin
                    Deb03.Reset;
                    Deb03.SetRange("Gen. Bus. Posting Group", '03');
                    Deb03.SetRange(GLN, Felt06);
                    if Deb03.FindSet then
                        FakKonto := Deb03."No.";

                end;

                if FakKonto = '' then begin
                    if StrLen(Felt10) >= 5 then begin
                        Deb03.Reset;
                        Deb03.SetRange("Gen. Bus. Posting Group", '03');
                        Deb03.SetRange("VAT Registration No.", Felt10);
                        if Deb03.FindSet then
                            FakKonto := Deb03."No.";
                    end;
                end;

                BUdenFak := false;
                if ((StrLen(DebKart.GLN) >= 9) OR (StrLen(DebKart."VAT Registration No.") >= 5)) and (StrLen(FakKonto) > 0) then begin
                    if (AMedlem = false) and (StrLen(DebKart.GLN) = 0) then
                        BUdenFak := true
                    else
                        Message('Check ' + DebKart."No." + '. Mangler fakturakonto');
                end;

                if (DebKart."No." <> FakKonto) and (StrLen(FakKonto) > 0) then
                    DebKart."Bill-to Customer No." := FakKonto;

                if StrLen(FakKonto) = 0 then
                    DebKart."Bill-to Customer No." := '';  //Måske bare konto

                DebKart.Name := Felt03 + ' ' + Felt04;

                if (Felt08 <> 'Privatperson') and (Felt08 <> 'Pensionist') then
                    DebKart.Address := Felt08
                else
                    DebKart.Address := '';

                DebKart."Address 2" := Felt15;
                DebKart."Post Code" := Felt16;
                DebKart.City := Felt17;
                if Felt17 = '' then begin
                    DebKart.Validate("Post Code");  //By/City fra debitor hvis ikke i fil
                end;

                if (BUdenFak = true) and (AMedlem = false) then begin
                    DebKart.Address := DebKart.Name;
                    DebKart.Name := Felt09;  //Firma
                end;

                DebKart."Phone No." := Felt13;
                DebKart."E-Mail" := Felt05;

                DebKart."Customer Posting Group" := DebKart."Gen. Bus. Posting Group";
                DebKart."VAT Bus. Posting Group" := 'INDENLANDS';
                DebKart."Search Name" := DebKart.Name;

                DebKart.Modify;

                //Så kommer opret salgsordre hvis der skiftes fra B-medlem til A-medlem
                if DebKart."Bill-to Customer No." <> '' then
                    FakKonto := DebKart."Bill-to Customer No."
                else
                    FakKonto := DebKart."No.";

                if (AMedlem = true) and (btoA = true) then begin
                    FakKart.Reset;
                    FakKart.SetRange("No.", FakKonto);
                    if FakKart.FindSet then begin
                        OrdKart.Reset;
                        OrdKart.Init;
                        OrdKart."Document Type" := OrdKart."Document Type"::Order;
                        //OrdKart.InitInsert;
                        //OrdKart.InitRecord;
                        //Message(OrdKart."No.");
                        OrdKart.Validate(OrdKart."Sell-to Customer No.", FakKart."No.");
                        OrdKart.Validate(OrdKart."Bill-to Customer No.", FakKart."No.");

                        if OrdKart."VAT Registration No." = '' then
                            OrdKart."VAT Registration No." := '00000000';

                        OrdKart."Shipment Date" := Today;
                        if FakKart."Fax No." <> '' then
                            OrdKart."Your Reference" := FakKart."Fax No.";
                        if FakKart."Fax No." <> '' then
                            OrdKart."External Document No." := FakKart."Fax No.";

                        OrdKart.Status := OrdKart.Status::Open;  //alternativt frigivet/released

                        OrdKart.Insert(true);

                        //Så kommer ordrelinier->
                        Clear(OrdLinie);
                        OrdLinie.validate(OrdLinie."Document Type", OrdKart."Document Type");
                        OrdLinie.Validate(OrdLinie."Document No.", OrdKart."No.");
                        OrdLinie."Line No." := 10000;
                        OrdLinie."Shipment Date" := OrdKart."Shipment Date";
                        OrdLinie.Type := OrdLinie.Type::Item;
                        //OrdLinie.Validate(Type);
                        //"Sales Line".Description := 'beskr. fra varen';  //FSLines.description;
                        Item.Get('110');
                        OrdLinie.Validate("No.", Item."No.");
                        OrdLinie.Description := Item.Description;
                        OrdLinie.Validate(quantity, 1);
                        OrdLinie.Validate("Unit Price");
                        if OrdLinie."Unit Price" = 0 then
                            OrdLinie."Unit Price" := 300;

                        OrdLinie.Validate(ordlinie.Amount, (OrdLinie."Unit Price" * OrdLinie.Quantity));
                        OrdLinie.Validate(OrdLinie."Line Amount", OrdLinie.Quantity * OrdLinie."Unit Price");
                        OrdLinie."Line Amount" := Round(OrdLinie."Line Amount", 0.01, '=');

                        //"Sales Line".Validate("Line No.", LineNo); //ændres

                        OrdLinie.Insert(true);

                        //Så kommer evt. bemærkning/note til linien                               

                        ComLine.Reset;
                        ComLine.Init;
                        ComLine."Document Type" := ComLine."Document Type"::Order;
                        ComLine."No." := OrdLinie."Document No.";
                        ComLine."Document Line No." := OrdLinie."Line No.";
                        ComLine."Line No." := 10000;
                        ComLine.Date := Today;
                        ComLine.Comment := Felt01 + ': ' + DebKart.Name;
                        ComLine.Insert(true);

                        if (Felt05 <> '') or (Felt13 <> '') then begin
                            ComLine.Init;
                            ComLine."Document Type" := ComLine."Document Type"::Order;
                            ComLine."No." := OrdLinie."Document No.";
                            ComLine."Document Line No." := OrdLinie."Line No.";
                            ComLine."Line No." := 20000;
                            ComLine.Date := Today;
                            ComLine.Comment := Felt05 + '  ' + Felt13;
                            ComLine.Insert(true);
                        end;
                    end
                    else
                        Message('Medlem: ' + Felt01 + ' eksisterer ikke');
                    //end;  //fakkart
                end; // opret salgsordre når fra B til A medlem

                //150921 until DebKart.NEXT = 0
            end
            else begin  //Opret ny debitor / Medlem
                DebKart.Reset;
                DebKart.Init;
                DebStd.Reset;
                DebStd.SetRange("No.", 'STANDARD');
                if DebStd.FindSet then
                    DebKart := DebStd;

                DebKart."No." := Felt01;

                if AMedlem = true then
                    DebKart."Gen. Bus. Posting Group" := '01'
                else
                    DebKart."Gen. Bus. Posting Group" := '02';

                DebKart."Customer Posting Group" := DebKart."Gen. Bus. Posting Group";
                DebKart."VAT Bus. Posting Group" := 'INDENLANDS';
                if StrLen(Felt06) <= 9 then begin
                    DebKart."Document Sending Profile" := '';
                    DebKart.GLN := '';
                    DebKart."OIOUBL-Profile Code" := '''';
                end
                else begin

                    DebKart."Document Sending Profile" := 'OIOUBL_KOPI';
                    DebKart.GLN := Felt06;
                    DebKart."OIOUBL-Profile Code" := 'BILSIM';
                end;
                DebKart."VAT Registration No." := Felt10;
                DebKart."E-Mail" := Felt05;

                if Felt01 = '' then
                    Message('Konto mangler: ' + Felt03);

                //Så kommer check på om der eksist. deb. grp. 03 med samme ean/momsnr
                FakKonto := '';
                if strlen(DebKart.GLN) > 9 then begin
                    Deb03.Reset;
                    Deb03.SetRange("Gen. Bus. Posting Group", '03');
                    Deb03.SetRange(GLN, Felt06);
                    if Deb03.FindSet then
                        FakKonto := Deb03."No.";

                end;

                if FakKonto = '' then begin
                    if StrLen(Felt10) >= 5 then begin
                        Deb03.Reset;
                        Deb03.SetRange("Gen. Bus. Posting Group", '03');
                        Deb03.SetRange("VAT Registration No.", Felt10);
                        if Deb03.FindSet then
                            FakKonto := Deb03."No.";
                    end;
                end;

                BUdenFak := false;
                if ((StrLen(DebKart.GLN) >= 9) OR (StrLen(DebKart."VAT Registration No.") >= 5)) and (StrLen(FakKonto) > 0) then begin
                    if (AMedlem = false) and (StrLen(DebKart.GLN) = 0) then
                        BUdenFak := true
                    else
                        Message('Check ' + DebKart."No." + '. Mangler fakturakonto');
                end;

                if (DebKart."No." <> FakKonto) and (StrLen(FakKonto) > 0) then
                    DebKart."Bill-to Customer No." := FakKonto;

                if StrLen(FakKonto) = 0 then
                    DebKart."Bill-to Customer No." := '';  //Måske bare konto

                DebKart.Name := Felt03 + ' ' + Felt04;

                if (Felt08 <> 'Privatperson') and (Felt08 <> 'Pensionist') then
                    DebKart.Address := Felt08
                else
                    DebKart.Address := '';

                DebKart."Address 2" := Felt15;
                DebKart."Post Code" := Felt16;
                DebKart.City := Felt17;
                if Felt17 = '' then begin
                    DebKart.Validate("Post Code");  //By/City fra debitor hvis ikke i fil
                end;

                if (BUdenFak = true) and (AMedlem = false) then begin
                    DebKart.Address := DebKart.Name;
                    DebKart.Name := Felt09;  //Firma
                end;

                DebKart."Phone No." := Felt13;
                DebKart."E-Mail" := Felt05;

                DebKart."Customer Posting Group" := DebKart."Gen. Bus. Posting Group";
                DebKart."VAT Bus. Posting Group" := 'INDENLANDS';
                DebKart."Search Name" := DebKart.Name;

                if DebKart."No." <> '' then
                    DebKart.Insert(true);

                //Husk salgsordre hvis det er et nyt A-medlem
                if DebKart."Bill-to Customer No." <> '' then
                    FakKonto := DebKart."Bill-to Customer No."
                else
                    FakKonto := DebKart."No.";

                if (AMedlem = true) then begin
                    FakKart.Reset;
                    FakKart.SetRange("No.", FakKonto);
                    if FakKart.FindSet then begin
                        OrdKart.Reset;
                        //OrdKart.Init;
                        Clear(OrdKart);
                        OrdKart."Document Type" := OrdKart."Document Type"::Order;
                        //OrdKart.InitInsert;
                        //OrdKart.InitRecord;
                        //Message(OrdKart."No." + '-99');
                        OrdKart.Validate(OrdKart."Sell-to Customer No.", FakKart."No.");
                        OrdKart.Validate(OrdKart."Bill-to Customer No.", FakKart."No.");

                        if OrdKart."VAT Registration No." = '' then
                            OrdKart."VAT Registration No." := '00000000';

                        OrdKart."Shipment Date" := Today;
                        if FakKart."Fax No." <> '' then
                            OrdKart."Your Reference" := FakKart."Fax No.";
                        if FakKart."Fax No." <> '' then
                            OrdKart."External Document No." := FakKart."Fax No.";

                        OrdKart.Status := OrdKart.Status::Open;  //alternativt frigivet/released

                        OrdKart.Insert(true);
                        //Message(OrdKart."No." + '-500');
                        //Så kommer ordrelinier->
                        Clear(OrdLinie);
                        OrdLinie.validate(OrdLinie."Document Type", OrdKart."Document Type");
                        OrdLinie.Validate(OrdLinie."Document No.", OrdKart."No.");
                        OrdLinie."Line No." := 10000;
                        OrdLinie."Shipment Date" := OrdKart."Shipment Date";
                        OrdLinie.Type := OrdLinie.Type::Item;
                        //OrdLinie.Validate(Type);
                        //"Sales Line".Description := 'beskr. fra varen';  //FSLines.description;
                        //Message(OrdLinie.Description + '-777');
                        Item.Get('110');
                        OrdLinie.Validate("No.", Item."No.");
                        OrdLinie.Description := Item.Description;
                        OrdLinie.Validate(quantity, 1);
                        OrdLinie.Validate("Unit Price");
                        if OrdLinie."Unit Price" = 0 then
                            OrdLinie."Unit Price" := 300;

                        OrdLinie.Validate(ordlinie.Amount, (OrdLinie."Unit Price" * OrdLinie.Quantity));
                        OrdLinie.Validate(OrdLinie."Line Amount", OrdLinie.Quantity * OrdLinie."Unit Price");
                        OrdLinie."Line Amount" := Round(OrdLinie."Line Amount", 0.01, '=');

                        //"Sales Line".Validate("Line No.", LineNo); //ændres

                        OrdLinie.Insert(true);

                        //Så kommer evt. bemærkning/note til linien                               

                        ComLine.Reset;
                        ComLine.Init;
                        ComLine."Document Type" := ComLine."Document Type"::Order;
                        ComLine."No." := OrdLinie."Document No.";
                        ComLine."Document Line No." := OrdLinie."Line No.";
                        ComLine."Line No." := 10000;
                        ComLine.Date := Today;
                        ComLine.Comment := Felt01 + ': ' + DebKart.Name;
                        ComLine.Insert(true);

                        if (Felt05 <> '') or (Felt13 <> '') then begin
                            ComLine.Init;
                            ComLine."Document Type" := ComLine."Document Type"::Order;
                            ComLine."No." := OrdLinie."Document No.";
                            ComLine."Document Line No." := OrdLinie."Line No.";
                            ComLine."Line No." := 20000;
                            ComLine.Date := Today;
                            ComLine.Comment := Felt05 + '  ' + Felt13;
                            ComLine.Insert(true);
                        end;
                    end
                    else
                        Message('Medlem: ' + Felt01 + ' eksisterer ikke');
                    //end;  //fakkart
                end; // opret salgsordre når fra B til A medlem
            end;

        end;
        Lin1 := false;

    end;


}
