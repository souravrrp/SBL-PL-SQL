SELECT 
  --s.CONTRACT,
  extract(year from ed.LUMP_SUM_TRANS_DATE)||'-'||extract(month from ed.LUMP_SUM_TRANS_DATE) period,
  --trunc(ed.LUMP_SUM_TRANS_DATE) LUMP_SUM_TRANS_DATE,
  t.TRANSACTION_CODE,
  t.TRANSACTION_TYPE,
  sum(ed.CURR_AMOUNT) AMOUNT
FROM  
  ifsapp.site_expenses_detail_tab ed,
  ifsapp.site_transaction_types_tab t--,
  --ifsapp.site_expenses_tab s
WHERE 
  ed.company = t.company AND
  ed.transaction_code = t.transaction_code and
  --t.TRANSACTION_CODE like '&TRANSACTION_CODE' and
  --ed.EXP_STATEMENT_ID=s.EXP_STATEMENT_ID and
  --s.CONTRACT like '&CONTRACT' and 
  trunc(ed.LUMP_SUM_TRANS_DATE) BETWEEN TO_DATE('&From_Date','YYYY/MM/DD') AND TO_DATE('&To_Date','YYYY/MM/DD') and 
  ed.ROWSTATE not in ('Cancelled') AND
  T.TRANSACTION_CODE IN ('BE002', 'BI001', 'BE039')
group by t.TRANSACTION_CODE,t.TRANSACTION_TYPE, extract(year from ed.LUMP_SUM_TRANS_DATE)||'-'||extract(month from ed.LUMP_SUM_TRANS_DATE)
--order by s.CONTRACT
