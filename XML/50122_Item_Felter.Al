
xmlport 50122 "Item Felter"
{
    Format = VariableText;
    FormatEvaluate = Legacy;
    Direction = Import;
    TextEncoding = WINDOWS;
    FieldSeparator = ';';
    FieldDelimiter = '¤';
    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {

                textelement(ItemNumber)
                {

                }
                textelement(MinPris)
                {

                }
                textelement(P1)
                {

                }

                textelement(P2)   //igroup hbk
                {

                }
                textelement(StkPrKs)
                {

                }
                textelement(Short)
                {
                    trigger OnAfterAssignVariable()
                    var

                    begin


                        //Evaluate(InvenTable."Costing Method", CostingMethod);

                    end;
                }

                textelement(PaySaldo)
                {

                }

                textelement(NoInnoItem)
                {

                }

                textelement(UnNumber)
                {

                }

                textelement(Farlig)
                {

                }

                textelement(VareTxt2)
                {

                }

                trigger OnBeforeInsertRecord()

                var
                    Vare: Record Item;

                begin
                    Vare.Reset();
                    vare.SetRange("No.", ItemNumber);
                    if Vare.FindSet() then begin
                        //   Evaluate(Vare.MinPris, MinPris);
                        //   Vare.P1 := P1;
                        //   Vare.P2 := P2;

                    end;

                end;

            }

        }

    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                //action(ActionName)
                //{

                //}
            }
        }
    }

    trigger OnInitXmlPort()
    var
        Comment: Record "Comment Line";
        ItemRec: Record Item;
        AltItem: Record "Item Substitution";
        BOMComponent: Record "BOM Component";
        CustPriceGroup: Record "Customer Price Group";
        DefaultDimension: Record "Default Dimension";

    begin

    end;

    var

        ItemDiscountGroup: Record "Item Discount Group";

        ItemUnit: Record "Item Unit of Measure";

}

