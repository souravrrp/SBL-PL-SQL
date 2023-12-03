--*****Wholesale Dealer Balance for Procedure
select g.party_type_id dealer_id, --***** Wholesale Dealerwise Balance (Posted Vouchers)
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
   and g.voucher_date <=
       last_day(to_date('&YEAR' || '/' || '&PERIOD' || '/1', 'YYYY/MM/DD'))
   and IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL', g.party_type_id, 'Customer') in ('TDCORP', 'WIAPPL', 'WDAPPL')
   /*and i.identity like '&DEALER_ID'*/
 group by g.party_type_id;

--*****Dealer List
select I.*, IFSAPP.IDENTITY_INVOICE_INFO_API.Get_Group_Id('SBL', I.Identity, 'Customer')
  from IFSAPP.IDENTITY_INVOICE_INFO_TAB I
 where I.GROUP_ID IN (/*'TDCORP',*/ 'WIAPPL', 'WDAPPL')
   AND I.PARTY_TYPE = 'CUSTOMER'
 ORDER BY I.IDENTITY;
 
--*****Dealer Count
select COUNT(I.IDENTITY)
  from IFSAPP.IDENTITY_INVOICE_INFO_TAB I
 where I.GROUP_ID IN ('TDCORP'/*, 'WIAPPL', 'WDAPPL'*/)
   AND I.PARTY_TYPE = 'CUSTOMER'
 ORDER BY I.IDENTITY
