/* Formatted on 3/29/2022 12:28:40 PM (QP5 v5.381) */
  SELECT *
    FROM ifsapp.purchase_order_tab
   WHERE 1 = 1
--AND order_no = 'W-9999'
ORDER BY date_entered DESC;

  SELECT *
    FROM ifsapp.purchase_order_hist_arc
   WHERE 1 = 1
ORDER BY data_archive_date DESC;

SELECT * FROM ifsapp.purchase_order_line_arc;

SELECT * FROM ifsapp.purchase_order_line_hist_arc;

SELECT * FROM ifsapp.purchase_order_type_tab;

SELECT * FROM ifsapp.purchase_order_approval_tab;

SELECT * FROM ifsapp.purchase_order_charge_tab;

SELECT * FROM ifsapp.purchase_order_hist_tab;

SELECT * FROM ifsapp.purchase_order_invoice_tab;

SELECT * FROM ifsapp.purchase_order_line_hist_tab;

SELECT * FROM ifsapp.purchase_order_line_tab;

--------------------------------No data Found-----------------------------------

SELECT * FROM ifsapp.purchase_order_line_comp_tab;

SELECT * FROM ifsapp.purchase_order_line_tax_tab;

SELECT * FROM ifsapp.purchase_order_milestone_tab;

SELECT * FROM ifsapp.purchase_order_option_tab;

SELECT * FROM ifsapp.purchase_order_reservation_tab;

SELECT * FROM ifsapp.purchase_order_response_tab;

SELECT * FROM ifsapp.purchase_order_resp_line_tab;

SELECT * FROM ifsapp.purchase_order_shipment_tab;

-----------------------------------Old Data-------------------------------------

  SELECT *
    FROM ifsapp.purchase_order_invoice_arc
   WHERE 1 = 1
--AND order_no = 'A-30820048'
ORDER BY data_archive_date DESC;

  SELECT *
    FROM ifsapp.purchase_order_arc
   WHERE 1 = 1
--AND order_no = 'A-30820048'
ORDER BY order_no DESC;

SELECT * FROM ifsapp.purchase_order_approval_arc;

SELECT * FROM ifsapp.sbl_purchase_order_tab;

SELECT * FROM ifsapp.sbl_purchase_order_line_tab;

------------------------------SBL PURCHASE ORDER--------------------------------

SELECT * FROM ifsapp.sbl_it_inv_purchase_order_tab;

SELECT * FROM ifsapp.sbl_it_inv_purchase_order_line;

SELECT * FROM ifsapp.purchase_order_charge_arc;

SELECT * FROM ifsapp.purchase_order_line_tax_arc;

SELECT * FROM ifsapp.purchase_order_milestone_arc;