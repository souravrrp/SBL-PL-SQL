--Wholesale Dealer Balance Transactions
select g.voucher_type,
       g.voucher_no,
       g.row_no,
       g.voucher_date,
       g.debet_amount,
       g.credit_amount,
       g.quantity,
       g.account,
       IFSAPP.ACCOUNT_API.Get_Description('SBL', g.ACCOUNT) ACCOUNT_Description,
       g.text,
       g.party_type_id,
       g.reference_serie,
       g.trans_code,
       g.code_b,
       g.code_c
  from ifsapp.GEN_LED_VOUCHER_ROW_TAB g
 where g.account in ('10070020',
                     '10070020',
                     '10070030',
                     '10070040',
                     '20020012',
                     '20020024')
   and g.voucher_type in ('N', 'F', 'B', 'I', 'U')
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
   and g.party_type_id like /*'W000%' 'W0001434-2' 'W0001671-2'*/ 'W0000621-1'
 order by g.voucher_date, g.voucher_no, g.row_no;


--Wholesale Dealerwise Balance
select g.party_type_id dealer_id,
       IFSAPP.CUSTOMER_INFO_API.Get_Name(g.party_type_id) dealer_name,
       nvl(sum(g.debet_amount), 0) debit_amount,
       nvl(sum(g.credit_amount), 0) credit_amount,
       (nvl(sum(g.debet_amount), 0) - nvl(sum(g.credit_amount), 0)) open_balance
  from ifsapp.GEN_LED_VOUCHER_ROW_TAB g
 where g.account in ('10070020',
                     '10070020',
                     '10070030',
                     '10070040',
                     '20020012',
                     '20020024')
   and g.voucher_type in ('N', 'F', 'B', 'I', 'U')
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
   and g.party_type_id like 'W000%' /*'W0001434-2' 'W0001671-2' 'W0000621-1'*/
 group by g.party_type_id
 order by g.party_type_id;


--Voucher Details
select g.voucher_type,
       g.voucher_no,
       g.row_no,
       g.voucher_date,
       g.debet_amount,
       g.credit_amount,
       g.quantity,
       g.account,
       IFSAPP.ACCOUNT_API.Get_Description('SBL', g.ACCOUNT) ACCOUNT_Description,
       g.text,
       g.party_type_id,
       g.reference_serie,
       g.trans_code,
       g.code_b,
       g.code_c
  from ifsapp.GEN_LED_VOUCHER_ROW_TAB g
 where g.voucher_type = '&voucher_type'
   and g.voucher_no = '&voucher_no'
 order by g.voucher_date, g.voucher_no, g.row_no;
