codeunit 50148 "Inno EventSubscriber"
{
    trigger OnRun()
    begin

    end;

    var

    //Expo - 250321
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Item", 'OnAfterCopyItem', '', false, false)]
    local procedure CopyItem_NoKliche(var TargetItem: Record Item)
    var

    //cod: Codeunit "Lagstat ERPG"; //
    begin
        //160621 TargetItem.KlicheNr := '';
        //160621 TargetItem.Modify;

        //Message('åbne ' + 'kliche');
        //cod.UpdateLAGSTAT();
    end;
    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"Company-Initialize", 'OnCompanyInitialize', '', false, false)]
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company Triggers", 'OnCompanyopen', '', false, false)]
    local procedure UpdateInventory()
    var

    //cod: Codeunit "Lagstat ERPG"; //
    begin
        //Message('åbne ' + CompanyName);
        //cod.UpdateLAGSTAT();
    end;


    //050121
    [EventSubscriber(ObjectType::Table, 18, 'OnBeforeInsertEvent', '', true, true)]
    local procedure SetCompanyId(VAR Rec: Record Customer; RunTrigger: Boolean)
    var
    //lab: Record Customer;

    begin
        //rec.CompanyId := rec.SystemId;

    end;



    //070521 - Her kommer vedr. Modify (Evt. Delete varer opdat oplysn. på åbne salgsordrer)
    [EventSubscriber(ObjectType::Table, 27, 'OnAfterModifyEvent', '', true, true)]
    local procedure ItemSetSalesHeaderMod(VAR Rec: Record Item; RunTrigger: Boolean)
    var


        Item: Record Item;
        SalesLineHead: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        Found: Boolean;

    begin

        // 040521
        if Rec."Assembly BOM" = true then begin
            SalesHeader.Reset;
            SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
            SalesHeader.SetRange(Status, SalesHeader.Status::Open);

            if SalesHeader.FindSet then begin
                repeat
                    Found := false;
                    SalesLineHead.Reset;
                    SalesLineHead.SetCurrentKey("Document Type", "Document No.", "Line No.");
                    SalesLineHead.SetRange("Document No.", SalesHeader."No.");
                    SalesLineHead.SetRange("Document Type", SalesHeader."Document Type");
                    SalesLineHead.SetRange(Type, SalesLineHead.Type::Item);
                    if SalesLineHead.FindSet then begin
                        repeat
                            if Found = false then begin
                                Item.Reset;
                                Item.SetRange("No.", SalesLineHead."No.");
                                Item.SetRange("Assembly BOM", true);
                                if Item.FindFirst then begin
                                    Found := true;

                                    if SalesLineHead."No." = rec."No." then begin
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
                                            Salesheader.Modify;
                                        end;
                                        */
                                    end

                                end;
                            end;
                        until SalesLineHead.Next = 0;
                    end;
                until SalesHeader.Next = 0;
            end;
        end;

    end;


    //070521 - opdat oplysn. på ordrer fra varer
    //OnAfterAssignHeaderValues
    //OnAfterAssignFieldsForNo

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterInsertEvent', '', true, true)]
    local procedure SetSalesHeaderItem(VAR Rec: Record "Sales Line"; RunTrigger: Boolean)
    var


        Item: Record Item;
        SalesLineHead: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        Found: Boolean;

    begin

        //040521
        //Message((Format(rec."Line No.")));
        if Rec."Line No." <> 0 then begin
            SalesHeader.Reset;
            SalesHeader.SetRange("Document Type", Rec."Document Type");
            SalesHeader.SetRange("No.", Rec."Document No.");
            if SalesHeader.FindFirst then begin
                Found := false;
                SalesLineHead.Reset;
                SalesLineHead.SetCurrentKey("Document Type", "Document No.", "Line No.");
                SalesLineHead.SetRange("Document No.", Rec."Document No.");
                SalesLineHead.SetRange("Document Type", Rec."Document Type"::Order);
                SalesLineHead.SetRange(Type, SalesLineHead.Type::Item);
                if SalesLineHead.FindSet then begin
                    repeat
                        if Found = false then begin
                            Item.Reset;
                            Item.SetRange("No.", SalesLineHead."No.");
                            Item.SetRange("Assembly BOM", true);
                            /*
                            if Item.FindFirst then begin
                                Found := true;
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
                            end;
                            */



                        end; //found
                    until SalesLineHead.Next = 0;
                end;
                if Found = false then begin
                    /*
                    Salesheader.Trykfarve1 := ''; //Item.Trykfarve1;
                    Salesheader.Trykfarve2 := ''; //Item.Trykfarve2;
                    Salesheader.Trykfarve3 := ''; //Item.Trykfarve3;
                    Salesheader.Trykfarve4 := ''; //Item.Trykfarve4;
                    Salesheader.BrtWeight := 0; //Item."Gross Weight";
                    Salesheader.KvalFarve := ''; //Item.KvalFarve;
                    Salesheader.TrykLgd := 0; //Item.TrykLgd;
                    Salesheader.KlicheNr := ''; //Item.KlicheNr;
                    Salesheader.Remark := ''; //Item.Remark;
                    Salesheader.Type_ := Item.Type_::" ";   //Item.Type_;
                    Salesheader.AfrulningsRetning := Item.AfrulningsRetning::" ";   //Item.AfrulningsRetning;
                    Salesheader.Volume := 0;  //Item."Unit Volume";         
                    */
                end;
            end;
        end;

    end;
    //050121

    //070521
    [EventSubscriber(ObjectType::Table, 37, 'OnAfterModifyEvent', '', true, true)]
    local procedure SetSalesHeaderItemMod(VAR Rec: Record "Sales Line"; RunTrigger: Boolean)
    var


        Item: Record Item;
        SalesLineHead: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        Found: Boolean;

    begin

        // 040521
        //Message((Format(rec."Line No.")));
        if Rec."Line No." <> 0 then begin
            SalesHeader.Reset;
            SalesHeader.SetRange("Document Type", Rec."Document Type");
            SalesHeader.SetRange("No.", Rec."Document No.");
            if SalesHeader.FindFirst then begin
                Found := false;
                SalesLineHead.Reset;
                SalesLineHead.SetCurrentKey("Document Type", "Document No.", "Line No.");
                SalesLineHead.SetRange("Document No.", Rec."Document No.");
                SalesLineHead.SetRange("Document Type", Rec."Document Type"::Order);
                SalesLineHead.SetRange(Type, SalesLineHead.Type::Item);
                //Message('header');
                if SalesLineHead.FindSet then begin
                    repeat
                        if Found = false then begin

                            Item.Reset;
                            Item.SetRange("No.", SalesLineHead."No.");
                            Item.SetRange("Assembly BOM", true);
                            //Message('line');
                            /*
                            if Item.FindFirst then begin
                                Found := true;
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
                                Salesheader.Modify;

                                //Message('item');
                            end;
                            */
                        end; //found
                    until SalesLineHead.Next = 0;
                end;
                if Found = false then begin
                    /*
                    Salesheader.Trykfarve1 := ''; //Item.Trykfarve1;
                    Salesheader.Trykfarve2 := ''; //Item.Trykfarve2;
                    Salesheader.Trykfarve3 := ''; //Item.Trykfarve3;
                    Salesheader.Trykfarve4 := ''; //Item.Trykfarve4;
                    Salesheader.BrtWeight := 0; //Item."Gross Weight";
                    Salesheader.KvalFarve := ''; //Item.KvalFarve;
                    Salesheader.TrykLgd := 0; //Item.TrykLgd;
                    Salesheader.KlicheNr := ''; //Item.KlicheNr;
                    Salesheader.Remark := ''; //Item.Remark;
                    Salesheader.Type_ := Item.Type_::" ";   //Item.Type_;
                    Salesheader.AfrulningsRetning := Item.AfrulningsRetning::" ";   //Item.AfrulningsRetning;
                    Salesheader.Volume := 0;  //Item."Unit Volume";   
                    SalesHeader.Modify;
                    */
                end;
            end;
        end;

    end;
    //050121

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterDeleteEvent', '', true, true)]
    local procedure SetSalesHeaderItemDel(VAR Rec: Record "Sales Line"; RunTrigger: Boolean)
    var


        Item: Record Item;
        SalesLineHead: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        Found: Boolean;

    begin

        // 040521
        if Rec."Line No." <> 0 then begin
            SalesHeader.Reset;
            SalesHeader.SetRange("Document Type", Rec."Document Type");
            SalesHeader.SetRange("No.", Rec."Document No.");
            if SalesHeader.FindFirst then begin
                Found := false;
                SalesLineHead.Reset;
                SalesLineHead.SetCurrentKey("Document Type", "Document No.", "Line No.");
                SalesLineHead.SetRange("Document No.", Rec."Document No.");
                SalesLineHead.SetRange("Document Type", Rec."Document Type"::Order);
                SalesLineHead.SetRange(Type, SalesLineHead.Type::Item);
                if SalesLineHead.FindSet then begin
                    repeat
                        if Found = false then begin

                            Item.Reset;
                            Item.SetRange("No.", SalesLineHead."No.");
                            Item.SetRange("Assembly BOM", true);
                            /*
                            if Item.FindFirst then begin
                                found := true;
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
                                Salesheader.Modify;

                            end;
                            */
                        end; //found
                    until SalesLineHead.Next = 0;
                end;
                if Found = false then begin
                    /*
                    Salesheader.Trykfarve1 := ''; //Item.Trykfarve1;
                    Salesheader.Trykfarve2 := ''; //Item.Trykfarve2;
                    Salesheader.Trykfarve3 := ''; //Item.Trykfarve3;
                    Salesheader.Trykfarve4 := ''; //Item.Trykfarve4;
                    Salesheader.BrtWeight := 0; //Item."Gross Weight";
                    Salesheader.KvalFarve := ''; //Item.KvalFarve;
                    Salesheader.TrykLgd := 0; //Item.TrykLgd;
                    Salesheader.KlicheNr := ''; //Item.KlicheNr;
                    Salesheader.Remark := ''; //Item.Remark;
                    Salesheader.Type_ := Item.Type_::" ";   //Item.Type_;
                    Salesheader.AfrulningsRetning := Item.AfrulningsRetning::" ";   //Item.AfrulningsRetning;
                    Salesheader.Volume := 0;  //Item."Unit Volume";       
                    SalesHeader.Modify;
                    */
                end;
            end;
        end;

    end;
    //050121
    //070521


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterCheckSalesDoc', '', false, false)]
    local procedure GetConsignorPakkeNo(VAR SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean)
    var
    /*
    lab: Record "Con Label Printer ERPG";
    ftp: Record "Ftp Service File ERPG";
    FtpProfile: Record "Ftp Profile ERPG";
    xml: XmlPort "Consignor Import ERPG";
    ins: InStream;
    t: Text;
    cc: Codeunit "Api Call FTP ERPG";
    aa: Text;
    */
    begin
        /*
        if SalesHeader."Package Tracking No." = '' then begin
            cc.run;
            lab.SetRange(IsDefault);

            if lab.FindFirst() then begin

                FtpProfile.SetRange(ID, Format(lab.FileExportProfile));
                if FtpProfile.FindFirst() then begin

                    ftp.SetRange(FtpProfileID, Format(lab.FileExportProfile));
                    ftp.SetRange(FilePath, FtpProfile.Path);
                    ftp.SetRange(FileName, SalesHeader."No." + '.txt');

                    if ftp.FindFirst() then begin

                        ftp.CalcFields(FileBlob);
                        ftp.FileBlob.CreateInStream(ins);
                        ins.ReadText(t);

                        aa := ConvertStr(t, ',', ',');
                        aa := SelectStr(4, aa);
                        SalesHeader."Package Tracking No." := aa;
                        SalesHeader.Modify(true);

                        cc.DeleteFile(SalesHeader."Consignor filename", FtpProfile);
                        cc.DeleteFile(SalesHeader."No." + '.txt', FtpProfile);


                    end;
                end;
            end;
        end;
        */
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeFinalizePosting', '', false, false)]
    local procedure DeleteConsignorFile(VAR SalesHeader: Record "Sales Header")
    var
    /*
    lab: Record "Con Label Printer ERPG";
    ftp: Record "Ftp Service File ERPG";
    FtpProfile: Record "Ftp Profile ERPG";
    xml: XmlPort "Consignor Import ERPG";
    ins: InStream;
    t: Text;
    cc: Codeunit "Api Call FTP ERPG";
    aa: Text;
    */

    begin


    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeFinalizePosting', '', false, false)]
    local procedure CreateInvoice(VAR SalesHeader: Record "Sales Header")
    var
    /*
      se: Record "Sales & Receivables Setup";
      ord: Codeunit "Order Handler ERPG";
      Country: Code[2];
      Cu: Record Customer;
      eSales: Record eSalesTable_I;  //HBK / ITB - 141020
      */
    begin
        /*
        //171120 message('før');
        se.Get();

        if ((SalesHeader."Bill-to Customer No." = se.SVComp)
         or (SalesHeader."Bill-to Customer No." = se.NoComp)) AND
            (SalesHeader."Order Class" = 'NOSVE') then begin   //HBK/ITB - 150920
            //message('inde');
            if SalesHeader."Bill-to Customer No." = se.NoComp then
                Country := 'NO';
            if SalesHeader."Bill-to Customer No." = se.SVComp then
                Country := 'SE';
            if cu.get(SalesHeader."Bill-to Customer No.") then begin
                //message('så oprettes');
                ord.CreateCostOrder(se, cu, SalesHeader, Country);
                ord.CreatePrtvCostOrder(se, cu, SalesHeader, Country);
            end;

        end;
        //HBK / ITB ->
        eSales.Reset();
        eSales.SetRange(SalesNumber, SalesHeader."No.");
        if eSales.FindSet() then begin
            eSales.Status := eSales.Status::Faktureret;
            eSales.Modify();
        end;
        //HBK / ITB <-
       */
    end;

    //HBK / ITB -> Check pris på ordrelinie page
    [EventSubscriber(ObjectType::Page, page::"Sales Order", 'OnAfterGetCurrRecordEvent', '', false, false)]
    local procedure CheckPrice(var rec: Record "Sales Header")
    var
    /*
           SHeader: Record "Sales Header";
           //CustTable: Record Customer;
           ItemTable: Record Item;
           PriceSE: Decimal;
           PriceDK: Decimal;
           LagStat: Record "Lagstat ERPG";  //121120
           */

    begin
        /*
        SHeader.RESET;
        SHeader.SetRange("No.", SalesLine."Document No.");
        if SHeader.FindSet() then begin
            if SalesLine.Quantity <> 0 then begin
                //if CustTable.get(SHeader."Bill-to Customer No.") then begin
                if ItemTable.get(SalesLine."No.") then begin
                    if (ItemTable.MinPris <> 0) then begin
                        if ((SalesLine.Amount / SalesLine.Quantity) < ItemTable.MinPris) then begin
                            Message('Pris er nu under den anbefalede minimumpris' + '\' +
                                    'under med: ' + Format(ItemTable.MinPris - (SalesLine.Amount / SalesLine.Quantity)) + '\' +
                                    'I alt: ' + Format((ItemTable.MinPris - (SalesLine.Amount / SalesLine.Quantity)) * SalesLine.Quantity));
                        end;
                    end;

                    //160221
                    if ItemTable.Type = ItemTable.Type::Inventory then begin
                        LagStat.Reset();
                        LagStat.SetRange(Code, SalesLine."No.");
                        if LagStat.FindSet() then begin
                            if SalesLine.Quantity > LagStat.Inventory then
                                Message('Der er kun ' + Format(LagStat.Inventory) + ' på lager !');
                        end
                        else
                            Message('Der findes ingen lageroplysninger på dette varenummer');
                    end;
                    //160121                        
                end;

                //
                                LagStat.Reset();
                                LagStat.SetRange(Code, SalesLine."No.");
                                if LagStat.FindSet() then begin
                                    if SalesLine.Quantity > LagStat.Inventory then
                                        Message('Der er kun ' + Format(LagStat.Inventory) + ' på lager !');
                                end
                                else
                                    Message('Der findes ingen lageroplysninger på dette varenummer');
                //

            end;
            
        end;
        
        //Message(Format(SalesLine.Quantity));
        */

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInsertItemLedgEntry', '', false, false)]
    local procedure InsertInvenTrans(VAR ItemLedgerEntry: Record "Item Ledger Entry")
    var
    //LagStat: Record "Lagstat ERPG";

    begin
        /*
        LagStat.Reset();
        LagStat.SetRange(Code, ItemLedgerEntry."Item No.");
        if LagStat.FindSet() then begin  //Hvis nordic eksisterer.
            LagStat.Inventory := LagStat.Inventory + ItemLedgerEntry.Quantity;
            LagStat.Modify();
            //171120 Message('inventransEx');
            //171120 message(format(LagStat.Inventory));
            //Error('slut');
        end
        else begin  //Hvis nordic ikke eksisterer
            LagStat.Reset();
            LagStat.Init();
            LagStat.Code := ItemLedgerEntry."Item No.";
            LagStat.Inventory := ItemLedgerEntry.Quantity;
            LagStat.InsertDate := DT2Date(CurrentDateTime);
            LagStat.Insert();
            //171120 Message('inventransEx-EJ');
            //171120 message(format(LagStat.Inventory));
            //Error('slut');
        end;
        //171120 Message('inventrans');
        //171120 message(format(ItemLedgerEntry.Quantity));
        //Error('slut');
        */
    end;
    //HBK / ITB <-

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnBeforeConfirmSalesPost', '', false, false)]
    local procedure ITB_Messages(SalesHeader: Record "Sales Header")
    var
    /*
            SalLin: Record "Sales Line";
            DangerWarning: Boolean;
            ItemTable: Record Item;
            LagStat: Record "Lagstat ERPG";
            sa: Record "Sales & Receivables Setup";  //120121
            cust: Record Customer;
            */

    begin
        /*
        DangerWarning := false;
        SalLin.Reset();
        SalLin.SetRange("Document No.", SalesHeader."No.");
        //Message(SalesHeader."No.");

        if SalLin.FindSet() then begin
            //Message('inde');
            //Message(SalLin."Document No.");
            repeat
                ItemTable.Reset();
                if SalLin."Qty. to Invoice" <> 0 then begin
                    //Message(SalLin."No.");
                    if ItemTable.Get(SalLin."No.") then
                        if ItemTable.Farlig = true then
                            DangerWarning := true;

                end;

                LagStat.Reset();
                LagStat.SetRange(Code, SalLin."No.");
                if LagStat.FindSet() then begin
                    //171120 Message(Format(LagStat.Inventory));
                    if SalLin."Qty. to Invoice" > LagStat.Inventory then
                        Message('Ordrenr: ' + SalLin."Document No." + ' Varenummer: ' + SalLin."No." + '\' +
                                'Antal: ' + Format(SalLin."Qty. to Invoice") + '\' +
                                'Beholdning: ' + Format(LagStat.Inventory));
                end
                else
                    Message('Ordrenr: ' + SalLin."Document No." + ' Varenummer: ' + SalLin."No." + '\' +
                            'Der findes ingen lageroplysninger på dette varenummer');

            until SalLin.Next() = 0;
            if DangerWarning = true then
                Message('Denne faktura indeholder FARLIGT gods !!!!');

        end;
        //171120 
        //HBK - 120121
        sa.Get();
        //130121 Message(sa.Country);
        //Error('slut fejl');
        if sa.Country = 'NO' then
            if cust.get(SalesHeader."Sell-to Customer No.") then begin
                //230221 Message(format(cust.EHF));
                if cust.EHF = true then
                    Message('Dette er en EHF Faktura kunde');
            end;
        //HBK - 120121            
        //Error('Det var testen !');
        //fra den anden

        //130121 Message('123456');
        */
    end;


}