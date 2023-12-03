--***** Wholesale Dealer Balance Transactions (Posted Vouchers)
select g.voucher_type,
       g.voucher_no,
       g.voucher_date,
       sum(g.debet_amount) debet_amount,
       sum(g.credit_amount) credit_amount,
       g.account,
       IFSAPP.ACCOUNT_API.Get_Description('SBL', g.ACCOUNT) ACCOUNT_Description,
       g.text,
       g.party_type_id,
       g.reference_serie
  from ifsapp.GEN_LED_VOUCHER_ROW_TAB g
 where g.account in ('10070010',
                     '10070020',
                     '10070030',
                     '10070040',
                     '20020012',
                     '20020024')
   and g.voucher_type in ('N', 'F', 'B', 'I', 'U', 'G', 'K', 'CB')
   and g.reference_serie in ('SDDLRS',
                             'CD',
                             'CR',
                             'WSADV',
                             'SI',
                             'CF',
                             'CI',
                             'EX',
                             'TRADV',
                             'WSADVRF',
                             'CUPOA')
   and g.voucher_date <= to_date('&As_On_Date', 'YYYY/MM/DD')
   and g.party_type_id like '&dealer_id' /*'W000%' 'W0001434-2' 'W0001671-2'*/ /*'W0000621-1'*/
 group by g.voucher_type,
          g.voucher_no,
          g.voucher_date,
          g.account,
          g.text,
          g.party_type_id,
          g.reference_serie

union

--***** Wholesale Dealer Balance Transactions (Non Posted Vouchers)
select v.voucher_type,
       v.voucher_no,
       v.voucher_date,
       sum(v.debet_amount) debet_amount,
       sum(v.credit_amount) credit_amount,
       v.account,
       IFSAPP.ACCOUNT_API.Get_Description('SBL', v.ACCOUNT) ACCOUNT_Description,
       v.text,
       v.party_type_id,
       v.reference_serie
  from ifsapp.VOUCHER_ROW_TAB v
 where v.account in ('10070010',
                     '10070020',
                     '10070030',
                     '10070040',
                     '20020012',
                     '20020024')
   and v.voucher_type in ('N', 'F', 'B', 'I', 'U', 'G', 'K', 'CB')
   and v.reference_serie in ('SDDLRS',
                             'CD',
                             'CR',
                             'WSADV',
                             'SI',
                             'CF',
                             'CI',
                             'EX',
                             'TRADV',
                             'WSADVRF',
                             'CUPOA')
   and v.voucher_date <= to_date('&As_On_Date', 'YYYY/MM/DD')
   and v.party_type_id like '&dealer_id' /*'W000%' 'W0001434-2' 'W0001671-2'*/ /*'W0000621-1'*/
 group by v.voucher_type,
          v.voucher_no,
          v.voucher_date,
          v.account,
          v.text,
          v.party_type_id,
          v.reference_serie
 order by 3, 2;
