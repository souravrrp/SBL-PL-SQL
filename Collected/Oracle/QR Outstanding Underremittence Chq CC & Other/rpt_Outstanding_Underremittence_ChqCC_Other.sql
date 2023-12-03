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
  cl.voucher_date <= to_date('&as_on_date','YYYY/MM/DD') AND
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
