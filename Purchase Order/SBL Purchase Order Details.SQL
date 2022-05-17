/* Formatted on 3/29/2022 12:59:53 PM (QP5 v5.381) */
SELECT TO_CHAR (pot.order_date, 'IW')
           "Week",
       TO_CHAR (pot.order_date, 'dd-mm-yyyy')
           "Order Date",
       Supplier_API.Get_Vendor_Name (pot.vendor_no)
           "Supplier",
       --pot.Cf$_Pur_Or_Description "Description",
       --pot.project_id "Project ID",
       --PROJECT_API.Get_Name (pot.PROJECT_ID) "Project Name",
       --pot.Cf$_Coordinator_Name "Coordinator",
       POT.order_no
           "Purchase Order",
       TO_CHAR (pot.wanted_receipt_date, 'dd-mm-yyyy')
           "Wanted Receipt Date",
       TO_CHAR (pot.wanted_receipt_date, 'IW')
           "Receipt Week",
       --pot.state "Status",
       Purchase_Order_API.Calc_Order_Total (pot.Order_No) + poc.charge_amount
           "Total Amount" --Purchase_Order_API.Calc_Total_Gross_Incl_Chg ( pot.order_no) "Tax and Charges"
                         ,
       pot.*
  FROM purchase_order_tab pot, purchase_order_charge poc
 WHERE 1 = 1 AND pot.order_no = poc.order_no
--AND purchase_order_cfv.OBJSTATE <> (select PURCHASE_ORDER_API.FINITE_STATE_ENCODE__('Cancelled') from dual) and purchase_order_cfv.OBJSTATE <> (select PURCHASE_ORDER_API.FINITE_STATE_ENCODE__('Planned') from dual)
--AND purchase_order_cfv.order_date BETWEEN TRUNC(Context_Substitution_Var_API.Get_Client_Value__('START_OF_THIS_YEAR'))
--AND TRUNC(Context_Substitution_Var_API.Get_Client_Value__('END_OF_THIS_YEAR')) + (1 - 1 / (60 * 60 * 24))
--ORDER BY pot.order_date