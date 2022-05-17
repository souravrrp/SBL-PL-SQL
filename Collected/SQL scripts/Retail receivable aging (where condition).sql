SELECT *
  FROM hpnret_form249_arrears_tab t
 WHERE to_number(case
         when length(CONCAT(to_char(t.year), to_char(t.period))) = 5 then
          to_char(t.year) || '0' || to_char(t.period)
         when length(CONCAT(to_char(t.year), to_char(t.period))) = 6 then
          CONCAT(to_char(t.year), to_char(t.period)) 
       end) between to_number(case
         when length(concat('&start_year', '&start_period')) = 5 then
          '&start_year' || '0' || '&start_period'
         when length(concat('&start_year', '&start_period')) = 6 then
          concat('&start_year', '&start_period')
       end) and to_number(case
         when length(concat('&end_year', '&end_period')) = 5 then
          '&end_year' || '0' || '&end_period'
         when length(concat('&end_year', '&end_period')) = 6 then
          concat('&end_year', '&end_period')
       end)
