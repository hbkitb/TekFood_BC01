tableextension 50003 "Purch Line ITB" extends "Purchase Line"
{
    fields
    {
        field(50000; QtyColli; Decimal)
        {
            Caption = 'AntalColli';
            trigger OnValidate()
            var
            //item: Record Item;
            begin
                if type = Type::Item then begin


                end;
            end;


        }

        field(50001; EANNr; Text[50])
        {
            Caption = 'EANNr';
            trigger OnValidate()
            var
                item: Record Item;


            begin
                if type = Type::Item then begin


                end;
            end;


        }

    }

    trigger OnAfterInsert()

    var
        ItemDC: Record Item;
        InDirect: Decimal;
        ExchRate: Decimal;
        UnitCostBefore: Decimal;
        UnitCostLCYBefore: Decimal;
    begin
        //Message('onafterinsert');
        ItemDC.Reset;
        ItemDC.SetRange("No.", Rec."No.");
        if (ItemDC.FindSet and (Rec."Direct Unit Cost" <> 0)) then begin
            if (ItemDC.FreightCost <> 0) or (ItemDC.FeeCost <> 0) or (ItemDC.DivCost <> 0) then begin
                if Rec."Unit Cost" <> 0 then
                    ExchRate := Rec."Unit Cost (LCY)" / Rec."Unit Cost"
                else
                    ExchRate := 1;
                if (ExchRate <> 1) and (ExchRate <> 0) then begin
                    UnitCostBefore := rec."Unit Cost";
                    UnitCostLCYBefore := rec."Unit Cost (LCY)";
                    //Rec."Unit Cost" := 0;
                    //Rec."Unit Cost (LCY)" := 0;
                    InDirect := ItemDC.FreightCost + ItemDC.FeeCost + ItemDC.DivCost;
                    rec."Unit Cost (LCY)" := UnitCostLCYBefore + InDirect;
                    InDirect := InDirect / ExchRate;
                    rec."Unit Cost" := UnitCostBefore + InDirect;
                    Rec."Indirect Cost %" := (rec."Unit Cost" - "Direct Unit Cost") / "Direct Unit Cost" * 100;
                    Rec.Validate(Quantity);
                    Rec.Modify;
                end
                else begin
                    UnitCostBefore := rec."Unit Cost";
                    UnitCostLCYBefore := rec."Unit Cost (LCY)";
                    //Rec."Unit Cost" := 0;
                    //Rec."Unit Cost (LCY)" := 0;
                    InDirect := ItemDC.FreightCost + ItemDC.FeeCost + ItemDC.DivCost;
                    rec."Unit Cost (LCY)" := UnitCostLCYBefore + InDirect;
                    InDirect := InDirect; //* ExchRate;
                    rec."Unit Cost" := UnitCostBefore + InDirect;
                    Rec."Indirect Cost %" := (rec."Unit Cost" - "Direct Unit Cost") / "Direct Unit Cost" * 100;
                    Rec.Validate(Quantity);
                    Rec.Modify;
                end;
            end;
        end;
    end;

    //hbk - 151221
    trigger OnBeforeModify()

    var


    begin
        UnitCostBeforeBefore := rec."Unit Cost";
        UnitCostLCYBeforeBefore := rec."Unit Cost (LCY)";
        IndCostPctBeforeBefore := Rec."Indirect Cost %";
        DirectUnitCostBeforeBefore := Rec."Direct Unit Cost";


    end;
    //hbk - 151221    

    //Først efter 151221
    trigger OnAfterModify()
    var
        ItemDC: Record Item;
        InDirect: Decimal;
        ExchRate: Decimal;
        UnitCostBefore: Decimal;
        UnitCostLCYBefore: Decimal;
    begin
        //Message('onafterinsert');
        ItemDC.Reset;
        ItemDC.SetRange("No.", Rec."No.");
        if ((ItemDC.FindSet) and (Rec."Direct Unit Cost" <> 0)) then begin
            if (ItemDC.FreightCost <> 0) or (ItemDC.FeeCost <> 0) or (ItemDC.DivCost <> 0) then begin
                if Rec."Unit Cost" <> 0 then
                    ExchRate := Rec."Unit Cost (LCY)" / Rec."Unit Cost"
                else
                    ExchRate := 1;
                if (ExchRate <> 1) and (ExchRate <> 0) then begin
                    UnitCostBefore := rec."Unit Cost";
                    UnitCostLCYBefore := rec."Unit Cost (LCY)";
                    //Rec."Unit Cost" := 0;
                    //Rec."Unit Cost (LCY)" := 0;
                    InDirect := ItemDC.FreightCost + ItemDC.FeeCost + ItemDC.DivCost;
                    //151221 rec."Unit Cost (LCY)" := UnitCostLCYBefore + InDirect;
                    rec."Unit Cost (LCY)" := (Rec."Direct Unit Cost" * ExchRate) + ((Rec."Direct Unit Cost" * ExchRate * (ItemDC."Indirect Cost %" / 100)) + InDirect);  //151221 UnitCostLCYBefore + InDirect;
                    InDirect := InDirect / ExchRate;
                    //rec."Unit Cost" := UnitCostBefore + InDirect;
                    Rec."Unit Cost" := Rec."Direct Unit Cost" + ((Rec."Direct Unit Cost" * (ItemDC."Indirect Cost %" / 100)) + InDirect);
                    Rec."Indirect Cost %" := (rec."Unit Cost" - rec."Direct Unit Cost") / rec."Direct Unit Cost" * 100;
                    Rec.Validate(Quantity);
                    Rec.Modify;
                end
                else begin
                    UnitCostBefore := rec."Unit Cost";
                    UnitCostLCYBefore := rec."Unit Cost (LCY)";
                    //Rec."Unit Cost" := 0;
                    //Rec."Unit Cost (LCY)" := 0;
                    InDirect := ItemDC.FreightCost + ItemDC.FeeCost + ItemDC.DivCost;
                    //151221 rec."Unit Cost (LCY)" := UnitCostLCYBefore + InDirect;
                    rec."Unit Cost (LCY)" := (Rec."Direct Unit Cost") + ((Rec."Direct Unit Cost" * (ItemDC."Indirect Cost %" / 100)) + InDirect);  //151221 UnitCostLCYBefore + InDirect;
                    InDirect := InDirect;  /// ExchRate;
                    //rec."Unit Cost" := UnitCostBefore + InDirect;
                    Rec."Unit Cost" := Rec."Direct Unit Cost" + ((Rec."Direct Unit Cost" * (ItemDC."Indirect Cost %" / 100)) + InDirect);
                    Rec."Indirect Cost %" := (rec."Unit Cost" - rec."Direct Unit Cost") / rec."Direct Unit Cost" * 100;
                    Rec.Validate(Quantity);
                    Rec.Modify;

                    /*
                     UnitCostBefore := rec."Unit Cost";
                     UnitCostLCYBefore := rec."Unit Cost (LCY)";
                     //Rec."Unit Cost" := 0;
                     //Rec."Unit Cost (LCY)" := 0;
                     InDirect := ItemDC.FreightCost + ItemDC.FeeCost + ItemDC.DivCost;
                     rec."Unit Cost (LCY)" := UnitCostLCYBefore + InDirect;
                     InDirect := InDirect; //* ExchRate;
                     rec."Unit Cost" := UnitCostBefore + InDirect;
                     Rec."Indirect Cost %" := (rec."Unit Cost" - "Direct Unit Cost") / "Direct Unit Cost" * 100;
                     Rec.Validate(Quantity);
                     Rec.Modify;
                     */
                end;
            end;
        end;

    end;



    trigger OnAfterDelete()

    var

    begin


    end;


    var
        UnitCostBeforeBefore: Decimal;
        UnitCostLCYBeforeBefore: Decimal;
        IndCostPctBeforeBefore: Decimal;
        DirectUnitCostBeforeBefore: Decimal;


}