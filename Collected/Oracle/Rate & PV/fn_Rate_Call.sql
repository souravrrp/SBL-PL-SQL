declare  
  pv float;
  nper integer;
  pmt float;  
  --fv number;
  int_rate float;

begin
  pv := 12000.0;
  pmt := 800.0;
  nper := 48;
  
  int_rate := fn_Rate_New(pv, pmt, nper);
  pv := fn_PV(pmt, int_rate, nper);
  dbms_output.put_line('Rate is '||int_rate);
  dbms_output.put_line('Present Value is '||pv);  

end;
