declare
  year_                number   := 2015;
  period_              number   := 6;
  acct_no_             varchar2(20) := 'DMK-H2970';
  actual_sales_date    date     := to_date('2015/04/20', 'YYYY/MM/DD');
  loc                  number   := 6;
  hire_price           number   := 38517.68;
  first_pay            number   := 10270;
  monthly_pay          number   := 4708;
  act_out_bal          number   := 24247.68;
  arr_amt              number   := 708;
  mature_date          date;
  cutoff_date          date;
  due_date             date;
  n                    number;
  no_of_mons_paid      number;
  amount_collected     number;
  amount_to_be_paid    number;
  total_dues           number;
  del_amt              number;
  

begin
  mature_date := ADD_MONTHS((actual_sales_date + 30), loc);
  cutoff_date := last_day(to_date(year_||'/'||(period_ + 1)||'/1', 'YYYY/MM/DD'));

  if mature_date < cutoff_date then
    no_of_mons_paid := loc;
  else
    n := floor(months_between(cutoff_date, actual_sales_date));
    due_date := ADD_MONTHS((actual_sales_date + 30), n);
    if due_date > cutoff_date then
      no_of_mons_paid := n - 1;
    else
      no_of_mons_paid := n;
    end if;
  end if;

  amount_collected := hire_price - first_pay - act_out_bal;
  amount_to_be_paid := monthly_pay * no_of_mons_paid;

  total_dues := amount_to_be_paid - amount_collected;

  if total_dues >= 0 then
    del_amt := total_dues - arr_amt;
  else
    del_amt := 0;
  end if;

  dbms_output.put_line('actual_sales_date = '||actual_sales_date);
  dbms_output.put_line('mature_date = '||mature_date);
  dbms_output.put_line('cutoff_date = '||cutoff_date);
  dbms_output.put_line('due_date = '||due_date);
  dbms_output.put_line('n = '||n);
  dbms_output.put_line('no_of_mons_paid = '||no_of_mons_paid);
  dbms_output.put_line('del_amt = '||del_amt);
end;
