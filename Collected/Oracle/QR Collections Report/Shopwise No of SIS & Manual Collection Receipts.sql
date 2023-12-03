--Shopwise No of SIS & Manual Collection Receipts
select s.contract,
       s.no_of_sis_receipts,
       s.sis_receipt_amount,
       m.no_of_manual_receipts,
       m.manual_receipt_amount
  from (select p.contract, --No of SIS Receipts
               count(p.receipt_no) no_of_sis_receipts,
               sum(p.amount) sis_receipt_amount
          from IFSAPP.HPNRET_PAY_RECEIPT_TAB p
         INNER JOIN IFSAPP.HPNRET_PAY_RECEIPT_HEAD_TAB ph
            ON P.RECEIPT_NO = PH.RECEIPT_NO
           AND P.COMPANY = PH.COMPANY
         where p.rowstate = 'Approved'
           and substr(p.receipt_no, 4, 3) = '-HC'
           and ph.sheet_serial_no is null
           and p.voucher_date between to_date('&from_date', 'YYYY/MM/DD') and
               to_date('&to_date', 'YYYY/MM/DD')
         group by p.contract) s
 inner join (select p.contract, --No of Manual Receipts
                    count(p.receipt_no) no_of_manual_receipts,
                    sum(p.amount) manual_receipt_amount
               from IFSAPP.HPNRET_PAY_RECEIPT_TAB p
              INNER JOIN IFSAPP.HPNRET_PAY_RECEIPT_HEAD_TAB ph
                 ON P.RECEIPT_NO = PH.RECEIPT_NO
                AND P.COMPANY = PH.COMPANY
              where p.rowstate = 'Approved'
                and substr(p.receipt_no, 4, 3) = '-HC'
                and ph.sheet_serial_no is not null
                and p.voucher_date between
                    to_date('&from_date', 'YYYY/MM/DD') and
                    to_date('&to_date', 'YYYY/MM/DD')
              group by p.contract) m
    on s.contract = m.contract
 order by 1
