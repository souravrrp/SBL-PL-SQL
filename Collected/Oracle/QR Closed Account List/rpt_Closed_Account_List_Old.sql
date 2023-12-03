select 
    --count(*)
    distinct(a.ACCOUNT_NO),
    a.CONTRACT,
    round(a.CASH_PRICE,2) NSP,
    ifsapp.Customer_Order_Line_API.Get_Total_Tax_Amount(a.ACCOUNT_NO,a.REF_LINE_NO,a.REF_REL_NO,a.REF_LINE_ITEM_NO) Tax_Amount,
    (a.CASH_PRICE +
    ifsapp.Customer_Order_Line_API.Get_Total_Tax_Amount(a.ACCOUNT_NO,a.REF_LINE_NO,a.REF_REL_NO,a.REF_LINE_ITEM_NO)) total_RSP ,
    round(DISCOUNT,2) DISCOUNT_Percent,
    a.DOWN_PAYMENT,
    a.INSTALL_AMT,
    ROWSTATE,
    trunc(SALES_DATE) SalesDate,
    trunc(CLOSED_DATE) CloseDate,
    trunc(VARIATED_DATE) Variation_Date,
    a.rowversion,
    a.rowstate
from ifsapp.hpnret_hp_dtl_tab a
where 
  a.ROWSTATE='Closed' and 
  a.LINE_NO=1 and 
  a.ROWVERSION between to_date('&FromDate','YYYY/MM/DD') and to_date('&ToDate','YYYY/MM/DD') and 
  a.CONTRACT like '&Site'
order by a.ACCOUNT_NO
