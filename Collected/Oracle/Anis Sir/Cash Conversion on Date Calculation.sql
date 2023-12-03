--Find Cash Conversion Date of an HP Account
SELECT d.account_no,
       d.line_no,
       d.account_rev,
       d.line_no,
       t.product_code,
       d.sales_date,
       trunc(d.sales_date) + t.to_days cash_conv_date,
       t.eff_from,
       t.eff_to,
       --d.sales_date + t.to_days cash_conv_date, --date time
       hpnret_level_h_util_api.get_higher_level(hpnret_level_h_util_api.get_channel_site(d.contract)) level_id
  FROM Hpnret_Cash_Con_dtl_Tab t, Hpnret_Hp_Dtl_Tab d
 WHERE t.product_code = d.catalog_no
      --AND d.account_no = '&account_no_'
   AND t.level_id =
       hpnret_level_h_util_api.get_higher_level(hpnret_level_h_util_api.get_channel_site(d.contract)) --'&site_'
   AND d.sales_date BETWEEN t.eff_from AND t.eff_to
      /*AND d.sales_date >= t.eff_from
      and d.sales_date <= t.eff_to*/
   and t.eff_from = (select max(t1.eff_from)
                     from Hpnret_Cash_Con_dtl_Tab t1
                    where t1.product_code = t.product_code)
   and t.eff_to = (select min(t1.eff_to)
                     from Hpnret_Cash_Con_dtl_Tab t1
                    where t1.product_code = t.product_code)
 order by d.account_no
