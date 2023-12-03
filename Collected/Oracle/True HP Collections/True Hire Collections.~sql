--***** True Hire Collections
--***** True HP Collections
select a.contract,
       b.acct_no,
       a.original_acc_no,
       a.receipt_no,
       a.amount amount,
       a.payment_date,
       a.pay_method,
       a.rowstate
  from (select c.contract, --***** Positive Collection
               c.account_no,
               c.original_acc_no,
               c.receipt_no,
               c.amount amount,
               c.payment_date,
               c.pay_method,
               c.rowstate
          from ifsapp.SBL_COLLECTION_INFO c
        
        union all
        
        SELECT r.contract, --***** Negative Collection
               r.order_no account_no,
               c.original_acc_no,
               c.receipt_no,
               (-1) * c.amount amount,
               r.date_returned,
               c.pay_method,
               c.rowstate
          FROM ifsapp.SBL_RETURN_INFO r, ifsapp.SBL_COLLECTION_INFO c
         WHERE r.order_no = c.account_no
           and r.contract = c.contract
        ) a
 inner join (select '&year' "YEAR", --h.year,
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
             'mm')) b
    on a.account_no = b.acct_no
 where a.payment_date between to_date('&from_date', 'YYYY/MM/DD') and to_date('&to_date', 'YYYY/MM/DD')

union all

--***** New True HP Collections
select a.contract,
       c.acct_no,
       a.original_acc_no,
       a.receipt_no,
       a.amount amount,
       a.payment_date,
       a.pay_method,
       a.rowstate
  from (select c.contract, --***** Positive Collection
               c.account_no,
               c.original_acc_no,
               c.receipt_no,
               c.amount amount,
               c.payment_date,
               c.pay_method,
               c.rowstate
          from ifsapp.SBL_COLLECTION_INFO c
        
        union all
        
        SELECT r.contract, --***** Negative Collection
               r.order_no account_no,
               c.original_acc_no,
               c.receipt_no,
               (-1) * c.amount amount,
               r.date_returned,
               c.pay_method,
               c.rowstate
          FROM ifsapp.SBL_RETURN_INFO r, ifsapp.SBL_COLLECTION_INFO c
         WHERE r.order_no = c.account_no
           and r.contract = c.contract
        ) a
 inner join (select h.year,
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
                    trunc(to_date('&year' || '/' || '&period' || '/1',
                                  'YYYY/MM/DD'),
                          'mm') - 1) c
    on a.account_no = c.acct_no
 where a.payment_date <= to_date('&to_date', 'YYYY/MM/DD')
