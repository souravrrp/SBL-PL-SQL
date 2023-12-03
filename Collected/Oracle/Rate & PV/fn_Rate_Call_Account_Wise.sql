declare  
  year int := 2013;
  period int := 2;
    
  type acct_array is varray(1000) of varchar2(25);--varray type declaration
  acct acct_array := acct_array();--declaration & initialization of shop_array variable
  counter int := 0;
  total_acct_no int;
  
  --cursor for fetching distinct shop codes
  cursor c_acct_no is
    select acct_no
      from hpnret_form249_arrears_tab
        where year = 2013
          and period = 1
          and shop_code = 'KTNB';
 

begin
  --Fetching all distinct shop codes into an array
  for i in c_acct_no loop
    if c_acct_no%notfound then
      dbms_output.put_line('Sorry, no account available.');
    else
      counter := counter + 1;
      acct.extend;
      acct(counter) := i.acct_no;
    end if;
  end loop;
  
  --Getting total no. of shops
  total_acct_no := acct.count;
  
  --update table with effective rate & present value data
  for n in 1 .. total_acct_no loop
    update hpnret_form249_arrears_tab
      set effective_rate = fn_Rate_New(amount_financed,monthly_pay,loc)--Calculate interest rate for each shop
    where year = 2013
        and period = 1
        and acct_no = acct(counter);
        --and original_acct_no = 'KTN-H1000';
    commit;

    /*update hpnret_form249_arrears_tab
      set present_value = fn_PV(effective_rate,monthly_pay,loc)--Calculate present value for each shop
    where year = year
      and period = period
      and shop_code = shop(counter);
    commit;*/
  end loop;
end;
