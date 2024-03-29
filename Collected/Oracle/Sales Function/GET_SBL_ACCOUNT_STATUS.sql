create or replace function GET_SBL_ACCOUNT_STATUS(
       acct_no_             in varchar2,
       line_no_             in varchar2,
       rel_no_              in varchar2,
       catalog_no_          in varchar2,
       sales_price_         in number,
       sales_date_          in date) return varchar2

is

    cursor get_cash_conv(acct_no_ in varchar2) is
      select h.cash_conv
      from   HPNRET_CUSTOMER_ORDER_TAB h
      where  h.order_no = acct_no_;

    cursor get_org_acct_no(acct_no_ in varchar2) is
      select hd.original_acc_no
      from   HPNRET_HP_HEAD_TAB hd
      where  hd.account_no = acct_no_;

    /*cursor get_variation_count(acct_no_ in varchar2) is
      select count(hd.account_no) no_of_variations
      from   HPNRET_HP_HEAD_TAB hd
      where  hd.original_acc_no = org_acct_no_;*/

    cursor get_hp_referred_status(acct_no_ in varchar2) is
      select h.rowstate
      from   hpnret_hp_dtl_tab h
      where  h.reference_hp = acct_no_;

    cursor get_reverted_date(acct_no_ in varchar2, line_no_ in varchar2, rel_no_ in varchar2, catalog_no_ in varchar2) is
      select trunc(d.reverted_date) reverted_date
      from   HPNRET_HP_DTL_TAB d
      where  d.account_no = acct_no_
      and    d.ref_line_no = line_no_
      and    d.ref_rel_no = rel_no_
      and    d.catalog_no = catalog_no_;

    cursor get_hp_line_status(acct_no_ in varchar2, line_no_ in varchar2, rel_no_ in varchar2, catalog_no_ in varchar2, sales_date_ in date) is
      select d.rowstate
      from   HPNRET_HP_DTL_TAB d
      where  d.account_no = acct_no_
      and    d.ref_line_no = line_no_
      and    d.ref_rel_no = rel_no_
      and    d.catalog_no = catalog_no_
      and    trunc(d.variated_date) = sales_date_;
    
  
    org_acct_no_             varchar2(12);
    --prev_acct_no_            varchar2;
    status_                  varchar2(40);
    cash_conv_               varchar2(20);
    reverted_date_           date;
    --no_of_variations         in number;

begin

    if (substr(acct_no_,4,2) = '-R' and sales_price_ > 0) then
      open get_cash_conv(acct_no_);
      fetch get_cash_conv into cash_conv_;
      close get_cash_conv;
      if cash_conv_ = 'TRUE' then
        status_ := 'PositiveCashConv';
        --return status_;
      else
        status_ := 'CashSale';
        --return status_;
      end if;
    elsif (substr(acct_no_,4,2) = '-R' and sales_price_ < 0) then
      open get_cash_conv(acct_no_);
      fetch get_cash_conv into cash_conv_;
      close get_cash_conv;
      if cash_conv_ = 'TRUE' then
        status_ := 'ReturnAfterCashConv';
        --return status_;
      else
        status_ := 'ReturnCompleted';
        --return status_;
      end if;
    elsif substr(acct_no_,4,2) = '-H' then
      open get_org_acct_no(acct_no_);
      fetch get_org_acct_no into org_acct_no_;
      close get_org_acct_no;
      if acct_no_ = org_acct_no_ and sales_price_ > 0 then
        status_ := 'HireSale';
        --return status_;
      elsif acct_no_ != org_acct_no_ and sales_price_ > 0 then
        open get_hp_referred_status(acct_no_);
        fetch get_hp_referred_status into status_;
        close get_hp_referred_status;
        status_ := 'Positive'||status_;
        --return status_;
      elsif sales_price_ < 0 then
        open get_reverted_date(acct_no_, line_no_, rel_no_, catalog_no_);
        fetch get_reverted_date into reverted_date_;
        close get_reverted_date;
        if reverted_date_ is null then
          open get_hp_line_status(acct_no_, line_no_, rel_no_, catalog_no_, sales_date_);
          fetch get_hp_line_status into status_;
          close get_hp_line_status;
          --return status_;
        else
          status_ := 'Reverted';
          --return status_;
        end if;
      end if;
    end if;
    return status_;
end GET_SBL_ACCOUNT_STATUS;
