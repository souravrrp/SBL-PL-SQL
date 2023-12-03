create or replace function fn_Rate(
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
  if pmt != 0 then    
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
  else
    return 0.0;
  end if;

exception
  when no_data_found then
    dbms_output.put_line('Sorry, no data found.');
  when others then
    dbms_output.put_line('Sorry, other error.');

end fn_Rate;
/