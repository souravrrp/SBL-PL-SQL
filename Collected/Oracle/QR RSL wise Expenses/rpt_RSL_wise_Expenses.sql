select m.EXP_STATEMENT_NO,
       to_char(m.STATEMENT_DATE, 'dd-Mon-YY') DT,
       d.TRANSACTION_CODE,
       t.TRANSACTION_TYPE,
       d.CURR_AMOUNT
  from IFSAPP.SITE_EXPENSES_DETAIL   d,
       IFSAPP.SITE_EXPENSES          m,
       ifsapp.SITE_TRANSACTION_TYPES t
 where m.EXP_STATEMENT_ID = d.EXP_STATEMENT_ID
   and d.TRANSACTION_CODE = t.TRANSACTION_CODE
   and m.CONTRACT = '&Site'
   and trunc(m.STATEMENT_DATE) between
       (select p.FROM_DATE
          from IFSAPP.HPNRET_RSL_PERIOD p
         where p.STATE = 'Activated'
           and p.RSL_YEAR = '&YEAR_i'
           and p.PERIOD = '&Period')
   and (select p.to_DATE
          from IFSAPP.HPNRET_RSL_PERIOD p
         where p.STATE = 'Activated'
           and p.RSL_YEAR = '&YEAR_i'
           and p.PERIOD = '&Period')

union

select 'Total',
       to_char(max(m.STATEMENT_DATE), 'dd-Mon-YY') DT,
       ' ' TRANSACTION_CODE,
       ' ' TRANSACTION_TYPE,
       sum(d.CURR_AMOUNT)
  from IFSAPP.SITE_EXPENSES_DETAIL   d,
       IFSAPP.SITE_EXPENSES          m,
       ifsapp.SITE_TRANSACTION_TYPES t
 where m.EXP_STATEMENT_ID = d.EXP_STATEMENT_ID
   and d.TRANSACTION_CODE = t.TRANSACTION_CODE
   and m.CONTRACT = '&Site'
   and trunc(m.STATEMENT_DATE) between
       (select p.FROM_DATE
          from IFSAPP.HPNRET_RSL_PERIOD p
         where p.STATE = 'Activated'
           and p.RSL_YEAR = '&YEAR_i'
           and p.PERIOD = '&Period')
   and (select p.to_DATE
          from IFSAPP.HPNRET_RSL_PERIOD p
         where p.STATE = 'Activated'
           and p.RSL_YEAR = '&YEAR_i'
           and p.PERIOD = '&Period')
 order by EXP_STATEMENT_NO
