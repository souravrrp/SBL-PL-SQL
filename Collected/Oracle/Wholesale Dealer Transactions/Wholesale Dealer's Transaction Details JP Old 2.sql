select O.dealer_id,
       O.dealer_name,
       O.phone_no,
       O.dealer_address,
       'OPENING BALANCE' "TYPE",
       $P{FROM_DATE} AS "DATE",
       (NVL(SUM(O.debet_amount), 0) - NVL(SUM(O.credit_amount), 0)) AMOUNT,
       '' ORDER_NO,
       '' "SITE",
       '' DELIVERY_SITE,
       '' "DESCRIPTION",
       '' CHECK_NO,
       '' BANK_ID,
       '' INVOICE_SERIES,
       '' INVOICE_NO
  from IFSAPP.SBL_VW_WS_DEALER_OPEN_BAL_TRN O
 where O.voucher_date < $P{FROM_DATE}
   AND O.dealer_id = $P{DEALER_ID}
 group by O.dealer_id, O.dealer_name, O.phone_no, O.dealer_address

union all

select i.identity dealer_id,
       ifsapp.customer_info_api.Get_Name(i.identity) dealer_name,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(i.identity) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(i.identity, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(i.identity, 1) dealer_address,
       'SALES' "TYPE",
       trunc(i.invoice_date) "DATE",
       (i.net_curr_amount + i.vat_curr_amount) amount,
       i.creators_reference order_no,
       i.c7 "SITE",
       '' DELIVERY_SITE,
       '' "DESCRIPTION",
       '' CHECK_NO,
       '' BANK_ID,
       i.series_id invoice_series,
       i.invoice_no invoice_no
  from IFSAPP.INVOICE_TAB i
 where i.c7 in ('JWSS', 'SAOS', 'SCSM', 'SWSS', 'WSMO')
   and (i.net_curr_amount + i.vat_curr_amount) != 0
   and trunc(i.invoice_date) between $P{FROM_DATE} and
       $P{TO_DATE}
   and i.identity = $P{DEALER_ID}

union all

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
 where C.payment_date between $P{FROM_DATE} and
       $P{TO_DATE}
   and C.dealer_ID = $P{DEALER_ID}

union all

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
 where S.INV_DATE between $P{FROM_DATE} and
       $P{TO_DATE}
   and s.dealer_id = $P{DEALER_ID}
