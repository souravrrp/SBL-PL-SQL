/* Formatted on 4/20/2022 12:05:04 PM (QP5 v5.381) */
  SELECT shop_code,
         onday,
         receipt_date,
         SUM (amount)     receipt_amount
    FROM (SELECT hprht.contract                                 shop_code,
                 TO_CHAR (hprht.receipt_date, 'YYYY/MM/DD')     receipt_date,
                 EXTRACT (DAY FROM hprht.receipt_date)          onday,
                 hprt.amount                                    amount
            FROM ifsapp.hpnret_pay_receipt_head_tab hprht,
                 ifsapp.hpnret_pay_receipt_tab     hprt
           WHERE     hprht.receipt_no = hprt.receipt_no
                 AND (UPPER (hprht.contract) = UPPER ('DGNB'))
                 AND TO_CHAR (hprht.receipt_date, 'MON-YYYY') = 'MAR-2022'
          UNION ALL
          SELECT hcpdt.contract                               shop_code,
                 TO_CHAR (hcpdt.rowversion, 'YYYY/MM/DD')     receipt_date,
                 EXTRACT (DAY FROM hcpdt.rowversion)          onday,
                 hcpdt.dom_amount                             amount
            FROM ifsapp.hpnret_co_pay_dtl_tab hcpdt
           WHERE     1 = 1
                 AND (UPPER (hcpdt.contract) = UPPER ('DGNB'))
                 AND TO_CHAR (hcpdt.rowversion, 'MON-YYYY') = 'MAR-2022')
GROUP BY shop_code, onday, receipt_date
ORDER BY shop_code, onday