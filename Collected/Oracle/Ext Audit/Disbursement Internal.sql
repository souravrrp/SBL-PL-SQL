--***** Disbursement Internal
SELECT distinct t1.ORDER_NO,
                t1.CONTRACT TR_PLACE,
                t2.INTERNAL_PO_NO PO_NO,
                t3.debit_note_no,
                t3.Vat_Receipt_No,
                TRUNC(T3.ROWVERSION) TR_DATE,
                t1.CATALOG_NO PART_CODE,
                p.product_desc,
                p.product_family,
                t3.ACTUAL_QTY_RESERVED QTY_OUT,
                t2.CUSTOMER_NO DESTINATION
  FROM customer_order_line_tab     t1,
       external_customer_order_tab t2,
       trn_trip_plan_co_line_tab   t3,
       purchase_order_line_tab     o,
       IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
 WHERE t1.order_no = t2.order_no
   AND t1.order_no = t3.order_no
   and t2.INTERNAL_PO_NO = o.ORDER_NO
   and t1.catalog_no = p.product_code
   /*AND t1.contract = '&shop_code'
   AND T1.CATALOG_NO = 'SRREF-SINGER-BCD-188C'*/
   AND t1.rowstate IN ('Invoiced', 'Delivered', 'PartiallyDelivered')
   and TRUNC(T3.ROWVERSION) between to_date('&from_date', 'YYYY/MM/DD') and
       to_date('&to_date', 'YYYY/MM/DD')
   AND cust_ord_customer_api.get_cust_grp(Customer_Order_API.Get_Customer_No(o.DEMAND_ORDER_NO)) is null
 order by 4
