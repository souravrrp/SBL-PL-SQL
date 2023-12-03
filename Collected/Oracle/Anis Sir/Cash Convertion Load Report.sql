--*****Cash Convertion Load Report
select h.acct_no,
       h.original_acct_no,
       /*h.product_code,*/
       h.actual_sales_date,
       h.sales_date,
       h.cash_conversion_on_date,
       /*h.state,*/
       /*h.normal_cash_price,*/
       h.hire_cash_price,
       /*h.hire_price,*/
       h.down_payment,
       (select sum(c.amount) amount
          from ifsapp.SBL_COLLECTION_INFO c
         where c.original_acc_no = h.original_acct_no
           and c.payment_date <= h.cash_conversion_on_date) coll_till_cc,
       (h.hire_cash_price - h.down_payment -
       (select sum(c.amount) amount
           from ifsapp.SBL_COLLECTION_INFO c
          where c.original_acc_no = h.original_acct_no
            and c.payment_date <= h.cash_conversion_on_date)) out_bal,
       /*h.act_out_bal,*/
       (h.cash_conversion_on_date + 25) max_4pc_cc_date,
       case
         when h.cash_conversion_on_date < sysdate then
          ((h.hire_cash_price - h.down_payment -
          (select sum(c.amount) amount
               from ifsapp.SBL_COLLECTION_INFO c
              where c.original_acc_no = h.original_acct_no
                and c.payment_date <= h.cash_conversion_on_date)) * 0.04)
         else
          0
       end load_4pc,
       (h.cash_conversion_on_date + 55) max_8pc_cc_date,
       case
         when h.cash_conversion_on_date < sysdate then
          ((h.hire_cash_price - h.down_payment -
          (select sum(c.amount) amount
               from ifsapp.SBL_COLLECTION_INFO c
              where c.original_acc_no = h.original_acct_no
                and c.payment_date <= h.cash_conversion_on_date)) * 0.08)
         else
          0
       end load_8pc
  from ifsapp.HPNRET_FORM249_ARREARS_TAB h
 where h.year = extract(year from(trunc(sysdate, 'mm') - 1))
   and h.period = extract(month from(trunc(sysdate, 'mm') - 1))
      /*and h.act_out_bal > 0*/
      /*and h.acct_no != h.original_acct_no*/
      /*and h.discount != 0*/
   and h.acct_no /*= '&ACCT_NO'*/
       in ('ABD-H10029', 'DKB-H5847')
 order by 1;

--*****
select *
  from ifsapp.HPNRET_FORM249_ARREARS_TAB t
 WHERE T.ORIGINAL_ACCT_NO = 'DKB-H5375';
