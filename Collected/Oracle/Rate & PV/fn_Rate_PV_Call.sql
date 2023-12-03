declare  
  /*pv float;
  pmt float;
  nper float;
  int_rate float;*/
  
  /*type shop_array is varray(400) of varchar2(5);--varray type declaration
  shop shop_array := shop_array();--declaration & initialization of shop_array variable
  counter int := 0;
  total_shop int;*/
  
  --cursor for fetching distinct shop codes
  /*cursor c_shop_code is
    select distinct(shop_code)
      from hpnret_form249_arrears_tab
        where year =2013
          and period = 1;
          --and shop_code like 'A%';
          and shop_code = 'TGTD';*/
  
  --cursor for fetching data of a specific shop for a specific period
  cursor c_data is
    select year
       ,period
       ,shop_code
       ,original_acct_no
       ,amount_financed
       ,monthly_pay
       ,loc
       ,rowid
     from hpnret_form249_arrears_tab
       where year = 2013
           and period = 1
           and shop_code = 'KTNB';
           --and shop_code = shop(counter);
           --and shop_code in ('AMIB','ANWD');
           --and original_acct_no = 'KTN-H1011';

begin
  --Fetching all distinct shop codes into an array
  /*for i in c_shop_code loop
    if c_shop_code%notfound then
      dbms_output.put_line('Sorry, no shop available.');
    else
      counter := counter + 1;
      shop.extend;
      shop(counter) := i.shop_code;
    end if;
  end loop;*/
  
  --Getting total no. of shops
  --total_shop := shop.count;
  
  --Calculate interest rate & present value for each shop
  /*for n in 1 .. total_shop loop
    counter := n;*/
    
    --Getting data of a shop
    for i in c_data loop
      if c_data%notfound then
        dbms_output.put_line('Sorry, no data found.');
        exit;
      else
        /*pv:= i.amount_financed;
        pmt:= i.monthly_pay;
        nper:= i.loc;*/
        
        /*int_rate := fn_Rate_New(pv, pmt, nper); --interest rate calculation
        pv := fn_PV(int_rate, pmt, nper);*/ --present value calculation
        
        --int_rate := fn_Rate_New(i.amount_financed, i.monthly_pay, i.loc); --interest rate calculation
        --pv := fn_PV(int_rate, i.monthly_pay, i.loc); --present value calculation
        
        --updating interest rate and present value of a specific account for a specific month
        /*update hpnret_form249_arrears_tab
           set effective_rate = fn_Rate_New(i.amount_financed, i.monthly_pay, i.loc)
               --,present_value = fn_PV(effective_rate, i.monthly_pay, i.loc)
           where year = i.year
             and period = i.period
             --and shop_code = i.shop_code
             and original_acct_no = i.original_acct_no;
        commit;*/
        
        --alternate update commandof of interest rate and present value of a specific account for a specific month
        update hpnret_form249_arrears_tab
           set effective_rate = fn_Rate_New(i.amount_financed, i.monthly_pay, i.loc)
               --,present_value = fn_PV(effective_rate, i.monthly_pay, i.loc)
           where rowid = i.rowid;
        commit;
        update hpnret_form249_arrears_tab
           set --effective_rate = fn_Rate_New(i.amount_financed, i.monthly_pay, i.loc)
               present_value = fn_PV(effective_rate, i.monthly_pay, i.loc)                
           where rowid = i.rowid;
        commit;
        
        --dbms_output.put_line('Account No. '||i.original_acct_no||' Interest Rate '||int_rate||' PV '||pv);
      end if;    
    end loop;
  --end loop;
end;
