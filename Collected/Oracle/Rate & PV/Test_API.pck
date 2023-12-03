create or replace package Test_API is

  -- Author  : ASDSAD
  -- Created : 11/6/2013 12:03:55 PM
  -- Purpose : Calculation of rate, pv, ucc, ecc
  
  -- Public type declarations
  --type <TypeName> is <Datatype>;
  
  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;

  -- Public function and procedure declarations
  --function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
  
  function fn_Rate(
    pv in float,
    pmt in float, 
    nper in float) return float;
  function fn_PV(
    int_rate in float,
    pmt in float,
    nper in float) return float;

end Test_API;
/
create or replace package body Test_API is

  -- Private type declarations
  --type <TypeName> is <Datatype>;
  
  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;

  -- Function and procedure implementations
  --function <FunctionName>(<Parameter> <Datatype>) return <Datatype> is
    --<LocalVariable> <Datatype>;
  /*begin
    <Statement>;
    return(<Result>);
  end;*/
  
  function fn_Rate(
      pv in float,
      pmt in float,
      nper in float)
      return float
  is
      int_rate float;
      principle float;
      int_pmt float;
      prin_pmt float;
      incrm float;
      i int;

  begin
    principle := pv;
    int_rate := (pmt * nper - principle) / (principle * nper);

    while true loop
      for i in 1 .. nper loop
        int_pmt := principle * int_rate;
        prin_pmt := pmt - int_pmt;
        principle := principle - prin_pmt;
      end loop;

      if abs(principle) > 0.01 then
        incrm := principle / (pv * nper * nper);
        int_rate := int_rate - incrm;
        principle := pv;
      else
        exit;
      end if;
    end loop;

    return round(int_rate,6);
    --dbms_output.put_line('Interest Rate is '||round(int_rate,6));

  exception
    when no_data_found then
      dbms_output.put_line('Sorry, no data found.');
    when others then
      dbms_output.put_line('Sorry, other error.');

  end fn_Rate_New;

  function fn_PV(
    int_rate in float,
    pmt in float,
    nper in float)
    return float 
  is
    pv float;

  begin
    --Formula of Present Value
    pv := round((pmt * ((1 - power((1 + int_rate), -nper)) / int_rate)),4);
    --Return the result of the function
    return pv;

  exception
    when zero_divide then
    dbms_output.put_line('PV can''t be generated because rate is less than zero');
    return 0.0;

  end fn_PV;
  
  procedure Calculate_Rate_PV_UCC_ECC (
    year in int,
    period in int)
    
    Begin
      --update table with effective rate, present value, actual ucc & effective ecc data
      --Calculate interest rate for a period
      update hpnret_form249_arrears_tab t
        set t.effective_rate = fn_Rate_New(t.amount_financed,t.monthly_pay,loc)
      where t.year = '&year' and
          t.period = '&period' and
          t.act_out_bal > 0;
      commit;

      --Calculate present value for a period
      update hpnret_form249_arrears_tab t
        set t.present_value = fn_PV(t.effective_rate,t.monthly_pay,t.act_out_bal/t.monthly_pay)
      where t.year = '&year' and
        t.period = '&period' and
        t.act_out_bal > 0;
      commit;

      --Calculate actual ucc for a period
      update hpnret_form249_arrears_tab t
        set t.actual_ucc = t.act_out_bal - t.present_value
      where t.year = '&year' and
        t.period = '&period' and
        t.act_out_bal > 0;
      commit;

      --Calculate effective ecc for a period
      update hpnret_form249_arrears_tab t
        set t.effective_ecc = t.total_ucc - t.actual_ucc
      where t.year = '&year' and
        t.period = '&period' and
        t.act_out_bal > 0;
      commit;
  end Calculate_Rate_PV_UCC_ECC;


/*begin
  -- Initialization
  <Statement>;*/
end Test_API;
/
