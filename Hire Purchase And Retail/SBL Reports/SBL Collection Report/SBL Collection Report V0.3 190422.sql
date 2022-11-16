/* Formatted on 4/13/2022 2:53:39 PM (QP5 v5.381) */
  SELECT shop_code,
         SUM (day_1)      day_1,
         SUM (day_2)      day_2,
         SUM (day_3)      day_3,
         SUM (day_4)      day_4,
         SUM (day_5)      day_5,
         SUM (day_6)      day_6,
         SUM (day_7)      day_7,
         SUM (day_8)      day_8,
         SUM (day_9)      day_9,
         SUM (day_10)     day_10,
         SUM (day_11)     day_11,
         SUM (day_12)     day_12,
         SUM (day_13)     day_13,
         SUM (day_14)     day_14,
         SUM (day_15)     day_15,
         SUM (day_16)     day_16,
         SUM (day_17)     day_17,
         SUM (day_18)     day_18,
         SUM (day_19)     day_19,
         SUM (day_20)     day_20,
         SUM (day_21)     day_21,
         SUM (day_22)     day_22,
         SUM (day_23)     day_23,
         SUM (day_24)     day_24,
         SUM (day_25)     day_25,
         SUM (day_26)     day_26,
         SUM (day_27)     day_27,
         SUM (day_28)     day_28,
         SUM (day_29)     day_29,
         SUM (day_30)     day_30,
         SUM (day_31)     day_31
    FROM (  SELECT hprht.contract    shop_code,
                   --TO_DATE (hprht.receipt_date, 'DD') receipt_date,
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '1'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_1",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '2'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_2",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '3'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_3",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '4'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_4",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '5'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_5",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '6'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_6",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '7'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_7",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '8'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_8",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '9'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_9",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '10'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_10",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '11'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_11",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '12'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_12",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '13'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_13",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '14'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_14",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '15'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_15",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '16'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_16",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '17'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_17",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '18'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_18",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '19'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_19",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '20'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_20",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '21'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_21",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '22'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_22",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '23'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_23",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '24'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_24",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '25'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_25",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '26'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_26",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '27'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_27",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '28'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_28",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '29'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_29",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '30'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_30",
                   (CASE
                        WHEN EXTRACT (DAY FROM hprht.receipt_date) = '31'
                        THEN
                            SUM (hprt.amount)
                        ELSE
                            0
                    END)             "DAY_31"
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
                                              AND   TO_DATE ('&to_date',
                                                             'YYYY/MM/DD')
                                                  + .99999
          GROUP BY hprht.contract, EXTRACT (DAY FROM hprht.receipt_date))
GROUP BY shop_code
ORDER BY shop_code