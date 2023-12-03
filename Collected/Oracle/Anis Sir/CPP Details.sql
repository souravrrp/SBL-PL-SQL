--***** CPP Details
select t.identity,
       t.name,
       t.invoice_id,
       t.series_id,
       t.invoice_no,
       t.invoice_date,
       t.state,
       t.voucher_date_ref voucher_date,
       t.voucher_type_ref voucher_type,
       t.voucher_no_ref voucher_no,
       t.gross_amount cpp_amount
  from IFSAPP.INCOMING_INVOICE2 t
 where t.identity like 'CPP-%'
   and t.invoice_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   and t.state = 'PaidPosted'
 order by t.invoice_date, t.invoice_id
