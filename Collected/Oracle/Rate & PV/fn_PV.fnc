create or replace function fn_PV(
  int_rate in float,
  pmt in float,
  nper in float)
  return float 
is
  pv float;

begin
  if pmt != 0 then
    if int_rate = 0 then
      pv := pmt * nper;
    else
      --Formula of Present Value
      pv := round((pmt * ((1 - power((1 + int_rate), -nper)) / int_rate)),4);
    end if;
    --Return the result of the function
    return pv;
  else
    return 0.0;
  end if;

exception
  when zero_divide then
  dbms_output.put_line('PV can''t be generated because rate is less than zero');
  return 0.0;

end fn_PV;
/
