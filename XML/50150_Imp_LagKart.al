xmlport 50160 "50156_Imp_LagKart"
{
    //Import af ekstra felter fra C5 Lagerkart

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
                XmlName = 'ImpLagKart';
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

                trigger OnBeforeInsertRecord()
                var
                //counter: Integer;

                begin

                    Counter := Counter + 1;   // pga fejl i indsæt på temp. tabel integer.
                    Integer.Number := Counter;


                    IF Felt01 <> '' THEN begin

                        GenPostSetupImp;  //bogopsæt


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
        ComLine: Record "Comment Line";
        LineNo: Decimal;
        LineNoOld: Decimal;

    /*
    EVALUATE(Dag,COPYSTR(Felt02,1,2));
    EVALUATE(Måned,COPYSTR(Felt02,4,2));
    EVALUATE(År,COPYSTR(Felt02,7,4));
    Dato := DMY2DATE(Dag,Måned,År);  //Dato oprettet

    EVALUATE(Løbenummer,Felt01);
    */


    local procedure GenPostSetupImp()
    begin

        Item.RESET;
        Item.SetRange("No.", Felt01);
        //250718 GenPostSetup.SETRANGE("Gen. Bus. Posting Group",Felt01);

        IF Item.FINDSET then
            repeat
            /*
                evaluate(Item.StkKrt, Felt02);
                Item.Trykfarve1 := Felt03;
                Item.Trykfarve2 := Felt04;
                Item.Trykfarve3 := Felt05;
                Item.Trykfarve4 := Felt06;
                Item.KvalFarve := Felt07;
                Evaluate(Item.TrykLgd, Felt08);
                Item.KlicheNr := Felt09;
                Item.Remark := Felt10;
                if Felt11 = '1' then
                    Item.Type_ := Item.Type_::Tryktape;
                if Felt11 = '2' then
                    Item.Type_ := Item.Type_::"Standard tape";
                if Felt11 = '3' then
                    Item.Type_ := Item.Type_::Dispenser;

                Evaluate(Item."Gross Weight", Felt12);

                Item.Modify;
                */
            /*
                Evaluate(item.MinPris, Felt02);

                Item.P1 := Felt03;
                Item.P2 := Felt04;

                Evaluate(item.StrPrKs, Felt05);

                Item.Short := Felt06;

                if Felt07 = '0' then
                    Item.PaySaldo := false
                else
                    Item.PaySaldo := true;

                if Felt08 = '0' then
                    Item.NoInnoItem := false
                else
                    Item.NoInnoItem := true;

                Item.UnNumber := Felt09;

                if Felt10 = '0' then
                    Item.Farlig := false
                else
                    Item.Farlig := true;

                Evaluate(item.StkPrLag, Felt11);
                Evaluate(item.StkPrPal, Felt12);

                Item.PlacCopy := Felt13;

                item.CostCurrency := Felt14;

                Evaluate(item.CostPriceVAL, Felt15);

                Item.ProductVariantId := Felt16;
                

                Item.MODIFY;
                */
            until Item.NEXT = 0;

    end;


}
