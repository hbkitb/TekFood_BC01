codeunit 50151 "50151_Diverse_OP_ERPG"
{

    trigger OnRun()
    begin
        MESSAGE('igang');
        //Mydialog.Open('Agiv kørsel', Svar01);
        Svar01 := Dialog.StrMenu('Imp LagKart,Imp DebKart,Imp Medarb,Imp Varegrp,Imp KostVAL,Check Kost');

        case Svar01 of
            1:
                begin
                    Message('LagKart');
                    Xmlport.Run(Xmlport::"50156_Imp_LagKart");
                end;
            2:
                begin
                    Message('DebKart');
                    Xmlport.Run(Xmlport::"50152_Imp_DebKart");
                end;
            3:
                begin
                    Message('MedKart');
                    Xmlport.Run(Xmlport::"50153_Imp_MedKart");
                end;
            4:
                begin
                    Message('VareGrp');
                    Xmlport.Run(Xmlport::"50154_Imp_VareBogGrp");
                end;
            5:
                begin
                    Message('KostVAL');
                    Xmlport.Run(Xmlport::"50155_Imp_LagKostVal");
                end;
            6:
                begin
                    Message('CHECK KOST');
                    Currency.GetLastestExchangeRate('NOK', DateT, CurrencyExRate);
                    Message(Format(CurrencyExRate));
                    Currency.GetLastestExchangeRate('SEK', DateT, CurrencyExRate);
                    Message(Format(CurrencyExRate));
                    Currency.GetLastestExchangeRate('EUR', DateT, CurrencyExRate);
                    Message(Format(CurrencyExRate));
                end;
        end;
        /* 230719 
        cust.Reset();
        cust.SetRange("Gen. Bus. Posting Group", '11');
        if cust.FindSet() then
            repeat
                //cust."Gen. Bus. Posting Group" := cust."Customer Posting Group";
                cust."VAT Bus. Posting Group" := 'DANMARK';
                cust.Modify();
            until cust.Next() = 0;
         230719 */

        /*151118
        FinKonto.RESET;
        FinKonto.SETRANGE("Gen. Posting Type",1);
        //FinKonto.SETFILTER("No.",'03001|03002..03020');
        IF FinKonto.FINDSET THEN
           REPEAT
              FinKonto."Gen. Bus. Posting Group" := 'DANMARK';
              FinKonto."Gen. Prod. Posting Group" := 'DIV';
              FinKonto."VAT Bus. Posting Group" := 'DANMARK';
              FinKonto."VAT Prod. Posting Group" := 'MOMS25';
              //FinKonto."Gen. Posting Type" := 1;
              FinKonto.MODIFY;
           UNTIL FinKonto.NEXT = 0;
        */


        /*180319
        {samle fak. + Sprog}
        cust.RESET;
        IF cust.FINDSET THEN
          REPEAT
         //   cust."Combine Shipments" := TRUE;
            IF cust."Language Code" = 'ISL' THEN
               cust."Language Code" := 'SVE';
            IF cust."Language Code" = 'NLD' THEN
               cust."Language Code" := 'NOR';
        
            cust.MODIFY;
          UNTIL cust.NEXT = 0;
        {}
        180319*/

        /*
        Teksten := 'ab123fff45cc6';
        pksizetext := '';
               pksizecount := 1;
               WHILE pksizecount <= STRLEN(Teksten) DO BEGIN
                 IF STRPOS('0123456789',COPYSTR(Teksten,pksizecount,1) ) > 0 THEN
                   pksizetext := pksizetext + COPYSTR(Teksten,pksizecount,1);
                 pksizecount := pksizecount + 1;
               END;
               EVALUATE(pksize,pksizetext);
        */
        //250718 EVALUATE(pksize,'-2345');
        //250718 MESSAGE(FORMAT(pksize));
        /*
        VirkBog.RESET;
        IF VirkBog.FINDSET THEN
          REPEAT
              IF VirkBog."Def. VAT Prod. Posting Group" = '' THEN BEGIN
                VirkBog."Def. VAT Prod. Posting Group" := 'MOMS25';
                VirkBog.MODIFY;
             END;
          UNTIL VirkBog.NEXT = 0;
        */

        /*varer skaberlonerne
        VirkBog.RESET;
        VirkBog.SETFILTER(Code,'011|026|035|036|078|085|126|178');
        //VirkBog.SETRANGE(Code,'035');
        //VirkBog.SETRANGE
        IF VirkBog.FINDSET THEN
          REPEAT
              Streng := VirkBog.Code;
              IF VirkBog.Code <> '001' THEN BEGIN
                 IF COPYSTR(VirkBog.Code,1,2)='00' THEN
                    Streng := COPYSTR(VirkBog.Code,3,1);
                 IF COPYSTR(VirkBog.Code,1,1)='0' THEN
                    Streng := COPYSTR(VirkBog.Code,2,2);
        
                 TempHoved.INIT;
                 TempHoved.Code := 'S-' + Streng;
                 TempHoved.Description := Streng;
                 TempHoved."Table ID" := 27;
                 TempHoved.Enabled := TRUE;
                 TempHoved."Table Name" := 'Item';
                 TempHoved.INSERT;
        
                 TempLineUd.RESET;
                 TempLineUd.SETRANGE(TempLineUd."Data Template Code",'S-1');
                 IF TempLineUd.FINDSET THEN
                    REPEAT
                       TempLinie.INIT;
                       TempLinie."Data Template Code" := TempHoved.Code;
                       TempLinie.Type := TempLineUd.Type;
                       TempLinie."Line No." := TempLineUd."Line No.";
                       TempLinie."Field ID" := TempLineUd."Field ID";
                       TempLinie."Field Name" := TempLineUd."Field Name";
                       TempLinie."Table ID" := TempLineUd."Table ID";
                       TempLinie."Table Name" := TempLineUd."Table Name";
                       TempLinie."Template Description" := TempLineUd."Template Description";
                       TempLinie.INSERT;
                    UNTIL TempLineUd.NEXT = 0;
        
             END;
          UNTIL VirkBog.NEXT = 0;
        */


        /*
        TempLinie.RESET;
        IF TempLinie.FINDSET THEN
           IF STRLEN(TempLinie."Data Template Code") < 6 THEN
           REPEAT
              Streng := COPYSTR(TempLinie."Data Template Code" ,3,3);
              IF STRLEN(Streng) = 2 THEN
                 Streng := '0' + Streng
              ELSE
                 IF STRLEN(Streng) = 1 THEN
                    Streng := '00' + Streng;
        
              CASE TempLinie."Line No." OF
                 10000:
                  TempLinie."Default Value" := Streng;
                 20000:
                 TempLinie."Default Value" := 'MOMS25';
                 30000:
                  TempLinie."Default Value" := Streng;
                 40000:
                  TempLinie."Default Value" := 'FIFO';
              END;
              TempLinie.MODIFY;
           UNTIL TempLinie.NEXT = 0;
        */


        /*
        //Debitor / Kreditor - en af gangen
        VirkBogD.RESET;
        IF VirkBogD.FINDSET THEN
          REPEAT
              Streng := VirkBogD.Code;
              IF ((VirkBogD.Code <> '01') AND (STRLEN(VirkBogD.Code) < 5)) THEN BEGIN
                 IF COPYSTR(VirkBogD.Code,1,2)='00' THEN
                    Streng := COPYSTR(VirkBog.Code,3,1);
                 IF COPYSTR(VirkBogD.Code,1,1)='0' THEN
                    Streng := COPYSTR(VirkBogD.Code,2,2);
        
                 TempHoved.INIT;
                 TempHoved.Code := 'K-' + Streng;
                 TempHoved.Description := Streng;
                 TempHoved."Table ID" := 23;
                 TempHoved.Enabled := TRUE;
                 TempHoved."Table Name" := 'Vendor';
                 TempHoved.INSERT;
        
                 TempLineUd.RESET;
                 TempLineUd.SETRANGE(TempLineUd."Data Template Code",'K-1');
                 IF TempLineUd.FINDSET THEN
                    REPEAT
                       TempLinie.INIT;
                       TempLinie."Data Template Code" := TempHoved.Code;
                       TempLinie.Type := TempLineUd.Type;
                       TempLinie."Line No." := TempLineUd."Line No.";
                       TempLinie."Field ID" := TempLineUd."Field ID";
                       TempLinie."Field Name" := TempLineUd."Field Name";
                       TempLinie."Table ID" := TempLineUd."Table ID";
                       TempLinie."Table Name" := TempLineUd."Table Name";
                       TempLinie."Template Description" := TempLineUd."Template Description";
                       TempLinie.INSERT;
                    UNTIL TempLineUd.NEXT = 0;
        
             END;
          UNTIL VirkBogD.NEXT = 0;
        */

        /*
        //Først debitor så kreditor
        TempLinie.RESET;
        IF TempLinie.FINDSET THEN
           IF (STRLEN(TempLinie."Data Template Code") < 6)  THEN
           REPEAT
              IF (COPYSTR(TempLinie."Data Template Code",1,1)='K') THEN BEGIN
                 Streng := COPYSTR(TempLinie."Data Template Code" ,3,3);
                 IF STRLEN(Streng) = 2 THEN
                    Streng := '0' + Streng
                 ELSE
                    IF STRLEN(Streng) = 1 THEN
                       Streng := '00' + Streng;
        
                 CASE TempLinie."Line No." OF
                    10000:
                     TempLinie."Default Value" := Streng;
                    20000:
                    TempLinie."Default Value" := 'DANMARK';
                    30000:
                    TempLinie."Default Value" := Streng;
        
                 END;
                 TempLinie.MODIFY;
              END;
           UNTIL TempLinie.NEXT = 0;
        */


        //021118 - Herfra igang

        /*kørt 021118 
        //Udfyld bogf.opsætning med alle kombinationer
        VirkBog.RESET;
        //VirkBog.SETRANGE(Code,'030');
        IF VirkBog.FINDSET THEN BEGIN
            REPEAT
                VirkBogD.RESET;
                IF VirkBogD.FINDSET THEN BEGIN
                    REPEAT
                        IF ((STRLEN(VirkBogD.Code) <= 2) AND (VirkBogD.Code <> 'EU')) THEN BEGIN
                            Bogop.RESET;
                            Bogop.INIT;
                            Bogop."Gen. Bus. Posting Group" := VirkBogD.Code;
                            Bogop."Gen. Prod. Posting Group" := VirkBog.Code;
                            Bogop.INSERT;
                        END;
                    UNTIL VirkBogD.NEXT = 0;
                END;
            UNTIL VirkBog.NEXT = 0;
        END;
        */

        /*kørt 021118
        //Udfyld bogf.opsætning med blanke kombinationer
        VirkBog.RESET;
        //VirkBog.SETRANGE(Code,'030');
        IF VirkBog.FINDSET THEN BEGIN
           REPEAT
                    IF ((STRLEN(VirkBog.Code) <= 3) AND (VirkBog.Code <> 'DIV')) THEN BEGIN
                       Bogop.RESET;
                       Bogop.INIT;
                       Bogop."Gen. Bus. Posting Group" := '';  //VirkBogD.Code;
                       Bogop."Gen. Prod. Posting Group" := VirkBog.Code;
                       Bogop.INSERT;
                    END;
        
        
           UNTIL VirkBog.NEXT = 0;
        END;
        */

        /*
        {040917}
        TempHeader.RESET;
        IF TempHeader.FINDSET THEN BEGIN
           //MESSAGE(TempHeader.Code);
           REPEAT
              IF COPYSTR(TempHeader.Code,1,2) = 'V-' THEN BEGIN
                 //IF COPYSTR(TempHeader.Code,3)='1' THEN MESSAGE(TempHeader.Code);
                 TempHeaderNy.RESET;
                 TempHeaderNy.INIT;
                 TempHeaderNy.Code := 'S' + COPYSTR(TempHeader.Code,2,10);
                 TempHeaderNy.Description := TempHeader.Description;
                 TempHeaderNy."Table ID" := TempHeader."Table ID";
                 TempHeaderNy.Enabled := TempHeader.Enabled;
                 TempHeaderNy."Table Name" := TempHeader."Table Name";
                 TempHeaderNy."Table Caption" := TempHeader."Table Caption";
                 TempHeaderNy."Used In Hierarchy" := TempHeader."Used In Hierarchy";
                 TempHeaderNy.INSERT;
              END;
           UNTIL TempHeader.NEXT = 0;
        END;
        
        {040917}
        
        TempLine.RESET;
        IF TempLine.FINDSET THEN BEGIN
           //MESSAGE(TempHeader.Code);
           REPEAT
              IF COPYSTR(TempLine."Data Template Code",1,2) = 'V-' THEN BEGIN
                 //IF COPYSTR(TempHeader.Code,3)='1' THEN MESSAGE(TempHeader.Code);
                 TempLineNy.RESET;
                 TempLineNy.INIT;
                 TempLineNy."Data Template Code" := 'S' + COPYSTR(TempLine."Data Template Code",2,10);
                 TempLineNy."Line No." := TempLine."Line No.";
                 TempLineNy.Type := TempLine.Type;
                 TempLineNy."Field ID" := TempLine."Field ID";
                 TempLineNy."Field Name" := TempLine."Field Name";
                 TempLineNy."Table ID" := TempLine."Table ID";
                 TempLineNy."Template Code" := TempLine."Template Code";
                 TempLineNy.Mandatory := TempLine.Mandatory;
                 TempLineNy.Reference := TempLine.Reference;
                 TempLineNy."Default Value" := TempLine."Default Value";
                 TempLineNy."Skip Relation Check" := TempLine."Skip Relation Check";
                 TempLineNy."Language ID" := TempLine."Language ID";
                 TempLineNy."Table Name" := TempLine."Table Name";
                 TempLineNy."Template Description" := TempLine."Template Description";
                 TempLineNy."Table Caption" := TempLine."Table Caption";
                 TempLineNy."Field Caption" := TempLine."Field Caption";
                 TempLineNy.INSERT;
              END;
           UNTIL TempLine.NEXT = 0;
        END;
        */

        /*250718 kørt 021118
        VirkBog3.RESET;  //
        IF VirkBog3.FINDSET THEN
          REPEAT
             VirkBog2 := VirkBog3;
             {IF STRLEN(VirkBog3.Code) = 1 THEN BEGIN
                VirkBog2.Code := '00' + VirkBog3.Code;
                VirkBog2.INSERT;
             END;}
             IF STRLEN(VirkBog3.Code) = 2 THEN BEGIN
                VirkBog2.Code := '0' + VirkBog3.Code;
                VirkBog2.INSERT;
             END;
          UNTIL VirkBog3.NEXT = 0;
        250718*/

        /*281217 - 250718 - 011118
        JLine.RESET;
        IF JLine.FINDSET THEN
           REPEAT
              JLine.Quantity := JLine.Quantity;
              JLine.MODIFY;
        
            IF JLine."Invoiced Quantity" < 0 THEN
               JLine."Invoiced Quantity" := - JLine."Invoiced Quantity";
        
            IF JLine."Quantity (Base)" < 0 THEN
                 JLine."Quantity (Base)" := - JLine."Quantity (Base)";
        
            IF JLine."Invoiced Qty. (Base)" < 0 THEN
                 JLine."Invoiced Qty. (Base)" := - JLine."Invoiced Qty. (Base)";
        
            IF JLine.Amount < 0 THEN
                 JLine.Amount := - JLine.Amount;
        
            JLine.MODIFY
        
        
           UNTIL JLine.NEXT = 0;
        250718*/

        /*
       VareBog.RESET;  //
       IF VareBog.FINDSET THEN
         REPEAT
            VareBog2 := VareBog;
            IF STRLEN(VareBog."Invt. Posting Group Code") = 2 THEN BEGIN
               VareBog2."Invt. Posting Group Code" := '0' + VareBog."Invt. Posting Group Code";
               VareBog2.INSERT;
            END;
            IF STRLEN(VareBog."Invt. Posting Group Code") = 1 THEN BEGIN
               VareBog2."Invt. Posting Group Code" := '00' + VareBog."Invt. Posting Group Code";
               VareBog2.INSERT;
            END;
         UNTIL VareBog.NEXT = 0;
         */

        /*021118
        VirkBog.RESET;  //
        IF VirkBog.FINDSET THEN
          REPEAT
             VareBog2.INIT;
             //VareBog2 := VareBog;
             //IF STRLEN(VareBog."Invt. Posting Group Code") = 2 THEN BEGIN
                VareBog2."Invt. Posting Group Code" := VirkBog.Code;
                VareBog2.INSERT;
        
             {
             END;
             IF STRLEN(VareBog."Invt. Posting Group Code") = 1 THEN BEGIN
                VareBog2."Invt. Posting Group Code" := '00' + VareBog."Invt. Posting Group Code";
                VareBog2.INSERT;
             END;
             }
          UNTIL VirkBog.NEXT = 0;
          021118*/

        /* - 230719
        //Opret ny bogføringsopsætning på grundlag af gammel
        Bogop.RESET;
        Bogop.SETRANGE("Gen. Prod. Posting Group",'010');
        
        IF Bogop.FINDSET THEN BEGIN
           REPEAT
              BogopKopi.RESET;
              BogopKopi.INIT;
              BogopKopi := Bogop;
              BogopKopi."Gen. Prod. Posting Group" := '112';
              BogopKopi.INSERT;
        
           UNTIL Bogop.NEXT = 0;
        END;
        230719 */
    end;

    var
        VirkBog: Record "Gen. Product Posting Group";
        TempHoved: Record "Config. Template Header";
        TempLinie: Record "Config. Template Line";
        TempLineUd: Record "Config. Template Line";
        Streng: Text[50];
        VirkBogD: Record "Gen. Business Posting Group";
        Bogop: Record "General Posting Setup";
        TempHeader: Record "Config. Template Header";
        TempLine: Record "Config. Template Line";
        TempHeaderNy: Record "Config. Template Header";
        TempLineNy: Record "Config. Template Line";
        JLine: Record "Item Journal Line";
        VirkBog2: Record "Inventory Posting Group";
        VirkBog3: Record "Inventory Posting Group";
        VareBog: Record "Inventory Posting Setup";
        VareBog2: Record "Inventory Posting Setup";
        pksize: Integer;
        pksizetext: Text[50];
        pksizecount: Integer;
        Teksten: Text[50];
        A: array[60] of Text[30];
        cust: Record Customer;
        FinKonto: Record "G/L Account";
        BogopKopi: Record "General Posting Setup";

        MyDialog: Dialog;

        Svar01: Option ImpLagKart,ImpDebKart,ImpMedarb,ImpVareGrp;
        DateT: Date;
        CurrencyExRate: Decimal;
        currency: Record "Currency Exchange Rate";

}

