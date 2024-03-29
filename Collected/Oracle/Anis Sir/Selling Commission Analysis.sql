--Transaction codewise selling commission
SELECT t.TRANSACTION_CODE,
       t.TRANSACTION_TYPE,
       /*s.CONTRACT,*/
       sum(ed.CURR_AMOUNT) AMOUNT
  FROM ifsapp.site_expenses_detail_tab   ed,
       ifsapp.site_transaction_types_tab t,
       ifsapp.site_expenses_tab          s
 WHERE ed.company = t.company
   AND ed.transaction_code = t.transaction_code
   and t.TRANSACTION_CODE in ('BE006', 'BE007', 'BE008', 'BE009', 'BI001')
   and ed.EXP_STATEMENT_ID = s.EXP_STATEMENT_ID
   --and s.CONTRACT like '&CONTRACT'
   and trunc(ed.LUMP_SUM_TRANS_DATE) BETWEEN
       TO_DATE('&FROM_DATE', 'YYYY/MM/DD') AND
       TO_DATE('&TO_DATE', 'YYYY/MM/DD')
   and ed.ROWSTATE not in ('Cancelled')
 group by t.TRANSACTION_CODE, t.TRANSACTION_TYPE/*, s.CONTRACT*/
 order by t.transaction_code
 

--*****Sales Typewise Selling Commission

--*****Sales Typewise Selling Commission Positive
select t.commission_sales_type,
       t.collection_type,
       SUM(t.comm_calc_amount) TOTAL_COMM_AMOUNT,
       --t.site,
       T.state
  from COMMISSION_VALUE_DETAIL t
 WHERE t.collection_type IS NULL
   AND trunc(t.calculated_date) BETWEEN to_date('&FromDate', 'YYYY/MM/DD') AND
       to_date('&ToDate', 'YYYY/MM/DD')
   and t.comm_calc_amount > 0
   and t.state = 'Approved' --Initial
   --and t.site = '&shop_code'
   GROUP BY t.commission_sales_type, t.collection_type, T.state/*, t.site*/

union all

--*****Sales Typewise Selling Commission Negative
select t.commission_sales_type,
       t.collection_type,
       SUM(t.comm_calc_amount) TOTAL_COMM_AMOUNT,
       --t.site,
       T.state
  from COMMISSION_VALUE_DETAIL t
 WHERE t.collection_type IS NULL
   AND trunc(t.calculated_date) BETWEEN to_date('&FromDate', 'YYYY/MM/DD') AND
       to_date('&ToDate', 'YYYY/MM/DD')
   and t.comm_calc_amount < 0
   and t.state = 'Approved' --Initial
   --and t.site = '&shop_code'
   GROUP BY t.commission_sales_type, t.collection_type, T.state/*, t.site*/
