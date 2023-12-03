select c.*--,
       /*(select trunc(hp.sales_date)
          from HPNRET_HP_HEAD hp
         where hp.account_no = c.order_no
           and hp.account_rev = c.account_rev) sales_date,
       
       (SELECT (trunc(d.sales_date) + distinct(t.to_days))
          FROM Hpnret_Cash_Con_dtl_Tab t, Hpnret_Hp_Dtl_Tab d
         WHERE t.product_code = d.catalog_no
           AND d.account_no = c.account_no
              \*and d.account_rev = c.account_rev
              and d.line_no = c.acc_line_no*\
           AND t.level_id =
               hpnret_level_h_util_api.get_higher_level(hpnret_level_h_util_api.get_channel_site(d.contract))
              --AND d.sales_date BETWEEN t.eff_from AND t.eff_to
           AND d.sales_date >= t.eff_from
           and d.sales_date <= t.eff_to
           and t.rowstate = 'Actived'
           \*and t.eff_to =
               (select min(t1.eff_to)
                  from Hpnret_Cash_Con_dtl_Tab t1
                 where t1.product_code = t.product_code)*\) cash_conv_date*/
  from COMMISSION_VALUE_DETAIL c
 WHERE c.commission_sales_type = 'HP'
   and c.collection_type = 'INST'
   and c.site like '&Site'
   and c.approved_date BETWEEN to_date('&FromDate', 'YYYY/MM/DD') AND
       to_date('&ToDate', 'YYYY/MM/DD')
   and c.state = 'Approved'
