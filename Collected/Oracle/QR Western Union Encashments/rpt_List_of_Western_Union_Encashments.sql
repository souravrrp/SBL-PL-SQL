select c.identity user_id,
       c.name,
       c.user_group shop_code,
       to_char(c.voucher_date, 'YYYY/MM/DD') voucher_date,
       c.voucher_no,
       c.voucher_text,
       c.full_dom_amount amount,
       c.way_id payment_method,
       to_char(c.payment_date, 'YYYY/MM/DD') payment_date,
       c.state
  from CHECK_LEDGER_ITEM c
 where c.way_id like '&encash_type' --'BKASH' --WESTERN UNION
   and c.voucher_date between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
 order by c.voucher_no
