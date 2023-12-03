--Wholesale Dealer's Opening Balance
select b.dealer_id,
       b.dealer_name,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(b.dealer_id) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(b.dealer_id, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(b.dealer_id, 1) dealer_address,
       'OPENING BALANCE' "TYPE",
       to_date('&FROM_DATE', 'YYYY/MM/DD') "DATE",
       sum(b.balance_amt) amount,
       /*'' SALES_QUANTITY,
       '' PRODUCT_CODE,*/
       '' ORDER_NO,
       '' "SITE",
       '' DELIVERY_SITE,
       /*'' WAY_ID,*/
       '' "DESCRIPTION",
       '' CHECK_NO,
       '' BANK_ID,
       '' invoice_series,
       '' invoice_no/*,
       '' FULLY_PAID,
       '' STATUS*/
  from (select g.party_type_id dealer_id, --***** Wholesale Dealerwise Balance (Posted Vouchers)
               IFSAPP.CUSTOMER_INFO_API.Get_Name(g.party_type_id) dealer_name,
               (nvl(sum(g.debet_amount), 0) - nvl(sum(g.credit_amount), 0)) balance_amt
          from ifsapp.GEN_LED_VOUCHER_ROW_TAB g
         where g.account in
               ('10070010', '10070020', '10070030', '10070040', '20020012')
           and g.voucher_type in ('N', 'F', 'B', 'I', 'U', 'G', 'K', 'CB')
           and g.reference_serie in ('CD',
                                     'CR',
                                     'WSADV',
                                     'SI',
                                     'CF',
                                     'CI',
                                     'EX',
                                     'TRADV',
                                     'WSADVRF',
                                     'CUPOA')
           and g.voucher_date < to_date('&FROM_DATE', 'YYYY/MM/DD')
           and g.party_type_id like '&dealer_id' /*'W000%'*/ /*('W0001434-2', 'W0001548-2', 'W0001641-2', 'W0001671-2')*/
         group by g.party_type_id
        
        union
        
        --***** Wholesale Dealerwise Balance (Non Posted Vouchers)
        select v.party_type_id dealer_id,
               IFSAPP.CUSTOMER_INFO_API.Get_Name(v.party_type_id) dealer_name,
               (nvl(sum(v.debet_amount), 0) - nvl(sum(v.credit_amount), 0)) balance_amt
          from ifsapp.VOUCHER_ROW_TAB v
         where v.account in
               ('10070010', '10070020', '10070030', '10070040', '20020012')
           and v.voucher_type in ('N', 'F', 'B', 'I', 'U', 'G', 'K', 'CB')
           and v.reference_serie in ('CD',
                                     'CR',
                                     'WSADV',
                                     'SI',
                                     'CF',
                                     'CI',
                                     'EX',
                                     'TRADV',
                                     'WSADVRF',
                                     'CUPOA')
           and v.voucher_date < to_date('&FROM_DATE', 'YYYY/MM/DD')
           and v.party_type_id like '&dealer_id' /*'W000%'*/ /*('W0001434-2', 'W0001548-2', 'W0001641-2', 'W0001671-2'*/
         group by v.party_type_id) b
 group by b.dealer_id, b.dealer_name

UNION ALL

--Wholesale Sales of Dealers
SELECT W.CUSTOMER_NO dealer_ID,
       W.CUSTOMER_NAME dealer_name,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(W.CUSTOMER_NO) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(W.CUSTOMER_NO, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(W.CUSTOMER_NO, 1) dealer_address,
       'SALES' "TYPE",
       TRUNC(W.SALES_DATE) "DATE",
       W.RSP AMOUNT,
       /*TO_CHAR(W.SALES_QUANTITY) SALES_QUANTITY,
       W.PRODUCT_CODE,*/
       W.ORDER_NO,
       W.SITE,
       W.DELIVERY_SITE,
       /*'' WAY_ID,*/
       '' "DESCRIPTION",
       '' CHECK_NO,
       '' BANK_ID,
       W.series_id invoice_series,
       W.invoice_no invoice_no/*,
       '' FULLY_PAID,
       '' STATUS*/
  FROM ifsapp.sbl_vw_wholesale_sales W
 WHERE W.CUSTOMER_NO = '&dealer_id'
   AND W.SALES_DATE between to_date('&FROM_DATE', 'yyyy/mm/dd') and
       to_date('&TO_DATE', 'yyyy/mm/dd')
   and W.SITE in ('JWSS', 'SAOS', 'SCSM', 'SWSS', 'WSMO')

UNION ALL

--Check Collections of Dealers
select t.identity dealer_ID,
       t.name dealer_name,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(t.identity) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(t.identity, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(t.identity, 1) dealer_address,
       'CHECK COLLECTION' "TYPE",
       trunc(t.payment_date) "DATE",
       (-1) * t.full_curr_amount AMOUNT,
       /*'' SALES_QUANTITY,
       '' PRODUCT_CODE,*/
       '' ORDER_NO,
       '' "SITE",
       '' DELIVERY_SITE,
       /*t.way_id,*/
       t.voucher_text "DESCRIPTION",
       nvl(substr(t.ledger_item_id, 0, instr(t.ledger_item_id, '#') - 1),
           t.ledger_item_id) check_no,
       t.cash_account bank_ID,
       t.ledger_item_series_id invoice_series,
       t.ledger_item_id invoice_no/*,
       '' FULLY_PAID,
       t.state status*/
  from ifsapp.CHECK_LEDGER_ITEM t
 where t.identity = '&dealer_id'
   and t.way_id = 'CHECK'
   and t.party_type = 'Customer'
   and t.state != 'Cancelled'
   and t.payment_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')

union all

--Cash Collections of Dealers
select l.identity dealer_id,
       ifsapp.customer_info_api.Get_Name(l.identity) dealer_name,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(l.identity) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(l.identity, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(l.identity, 1) dealer_address,
       'CASH COLLECTION' "TYPE",
       trunc(m.mixed_payment_date) "DATE",
       (-1) * l.curr_amount AMOUNT,
       /*'' SALES_QUANTITY,
       '' PRODUCT_CODE,*/
       '' ORDER_NO,
       '' "SITE",
       '' DELIVERY_SITE,
       /*'CASH' way_id,*/
       l.text "DESCRIPTION",
       '' check_no,
       m.short_name bank_ID,
       '' invoice_series,
       '' invoice_no/*,
       '' FULLY_PAID,
       m.rowstate status*/
  from ifsapp.MIXED_PAYMENT_LUMP_SUM_TAB l
 inner join ifsapp.MIXED_PAYMENT_TAB m
    on m.mixed_payment_id = l.mixed_payment_id
 where l.identity = '&dealer_id'
   and l.party_type = 'CUSTOMER'
   and m.rowstate != 'Cancelled'
   and m.mixed_payment_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')

union all

--Supplier Invoices
select s.identity dealer_id,
       IFSAPP.SUPPLIER_INFO_API.Get_Name(s.identity) dealer_name,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(s.identity) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(s.identity, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(s.identity, 1) dealer_address,
       'SUPPLIER INVOICE' "TYPE",
       nvl(s.ledger_date, s.due_date) "DATE",
       decode(s.open_amount, 0, s.inv_amount * (-1), s.inv_amount) inv_amount,
       /*'' SALES_QUANTITY,
       '' PRODUCT_CODE,*/
       '' ORDER_NO,
       '' "SITE",
       '' DELIVERY_SITE,
       /*'' way_id,*/
       s.ncf_reference "DESCRIPTION",
       '' check_no,
       '' BANK_ID,
       s.ledger_item_series_id invoice_series,
       s.ledger_item_id invoice_no/*,
       s.fully_paid,
       s.objstate STATUS*/
  from ifsapp.LEDGER_ITEM_SU_QRY s
 where s.identity = '&dealer_id'
   and s.ledger_item_series_id = 'SI'
   and s.objstate != 'Cancelled'
   and nvl(s.ledger_date, s.due_date) between
       to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
 order by 4
