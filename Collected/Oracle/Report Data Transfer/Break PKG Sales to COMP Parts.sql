-- Break PKG Sales Data to COMP Parts
select P.INVOICE_ID,
       P.ITEM_ID,
       P.SITE,
       P.ORDER_NO,
       P.LINE_NO,
       P.REL_NO,
       L.LINE_ITEM_NO COMP_NO,
       P.STATUS,
       P.SALES_DATE,
       P.CUSTOMER_NO,
       P.DELIVERY_SITE,
       L.CATALOG_NO PRODUCT_CODE,
       L.QTY_INVOICED SALES_QUANTITY,
       IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Sale_Price_Total(P.ORDER_NO,
                                                           P.LINE_NO,
                                                           P.REL_NO,
                                                           L.LINE_ITEM_NO) SALES_PRICE,
       ROUND(L.PART_PRICE, 2) UNIT_NSP,
       P.DISCOUNT,
       ROUND((L.COST * L.QTY_INVOICED * P.VAT) /
             (select L2.COST
                from IFSAPP.CUSTOMER_ORDER_LINE_TAB L2
               WHERE L2.ORDER_NO = P.ORDER_NO
                 AND L2.LINE_NO = P.LINE_NO
                 AND L2.REL_NO = P.REL_NO
                 AND L2.CATALOG_TYPE = 'PKG'),
             2) VAT,
       IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Sale_Price_Total(P.ORDER_NO,
                                                           P.LINE_NO,
                                                           P.REL_NO,
                                                           L.LINE_ITEM_NO) +
       ROUND((L.COST * L.QTY_INVOICED * P.VAT) /
             (select L2.COST
                from IFSAPP.CUSTOMER_ORDER_LINE_TAB L2
               WHERE L2.ORDER_NO = P.ORDER_NO
                 AND L2.LINE_NO = P.LINE_NO
                 AND L2.REL_NO = P.REL_NO
                 AND L2.CATALOG_TYPE = 'PKG'),
             2) AMOUNT_RSP
  from IFSAPP.CUSTOMER_ORDER_LINE_TAB L
  LEFT JOIN IFSAPP.SBL_JR_SALES_DTL_PKG P
    ON L.ORDER_NO = P.ORDER_NO
   AND L.LINE_NO = P.LINE_NO
   AND L.REL_NO = P.REL_NO
 where L.CATALOG_TYPE = 'KOMP'
   /*AND P.SALES_DATE = TO_DATE('&SALES_DATE', 'YYYY/MM/DD')*/
   AND P.ORDER_NO = 'DGN-R19983'/*'RGS-R5416'*/ /*'BGT-H3228'*/ /*'BGR-H860'*/
 ORDER BY 3, 4, 5, 6, 7
