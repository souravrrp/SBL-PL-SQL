--Negative Commission Segregation
SELECT 
    commission_receiver,
    entitlement_type,
    SUM(comm_calc_amount) gross, 
    SUM(approved_amount) approved
FROM ifsapp.commission_value_detail_tab
WHERE 
  UPPER(rowstate) = UPPER('Approved') AND 
  commission_type = 'COMMISSION' AND 
  deduction_type IS NULL AND 
  claim_id IS NULL AND 
  TRUNC(calculated_date) BETWEEN to_date('&FromDate','YYYY/MM/DD') AND to_date('&ToDate','YYYY/MM/DD')
GROUP BY commission_receiver,entitlement_type

--Negative Commission - RSL
SELECT 
    t.User_Id,
    SUM(t.dom_amount) amount
FROM site_expenses_detail_tab t 
WHERE 
  trunc(t.voucher_date) BETWEEN to_date('&FromDate','yyyy/mm/dd') AND to_date('&ToDate','yyyy/mm/dd') AND 
  t.transaction_code = 'BI001'
GROUP BY t.User_Id
