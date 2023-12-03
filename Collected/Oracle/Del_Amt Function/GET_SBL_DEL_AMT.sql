create or replace function GET_SBL_DEL_AMT(
       year_      in number,
       period_    in number,
       acct_no_   in varchar2) return number

is

    cursor get_actual_sales_date(year_ in number, period_ in number, acct_no_ in varchar2) is
      select h.actual_sales_date
      from   HPNRET_FORM249_ARREARS_TAB h
      where  h.year = year_
      and    h.period = period_
      and    h.acct_no = acct_no_;
    
    cursor get_loc(year_ in number, period_ in number, acct_no_ in varchar2) is
      select h.loc
      from   HPNRET_FORM249_ARREARS_TAB h
      where  h.year = year_
      and    h.period = period_
      and    h.acct_no = acct_no_;
    
    cursor get_hire_price(year_ in number, period_ in number, acct_no_ in varchar2) is
      select h.hire_price
      from   HPNRET_FORM249_ARREARS_TAB h
      where  h.year = year_
      and    h.period = period_
      and    h.acct_no = acct_no_;
    
    cursor get_first_pay(year_ in number, period_ in number, acct_no_ in varchar2) is
      select h.first_pay
      from   HPNRET_FORM249_ARREARS_TAB h
      where  h.year = year_
      and    h.period = period_
      and    h.acct_no = acct_no_;
    
    cursor get_monthly_pay(year_ in number, period_ in number, acct_no_ in varchar2) is
      select h.monthly_pay
      from   HPNRET_FORM249_ARREARS_TAB h
      where  h.year = year_
      and    h.period = period_
      and    h.acct_no = acct_no_;
    
    cursor get_act_out_bal(year_ in number, period_ in number, acct_no_ in varchar2) is
      select h.act_out_bal
      from   HPNRET_FORM249_ARREARS_TAB h
      where  h.year = year_
      and    h.period = period_
      and    h.acct_no = acct_no_;
    
    cursor get_arr_amt(year_ in number, period_ in number, acct_no_ in varchar2) is
      select h.arr_amt
      from   HPNRET_FORM249_ARREARS_TAB h
      where  h.year = year_
      and    h.period = period_
      and    h.acct_no = acct_no_;
    
    actual_sales_date    date;
    loc                  number;
    hire_price           number;
    first_pay            number;
    monthly_pay          number;
    act_out_bal          number;
    arr_amt              number;
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
  
    open get_actual_sales_date(year_, period_, acct_no_);
    fetch get_actual_sales_date into actual_sales_date;
    close get_actual_sales_date;
    
    open get_loc(year_, period_, acct_no_);
    fetch get_loc into loc;
    close get_loc;
    
    open get_hire_price(year_, period_, acct_no_);
    fetch get_hire_price into hire_price;
    close get_hire_price;
    
    open get_first_pay(year_, period_, acct_no_);
    fetch get_first_pay into first_pay;
    close get_first_pay;
    
    open get_monthly_pay(year_, period_, acct_no_);
    fetch get_monthly_pay into monthly_pay;
    close get_monthly_pay;
    
    open get_act_out_bal(year_, period_, acct_no_);
    fetch get_act_out_bal into act_out_bal;
    close get_act_out_bal;
    
    open get_arr_amt(year_, period_, acct_no_);
    fetch get_arr_amt into arr_amt;
    close get_arr_amt;
    
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
    
    /*dbms_output.put_line('actual_sales_date = '||actual_sales_date);
    dbms_output.put_line('mature_date = '||mature_date);
    dbms_output.put_line('cutoff_date = '||cutoff_date);
    dbms_output.put_line('due_date = '||due_date);
    dbms_output.put_line('n = '||n);
    dbms_output.put_line('no_of_mons_paid = '||no_of_mons_paid);
    dbms_output.put_line('del_amt = '||del_amt);*/
      
    return del_amt;
end GET_SBL_DEL_AMT;
      
