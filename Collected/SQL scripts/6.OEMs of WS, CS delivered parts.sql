SELECT p.demand_order_no AS ORDER_NO, --p=PURCHASE_ORDER_LINE_TAB
       p.demand_release as line_no,
       P.Demand_Sequence_No as REL_NO,
       c.order_no as DELIVERY_ORDER_NO, --c=CUSTOMER_ORDER_LINE_TAB
       c.line_no as DELIVERY_LINE_NO,
       C.REL_NO AS DELIVERY_REL_NO,
       c.contract AS DELIVERY_SITE,
       c.part_no,
       pr.product_family, --pr=sbl_jr_product_dtl_info
       pr.brand,
       lov.serial_no,
       IFSAPP.SERIAL_OEM_CONN_API.Get_Oem_No(pr.product_code, lov.serial_no) oem_no,
       c.real_ship_date AS INVOICE_DATE,
       lov.qty_shipped

  FROM IFSAPP.CUSTOMER_ORDER_LINE_TAB C
 INNER JOIN IFSAPP.PURCHASE_ORDER_LINE_TAB P
    ON C.DEMAND_ORDER_REF1 = P.ORDER_NO
   AND C.DEMAND_ORDER_REF2 = P.LINE_NO
   AND C.DEMAND_ORDER_REF3 = P.RELEASE_NO
 INNER JOIN IFSAPP.CUSTOMER_ORDER_RES_SERIAL_LOV LOV
    ON C.ORDER_NO = LOV.ORDER_NO
   AND C.LINE_NO = LOV.line_no
   AND C.REL_NO = LOV.rel_no
   AND C.LINE_ITEM_NO = LOV.line_item_no
 INNER JOIN IFSAPP.sbl_jr_product_dtl_info pr
    ON pr.product_code = c.part_no
 WHERE c.real_ship_date BETWEEN TO_DATE('&FROM_DATE', 'YYYY/MM/DD') AND
       TO_DATE('&TO_DATE', 'YYYY/MM/DD')
   AND pr.product_family = '&Product_Family'
   AND pr.brand = '&Brand'
   AND p.contract IN ('WSMO',
                      'JWSS',
                      'SAOS',
                      'SWSS',
                      'SCSM',
                      'SITM',
                      'SAPM',
                      'SHOM',
                      'SSAM')
--WHERE C.ORDER_NO='CLW-R9547'
