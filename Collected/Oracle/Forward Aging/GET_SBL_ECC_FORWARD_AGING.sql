create or replace procedure GET_SBL_ECC_FORWARD_AGING(year_    in number,
                                                     period_  in number,
                                                     acct_no_ in varchar2)

 is

  cursor get_pv(year_ in number, period_ in number, acct_no_ in varchar2) is
    select h.present_value
      from HPNRET_FORM249_ARREARS_TAB h
     where h.year = year_
       and h.period = period_
       and h.acct_no = acct_no_;

  cursor get_effective_rate(year_    in number,
                            period_  in number,
                            acct_no_ in varchar2) is
    select h.effective_rate
      from HPNRET_FORM249_ARREARS_TAB h
     where h.year = year_
       and h.period = period_
       and h.acct_no = acct_no_;

  cursor get_monthly_pay(year_    in number,
                         period_  in number,
                         acct_no_ in varchar2) is
    select h.monthly_pay
      from HPNRET_FORM249_ARREARS_TAB h
     where h.year = year_
       and h.period = period_
       and h.acct_no = acct_no_;

  pv             number;
  effective_rate number;
  monthly_pay    number;
  m1             number;
  m2             number;
  m3             number;
  m4             number;
  m5             number;
  m6             number;
  m7             number;
  m8             number;
  m9             number;
  m10            number;
  m11            number;
  m12            number;
  m13            number;

begin

  
  open get_pv(year_, period_, acct_no_);
  fetch get_pv
    into pv;
  close get_pv;

  open get_effective_rate(year_, period_, acct_no_);
  fetch get_effective_rate
    into effective_rate;
  close get_effective_rate;

  open get_monthly_pay(year_, period_, acct_no_);
  fetch get_monthly_pay
    into monthly_pay;
  close get_monthly_pay;

  if pv > 0 then
    m1 := round(pv * effective_rate, 6);
  else
    m1 := 0;
  end if;

  if m1 > 0 and (pv - (monthly_pay - m1)) > 0 then
    m2 := round((pv - (monthly_pay - m1)) * effective_rate, 6);
  else
    m2 := 0;
  end if;

  if m2 > 0 and (pv - ((2 * monthly_pay) - m1 - m2)) > 0 then
    m3 := round((pv - ((2 * monthly_pay) - m1 - m2)) * effective_rate, 6);
  else
    m3 := 0;
  end if;

  if m3 > 0 and (pv - ((3 * monthly_pay) - m1 - m2 - m3)) > 0 then
    m4 := round((pv - ((3 * monthly_pay) - m1 - m2 - m3)) * effective_rate,
                6);
  else
    m4 := 0;
  end if;

  if m4 > 0 and (pv - ((4 * monthly_pay) - m1 - m2 - m3 - m4)) > 0 then
    m5 := round((pv - ((4 * monthly_pay) - m1 - m2 - m3 - m4)) *
                effective_rate,
                6);
  else
    m5 := 0;
  end if;

  if m5 > 0 and (pv - ((5 * monthly_pay) - m1 - m2 - m3 - m4 - m5)) > 0 then
    m6 := round((pv - ((5 * monthly_pay) - m1 - m2 - m3 - m4 - m5)) *
                effective_rate,
                6);
  else
    m6 := 0;
  end if;

  if m6 > 0 and
     (pv - ((6 * monthly_pay) - m1 - m2 - m3 - m4 - m5 - m6)) > 0 then
    m7 := round((pv - ((6 * monthly_pay) - m1 - m2 - m3 - m4 - m5 - m6)) *
                effective_rate,
                6);
  else
    m7 := 0;
  end if;

  if m7 > 0 and
     (pv - ((7 * monthly_pay) - m1 - m2 - m3 - m4 - m5 - m6 - m7)) > 0 then
    m8 := round((pv -
                ((7 * monthly_pay) - m1 - m2 - m3 - m4 - m5 - m6 - m7)) *
                effective_rate,
                6);
  else
    m8 := 0;
  end if;

  if m8 > 0 and
     (pv - ((8 * monthly_pay) - m1 - m2 - m3 - m4 - m5 - m6 - m7 - m8)) > 0 then
    m9 := round((pv -
                ((8 * monthly_pay) - m1 - m2 - m3 - m4 - m5 - m6 - m7 - m8)) *
                effective_rate,
                6);
  else
    m9 := 0;
  end if;

  if m9 > 0 and
     (pv - ((9 * monthly_pay) - m1 - m2 - m3 - m4 - m5 - m6 - m7 - m8 - m9)) > 0 then
    m10 := round((pv -
                 ((9 * monthly_pay) - m1 - m2 - m3 - m4 - m5 - m6 - m7 - m8 - m9)) *
                 effective_rate,
                 6);
  else
    m10 := 0;
  end if;

  if m10 > 0 and
     (pv -
     ((10 * monthly_pay) - m1 - m2 - m3 - m4 - m5 - m6 - m7 - m8 - m9 - m10)) > 0 then
    m11 := round((pv -
                 ((10 * monthly_pay) - m1 - m2 - m3 - m4 - m5 - m6 - m7 - m8 - m9 - m10)) *
                 effective_rate,
                 6);
  else
    m11 := 0;
  end if;

  if m11 > 0 and
     (pv -
     ((11 * monthly_pay) - m1 - m2 - m3 - m4 - m5 - m6 - m7 - m8 - m9 - m10 - m11)) > 0 then
    m12 := round((pv -
                 ((11 * monthly_pay) - m1 - m2 - m3 - m4 - m5 - m6 - m7 - m8 - m9 - m10 - m11)) *
                 effective_rate,
                 6);
  else
    m12 := 0;
  end if;
  
  if m12 > 0 and
     (pv -
     ((12 * monthly_pay) - m1 - m2 - m3 - m4 - m5 - m6 - m7 - m8 - m9 - m10 - m11 - m12)) > 0 then
    m13 := round((pv -
                 ((12 * monthly_pay) - m1 - m2 - m3 - m4 - m5 - m6 - m7 - m8 - m9 - m10 - m11 - m12)) *
                 effective_rate,
                 6);
  else
    m13 := 0;
  end if;
  
  update SBL_ECC_FORWARD_AGING f
     set f.month_1  = m1,
         f.month_2  = m2,
         f.month_3  = m3,
         f.month_4  = m4,
         f.month_5  = m5,
         f.month_6  = m6,
         f.month_7  = m7,
         f.month_8  = m8,
         f.month_9  = m9,
         f.month_10 = m10,
         f.month_11 = m11,
         f.month_12 = m12,
         f.month_13 = m13
   where f.year = year_
     and f.period = period_
     and f.acct_no = acct_no_;
  commit;

  /*dbms_output.put_line('m1 = ' || m1);
  dbms_output.put_line('m2 = ' || m2);
  dbms_output.put_line('m3 = ' || m3);
  dbms_output.put_line('m4 = ' || m4);
  dbms_output.put_line('m5 = ' || m5);
  dbms_output.put_line('m6 = ' || m6);
  dbms_output.put_line('m7 = ' || m7);
  dbms_output.put_line('m8 = ' || m8);
  dbms_output.put_line('m9 = ' || m9);
  dbms_output.put_line('m10 = ' || m10);
  dbms_output.put_line('m11 = ' || m11);
  dbms_output.put_line('m12 = ' || m12);*/

END GET_SBL_ECC_FORWARD_AGING;
