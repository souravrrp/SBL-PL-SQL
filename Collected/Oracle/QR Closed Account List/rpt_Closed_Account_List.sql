select d.ACCOUNT_NO,
       d.CONTRACT,
       round(d.CASH_PRICE, 2) NSP,
       ifsapp.Customer_Order_Line_API.Get_Total_Tax_Amount(d.ACCOUNT_NO,
                                                           d.REF_LINE_NO,
                                                           d.REF_REL_NO,
                                                           d.REF_LINE_ITEM_NO) Tax_Amount,
       (d.CASH_PRICE +
       ifsapp.Customer_Order_Line_API.Get_Total_Tax_Amount(d.ACCOUNT_NO,
                                                            d.REF_LINE_NO,
                                                            d.REF_REL_NO,
                                                            d.REF_LINE_ITEM_NO)) total_RSP,
       round(d.DISCOUNT, 2) DISCOUNT_Percent,
       d.DOWN_PAYMENT,
       d.INSTALL_AMT,
       h.rowstate status,
       d.rowstate,
       to_char(d.SALES_DATE, 'YYYY/MM/DD') SalesDate,
       to_char(d.CLOSED_DATE, 'YYYY/MM/DD') CloseDate,
       to_char(d.VARIATED_DATE, 'YYYY/MM/DD') Variation_Date
  from ifsapp.hpnret_hp_dtl_tab d
 inner join ifsapp.HPNRET_HP_HEAD_TAB h
    on d.account_no = h.account_no
 where h.ROWSTATE = 'Closed'
   and d.rowstate != 'Returned'
   and d.LINE_NO = 1
   and d.ROWVERSION between to_date('&FromDate', 'YYYY/MM/DD') and
       to_date('&ToDate', 'YYYY/MM/DD')
   and d.CONTRACT like '&Site'
 order by d.ACCOUNT_NO
