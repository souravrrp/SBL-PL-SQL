declare  
  year_t int; --:= 2013;
  period int; --:= 1;
  
  --dbms_output.put_line('&year');
  --dbms_output.put_line('&period');
  
  type shop_array is varray(400) of varchar2(5);--varray type declaration
  shop shop_array := shop_array();--declaration & initialization of shop_array variable
  counter int := 0;
  total_shop int;
  
  --cursor for fetching distinct shop codes
  cursor c_shop_code is
    select distinct(shop_code)
      from hpnret_form249_arrears_tab t
        where t.year = year_t and
          t.period = period;
          --and shop_code = 'AKHB';
          --and rownum <= 10;
          --and shop_code not in ('KTNB','RAMB','TGTD');

begin
  year_t := &t_year;
  period := &period;
  
  --Fetching all distinct shop codes into an array
  for i in c_shop_code loop
    if c_shop_code%notfound then
      dbms_output.put_line('Sorry, no shop available.');
    else
      counter := counter + 1;
      shop.extend;
      shop(counter) := i.shop_code;
    end if;
  end loop;
  
  --Getting total no. of shops
  total_shop := shop.count;
  
  --update table with effective rate & present value data
  for n in 1 .. total_shop loop
    update hpnret_form249_arrears_tab t
      set t.effective_rate = fn_Rate(t.amount_financed,t.monthly_pay,t.loc)--Calculate interest rate for each shop
    where t.year = year_t and
        t.period = period and
        t.act_out_bal > 0 and
        t.shop_code = shop(counter);
    commit;

    /*update hpnret_form249_arrears_tab
      set present_value = fn_PV(effective_rate,monthly_pay,act_out_bal/monthly_pay)--Calculate present value for each shop
    where year = year
      and period = period
      and shop_code = shop(counter);
    commit;*/
    
    /*update hpnret_form249_arrears_tab
      set actual_ucc = act_out_bal - present_value --Calculate actual ucc for each shop
    where year = year
      and period = period
      and shop_code = shop(counter);
    commit;*/
    
    /*update hpnret_form249_arrears_tab
      set effective_ecc = total_ucc - actual_ucc --Calculate effective ecc for each shop
    where year = year
      and period = period
      and shop_code = shop(counter);
    commit;*/
  end loop;
end;
