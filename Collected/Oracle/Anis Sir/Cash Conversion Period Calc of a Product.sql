--Cash Conversion Period of a Product for a specific sales_date
select *
  from (select *
          from HPNRET_CASH_CON_DTL_TAB c
         where to_date('&sales_date', 'yyyy/mm/dd') between c.eff_from and
               c.eff_to
           and c.product_code like '&product_code' --'SRREF-G-BCD-192'
           --and c.level_id = hpnret_level_h_util_api.get_higher_level(hpnret_level_h_util_api.get_channel_site('&site'))
           and c.budget_book like '&bb_no'
           and c.rowstate = 'Actived'
         order by c.rowversion desc)
 where rownum <= 1
