create or replace procedure SET_SBL_ECC_FORWARD_AGING(year_   in number,
                                                      period_ in number)

 is

  cursor get_data(year_ in number, period_ in number) is
    select h.acct_no
      from HPNRET_FORM249_ARREARS_TAB h
     where h.year = year_
       and h.period = period_
       and h.act_out_bal > 0;

  acct_no_list get_data%rowtype;

begin

  open get_data(year_, period_);
  loop
    fetch get_data
      into acct_no_list;
    exit when get_data%notfound;
    GET_SBL_ECC_FORWARD_AGING(year_, period_, acct_no_list.acct_no);
    --dbms_output.put_line(acct_no_list.acct_no);
  end loop;
end SET_SBL_ECC_FORWARD_AGING;
