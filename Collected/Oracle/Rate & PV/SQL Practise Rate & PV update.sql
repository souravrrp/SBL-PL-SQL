select *
  from hpnret_form249_arrears_tab
  where year = 2014 and
    period = 2 and
    shop_code = 'BBZB';
      --and actual_sales_date between to_date('2012/07/01','yyyy/mm/dd') and to_date('2012/07/31','yyyy/mm/dd');
      --and rowid = 'AAANv+AAbAABj4kAAA';

--selection of data range for interest rate calculation
select t.year,
    t.period,
    t.shop_code,
    t.original_acct_no,
    t.acct_no,
    t.amount_financed,
    t.monthly_pay,
    t.loc,
    t.total_ucc,
    t.act_out_bal,
    t.effective_rate,
    t.present_value,
    t.effective_ecc,
    t.actual_ucc--,
    --rowid
 from hpnret_form249_arrears_tab t
   where t.year = 2013 and
     t.period = 11 and
     t.act_out_bal > 0
     --t.monthly_pay = 0 and
     --t.shop_code = 'AKHB' and
     --t.rownum <= 10 and
     --t.shop_code like 'K%' and
     --t.shop_code > 'K%' and
     --t.shop_code not in ('ABDD','AKHB','AMIB','ANWD') and
     --t.original_acct_no = 'RAM-H138' and
     --t.effective_rate is null and
     --t.present_value is null;


--no.of shops have open hire account in a specific period of a year
select distinct(shop_code) "Shop"
  from hpnret_form249_arrears_tab
  where year = 2013 and
    period = 1 and
    shop_code like 'K%';

--shop wise no. of hire accounts
select year,
    period,
    shop_code,
    count(original_acct_no)
  from hpnret_form249_arrears_tab
  where year = 2013 and
    period = 1 and
    shop_code = 'KTNB'
  group by year, period, shop_code;
  --group by shop_code;

--Year and period wise no. of hire accounts
select year,
  period,
  count(distinct(acct_no))
from hpnret_form249_arrears_tab
where year = 2013 and
  period = 2
  --and shop_code > 'R%'
  --and shop_code != 'RAMB'
  --and shop_code not in ('KTNB','RAMB','TGTD')
group by year, period;

--test count(*)        
select year,
  --period,
  count(*)
from hpnret_form249_arrears_tab
  where --year = 2013 and
    --period = 2 and
    --shop_code > 'R%' and
    --shop_code != 'RAMB' and
    --shop_code not in ('KTNB','RAMB','TGTD')
  group by year, period;

       
--update interest rate & present value of a specific account for a specific month
update hpnret_form249_arrears_tab
  set effective_rate = '',
     present_value = '',
     actual_ucc = '',
     effective_ecc = '';     
  --where year = 2013 and
    --period = 1 and
    --shop_code = 'KTNB' and
    --original_acct_no = '104024';
COMMIT;

--update effective rate using new function    
update hpnret_form249_arrears_tab
  set effective_rate = fn_Rate_New(amount_financed,monthly_pay,loc)
  where year = 2013 and
    period = 1; --and
    --shop_code = 'KTNB';
COMMIT;

--update present value using function
update hpnret_form249_arrears_tab
  set present_value = fn_PV(effective_rate, monthly_pay, loc)
  where year = 2013 and
   period = 3; --and
   --shop_code != 'KTNB';
commit;


--extract distinct shop codes using cursor and put it into a varray variable
declare
  type shop_array is varray(400) of hpnret_form249_arrears_tab.shop_code%type;
  shop shop_array := shop_array();
  total_shop int;
  counter int := 0;

  cursor c_shop_code is
      select distinct(shop_code)
        from hpnret_form249_arrears_tab
          where year =2013 and
            period = 4 and
            shop_code like 'ABDD';

begin
  for i in c_shop_code loop
    counter := counter + 1;
    shop.extend;
    shop(counter) := i.shop_code;
    dbms_output.put_line('Shop Code: '||shop(counter));
  end loop;
  total_shop := shop.count;
  dbms_output.put_line('Total no. of shops are '||total_shop);
end;

--Put shop code direct into array
declare
  type shop_array is varray(400) of hpnret_form249_arrears_tab.shop_code%type;
  shop shop_array := shop_array();
  total_shop int;
  --shop_array as array
  
begin
  shop.extend;
  select distinct(shop_code)    
    into shop
    from hpnret_form249_arrears_tab
    
      where year = 2013
        and period = 1 ;
  
  total_shop := shop.count;
  dbms_output.put_line(total_shop);
  
end;


--effective rate calculation using function
declare
  pv float := 23000.001379310345;
  pmt float := 1457;
  nper float := 24;
  effective_rate float;

begin
  effective_rate := fn_Rate_New(pv,pmt,nper);
  dbms_output.put_line(effective_rate);

end;


--Effective_ECC calculation sample data using rownum
select t.product_code,
  t.normal_cash_price,
  t.hire_cash_price,
  t.hire_price,
  t.list_price,
  t.total_ucc,
  t.outstanding_ucc,
  t.amount_financed,
  t.monthly_pay,
  t.loc,
  t.original_acct_no,
  t.acct_no
from HPNRET_FORM249_ARREARS_TAB t
where rownum <= 5


