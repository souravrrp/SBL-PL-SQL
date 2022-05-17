select v.year,
       v.period,
       v.range,
       sum(act_out_bal) as past_due,
       sum(actual_ucc) as ucc,
       count(acct_no) as noacc
  from (select t.*,
               case
                 when t.arr_mon > 12 then
                  '12+'
                 else
                  case
                    when length(to_char(t.arr_mon)) = 1 then
                     '0' || to_char(t.arr_mon)
                     else 
                       to_char(t.arr_mon)
                    end 
               end range
          from hpnret_form249_arrears_tab t
         where to_number(case
                           when length(CONCAT(to_char(t.year), to_char(t.period))) = 5 then
                            to_char(t.year) || '0' || to_char(t.period)
                           when length(CONCAT(to_char(t.year), to_char(t.period))) = 6 then
                            CONCAT(to_char(t.year), to_char(t.period))
                         end) between to_number(case
                                                  when length(concat('&start_year', '&start_period')) = 5 then
                                                   '&start_year' || '0' || '&start_period'
                                                  when length(concat('&start_year', '&start_period')) = 6 then
                                                   concat('&start_year', '&start_period')
                                                end) and
               to_number(case
                           when length(concat('&end_year', '&end_period')) = 5 then
                            '&end_year' || '0' || '&end_period'
                           when length(concat('&end_year', '&end_period')) = 6 then
                            concat('&end_year', '&end_period')
                         end)
           AND t.act_out_bal > 0
           AND t.shop_code NOT IN ('JWSS',
                                   'SAOS',
                                   'SWSS',
                                   'WSMO',
                                   'SITM',
                                   'SSAM',
                                   'WITM', --Wholesale Sites
                                   'SAPM',
                                   'SCOM',
                                   'SCSM',
                                   'SESM',
                                   'SHOM',
                                   'SISM',
                                   'SFSM',
                                   'SOSM') --Corporate, Employee, & Scrap Sites
        
        ) v
 GROUP BY year, period, v.range

 order by 1, 2, 3
