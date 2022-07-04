select t.creators_reference as ACC_NO,
       t.client_state       as STATUS,
       trunc(t.delivery_date)      as DATE_
  from ifsapp.CUSTOMER_ORDER_INV_HEAD t
 where trunc(t.delivery_date) between to_date('&start', 'yyyy/mm/dd') and
       to_date('&end', 'yyyy/mm/dd')
       and t.creators_reference like '%-H%'
       and t.client_state in ('Printed', 'Preliminary', 'PostedAuth')
 order by t.delivery_date, t.creators_reference