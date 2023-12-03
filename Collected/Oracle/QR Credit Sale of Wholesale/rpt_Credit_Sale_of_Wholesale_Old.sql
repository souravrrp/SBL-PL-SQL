    select t.CONTRACT,
           t.ORDER_NO,
           t.pay_term_id,
           trunc(c.ROWVERSION) SALE_DATE,
           c.VENDOR_NO,
           t.CUSTOMER_NO,
           ifsapp.customer_info_api.Get_Name(t.CUSTOMER_NO) CUSTOMER_NAME,
           c.CATALOG_NO,
           c.QTY_SHIPPED,
           ifsapp.customer_order_line_api.Get_Sale_Price_Total(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO) * 
             (c.QTY_SHIPPED/c.BUY_QTY_DUE) SALE_PRICE,
           ifsapp.customer_order_line_api.Get_Total_Discount(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO) DISCOUNT,
           ifsapp.customer_order_line_api.Get_Total_Tax_Amount(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO) * 
             (c.QTY_SHIPPED/c.BUY_QTY_DUE) TAX_AMOUNT,
           (ifsapp.customer_order_line_api.Get_Sale_Price_Total(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO) *
             (c.QTY_SHIPPED/c.BUY_QTY_DUE)) + 
             (ifsapp.customer_order_line_api.Get_Total_Tax_Amount(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO) * 
             (c.QTY_SHIPPED/c.BUY_QTY_DUE)) "AMOUNT(RSP)"
    from  ifsapp.customer_order_tab t,
          ifsapp.customer_order_line_tab c,
          ifsapp.purchase_order_line_tab o
    where c.ORDER_NO = t.ORDER_NO 
    and   t.ORDER_NO = o.DEMAND_ORDER_NO 
    and   c.CATALOG_NO = o.PART_NO 
    and   trunc(c.ROWVERSION) between to_date('&From_Date','YYYY/MM/DD') and to_date('&To_Date','YYYY/MM/DD') 
    and   ifsapp.cust_ord_customer_api.get_cust_grp(t.CUSTOMER_NO) = '003' 
    and   t.customer_no like '&customer_no'
    and   c.ROWSTATE in ('Invoiced','PartiallyDelivered') 
    and   t.ROWSTATE in ('Invoiced','Delivered','PartiallyDelivered') 
    and   ifsapp.customer_order_line_api.Get_Sale_Price_Total(c.order_no, c.LINE_NO, c.REL_NO ,c.LINE_ITEM_NO) > 0 
    and   t.ORDER_NO in (select L.DEMAND_ORDER_NO
                         from   IFSAPP.PURCHASE_ORDER_LINE_PART L
                         where  L.STATE in ('Closed','Released')) 
    and   o.ORDER_NO in (select t2.INTERNAL_PO_NO 
                         from   ifsapp.trn_trip_plan_co_line_tab t3,
                                ifsapp.external_customer_order_tab t2
                         where  t3.ORDER_NO = t2.ORDER_NO) 
    and   t.pay_term_id like 'CR%'
    --and   t.order_no = 'WSM-R10591' 
 order by c.ROWVERSION
