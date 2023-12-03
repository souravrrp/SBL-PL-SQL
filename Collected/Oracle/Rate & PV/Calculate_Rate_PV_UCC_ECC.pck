create or replace package Calculate_Rate_PV_UCC_ECC_API is

  -- Author  : Abu Kaiser Mohammad Hashem
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
  
  procedure Calculate_Rate(
    year_t in int,
    period in int);
  
  procedure Calculate_PV(
    year_t in int,
    period in int);
  
  procedure Calculate_UCC(
    year_t in int,
    period in int);
  
  procedure Calculate_ECC(
    year_t in int,
    period in int);

end Calculate_Rate_PV_UCC_ECC_API;
/
create or replace package body Calculate_Rate_PV_UCC_ECC_API is

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
  
  --Funtion to Calculate Effective Interest Rate
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

  end fn_Rate;

  --Function to Calculate Present Value
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
    --dbms_output.put_line('PV is '||pv);
    return pv;

  exception
    when zero_divide then
    dbms_output.put_line('PV can''t be generated because rate is less than zero');
    return 0.0;

  end fn_PV;
  
  --Procedure to Calculate Effective Interest Rate, Present Value, Actual UCC & Effective ECC
  procedure Calculate_Rate(
    year_t in int,
    period in int)
    is
    
    Begin
      --update table with effective rate, present value, actual ucc & effective ecc data
      --Calculate interest rate for a period
      update hpnret_form249_arrears_tab t
        set t.effective_rate = Calculate_Rate_PV_UCC_ECC_API.fn_Rate(t.amount_financed,t.monthly_pay,t.loc)
      where t.year = year_t and
          t.period = period and
          t.act_out_bal > 0;
      commit;
    end Calculate_Rate;

  procedure Calculate_PV(
    year_t in int,
    period in int)
    is
    
    Begin
      --Calculate present value for a period
      update hpnret_form249_arrears_tab t
        set t.present_value = Calculate_Rate_PV_UCC_ECC_API.fn_PV(t.effective_rate,t.monthly_pay,t.act_out_bal/t.monthly_pay)
      where t.year = year_t and
        t.period = period and
        t.act_out_bal > 0;
      commit;
    end Calculate_PV;

  procedure Calculate_UCC(
    year_t in int,
    period in int)
    is
    
    Begin
      --Calculate actual ucc for a period
      update hpnret_form249_arrears_tab t
        set t.actual_ucc = t.act_out_bal - t.present_value
      where t.year = year_t and
        t.period = period and
        t.act_out_bal > 0;
      commit;
    end Calculate_UCC;

  procedure Calculate_ECC(
    year_t in int,
    period in int)
    is
    
    Begin
      --Calculate effective ecc for a period
      update hpnret_form249_arrears_tab t
        set t.effective_ecc = t.total_ucc - t.actual_ucc
      where t.year = year_t and
        t.period = period and
        t.act_out_bal > 0;
      commit;
  end Calculate_ECC;

/*begin
  -- Initialization
  <Statement>;*/
end Calculate_Rate_PV_UCC_ECC_API;
/
