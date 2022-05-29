/* Formatted on 5/29/2022 3:30:01 PM (QP5 v5.381) */
  SELECT t.PRICE_LIST_NO,
         t.CATALOG_NO,
         s.FEE_CODE,
         s.FEE_RATE,
         t.SALES_PRICE                                          NSP,
         t.SALES_PRICE + t.SALES_PRICE * (s.FEE_RATE / 100)     RSP
    FROM IFSAPP.SALES_PRICE_LIST_PART t, IFSAPP.STATUTORY_FEE_DEDUCT_MULTIPLE s
   WHERE     t.PRICE_LIST_NO = '1'
         AND t.LAST_UPDATED IN
                 (SELECT MAX (m.LAST_UPDATED)
                    FROM IFSAPP.SALES_PRICE_LIST_PART m
                   WHERE m.PRICE_LIST_NO = '1' AND t.CATALOG_NO = m.CATALOG_NO)
         AND t.CASH_TAX_CODE = s.FEE_CODE
ORDER BY t.CATALOG_NO