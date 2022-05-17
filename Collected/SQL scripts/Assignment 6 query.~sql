select p.demand_order_no AS ORDER_NO,
       p.line_no,
       p.rel_no,
       tab.part_no,
       tab.order_no AS DELIVERY_ORDER_NO,
       --delivery line no
       p.demand_release AS DELIVERY_REL_NO,
       tab.contract AS DELIVERY_SITE,
       pr.product_family,
       pr.brand,
       lov.serial_no,
       IFSAPP.SERIAL_OEM_CONN_API.Get_Oem_No(pr.product_code, lov.serial_no) oem_no,
       p.date_entered AS INVOICE_DATE,
       lov.qty_shipped
  from customer_order_res_serial_lov lov
 INNER JOIN customer_order_line_tab tab
    ON lov.order_no = tab.order_no
   AND lov.line_no = tab.line_no
   AND lov.rel_no = tab.rel_no
   AND lov.line_item_no = tab.line_item_no
 INNER JOIN sbl_jr_product_dtl_info pr
    ON pr.product_code = tab.part_no
 INNER JOIN purchase_order_line_tab p
   ON tab.line_no = p.line_no
   AND tab.rel_no = p.release_no
 --WHERE tab.real_ship_date BETWEEN TO_DATE('&FROM_DATE', 'YYYY/MM/DD') AND
       --TO_DATE('&TO_DATE', 'YYYY/MM/DD')
 --AND p.demand_order_no='&DEMAND_ORDER'
 AND pr.product_family='&Product_Family'
 AND pr.brand='&Brand'
