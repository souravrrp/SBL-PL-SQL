declare
  --rate float;
  --pv float;
  year_t int := 2013;
  period int := 1;
begin
  --rate := Calculate_Rate_Pv_Ucc_Ecc_Api.fn_Rate(25500.04,3386,9);
  --dbms_output.put_line(rate);
  --pv := Calculate_Rate_Pv_Ucc_Ecc_Api.fn_PV(0.03721,664,5871/664);
  --dbms_output.put_line(pv);
  calculate_rate_pv_ucc_ecc_api.Calculate_Rate(year_t,period);
end;



--5000.43
--664
--9
--5871
--0.03721