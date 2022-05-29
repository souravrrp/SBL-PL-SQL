/* Formatted on 5/29/2022 11:32:19 AM (QP5 v5.381) */
SELECT CATALOG_NO Model, sales_price, VALID_FROM_DATE
  FROM SALES_PRICE_LIST_PART t
 WHERE     CATALOG_NO || (TO_CHAR (VALID_FROM_DATE, 'DD-MON-YY')) IN
               (  SELECT    CATALOG_NO
                         || TO_CHAR (
                                MAX (
                                    TO_DATE (
                                        TO_CHAR (VALID_FROM_DATE, 'DD-MON-YY'))))
                    FROM ifsapp.SALES_PRICE_LIST_PART
                GROUP BY CATALOG_NO)
       AND t.BASE_PRICE_SITE = 'SCOM'