codeunit 50005 "Global_Var"
{

    SingleInstance = true;

    trigger OnRun()
    begin

    end;

    var
        Global_AC_Number: Code[20];
        Global_AC_Cash: Decimal;

    procedure Kvit_Save(VAR AC_Number: Code[20]; VAR AC_Cash: Decimal);
    var


    begin
        Global_AC_Cash := AC_Cash;
        Global_AC_Number := AC_Number;
    end;

    procedure Kvit_Get(VAR AC_Number: Code[20]; VAR AC_Cash: Decimal);
    var


    begin
        //Global_AC_Cash := AC_Cash;
        //Global_AC_Number := AC_Number;
        AC_Cash := Global_AC_Cash;
        AC_Number := Global_AC_Number;
        //AC_Cash2 := Global_AC_Cash;
        //Message(format(Global_AC_Cash));
        //Message(format(AC_Cash));
        //Message(format(AC_Cash2));
        //exit(AC_Cash2);

    end;

}
