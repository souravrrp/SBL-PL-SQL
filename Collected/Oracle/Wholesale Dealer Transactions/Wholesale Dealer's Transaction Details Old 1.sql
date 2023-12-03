--Wholesale Dealer's Opening Balance
select O.dealer_id,
       O.dealer_name,
       O.phone_no,
       O.dealer_address,
       'OPENING BALANCE' "TYPE",
       to_date('&FROM_DATE', 'YYYY/MM/DD') "DATE",
       NVL(SUM(O.debet_amount), 0) - NVL(SUM(O.credit_amount), 0) AMOUNT,
       '' ORDER_NO,
       '' "SITE",
       '' DELIVERY_SITE,
       '' "DESCRIPTION",
       '' CHECK_NO,
       '' BANK_ID,
       '' INVOICE_SERIES,
       '' INVOICE_NO
  from IFSAPP.SBL_VW_WS_DEALER_OPEN_BAL_TRN O
 where O.voucher_date < to_date('&FROM_DATE', 'YYYY/MM/DD')
   AND O.dealer_id = '&DEALER_ID'
 group by O.dealer_id, O.dealer_name, O.phone_no, O.dealer_address

union all

--Wholesale Dealer's Sales
SELECT W.CUSTOMER_NO dealer_ID,
       W.CUSTOMER_NAME dealer_name,
       W.phone_no,
       W.dealer_address,
       'SALES' "TYPE",
       TRUNC(W.SALES_DATE) "DATE",
       W.RSP AMOUNT,
       W.ORDER_NO,
       W.SITE,
       W.DELIVERY_SITE,
       '' "DESCRIPTION",
       '' CHECK_NO,
       '' BANK_ID,
       W.series_id invoice_series,
       W.invoice_no invoice_no
  FROM ifsapp.sbl_vw_wholesale_sales W
 WHERE W.SITE in ('JWSS', 'SAOS', 'SCSM', 'SWSS', 'WSMO')
   AND W.SALES_DATE between to_date('&FROM_DATE', 'yyyy/mm/dd') and
       to_date('&TO_DATE', 'yyyy/mm/dd')
   AND W.CUSTOMER_NO = '&DEALER_ID'

union all

--Collections of Dealer
select C.dealer_ID,
       C.dealer_name,
       C.phone_no,
       C.dealer_address,
       C.TYPE,
       C.payment_date "DATE",
       C.COLL_AMOUNT AMOUNT,
       '' ORDER_NO,
       '' "SITE",
       '' DELIVERY_SITE,
       C.DESCRIPTION,
       C.check_no,
       C.bank_ID,
       C.invoice_series,
       C.invoice_no
  from IFSAPP.SBL_VW_WS_DEALER_COLLECTIONS C
 where C.payment_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
   and C.dealer_ID = '&DEALER_ID'

union all

--Dealer's Supplier Invoices
select S.dealer_id,
       S.dealer_name,
       S.phone_no,
       S.dealer_address,
       S.TYPE,
       S.INV_DATE "DATE",
       S.inv_amount,
       '' ORDER_NO,
       '' "SITE",
       '' DELIVERY_SITE,
       S.DESCRIPTION,
       '' check_no,
       '' BANK_ID,
       S.invoice_series,
       S.invoice_no
  from IFSAPP.SBL_VW_WS_SUPP_INV S
 where S.INV_DATE between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
   and s.dealer_id = '&DEALER_ID'
 order by 6
