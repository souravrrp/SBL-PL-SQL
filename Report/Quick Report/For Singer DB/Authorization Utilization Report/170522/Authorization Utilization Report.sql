/* Formatted on 5/17/2022 9:19:28 AM (QP5 v5.381) */
  SELECT t.account_no                                     "Account No",
         t.variation_db                                   "Variation ID",
         ifsapp.Variation_API.DECODE (t.variation_db)     "Variation Name",
         TO_CHAR (t.from_date, 'YYYY/MM/DD')              "Permission Date",
         TO_CHAR (t.TO_DATE, 'YYYY/MM/DD')                "Last Date",
         t.utilized                                       "Service Utilized",
         t.discount                                       "Discount",
         t.discount_percentage                            "Discount Percent",
         t.service_charge                                 "Service Charge"
    FROM IFSAPP.HPNRET_AUTH_VARIATION t
   WHERE     t.utilized = 1
         AND t.variation_db = '&variation'
         AND t.from_date BETWEEN TO_DATE ('&fromdate', 'YYYY/MM/DD')
                             AND TO_DATE ('&todate', 'YYYY/MM/DD')
ORDER BY t.from_date, t.account_no