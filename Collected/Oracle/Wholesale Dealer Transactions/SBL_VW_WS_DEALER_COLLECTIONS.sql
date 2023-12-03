--SBL_VW_WS_DEALER_COLLECTIONS
CREATE OR REPLACE VIEW SBL_VW_WS_DEALER_COLLECTIONS AS
SELECT C.dealer_ID,
       ifsapp.customer_info_api.Get_Name(C.dealer_ID) dealer_name,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(C.dealer_ID) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(C.dealer_ID, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(C.dealer_ID, 1) dealer_address,
       C.TYPE,
       C.payment_date,
       C.COLL_AMOUNT * (-1) COLL_AMOUNT,
       C.DESCRIPTION,
       C.check_no,
       C.bank_ID,
       C.invoice_series,
       C.invoice_no
  FROM (select t.identity dealer_ID,
               'CHEQUE COLLECTION' "TYPE",
               trunc(t.payment_date) payment_date,
               t.full_curr_amount COLL_AMOUNT,
               t.voucher_text "DESCRIPTION",
               nvl(substr(t.ledger_item_id,
                          0,
                          instr(t.ledger_item_id, '#') - 1),
                   t.ledger_item_id) check_no,
               t.cash_account bank_ID,
               t.ledger_item_series_id invoice_series,
               t.ledger_item_id invoice_no
          from ifsapp.CHECK_LEDGER_ITEM t
         where t.way_id = 'CHECK'
           and t.party_type = 'Customer'
           and ifsapp.cust_ord_customer_api.get_cust_grp(t.identity) = '003'
           and t.state != 'Cancelled'
        
        union all
        
        select l.identity dealer_id,
               'CASH COLLECTION' "TYPE",
               trunc(m.mixed_payment_date) payment_date,
               l.curr_amount COLL_AMOUNT,
               l.text "DESCRIPTION",
               '' check_no,
               m.short_name bank_ID,
               '' invoice_series,
               '' invoice_no
          from ifsapp.MIXED_PAYMENT_LUMP_SUM_TAB l
         inner join ifsapp.MIXED_PAYMENT_TAB m
            on m.mixed_payment_id = l.mixed_payment_id
         where l.party_type = 'CUSTOMER'
           and ifsapp.cust_ord_customer_api.get_cust_grp(l.identity) = '003'
           and m.rowstate != 'Cancelled') C;