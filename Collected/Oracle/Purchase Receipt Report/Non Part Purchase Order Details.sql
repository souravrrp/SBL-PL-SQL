--Non Part Purchase Order Details
select T.order_no,
       T.line_no,
       T.release_no,
       T.vendor_no SUPPLIER,
       IFSAPP.SUPPLIER_INFO_API.Get_Name(T.vendor_no) SUPPLIER_NAME,
       T.description,
       T.buy_qty_due QUANTITY,
       T.buy_unit_price,
       T.original_qty QUANTITY_RECEIPTS,
       T.contract "SITE",
       T.planned_receipt_date receipt_date,
       T.state STATUS
  from PURCHASE_ORDER_LINE_NOPART t
 where T.vendor_no IN ('XLBD-GBPL', 'XLBD-ONCS', 'XLBD-STBL', 'XLBD- INSL')
   /*AND t.order_no = 'L-2729'*/
