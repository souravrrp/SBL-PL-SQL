declare
  cursor get_acct_info(invoice_id_ in number, item_id_ in number) is
    select t.c1, t.c2, t.c3, t.c5, t.net_curr_amount, i.invoice_date
      from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
     where t.invoice_id = i.invoice_id
       and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
       and t.rowstate = 'Posted'
       and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in ('INV', 'PKG')
       and t.invoice_id = invoice_id_ --'&invoice_id_'
       and t.item_id != item_id_ --'&item_id_'
       and t.net_curr_amount != 0
       and rownum <= 1;

  acct_no_     varchar2(100);
  line_no_     varchar2(100);
  rel_no_      varchar2(100);
  catalog_no_  varchar2(200);
  sales_price_ number;
  sales_date_  date;
  status_      varchar2(100);

begin
  acct_no_ := '&acct_no_';
  
  open get_acct_info('&invoice_id_', '&item_id_');
  fetch get_acct_info
    into acct_no_,
         line_no_,
         rel_no_,
         catalog_no_,
         sales_price_,
         sales_date_;
  close get_acct_info;
  
  if catalog_no_ is not null then
    status_ := GET_SBL_ACCOUNT_STATUS(acct_no_, line_no_, rel_no_, catalog_no_, sales_price_, sales_date_); /*'Not Defined';*/
  else
    if (substr(acct_no_, 4, 2) = '-R') then
      status_ := 'CashSale';
    else
      status_ := 'HireSale';
    end if;
  end if;
  
  dbms_output.put_line('acct_no_: ' || acct_no_);
  dbms_output.put_line('line_no_: ' || line_no_);
  dbms_output.put_line('rel_no_: ' || rel_no_);
  dbms_output.put_line('catalog_no_: ' || catalog_no_);
  dbms_output.put_line('sales_price_: ' || sales_price_);
  dbms_output.put_line('sales_date_: ' || sales_date_);
  dbms_output.put_line('status_: ' || status_);

end GET_SBL_FREE_ISSUE_LINE_STATE;
