select
    C.order_no order_no,
    C.real_ship_date  real_ship_date,
    c.qty_invoiced    qty_invoiced,
    C.base_sale_unit_price  cash_price,
    nvl(ifsapp.HPNRET_HP_DTL_API.Get_Down_Payment(c.order_no,1,c.line_no), 0) Down_Payment,
    C.dock_code       dock_code,
    1                 sale_cat,
    C.catalog_no      part_no,
    'Active'          state,
    'CO'              ord_type,
    C.discount        discount,                   
    C.buy_qty_due     qty,                
    C.catalog_type    cat_type,
    ifsapp.customer_info_api.Get_Name(ifsapp.customer_order_line_api.Get_Customer_No( C.order_no , C.line_no ,C.REL_NO ,C.line_item_no )) customer_name,
    ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(ifsapp.customer_order_line_api.Get_Customer_No( C.order_no , C.line_no ,C.REL_NO ,C.line_item_no )) phone_no    
FROM ifsapp.customer_order_line_tab C
WHERE 
  C.CATALOG_type <> 'KOMP' AND--'BAB01' 
  --C.contract = cont_ AND
  trunc(C.real_ship_date) between TO_DATE('&from_','YYYY/MM/DD') and TO_DATE('&to_','YYYY/MM/DD') AND
  substr(order_no,instr(order_no,'-',-1,1)+1,1) = 'H'