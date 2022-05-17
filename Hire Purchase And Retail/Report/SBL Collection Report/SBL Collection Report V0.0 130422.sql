/* Formatted on 4/13/2022 2:13:20 PM (QP5 v5.381) */
  SELECT shop_code, onday, reciept_amount
    FROM (  SELECT hprht.contract                            shop_code,
                   --TO_DATE (hprht.receipt_date, 'DD') receipt_date,
                   EXTRACT (DAY FROM hprht.receipt_date)     onday,
                   SUM (hprt.amount)                         reciept_amount
              FROM ifsapp.hpnret_pay_receipt_head_tab hprht,
                   ifsapp.hpnret_pay_receipt_tab   hprt
             WHERE     1 = 1
                   AND hprht.receipt_no = hprt.receipt_no(+)
                   --AND hprht.rowstate IN ('Approved', 'Printed')
                   --AND hprht.contract != 'SOPM'
                   AND (   :p_shop_code IS NULL
                        OR (UPPER (hprht.contract) = UPPER ( :p_shop_code)))
                   AND hprht.receipt_date BETWEEN TO_DATE ('&from_date',
                                                           'yyyy/mm/dd')
                                              AND TO_DATE ('&to_date',
                                                           'YYYY/MM/DD')
                   AND (   :p_receipt_no IS NULL
                        OR (UPPER (hprht.receipt_no) = UPPER ( :p_receipt_no)))
          GROUP BY hprht.contract, EXTRACT (DAY FROM hprht.receipt_date))
         PIVOT (SUM (reciept_amount)
               FOR onday
               IN ('1',
                  '2',
                  '3',
                  '4',
                  '5',
                  '6',
                  '7',
                  '8',
                  '9',
                  '10',
                  '11',
                  '12',
                  '13',
                  '14',
                  '15',
                  '16',
                  '17',
                  '18',
                  '19',
                  '20',
                  '21',
                  '22',
                  '23',
                  '24',
                  '25',
                  '26',
                  '27',
                  '28',
                  '29',
                  '30'))
ORDER BY shop_code;