--*** Wholesale Dealer Statement
select O.dealer_id,
       O.dealer_name,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(o.dealer_id) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(o.dealer_id, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(o.dealer_id, 1) dealer_address,
       'OPENING BALANCE' "TYPE",
       '' ORDER_NO,
       '' DELIVERY_SITE,
       '' "DESCRIPTION",
       to_date('&YEAR' || '/' || '&START_PERIOD' || '/1', 'YYYY/MM/DD') "DATE",
       '' INVOICE_NO,
       NVL(O.CLOSE_BALANCE, 0) "AMOUNT (IN TAKA)"
  from IFSAPP.SBL_DEALER_BALANCE O
 where O.YEAR = EXTRACT (YEAR FROM (to_date('&YEAR' || '/' || '&START_PERIOD' || '/1', 'YYYY/MM/DD') -1))
   AND O.PERIOD = EXTRACT (MONTH FROM (to_date('&YEAR' || '/' || '&START_PERIOD' || '/1', 'YYYY/MM/DD') -1))
   AND O.dealer_id = '&DEALER_ID'

union all

select i.identity dealer_id,
       ifsapp.customer_info_api.Get_Name(i.identity) dealer_name,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(i.identity) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(i.identity, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(i.identity, 1) dealer_address,
       CASE
         WHEN i.net_curr_amount > 0 THEN
          'SALES'
         ELSE
          'SALES RETURN'
       END "TYPE",
       i.creators_reference order_no,
       (select max(c.vendor_no)
          from ifsapp.CUSTOMER_ORDER_LINE_TAB c
         where c.order_no = i.creators_reference
           and c.rowstate != 'Cancelled') DELIVERY_SITE,
       'PAYMENT TERM - '||i.pay_term_id "DESCRIPTION",
       trunc(i.invoice_date) "DATE",
       i.invoice_no invoice_no,
       (i.net_curr_amount + i.vat_curr_amount) "AMOUNT (IN TAKA)"
  from IFSAPP.INVOICE_TAB i
 where i.c7 in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM', 'WITM', 'SCSM')
   and (i.net_curr_amount + i.vat_curr_amount) != 0
   and trunc(i.invoice_date) between
       to_date('&YEAR' ||'/'|| '&START_PERIOD' || '/1', 'YYYY/MM/DD') and
       last_day(to_date('&YEAR' ||'/'|| '&END_PERIOD' || '/1', 'YYYY/MM/DD'))
   and i.identity = '&DEALER_ID'

union all

select C.dealer_ID,
       C.dealer_name,
       C.phone_no,
       C.dealer_address,
       C.TYPE,
       '' ORDER_NO,
       '' DELIVERY_SITE,
       C.DESCRIPTION,
       C.payment_date "DATE",
       '' invoice_no,
       C.COLL_AMOUNT "AMOUNT (IN TAKA)"
  from IFSAPP.SBL_VW_WS_DEALER_COLLECTIONS C
 where C.payment_date between
       to_date('&YEAR' ||'/'|| '&START_PERIOD' || '/1', 'YYYY/MM/DD') and
       last_day(to_date('&YEAR' ||'/'|| '&END_PERIOD' || '/1', 'YYYY/MM/DD'))
   and C.dealer_ID = '&DEALER_ID'

union all

select S.dealer_id,
       S.dealer_name,
       S.phone_no,
       S.dealer_address,
       S.TYPE,
       '' ORDER_NO,
       '' DELIVERY_SITE,
       S.DESCRIPTION,
       S.INV_DATE "DATE",
       S.invoice_no,
       S.inv_amount
  from IFSAPP.SBL_VW_WS_SUPP_INV S
 where S.INV_DATE between
       to_date('&YEAR' ||'/'|| '&START_PERIOD' || '/1', 'YYYY/MM/DD') and
       last_day(to_date('&YEAR' ||'/'|| '&END_PERIOD' || '/1', 'YYYY/MM/DD'))
   and s.dealer_id = '&DEALER_ID'
 order by 9
