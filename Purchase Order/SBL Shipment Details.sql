/* Formatted on 9/22/2022 4:58:41 PM (QP5 v5.381) */
SELECT pspt.order_no,
       pspt.line_no,
       pspt.release_no,
       pspt.rowstate     line_status,
       pst.shipment_date,
       pst.vendor_no,
       pst.contract      shp_code,
       pst.rowstate      status
  --pst.*,
  --pspt.*,
  FROM ifsapp.purinv_ship_poline_tab pspt, ifsapp.purinv_shipments_tab pst
 WHERE 1 = 1 AND order_no = 'F-120' AND pspt.shipment_id = pst.shipment_id;