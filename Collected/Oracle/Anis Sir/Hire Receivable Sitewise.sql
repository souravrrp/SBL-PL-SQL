--***** Hire Receivable Sitewise
select a.account,
       a.code_b "SITE",
       sum(a.debet_amount) debet_amount,
       sum(a.credit_amount) credit_amount,
       (sum(a.debet_amount) - sum(a.credit_amount)) balance
  from (select g.account,
               g.code_b,
               nvl(g.debet_amount, 0) debet_amount,
               nvl(g.credit_amount, 0) credit_amount
          from ifsapp.GEN_LED_VOUCHER_ROW_TAB g
         where g.account = '10060010'
           and g.voucher_date <= to_date('&AS_ON_DATE', 'YYYY/MM/DD')
        
        union all
        
        select v.account,
               v.code_b,
               nvl(v.debet_amount, 0) debet_amount,
               nvl(v.credit_amount, 0) credit_amount
          from ifsapp.VOUCHER_ROW v
         where v.account = '10060010'
           and v.voucher_date <= to_date('&AS_ON_DATE', 'YYYY/MM/DD')) a
 group by a.account, a.code_b
