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
  bk.voucher_date <= to_date('&as_on_date','YYYY/MM/DD') AND  
  bk.under_remitted = 'TRUE' AND
  nv.open_amount > 0 AND  
  nv.series_id = 'UR' AND
  bk.company = 'SBL'
order by bk.voucher_date, bh.contract, nv.payer_identity 
