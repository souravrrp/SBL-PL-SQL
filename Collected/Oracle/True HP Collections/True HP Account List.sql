--True HP
select '&year' "YEAR", --h.year,
       '&period' "PERIOD", --h.period,
       h.acct_no,
       trunc(h.cash_conversion_on_date) cash_conversion_on_date
  from HPNRET_FORM249_ARREARS_TAB h
 where h.year =
       extract(year from trunc(trunc(to_date('&year' || '/' || '&period' || '/1',
                                   'YYYY/MM/DD'),
                           'mm') - 1,
                     'mm'))
   and h.period =
       extract(month from trunc(trunc(to_date('&year' || '/' || '&period' || '/1',
                                   'YYYY/MM/DD'),
                           'mm') - 1,
                     'mm'))
   and trunc(h.cash_conversion_on_date) <
       trunc(trunc(to_date('&year' || '/' || '&period' || '/1',
                           'YYYY/MM/DD'),
                   'mm') - 1,
             'mm')
order by h.acct_no;

--New True HP
select h.year,
       h.period,
       h.acct_no,
       trunc(h.cash_conversion_on_date) cash_conversion_on_date
  from HPNRET_FORM249_ARREARS_TAB h
 where h.year = '&year'
   and h.period = '&period'
   and trunc(h.cash_conversion_on_date) between
       trunc(trunc(to_date('&year' || '/' || '&period' || '/1',
                           'YYYY/MM/DD'),
                   'mm') - 1,
             'mm') and
       trunc(to_date('&year' || '/' || '&period' || '/1', 'YYYY/MM/DD'),
             'mm') - 1
order by h.acct_no;
