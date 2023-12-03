--Inventory Transaction History
select t.voucher_no, SUM(T.value)
  from MPCCOM_ACCOUNTING t, INVENTORY_TRANSACTION_HIST2 H
 WHERE t.str_code = 'M4'
   AND T.accounting_id = H.accounting_id
   AND H.date_applied BETWEEN TO_DATE('&from_date', 'YYYY/MM/DD') AND
       TO_DATE('&to_date', 'YYYY/MM/DD')
 GROUP BY t.voucher_no;
