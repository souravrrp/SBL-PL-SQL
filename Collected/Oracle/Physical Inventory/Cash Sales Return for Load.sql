select 
    --*
    R.ORDER_NO,
    R.LINE_NO,
    R.REL_NO,
    R.LINE_ITEM_NO,
    R.CONTRACT SHOP_CODE,
    R.CATALOG_NO PART_NO,
    IFSAPP.Customer_Order_Line_API.Get_Catalog_Desc(R.ORDER_NO, R.LINE_NO, R.REL_NO, R.LINE_ITEM_NO) PART_DESCRIPTION,
    --IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Catalog_Type(R.ORDER_NO, R.LINE_NO, R.REL_NO, R.LINE_ITEM_NO) PART_Type,
    ifsapp.sales_part_api.Get_Catalog_Type_Db(R.CONTRACT, R.CATALOG_NO) PART_Type,
    TRUNC(R.DATE_RETURNED) DATE_RETURNED,
    (-1) * R.QTY_RETURNED_INV QUANTIY,
    (-1) * IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Base_Sale_Unit_Price(R.ORDER_NO, R.LINE_NO, R.REL_NO, R.LINE_ITEM_NO) Base_Sale_Unit_Price,
    (-1) * IFSAPP.customer_order_line_api.Get_Sale_Price_Total(R.ORDER_NO, R.LINE_NO, R.REL_NO, R.LINE_ITEM_NO) NSP,
    (-1) * IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Total_Discount(R.ORDER_NO, R.LINE_NO, R.REL_NO, R.LINE_ITEM_NO) Discount,
    (-1) * IFSAPP.Customer_Order_Line_API.Get_Total_Tax_Amount(R.ORDER_NO, R.LINE_NO, R.REL_NO, R.LINE_ITEM_NO) VAT,
    R.ROWSTATE STATUS,
    ifsapp.customer_order_line_api.Get_Customer_No(R.ORDER_NO, R.LINE_NO, R.REL_NO, R.LINE_ITEM_NO) Customer_No,
    ifsapp.customer_info_api.Get_Name
      (ifsapp.customer_order_line_api.Get_Customer_No(R.ORDER_NO, R.LINE_NO, R.REL_NO, R.LINE_ITEM_NO)) customer_name,
    ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No
      (ifsapp.customer_order_line_api.Get_Customer_No(R.ORDER_NO, R.LINE_NO, R.REL_NO, R.LINE_ITEM_NO)) phone_no,
    IFSAPP.CUSTOMER_INFO_API.Get_NIC_No
      (ifsapp.customer_order_line_api.Get_Customer_No(R.ORDER_NO, R.LINE_NO, R.REL_NO, R.LINE_ITEM_NO)) NIC_NO,
    (select a.address1 from CUSTOMER_INFO_ADDRESS a where a.customer_id = ifsapp.customer_order_line_api.Get_Customer_No(R.ORDER_NO, R.LINE_NO, R.REL_NO, R.LINE_ITEM_NO)) || ' ' ||
    (select a.address2 from CUSTOMER_INFO_ADDRESS a where a.customer_id = ifsapp.customer_order_line_api.Get_Customer_No(R.ORDER_NO, R.LINE_NO, R.REL_NO, R.LINE_ITEM_NO)) Customer_Address
from HPNRET_SALES_RET_LINE_TAB R
WHERE 
  SUBSTR(R.ORDER_NO,5,1) = 'R' AND
  R.ROWSTATE IN ('ReturnCompleted') AND
  TRUNC(R.DATE_RETURNED) >= to_date('2014/10/1', 'YYYY/MM/DD') --AND
  --R.CONTRACT = 'RSCP' AND
  --R.ORDER_NO = 'HSG-R1740'
  
