/* Formatted on 5/26/2022 3:33:36 PM (QP5 v5.381) */
  SELECT SUBSTR (account_no, 1, 4)          Shop_code,
         TO_CHAR (SYSDATE, 'DD-MON-YY')     to_dayIS,
         SUM (TO_NUMBER (to_day))           to_day,
         SUM (TO_NUMBER (dayback_1))        dayback_1,
         SUM (TO_NUMBER (dayback_2))        dayback_2,
         SUM (TO_NUMBER (dayback_3))        dayback_3,
         SUM (TO_NUMBER (dayback_4))        dayback_4,
         SUM (TO_NUMBER (dayback_5))        dayback_5,
         SUM (TO_NUMBER (dayback_6))        dayback_6
    FROM (SELECT Account_no,
                 DECODE (TO_CHAR (sales_date, 'DD-MON-YY'),
                         TO_CHAR (SYSDATE, 'DD-MON-YY'), 1,
                         0)    to_day,
                 DECODE (TO_CHAR (sales_date, 'DD-MON-YY'),
                         TO_CHAR (SYSDATE - 1, 'DD-MON-YY'), 1,
                         0)    dayback_1,
                 DECODE (TO_CHAR (sales_date, 'DD-MON-YY'),
                         TO_CHAR (SYSDATE - 2, 'DD-MON-YY'), 1,
                         0)    dayback_2,
                 DECODE (TO_CHAR (sales_date, 'DD-MON-YY'),
                         TO_CHAR (SYSDATE - 3, 'DD-MON-YY'), 1,
                         0)    dayback_3,
                 DECODE (TO_CHAR (sales_date, 'DD-MON-YY'),
                         TO_CHAR (SYSDATE - 4, 'DD-MON-YY'), 1,
                         0)    dayback_4,
                 DECODE (TO_CHAR (sales_date, 'DD-MON-YY'),
                         TO_CHAR (SYSDATE - 5, 'DD-MON-YY'), 1,
                         0)    dayback_5,
                 DECODE (TO_CHAR (sales_date, 'DD-MON-YY'),
                         TO_CHAR (SYSDATE - 6, 'DD-MON-YY'), 1,
                         0)    dayback_6
            FROM (SELECT Account_no, sales_Date FROM ifsapp.Hpnret_Hp_Head_Tab
                  UNION ALL
                  SELECT order_no, date_entered
                    FROM ifsapp.HPNRET_CUSTOMER_ORDER))
GROUP BY SUBSTR (account_no, 1, 4)