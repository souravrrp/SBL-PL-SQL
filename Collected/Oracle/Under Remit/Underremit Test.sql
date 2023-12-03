--Outstanding Underremittence - Bank Slips – Site
SELECT 
       concat(substr(bk.rsl_reference,1,3),'01') "Branch",
       ifsapp.site_api.Get_Description(concat(substr(bk.rsl_reference,1,3),'01')) "Branch_Name",
       nv.identity "Salesman",
       upper(bk.document_type) "Document_Type",
       nv.series_id "Invoice_Series",
       nv.invoice_no "Invoice_No",
       bk.bank_statement_no "Slip_No",
       bk.amount_banked "Slip_Amount",
       nv.open_amount "Outstading_Balance",
       bk.statement_date "Slip_Date",
       nv.identity "Salesman",
       nv.NAME "Salesman_Name",
       bk.bank_id "Bank_No",
       bk.branch_id "Branch_No",
       'Underremitted' "Status",
       substr(nv.notes,instr(nv.notes,'DOC DATE')+10,12) "Doc_Date",
       substr(nv.notes,instr(nv.notes,'RSL PERIOD')+16,25) "RSL_Period",
       substr(nv.notes,instr(nv.notes,'RSL REFERENCE')+16,14) "RSL Reference",
       substr(nv.notes,instr(nv.notes,'REMARKS')+9,70) "Remarks"
FROM   ifsapp.bcb_statement_bank_detail bk,
       ifsapp.bcb_statement bs,
       ifsapp.invoice_ledger_item_cu_qry nv
WHERE  concat(substr(bk.rsl_reference,1,3),'01')  = '&Site'
AND    bs.voucher_date_ref = nv.voucher_date_ref
AND    bs.bcb_statement_id = bk.bcb_statement_id
AND    bs.company = bk.company
AND    bs.contract = '&Site'
AND    nv.voucher_date_ref > to_date('2009/07/31','YYYY/MM/DD')
AND    bk.under_remitted = 'TRUE'
AND    nv.open_amount > 0
AND    bk.invoice_id = nv.invoice_id
AND    nv.series_id = 'UR'
AND    bk.company = 'SSL'
AND    bk.company = nv.company 
AND    nv.pay_term_id = 'UR'
AND    nv.party_type = 'Customer'
ORDER BY concat(substr(bk.rsl_reference,1,3),'01') ,nv.identity,bk.statement_date


--Outstanding Underremittence - Expenses – Site
SELECT 
  bh.contract "Branch",
  ifsapp.site_api.Get_Description(bh.contract) "Branch_Name",
  nv.identity "Salesman",
  upper(bk.transaction_code) "Expense_Type",
  ifsapp.site_transaction_types_api.Get_Transaction_Type('SBL',bk.transaction_code) "Expense_Name", 
  nv.series_id "Invoice_Series",
  nv.invoice_no "Invoice_No",
  bk.bcb_lump_sum_trans_no "Payments_Line_No",
  bk.curr_amount "Expense_Amount",
  nv.open_amount "Outstading_Balance",
  bk.voucher_date "Expense_Date",
  nv.identity "Salesman",
  nv.NAME "Salesman_Name",
  'Underremitted' "Status",
  bh.bcb_statement_no "BCB_No",
  substr(nv.notes,instr(nv.notes,'EXPENCE DATE')+14,12) "Doc_Date",
  substr(nv.notes,instr(nv.notes,'RSL PERIOD')+16,25) "RSL_Period",
  substr(nv.notes,instr(nv.notes,'RSL REFERENCE')+16,14) "RSL Reference",
  substr(nv.notes,instr(nv.notes,'REMARKS')+9,70) "Remarks"
FROM   
  ifsapp.bcb_statement_details bk,
  ifsapp.invoice_ledger_item_cu_qry nv,
  ifsapp.bcb_statement bh
WHERE  
  bk.company = nv.company AND
  bk.invoice_id = nv.invoice_id AND
  bh.bcb_statement_id = bk.bcb_statement_id AND
  bk.company = bh.company AND
  bh.contract like '&Site' AND
  bk.voucher_date <= to_date('&date_i','YYYY/MM/DD') AND  
  bk.under_remitted = 'TRUE' AND
  nv.open_amount > 0 AND  
  nv.series_id = 'UR' AND
  bk.company = 'SBL'
order by bk.voucher_date, bh.contract, nv.payer_identity 
  


--Outstanding Underremittence Chq/CC & Other – Site
SELECT 
  cl.user_group "Branch",
  ifsapp.site_api.Get_Description(cl.user_group) "Branch_Name",
  nv.payer_identity "Salesman",
  cl.way_id "Doc_Typ",
  cl.diff_inv_series_id "Inv_Series",
  cl.diff_inv_no "Invoice_No",
  cl.ledger_item_id "Doc_No",
  cl.full_curr_amount "Inv_Amount",
  nv.open_amount "Outsta_Bal",
  cl.voucher_date "Vouc_Date",
  cl.identity "Cust_ID",
  cl.NAME "Cust_Name",
  cl.bank_no "Bank_No",
  cl.state "Status",
  substr(nv.notes,instr(nv.notes,'CHECK DATE')+12,12) "Check_Date",
  substr(nv.notes,instr(nv.notes,'RSL PERIOD')+16,24) "RSL_Period",
  substr(nv.notes,instr(nv.notes,'RSL REFERENCE')+16,14) "RSL Ref",
  substr(nv.notes,instr(nv.notes,'REMARKS')+9,70) "Remarks"
FROM   
  ifsapp.check_ledger_item cl,
  ifsapp.invoice_ledger_item_cu_qry nv,
  ifsapp.payment_way w
WHERE  
  cl.user_group like '&Site' AND
  cl.voucher_date <= to_date('&date_i','YYYY/MM/DD') AND
  cl.state = 'UnderRemitted' AND
  nv.series_id IN ('UR','CF','CCUR') AND
  nv.open_amount > 0 AND
  cl.diff_inv_no = nv.invoice_no AND
  cl.diff_inv_series_id = nv.series_id AND
  cl.company = nv.company AND
  cl.company = 'SBL' AND
  w.way_id = cl.way_id AND
  w.company = cl.company and
  cl.diff_inv_no is not null
ORDER BY cl.voucher_date, cl.user_group, nv.payer_identity
