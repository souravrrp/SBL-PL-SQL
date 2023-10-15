/* Formatted on 6/6/2023 11:05:28 AM (QP5 v5.381) */
SELECT hfat.year,
       hfat.period,
       hfat.acct_no,
       hfat.product_code,
       hfat.customer,
       ifsapp.customer_info_api.get_name (hfat.customer)
           customer_name,
       TO_CHAR (hfat.sales_date, 'MM/DD/YYYY')
           sales_date,
       hfat.amount_financed,
       hfat.monthly_pay,
       hfat.loc,
       hfat.total_ucc,
       hfat.act_out_bal,
       hfat.arr_mon
           arrear_month,
       TO_CHAR (hfat.cash_conversion_on_date, 'MM/DD/YYYY')
           cash_conversion_on_date,
       hfat.effective_rate,
       hfat.present_value,
       hfat.effective_ecc,
       hfat.actual_ucc
  FROM ifsapp.hpnret_form249_arrears_tab hfat
 WHERE 1 = 1 AND hfat.act_out_bal > 0 AND EFFECTIVE_ECC IS NOT NULL