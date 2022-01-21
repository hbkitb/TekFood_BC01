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
            column(DummyCompanyInfoPic; DummyCompanyInfo.Picture)
            {

            }


            trigger OnAfterGetRecord()
            begin
                Customer.CalcFields("Balance (LCY)");
                //Rest := Rec."Balance (LCY)";
                comp.get();
                AC_Company := comp.Name;
                DummyCompanyInfo.Picture := comp.Picture;
                emp.Reset;
                emp.SetRange("User Name", UserId);
                if emp.FindSet then
                    AC_Employee := emp."Full Name";

                Global_Var.Kvit_Get(AC_Number, AC_Cash);
                //AC_Cash := Customer."Budgeted Amount";
                //message('report');
                //Message(Format(AC_Cash));
                AC_After_Balance := Customer."Balance (LCY)";  //- AC_Cash;
                //AC_Number := Customer."Telex No.";


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
        AC_Number: Code[20];   //Text[20];
        AC_Cash: Decimal;
        AC_After_Balance: Decimal;
        AC_Employee: Text[100];
        AC_Company: Text[100];
        AC_Kvitt: Text[30];
        emp: Record user;
        comp: Record "Company Information";
        Global_Var: Codeunit Global_Var;
        DummyCompanyInfo: Record "Company Information";


    procedure InitializeRequest(SetLabelFormat: Option)
    begin
        //LabelFormat := SetLabelFormat;
    end;
}

