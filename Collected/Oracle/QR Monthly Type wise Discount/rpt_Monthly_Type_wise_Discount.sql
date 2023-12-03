--RETAIL MONTHLY TYPE WISE DISCOUNT
SELECT D.DISCOUNT_TYPE,
       EXTRACT(YEAR FROM D.ROWVERSION) || '-' || EXTRACT(MONTH FROM D.ROWVERSION) PERIOD,
       SUM(D.DISCOUNT_AMOUNT) SUM_DISCOUNT_AMOUNT
  FROM CUST_ORDER_LINE_DISCOUNT_TAB D
 WHERE TRUNC(D.ROWVERSION) BETWEEN TO_DATE('&FROM_DATE', 'YYYY/MM/DD') AND
       TO_DATE('&TO_DATE', 'YYYY/MM/DD')
   /*AND D.ORDER_NO IN (SELECT O.ORDER_NO
                        FROM CUSTOMER_ORDER_TAB O
                       WHERE O.CONTRACT NOT IN ('JWSS',
                                                'SAOS',
                                                'SWSS',                                                                                      
                                                'WSMO',
                                                'SAPM'
                                                'SCSM',
                                                'SESM',
                                                'SHOM', 
                                                'SISM', 
                                                'SFSM'
                                                'BSCP',
                                                'BLSP'
                                                'CSCP',
                                                'DSCP',
                                                'JSCP',
                                                'RSCP',
                                                'SSCP',
                                                'MS1C',
                                                'MS2C',
                                                'BTSC'))*/
   AND D.ORDER_NO not in (select ORDER_NO
                            from HPNRET_CUSTOMER_ORDER_TAB r
                           where r.ORDER_NO = D.ORDER_NO
                             and r.CASH_CONV = 'TRUE') --NEW
 GROUP BY D.DISCOUNT_TYPE,
          EXTRACT(YEAR FROM D.ROWVERSION) || '-' ||
          EXTRACT(MONTH FROM D.ROWVERSION)
 ORDER BY D.DISCOUNT_TYPE
          
--WHOLESALE MONTHLY TYPE WISE DISCOUNT
SELECT D.DISCOUNT_TYPE,
       EXTRACT(YEAR FROM D.ROWVERSION) || '-' ||
       EXTRACT(MONTH FROM D.ROWVERSION) PERIOD,
       SUM(D.DISCOUNT_AMOUNT) SUM_DISCOUNT_AMOUNT
  FROM CUST_ORDER_LINE_DISCOUNT_TAB D
 WHERE TRUNC(D.ROWVERSION) BETWEEN TO_DATE('&FROM_DATE', 'YYYY/MM/DD') AND
       TO_DATE('&TO_DATE', 'YYYY/MM/DD')
   AND D.ORDER_NO IN
       (SELECT O.ORDER_NO
          FROM CUSTOMER_ORDER_TAB O
         WHERE O.CONTRACT IN ('JWSS', 'SAOS', 'SWSS', 'WSMO'))
 GROUP BY D.DISCOUNT_TYPE,
          EXTRACT(YEAR FROM D.ROWVERSION) || '-' ||
          EXTRACT(MONTH FROM D.ROWVERSION)
 ORDER BY D.DISCOUNT_TYPE
