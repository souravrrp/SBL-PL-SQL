--Wholesale & Corporate Int Purch Dir Sales with VAT Receipt
SELECT E.SITE,
       E.ORDER_NO,
       E.LINE_NO,
       E.REL_NO,
       TO_CHAR(E.SALES_DATE, 'YYYY/MM/DD') SALES_DATE,
       E.CUSTOMER_NO,
       E.CUSTOMER_NAME,
       E.DELIVERY_SITE,
       IO.INTERNAL_CO_NO,
       IO.DEMAND_ORDER_REF1 PO_NO,
       IO.TRIP_NO,
       IO.DEMAND_CODE,
       IO.VAT_RECEIPT_NO
  FROM (SELECT W.SITE,
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
          LEFT OUTER JOIN IFSAPP.PURCHASE_ORDER_LINE_TAB P
            ON W.SITE = P.CONTRACT
           AND W.ORDER_NO = P.DEMAND_ORDER_NO
           AND W.LINE_NO = P.DEMAND_RELEASE
           AND W.REL_NO = P.DEMAND_SEQUENCE_NO
         WHERE W.SITE in
               ('JWSS', 'SAOS', 'SCSM', 'SESM', 'SHOM', 'SWSS', 'WSMO') --Wholesale & Corporate Sites
           and W.DELIVERY_SITE IN ('APWH',
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
                                   'TWHW',
                                   'ABWW',
                                   'BAWW',
                                   'BGWW',
                                   'CLWW',
                                   'CTWW',
                                   'KHWW',
                                   'MHWW',
                                   'RHWW',
                                   'SDWW',
                                   'SVWW',
                                   'SLWW',
                                   'TUWW',
                                   'JWSS',
                                   'SAOS',
                                   'WSMO',
                                   'SCSM',
                                   'SESM',
                                   'SHOM',
                                   'SWSS') --Wareghous Sites
        ) E
  LEFT OUTER JOIN (select tl.trip_no,
                          tl.release_no,
                          tl.order_no internal_co_no,
                          tl.line_no,
                          tl.rel_no,
                          tl.debit_note_no,
                          tl.invoice_no,
                          tl.vat_receipt_no,
                          c.demand_order_ref1,
                          c.demand_order_ref2,
                          c.demand_order_ref3,
                          c.demand_order_ref4,
                          c.demand_code
                     from IFSAPP.TRN_TRIP_PLAN_CO_LINE_TAB tl
                    inner join IFSAPP.TRN_TRIP_PLAN_TAB p2
                       on p2.trip_no = tl.trip_no
                      and p2.release_no = tl.release_no
                    inner join IFSAPP.CUSTOMER_ORDER_LINE_TAB c
                       on tl.order_no = c.order_no
                      and tl.line_no = c.line_no
                      and tl.rel_no = c.rel_no
                      and tl.line_item_no = c.line_item_no
                    where p2.rowstate != 'Cancelled'
                      and c.demand_code = 'IPD') IO
    ON E.PO_NO = IO.DEMAND_ORDER_REF1
   AND E.P_LINE_NO = IO.DEMAND_ORDER_REF2
   AND E.RELEASE_NO = IO.DEMAND_ORDER_REF3
 WHERE E.SALES_DATE between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   /*AND E.ORDER_NO = 'WSM-R22899'*/
 ORDER BY IO.VAT_RECEIPT_NO
