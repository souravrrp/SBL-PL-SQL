/* Formatted on 8/2/2023 4:50:25 PM (QP5 v5.381) */
SELECT t4.order_no,
       t2.part_no,
       t4.delnote_no,
       t4.qty_shipped,
       t4.date_delivered,
       -------------------------------------------------------------------------
       t2.customer_no,
       (SELECT cia.address1 || ',' || cia.address2
          FROM ifsapp.customer_info_address cia
         WHERE cia.customer_id = t2.customer_no)
           address,
       ifsapp.customer_info_comm_method_api.get_any_phone_no (t2.customer_no)
           phone_number,
       (t2.buy_qty_due * t2.base_sale_unit_price)
           nsp,
       ifsapp.customer_order_line_api.get_total_tax_amount (t2.order_no,
                                                            t2.line_no,
                                                            t2.rel_no,
                                                            t2.line_item_no)
           vat_amount
  --,t4.*
  --,t2.*
  FROM ifsapp.customer_order_delivery_tab  t4,
       ifsapp.customer_order_line_tab      t2
 WHERE     t2.order_no = t4.order_no
       AND t2.line_no = t4.line_no
       AND t2.rel_no = t4.rel_no
       AND t2.line_item_no = t4.line_item_no
       AND t2.demand_order_ref1 LIKE '&po_no'