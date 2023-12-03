CREATE OR REPLACE VIEW SBL_VW_JR_WS_INVOICE_ANNEXURE AS
select W.*,
       n.delnote_no,
       W.PRODUCT_CODE || ' - ' || W.PRODUCT_DESC PARTICULARS,
       W.unit_nsp * W.SALES_QUANTITY BASE_PRICE,
       case
         when W.SALES_PRICE != 0 then
          round(((nvl((select d.discount_amount
                  from ifsapp.CUST_ORDER_LINE_DISCOUNT_TAB d
                 where d.discount_type = 'WS'
                   and d.order_no = w.ORDER_NO
                   and d.line_no = w.LINE_NO
                   and d.rel_no = w.REL_NO
                   and d.line_item_no = w.LINE_ITEM_NO),
                0) / W.unit_nsp) * 100), 2)
         else
          0
       end "WS_DISCOUNT_PCT",
       case
         when W.SALES_PRICE != 0 then
          (nvl((select d.discount_amount
                 from ifsapp.CUST_ORDER_LINE_DISCOUNT_TAB d
                where d.discount_type = 'WS'
                  and d.order_no = w.ORDER_NO
                  and d.line_no = w.LINE_NO
                  and d.rel_no = w.REL_NO
                  and d.line_item_no = w.LINE_ITEM_NO),
               0) * W.SALES_QUANTITY)
         else
          0
       end WS_DISCOUNT_AMOUNT,
       case
         when W.SALES_PRICE != 0 then
          (nvl((select sum(d.discount_amount)
                 from ifsapp.CUST_ORDER_LINE_DISCOUNT_TAB d
                where d.discount_type != 'WS'
                  and d.order_no = w.ORDER_NO
                  and d.line_no = w.LINE_NO
                  and d.rel_no = w.REL_NO
                  and d.line_item_no = w.LINE_ITEM_NO),
               0) * W.SALES_QUANTITY)
         else
          0
       end G_DISCOUNT_AMOUNT,
       (W.SALES_PRICE + W.VAT) DEALER_PURCHASE_PRICE,
       case
         when W.SALES_PRICE != 0 then
          ((nvl((select d.discount_amount
                  from ifsapp.CUST_ORDER_LINE_DISCOUNT_TAB d
                 where d.discount_type = 'WS'
                   and d.order_no = w.ORDER_NO
                   and d.line_no = w.LINE_NO
                   and d.rel_no = w.REL_NO
                   and d.line_item_no = w.LINE_ITEM_NO),
                0) * W.SALES_QUANTITY) + W.SALES_PRICE + W.VAT)
         else
          0
       end DEALER_SALE_PRICE
  from IFSAPP.CUSTOMER_ORDER_DELIVERY_TAB n
  left join IFSAPP.CUSTOMER_ORDER_LINE_TAB l
    on n.order_no = l.order_no
   and n.line_no = l.line_no
   and n.rel_no = l.rel_no
   and n.line_item_no = l.line_item_no
 inner join IFSAPP.CUSTOMER_ORDER_PUR_ORDER p
    on l.demand_order_ref1 = p.po_order_no
   and l.demand_order_ref2 = p.po_line_no
   and l.demand_order_ref3 = p.po_rel_no
 inner join IFSAPP.sbl_vw_wholesale_sales w
    on p.oe_order_no = W.ORDER_NO
   and p.oe_line_no = W.LINE_NO
   and p.oe_rel_no = W.REL_NO
   and p.oe_line_item_no = W.LINE_ITEM_NO
   and n.qty_shipped = w.SALES_QUANTITY;
 -- where n.delnote_no = '&invoice_id' /*'5992157'*/ /*'5993321'*/
