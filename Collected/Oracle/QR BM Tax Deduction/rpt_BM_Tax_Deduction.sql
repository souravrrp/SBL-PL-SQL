--***** BM Tax Deduction
select l.site,
       l.commission_receiver,
       to_char(l.calculated_date, 'YYYY/MM/DD') calculated_date,
       l.entitlement_type,
       l.gross_amount,
       l.approved_amount,
       l.deduction_amount,
       l.state
  from IFSAPP.COMM_BONS_INCEN_CLAIM L
 where l.calculated_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
   and l.site like upper('%&SHOP_CODE%')
 order by l.site, l.claim_id;
