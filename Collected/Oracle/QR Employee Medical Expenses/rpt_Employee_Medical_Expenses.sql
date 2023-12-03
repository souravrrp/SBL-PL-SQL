select g.company,
       g.party_type_id emp_id,
       g.text emp_name,
       g.voucher_type,
       g.voucher_no,
       g.accounting_year,
       g.accounting_period,
       g.voucher_date,
       g.account,
       g.account_desc,
       g.code_b,
       g.code_b_desc,
       g.trans_code,
       g.currency_code,
       g.correction,
       g.reference_serie invoice_series,
       g.reference_number,
       g.amount
from   IFSAPP.GL_AND_HOLD_VOU_ROW_QRY g
where  g.account in ('20030045', '80030090', '80030100', '80030110')
and    g.reference_serie = 'EMEDSI'
and    g.voucher_date between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD')
and    g.party_type_id like '&emp_id'
