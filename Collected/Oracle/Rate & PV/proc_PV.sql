declare
  pv float;
  rate float;
  pmt float;
  act_out_bal float;
  --nper float;

begin
  pmt := 2032;
  act_out_bal := 12680;
  --nper := act_out_bal/pmt;
  rate := 0.037455;
  --Formula of Present Value
  pv := fn_pv(rate,pmt,act_out_bal/pmt);
  --pv := pmt * ((1 - power((1 + rate), -nper)) / rate);
  dbms_output.put_line('Present Value is '||round(pv,4));
  --Return the result of the function
  --return pv;

exception
  when zero_divide then
  dbms_output.put_line('PV can''t be generated because rate is less than zero');
  --return 0.00;
end;
