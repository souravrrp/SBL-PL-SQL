/* Formatted on 4/20/2022 11:29:05 AM (QP5 v5.381) */
  SELECT shop_code,
         onday,
         receipt_date,
         SUM (amount)     receipt_amount
    FROM (SELECT hcpdt.contract                                 shop_code,
                 TO_CHAR (hcpdt.voucher_date, 'YYYY/MM/DD')     receipt_date,
                 EXTRACT (DAY FROM hcpdt.voucher_date)          onday,
                 hcpdt.curr_amount                              amount
            FROM ifsapp.hpnret_co_pay_dtl_tab hcpdt
           WHERE     1 = 1
                 AND UPPER (hcpdt.contract) =
                     NVL (UPPER ('&SHOP_CODE'), UPPER (hcpdt.contract))
                 AND hcpdt.voucher_date BETWEEN TO_DATE ('&FROM_DATE',
                                                         'YYYY/MM/DD')
                                            AND   TO_DATE ('&TO_DATE',
                                                           'YYYY/MM/DD')
                                                + 0.99999)
GROUP BY shop_code, onday, receipt_date
ORDER BY shop_code, onday