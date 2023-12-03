--***** Warehouse Disbursement (External)
SELECT distinct t1.ORDER_NO,
                t1.CONTRACT TR_PLACE,
                o.DEMAND_ORDER_NO,
                t2.INTERNAL_PO_NO DOC_REF1,
                t1.REAL_SHIP_DATE TR_DATE,
                t1.CATALOG_NO PART_CODE,
                t1.QTY_SHIPPED QTY_OUT,
                t3.DEBIT_NOTE_NO,
                t3.VAT_RECEIPT_NO DOC_REF2,
                customer_info_api.get_name(customer_order_api.Get_Customer_No(o.DEMAND_ORDER_NO)) DEST_SOURCE
  FROM customer_order_line_tab     t1,
       external_customer_order_tab t2,
       trn_trip_plan_co_line_tab   t3,
       purchase_order_line_tab     o
 WHERE t1.order_no = t2.order_no
   AND t1.order_no = t3.order_no
   and t2.INTERNAL_PO_NO = o.ORDER_NO
   AND t1.contract /*= '&shop_code'*/ in (select w.ware_house_name from ware_house_info w)
   AND t1.rowstate IN ('Invoiced', 'Delivered', 'PartiallyDelivered')
   and trunc(t1.real_ship_date) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   AND cust_ord_customer_api.get_cust_grp(Customer_Order_API.Get_Customer_No(o.DEMAND_ORDER_NO)) =
       '003'
   and t3.vat_receipt_no is not null

union all

--***** Warehouse Disbursement (Internal)
SELECT distinct t1.ORDER_NO,
                t1.CONTRACT TR_PLACE,
                '' DEMAND_ORDER_NO,
                t2.INTERNAL_PO_NO DOC_REF1,
                TRUNC(T3.ROWVERSION) TR_DATE,
                t1.CATALOG_NO PART_CODE,
                t3.ACTUAL_QTY_RESERVED QTY_OUT,
                t3.DEBIT_NOTE_NO,
                '' DOC_REF2,
                t2.CUSTOMER_NO DEST_SOURCE
  FROM customer_order_line_tab     t1,
       external_customer_order_tab t2,
       trn_trip_plan_co_line_tab   t3,
       purchase_order_line_tab     o
 WHERE t1.order_no = t2.order_no
   AND t1.order_no = t3.order_no
   and t3.LINE_NO = t1.LINE_NO
   and t3.REL_NO = t1.REL_NO
   and t2.INTERNAL_PO_NO = o.ORDER_NO
   AND t1.contract /*= '&shop_code'*/ in (select w.ware_house_name from ware_house_info w)
   AND t1.rowstate IN ('Invoiced', 'Delivered', 'PartiallyDelivered')
   and TRUNC(T3.ROWVERSION) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   AND ifsapp.cust_ord_customer_api.get_cust_grp(Customer_Order_API.Get_Customer_No(o.DEMAND_ORDER_NO)) is null
 order by 1,5
