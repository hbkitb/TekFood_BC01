tableextension 50001 "Item ITB" extends Item
{
    fields
    {
        field(50000; EANNr; Text[50])
        {
            Caption = 'EANNr';
            trigger OnValidate()
            var
                item: Record Item;
            begin
                //if type = Type::Item then begin


                //end;
            end;


        }

        field(50001; EANNr02; Text[50])
        {
            Caption = 'EANNr02';
            trigger OnValidate()
            var
                item: Record Item;
            begin
                //if type = Type::Item then begin


                //end;
            end;


        }

        field(50002; KartAntal; Decimal)
        {
            Caption = 'KartAntal';
            trigger OnValidate()
            var
            //item: Record Item;
            begin
                //if type = Type::Item then begin


                //end;
            end;


        }

        field(50003; PantItem; Code[20])
        {
            Caption = 'PantVare';
            trigger OnValidate()
            var
            //item: Record Item;
            begin
                //if type = Type::Item then begin


                //end;
            end;


        }

        field(50004; Mangde; Text[20])
        {
            Caption = 'Mængde';
            trigger OnValidate()
            var
            //item: Record Item;
            begin
                //if type = Type::Item then begin


                //end;
            end;


        }

        field(50005; FreightCost; Decimal)
        {
            Caption = 'FragtTillæg(Kr)';
            trigger OnValidate()
            var
            //item: Record Item;
            begin
                //if type = Type::Item then begin
                Rec.TotalCost := Rec."Last Direct Cost" + (Rec."Last Direct Cost" * Rec."Indirect Cost %" / 100) + Rec.DivCost + Rec.FeeCost + Rec.FreightCost;
                Rec.TotalCost := Round(Rec.TotalCost, 0.01, '=');

                if Rec."Unit Price" <> 0 then
                    Rec.TotalDG := (Rec."Unit Price" - Rec.TotalCost) / Rec."Unit Price" * 100
                else
                    Rec.TotalDG := 0;

                Rec.TotalDG := Round(Rec.TotalDG, 0.01, '=');

                //end;
            end;


        }

        field(50006; FeeCost; Decimal)
        {
            Caption = 'AfgiftTillæg(Kr)';
            trigger OnValidate()
            var
            //item: Record Item;
            begin
                //if type = Type::Item then begin
                Rec.TotalCost := Rec."Last Direct Cost" + (Rec."Last Direct Cost" * Rec."Indirect Cost %" / 100) + Rec.DivCost + Rec.FeeCost + Rec.FreightCost;
                Rec.TotalCost := Round(Rec.TotalCost, 0.01, '=');

                if Rec."Unit Price" <> 0 then
                    Rec.TotalDG := (Rec."Unit Price" - Rec.TotalCost) / Rec."Unit Price" * 100
                else
                    Rec.TotalDG := 0;

                Rec.TotalDG := Round(Rec.TotalDG, 0.01, '=');

                //end;
            end;


        }

        field(50007; DivCost; Decimal)
        {
            Caption = 'DiverseTillæg(Kr)';
            trigger OnValidate()
            var
            //item: Record Item;
            begin
                //if type = Type::Item then begin
                Rec.TotalCost := Rec."Last Direct Cost" + (Rec."Last Direct Cost" * Rec."Indirect Cost %" / 100) + Rec.DivCost + Rec.FeeCost + Rec.FreightCost;
                Rec.TotalCost := Round(Rec.TotalCost, 0.01, '=');

                if Rec."Unit Price" <> 0 then
                    Rec.TotalDG := (Rec."Unit Price" - Rec.TotalCost) / Rec."Unit Price" * 100
                else
                    Rec.TotalDG := 0;

                Rec.TotalDG := Round(Rec.TotalDG, 0.01, '=');

                //end;
            end;


        }

        field(50008; TotalCost; Decimal)
        {
            Caption = 'TEK-Total Kost';
            //FieldClass = FlowField;
            Editable = false;

        }

        field(50009; TotalDG; Decimal)
        {
            Caption = 'TEK-Total DG';
            //FieldClass = 
            Editable = true;

            trigger OnValidate()
            var
            //item: Record Item;
            begin
                //if type = Type::Item then begin
                /*
                Rec.TotalCost := Rec."Last Direct Cost" + (Rec."Last Direct Cost" * Rec."Indirect Cost %" / 100) + Rec.DivCost + Rec.FeeCost + Rec.FreightCost;
                Rec.TotalCost := Round(Rec.TotalCost, 0.01, '=');

                if Rec."Unit Price" <> 0 then
                    Rec.TotalDG := (Rec."Unit Price" - Rec.TotalCost) / Rec."Unit Price" * 100
                else
                    Rec.TotalDG := 0;

                Rec.TotalDG := Round(Rec.TotalDG, 0.01, '=');
                */
                if Rec.TotalDG = 100 then begin
                    Rec."Unit Price" := 0;  //121121 Rec.TotalCost * 2;
                    Rec.Validate("Unit Price");
                end
                else begin
                    Rec."Unit Price" := -100 * Rec.TotalCost / (Rec.TotalDG - 100);
                    Rec."Unit Price" := Round(Rec."Unit Price", 0.01, '=');
                    Rec.Validate("Unit Price");
                end;

                //end;
            end;

        }


    }


    trigger OnBeforeInsert()
    var

    begin

        Rec.TotalCost := Rec."Last Direct Cost" + (Rec."Last Direct Cost" * Rec."Indirect Cost %" / 100) + Rec.DivCost + Rec.FeeCost + Rec.FreightCost;
        Rec.TotalCost := Round(Rec.TotalCost, 0.01, '=');

        if Rec."Unit Price" <> 0 then
            Rec.TotalDG := (Rec."Unit Price" - Rec.TotalCost) / Rec."Unit Price" * 100
        else
            Rec.TotalDG := 0;

        Rec.TotalDG := Round(Rec.TotalDG, 0.01, '=');


    end;


    trigger OnBeforeModify()

    var

    begin

        Rec.TotalCost := Rec."Last Direct Cost" + (Rec."Last Direct Cost" * Rec."Indirect Cost %" / 100) + Rec.DivCost + Rec.FeeCost + Rec.FreightCost;
        Rec.TotalCost := Round(Rec.TotalCost, 0.01, '=');

        if Rec."Unit Price" <> 0 then
            Rec.TotalDG := (Rec."Unit Price" - Rec.TotalCost) / Rec."Unit Price" * 100
        else
            Rec.TotalDG := 0;

        Rec.TotalDG := Round(Rec.TotalDG, 0.01, '=');


    end;


}