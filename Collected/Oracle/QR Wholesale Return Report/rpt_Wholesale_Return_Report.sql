SELECT W.RMA_NO,
       W.SITE,
       W.ORDER_NO,
       W.LINE_NO,
       W.REL_NO,
       (select h.orig_sale_date
          from ifsapp.HPNRET_CUSTOMER_ORDER_TAB h
         where h.order_no = W.ORDER_NO) DELIVERY_DATE,
       /*to_char((select c.real_ship_date
         from ifsapp.Customer_Order_Line_Tab c
        inner join ifsapp.purchase_order_line_tab p
           on c.demand_order_ref1 = p.order_no
          and c.demand_order_ref2 = p.line_no
          and c.demand_order_ref3 = p.release_no
        where p.demand_order_no = W.ORDER_NO
          and p.demand_release = W.LINE_NO
          and p.demand_sequence_no = W.REL_NO),
       'YYYY/MM/DD') DELIVERY_DATE,*/
       /*(select i.invoice_date
        from IFSAPP.CUSTOMER_ORDER_INV_ITEM i
       where i.order_no = W.ORDER_NO
         and i.line_no = W.LINE_NO
         and i.release_no = W.REL_NO
         and i.series_id = 'CD') SALES_DATE,*/
       TO_CHAR(W.SALES_DATE, 'YYYY/MM/DD') RETURN_DATE,
       ifsapp.return_material_reason_api.Get_Return_Reason_Description(ifsapp.return_material_line_api.Get_Return_Reason_Code(W.RMA_NO,
                                                                                                                              W.RMA_LINE_NO)) return_reason,
       W.CUSTOMER_NO CUSTOMER_ID,
       W.CUSTOMER_NAME,
       W.DELIVERY_SITE,
       W.PRODUCT_CODE,
       W.PRODUCT_DESC,
       W.SALES_QUANTITY,
       W.SALES_PRICE,
       W.DISCOUNT "DISCOUNT(%)",
       W.VAT,
       W.unit_nsp,
       W.RSP "SALES_RETURN_AMOUNT"
  FROM ifsapp.sbl_vw_wholesale_sales W
 WHERE W.SALES_DATE between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and W.SITE in ('JWSS', 'SAOS', 'SCSM', 'SWSS', 'WSMO', 'SITM', 'WITM', 'SSAM')
   AND W.CUSTOMER_NO LIKE '&CUSTOMER_ID'
   and W.SALES_PRICE < 0
 order by W.ORDER_NO