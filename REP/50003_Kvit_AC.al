report 50003 "Kvit_AC"   //var report 110
{
    DefaultLayout = RDLC;
    //RDLCLayout = './Kvit_AC.rdlc';
    RDLCLayout = 'REP/layout/Kvit_AC.rdl';
    ApplicationArea = Suite;
    Caption = 'Kvittering AC';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", Name;
            column(No_; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(Address; Address)
            {
            }
            column(Address_2; "Address 2")
            {
            }
            column(Post_Code; "Post Code")
            {
            }
            column(City; City)
            {
            }
            column(Contact; Contact)
            {
            }
            column(AC_Kvitt; AC_Kvitt)
            {
            }
            column(AC_Date; AC_Date)
            {
            }
            column(AC_Number; AC_Number)
            {
            }
            column(AC_Cash; AC_Cash)
            {
            }
            column(AC_After_Balance; AC_After_Balance)
            {
            }
            column(AC_Company; AC_Company)
            {
            }
            column(AC_Employee; AC_Employee)
            {
            }

            column(GroupNo1; GroupNo)
            {
            }


            trigger OnAfterGetRecord()
            begin
                Customer.CalcFields("Balance (LCY)");
                //Rest := Rec."Balance (LCY)";//

                AC_Cash := Customer."Budgeted Amount";
                AC_After_Balance := Customer."Balance (LCY)" - AC_Cash;
            end;

            trigger OnPreDataItem()
            begin

            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        GroupNo := 1;
        RecPerPageNum := 7;
    end;

    var
        FormatAddr: Codeunit "Format Address";
        LabelFormat: Option "36 x 70 mm (3 columns)","37 x 70 mm (3 columns)","36 x 105 mm (2 columns)","37 x 105 mm (2 columns)";
        CustAddr: array[3, 8] of Text[100];
        NoOfRecords: Integer;
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
        i: Integer;
        GroupNo: Integer;
        Counter: Integer;
        RecPerPageNum: Integer;
        AC_Date: Date;
        AC_Number: Text[20];
        AC_Cash: Decimal;
        AC_After_Balance: Decimal;
        AC_Employee: Text[100];
        AC_Company: Text[100];
        AC_Kvitt: Text[30];


    procedure InitializeRequest(SetLabelFormat: Option)
    begin
        //LabelFormat := SetLabelFormat;
    end;
}

