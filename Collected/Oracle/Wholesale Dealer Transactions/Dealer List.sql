--*****
select b.dealer_id
  from IFSAPP.SBL_DEALER_BALANCE b
 where b.year = '&year'
   and b.period = '&period'
   and b.close_balance > 0

MINUS

select i.identity
  from IFSAPP.INVOICE_TAB i
 where i.c7 in ('JWSS', 'SAOS', 'SWSS', 'WSMO')
   and (i.net_curr_amount + i.vat_curr_amount) != 0
   and trunc(i.invoice_date) between
       to_date('&year' || '/' || '&period' || '/1', 'YYYY/MM/DD') and
       last_day(to_date('&year' || '/' || '&period' || '/1', 'YYYY/MM/DD'))
 group by i.identity
 order by 1;

--*****
select b.dealer_id
  from IFSAPP.SBL_DEALER_BALANCE b
 where b.year = '&year'
   and b.period = '&period'
   and b.close_balance != 0
 order by 1;
