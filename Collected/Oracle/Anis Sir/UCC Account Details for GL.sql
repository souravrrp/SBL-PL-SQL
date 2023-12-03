SELECT h.account,
       h.account_desc,
       h.accounting_year,
       h.accounting_period,
       h.voucher_type,
       h.voucher_no,
       h.voucher_date,
       h.code_b,
       h.code_b_desc,
       h.trans_code,
       h.amount,
       h.party_type_id,
       h.reference_serie,
       h.reference_number
     
FROM ifsapp.gl_and_hold_vou_row_qry h
WHERE h.company = 'SBL'
AND h.ACCOUNT = '10030010'
AND h.accounting_year = '&Year'
AND h.accounting_period = '&Period'
