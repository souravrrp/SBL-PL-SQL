--Wholesale & Corporate Int Purch Dir Sales with PO info
SELECT W.SITE,
       W.ORDER_NO,
       W.LINE_NO,
       W.REL_NO,
       W.SALES_DATE,
       W.CUSTOMER_NO,
       W.CUSTOMER_NAME,
       W.DELIVERY_SITE,
       W.PRODUCT_CODE,
       W.PRODUCT_DESC,
       W.CATALOG_TYPE,
       W.SALES_QUANTITY,
       W.SALES_PRICE,
       W.DISCOUNT       "DISCOUNT(%)",
       W.VAT,
       W.unit_nsp,
       W.RSP            "AMOUNT(RSP)",
       P.ORDER_NO       PO_NO,
       P.LINE_NO        P_LINE_NO,
       P.RELEASE_NO
  FROM ifsapp.sbl_vw_wholesale_sales W
 INNER JOIN IFSAPP.PURCHASE_ORDER_LINE_TAB P
    ON W.SITE = P.CONTRACT
   AND W.ORDER_NO = P.DEMAND_ORDER_NO
   AND W.LINE_NO = P.DEMAND_RELEASE
   AND W.REL_NO = P.DEMAND_SEQUENCE_NO
 WHERE W.SALES_DATE between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   AND W.SALES_PRICE > 0
   AND (W.SITE in ('JWSS', 'SAOS', /*'SCSM', 'SWSS',*/ 'WSMO') --Wholesale Sites
       or W.SITE in ('SCSM', 'SESM', 'SHOM', 'SWSS')) --Corporate Sites
   and (W.DELIVERY_SITE IN ('APWH',
                            'BBWH',
                            'BWHW',
                            'CMWH',
                            'CTGW',
                            'KWHW',
                            'MYWH',
                            'RWHW',
                            'SPWH',
                            'SWHW',
                            'SYWH',
                            'TWHW') --Wareghous Sites
       OR W.DELIVERY_SITE IN
       ('JWSS', 'SAOS', 'WSMO', 'SCSM', 'SESM', 'SHOM', 'SWSS'))
