--***** Disbursement External
SELECT distinct t1.ORDER_NO,
                t1.CONTRACT TR_PLACE,
                o.DEMAND_ORDER_NO,
                t2.INTERNAL_PO_NO PO_NO,
                t3.VAT_RECEIPT_NO,
                t1.REAL_SHIP_DATE TR_DATE,
                t1.CATALOG_NO PART_CODE,
                p.product_desc,
                p.product_family,
                t1.QTY_SHIPPED QTY_OUT,
                t3.DEBIT_NOTE_NO,
                customer_order_api.Get_Customer_No(o.DEMAND_ORDER_NO) customer_id,
                customer_info_api.get_name(customer_order_api.Get_Customer_No(o.DEMAND_ORDER_NO)) customer_name
  FROM customer_order_line_tab     t1,
       external_customer_order_tab t2,
       trn_trip_plan_co_line_tab   t3,
       purchase_order_line_tab     o,
       IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
 WHERE t1.order_no = t2.order_no
   AND t1.order_no = t3.order_no
   and t2.INTERNAL_PO_NO = o.ORDER_NO
   and t1.catalog_no = p.product_code
   /*AND t1.contract = '&shop_code'*/
   AND t1.rowstate IN ('Invoiced', 'Delivered', 'PartiallyDelivered')
   and TRUNC(t1.real_ship_date) between to_date('&FROM_DATE', 'YYYY/MM/DD') and
       to_date('&TO_DATE', 'YYYY/MM/DD')
   AND cust_ord_customer_api.get_cust_grp(Customer_Order_API.Get_Customer_No(o.DEMAND_ORDER_NO)) =
       '003'
   and vat_receipt_no is not null
 order by t3.DEBIT_NOTE_NO, t1.REAL_SHIP_DATE
