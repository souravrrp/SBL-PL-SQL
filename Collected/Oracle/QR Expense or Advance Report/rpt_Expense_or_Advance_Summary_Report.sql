SELECT s.CONTRACT,
       t.TRANSACTION_CODE,
       t.TRANSACTION_TYPE,
       sum(ed.CURR_AMOUNT) AMOUNT
  FROM ifsapp.site_expenses_detail_tab   ed,
       ifsapp.site_transaction_types_tab t,
       ifsapp.site_expenses_tab          s
 WHERE ed.company = t.company
   AND ed.transaction_code = t.transaction_code
   and t.TRANSACTION_CODE like '&TRANSACTION_CODE' --in ('BE008', 'BE009')
   and ed.EXP_STATEMENT_ID = s.EXP_STATEMENT_ID
   and s.CONTRACT like '&CONTRACT'
   and trunc(ed.LUMP_SUM_TRANS_DATE) BETWEEN
       TO_DATE('&FROM_DATE', 'YYYY/MM/DD') AND
       TO_DATE('&TO_DATE', 'YYYY/MM/DD')
   and ed.ROWSTATE not in ('Cancelled')
 group by t.TRANSACTION_CODE, t.TRANSACTION_TYPE, s.CONTRACT
 order by s.CONTRACT
