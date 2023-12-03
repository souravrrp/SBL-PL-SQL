--SBL_VW_WS_DEALER_OPEN_BAL_TRN
CREATE OR REPLACE VIEW SBL_VW_WS_DEALER_OPEN_BAL_TRN AS
select b.dealer_id,
       IFSAPP.CUSTOMER_INFO_API.Get_Name(b.dealer_id) dealer_name,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(b.dealer_id) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(b.dealer_id, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(b.dealer_id, 1) dealer_address,
       b.voucher_date,
       b.debet_amount,
       b.credit_amount
  from (select g.party_type_id dealer_id, g.voucher_date, g.debet_amount, g.credit_amount
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
        
        union all
        
        select v.party_type_id dealer_id, v.voucher_date, v.debet_amount, v.credit_amount
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
                                     'CUPOA')) b;
