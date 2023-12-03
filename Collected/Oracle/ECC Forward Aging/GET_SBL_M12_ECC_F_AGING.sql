create or replace function GET_SBL_M12_ECC_F_AGING(
       year_      in number,
       period_    in number,
       acct_no_   in varchar2) return number

is

    cursor get_pv(year_ in number, period_ in number, acct_no_ in varchar2) is
      select h.present_value
      from   HPNRET_FORM249_ARREARS_TAB h
      where  h.year = year_
      and    h.period = period_
      and    h.acct_no = acct_no_;

    cursor get_effective_rate(year_ in number, period_ in number, acct_no_ in varchar2) is
      select h.effective_rate
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
    
    pv                   number;
    effective_rate       number;
    monthly_pay          number;
    m1                   number;
    m2                   number;
    m3                   number;
    m4                   number;
    m5                   number;            
    m6                   number;
    m7                   number;
    m8                   number;
    m9                   number;
    m10                  number;    
    m11                  number;
    m12                  number;


begin
  
    open get_pv(year_, period_, acct_no_);
    fetch get_pv into pv;
    close get_pv;
    
    open get_effective_rate(year_, period_, acct_no_);
    fetch get_effective_rate into effective_rate;
    close get_effective_rate;
    
    open get_monthly_pay(year_, period_, acct_no_);
    fetch get_monthly_pay into monthly_pay;
    close get_monthly_pay;
    
    m1 := GET_SBL_M1_ECC_F_AGING(year_, period_, acct_no_);
    m2 := GET_SBL_M2_ECC_F_AGING(year_, period_, acct_no_);
    m3 := GET_SBL_M3_ECC_F_AGING(year_, period_, acct_no_);
    m4 := GET_SBL_M4_ECC_F_AGING(year_, period_, acct_no_);
    m5 := GET_SBL_M5_ECC_F_AGING(year_, period_, acct_no_);
    m6 := GET_SBL_M6_ECC_F_AGING(year_, period_, acct_no_);
    m7 := GET_SBL_M7_ECC_F_AGING(year_, period_, acct_no_);
    m8 := GET_SBL_M8_ECC_F_AGING(year_, period_, acct_no_);
    m9 := GET_SBL_M9_ECC_F_AGING(year_, period_, acct_no_);
    m10 := GET_SBL_M9_ECC_F_AGING(year_, period_, acct_no_);
    m11 := GET_SBL_M9_ECC_F_AGING(year_, period_, acct_no_);
    
    if m11 > 0 and (pv - ((11 * monthly_pay) - m1 - m2 - m3 - m4 - m5 - m6 - m7 - m8 - m9 - m10 - m11)) > 0 then
      m12 := round((pv - ((11 * monthly_pay) - m1 - m2 - m3 - m4 - m5 - m6 - m7 - m8 - m9 - m10 - m11)) * effective_rate, 6);
    else
      m12 := 0;
    end if;
    
    /*dbms_output.put_line('m1 = '||m1);*/
    
    return m12;
    
end GET_SBL_M12_ECC_F_AGING;
