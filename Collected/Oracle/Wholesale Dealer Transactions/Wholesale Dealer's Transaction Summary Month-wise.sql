--*****Wholesale Dealer's Transaction Summary Month-wise
--Wholesale Dealer's Opening Balance
select O.dealer_id,
       O.dealer_name,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(o.dealer_id) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(o.dealer_id, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(o.dealer_id, 1) dealer_address,
       'OPENING BALANCE' "TYPE",
       NVL(O.CLOSE_BALANCE, 0) "AMOUNT (IN TAKA)"
  from IFSAPP.SBL_DEALER_BALANCE O
 where O.YEAR = EXTRACT (YEAR FROM (to_date('&YEAR' || '/' || '&PERIOD' || '/1', 'YYYY/MM/DD') - 1))
   AND O.PERIOD = EXTRACT (MONTH FROM (to_date('&YEAR' || '/' || '&PERIOD' || '/1', 'YYYY/MM/DD') - 1))
   AND O.dealer_id = '&DEALER_ID'

union all

--Wholesale Dealer's Sales Summary
select i.identity dealer_id,
       ifsapp.customer_info_api.Get_Name(i.identity) dealer_name,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(i.identity) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(i.identity, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(i.identity, 1) dealer_address,
       'SALES' "TYPE",
       sum(i.net_curr_amount + i.vat_curr_amount) "AMOUNT (IN TAKA)"
  from IFSAPP.INVOICE_TAB i
 where i.c7 in ('JWSS', 'SAOS', /*'SCSM',*/ 'SWSS', 'WSMO')
   and (i.net_curr_amount + i.vat_curr_amount) != 0
   and trunc(i.invoice_date) between
       to_date('&YEAR' || '/' || '&PERIOD' || '/1', 'YYYY/MM/DD') and
       last_day(to_date('&YEAR' || '/' || '&PERIOD' || '/1', 'YYYY/MM/DD'))
   and i.identity = '&DEALER_ID'
 group by i.identity

union all

--Collections Summary of Dealer
select C.dealer_ID,
       C.dealer_name,
       C.phone_no,
       C.dealer_address,
       C.TYPE,
       SUM(C.COLL_AMOUNT) "AMOUNT (IN TAKA)"
  from IFSAPP.SBL_VW_WS_DEALER_COLLECTIONS C
 where C.payment_date between
       to_date('&YEAR' || '/' || '&PERIOD' || '/1', 'YYYY/MM/DD') and
       last_day(to_date('&YEAR' || '/' || '&PERIOD' || '/1', 'YYYY/MM/DD'))
   and C.dealer_ID = '&DEALER_ID'
 group by c.dealer_ID, c.dealer_name, c.phone_no, c.dealer_address, c.TYPE

union all

--Dealer's Supplier Invoice Summary
select S.dealer_id,
       S.dealer_name,
       S.phone_no,
       S.dealer_address,
       S.TYPE,
       SUM(S.inv_amount) "AMOUNT (IN TAKA)"
  from IFSAPP.SBL_VW_WS_SUPP_INV S
 where S.INV_DATE between
       to_date('&YEAR' || '/' || '&PERIOD' || '/1', 'YYYY/MM/DD') and
       last_day(to_date('&YEAR' || '/' || '&PERIOD' || '/1', 'YYYY/MM/DD'))
   and s.dealer_id = '&DEALER_ID'
 group by s.dealer_id, s.dealer_name, s.phone_no, s.dealer_address, s.TYPE
