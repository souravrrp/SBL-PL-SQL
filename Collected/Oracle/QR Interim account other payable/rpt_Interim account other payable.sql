SELECT      
    q.accounting_year,
    q.accounting_period,
    q.account,
    q.account_desc,
    q.voucher_date,
    q.voucher_type,
    q.voucher_no,
    q.amount,
    q.trans_code,
    q.reference_serie,
    q.reference_number,
    q.party_type_id,
    q.text,
    substr(q.transfer_id,1, instr(q.transfer_id,'$')-1) "User",
    ifsapp.invoice_ledger_item_api.Get_Rowstate('SBL',q.party_type_id,'Supplier',q.reference_serie,q.reference_number,1) "Status"
       
FROM ifsapp.gl_and_hold_vou_row_qry q
WHERE 
  q.accounting_year LIKE '&Year'
  AND q.accounting_period LIKE '&Period'
  AND q.ACCOUNT = '&Account'
  AND q.accounting_period NOT IN ('13','0')
ORDER BY q.reference_serie,q.reference_number
