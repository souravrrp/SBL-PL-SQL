--LC Opening Charge Date Range
select P.order_no,
       P.authorize_code,
       P.contract,
       P.vendor_no,
       TRUNC(P.date_entered) CREATION_DATE,
       P.lc_no,
       P.state PO_STATUS,
       C.charge_type,
       C.description,
       C.charge_by_supplier,
       IFSAPP.SUPPLIER_INFO_API.Get_Name(C.charge_by_supplier) SUPPLIER_NAME,
       C.shipment_id,
       C.creation_method,
       ROUND(C.charge_amount, 2) charge_amount,
       C.fcharge_amount,
       C.currency_rate,
       C.tax_amount
  from IFSAPP.PURCHASE_ORDER P
 INNER JOIN IFSAPP.PURCHASE_ORDER_CHARGE C
    ON P.order_no = C.order_no
 WHERE P.state IN ('Closed', 'Received')
   /*AND C.charge_type = 'LC_OPENING'*/
   AND TRUNC(P.date_entered) BETWEEN TO_DATE('&FROM_DATE', 'YYYY/MM/DD') AND
       TO_DATE('&TO_DATE', 'YYYY/MM/DD')
/*AND C.creation_method != 'Shipment'
AND P.order_no = 'F-21616'*/
 ORDER BY P.lc_no,P.date_entered
