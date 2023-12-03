--Voucher Not Update Records
select *
  from MPCCOM_ACCOUNTING t, INVENTORY_TRANSACTION_HIST2 H
 WHERE T.accounting_id = H.accounting_id
   AND H.date_applied BETWEEN TO_DATE('&from_date', 'YYYY/MM/DD') AND
       TO_DATE('&to_date', 'YYYY/MM/DD')
   AND t.account_no = '&account_no' --'10110055'
   AND t.voucher_no IS NULL

--Voucher Not Update Records Summary
select t2.account_no,
       IFSAPP.ACCOUNT_API.Get_Description('SBL', t2.account_no) account_Description,
       sum(t2.curr_amount) TOTAL_curr_amount,
       t2.debit_credit
  from MPCCOM_ACCOUNTING t2
 INNER JOIN (select T.accounting_id
               from MPCCOM_ACCOUNTING t, INVENTORY_TRANSACTION_HIST2 H
              WHERE T.accounting_id = H.accounting_id
                AND H.date_applied BETWEEN
                    TO_DATE('&from_date', 'YYYY/MM/DD') AND
                    TO_DATE('&to_date', 'YYYY/MM/DD')
                AND t.account_no = '&account_no' --10110055
                AND t.voucher_no IS NULL) A
    ON T2.accounting_id = A.accounting_id
 GROUP BY t2.account_no, t2.debit_credit

--Voucher Not Update Record Details
select a.accounting_id, b.seq, b.transaction_id, b.part_no
  from (select t2.accounting_id, t2.seq, h2.transaction_id, h2.part_no
          from MPCCOM_ACCOUNTING t2, INVENTORY_TRANSACTION_HIST2 H2
         WHERE T2.accounting_id = H2.accounting_id) b
 inner join (select T.accounting_id
               from MPCCOM_ACCOUNTING t, INVENTORY_TRANSACTION_HIST2 H
              WHERE T.accounting_id = H.accounting_id
                AND H.date_applied BETWEEN
                    TO_DATE('&from_date', 'YYYY/MM/DD') AND
                    TO_DATE('&to_date', 'YYYY/MM/DD')
                AND t.account_no != '&account_no' --10110055
                AND t.voucher_no IS NULL
              group by t.accounting_id) a
    on b.accounting_id = a.accounting_id
