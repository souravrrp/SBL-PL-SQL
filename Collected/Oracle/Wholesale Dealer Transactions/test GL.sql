select *
  from GEN_LED_VOUCHER_TAB t
 where t.voucher_type = '&voucher_type'
   and t.voucher_no = '&voucher_no';

--GL Vouchers Dealerwise
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
 where g.party_type_id like '&dealer_id'
   and g.voucher_date <= to_date('&As_On_Date', 'YYYY/MM/DD')
   and g.account = '&account_no'
 order by g.voucher_date, g.voucher_no, g.row_no;

--GL Vouchers Details
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

--Non Posted Vouchers Dealerwise
select v.voucher_type,
       v.voucher_no,
       v.row_no,
       v.voucher_date,
       v.debet_amount,
       v.credit_amount,
       v.quantity,
       v.account,
       IFSAPP.ACCOUNT_API.Get_Description('SBL', v.ACCOUNT) ACCOUNT_Description,
       v.text,
       v.party_type_id,
       v.reference_serie,
       v.trans_code,
       v.code_b,
       v.code_c
  from ifsapp.VOUCHER_ROW_TAB v
 where v.party_type_id like '&dealer_id'
   and v.voucher_date <= to_date('&As_On_Date', 'YYYY/MM/DD')
   and v.account = '&account_no'
 order by v.voucher_date, v.voucher_no, v.row_no;

--Non Posted Vouchers Details
select v.voucher_type,
       v.voucher_no,
       v.row_no,
       v.voucher_date,
       v.debet_amount,
       v.credit_amount,
       v.quantity,
       v.account,
       IFSAPP.ACCOUNT_API.Get_Description('SBL', v.ACCOUNT) ACCOUNT_Description,
       v.text,
       v.party_type_id,
       v.reference_serie,
       v.trans_code,
       v.code_b,
       v.code_c
  from ifsapp.VOUCHER_ROW_TAB v
 where v.voucher_type = '&voucher_type'
   and v.voucher_no = '&voucher_no'
 order by v.voucher_date, v.voucher_no, v.row_no;

--Voucher type wise dealer vouchers
select t.party_type_id, t.voucher_type, t.voucher_no
  from ifsapp.GEN_LED_VOUCHER_ROW_TAB t
 where t.party_type_id like 'W000%'
 group by t.party_type_id, t.voucher_type, t.voucher_no
having t.voucher_type in('CB', 'J', 'K', 'U')
 order by 2, 3, 1;
