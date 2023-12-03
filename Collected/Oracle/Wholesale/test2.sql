select
    L.DEMAND_ORDER_NO,
    L.demand_code,
    ifsapp.customer_info_api.Get_Name(ifsapp.customer_order_api.Get_Customer_No( L.DEMAND_ORDER_NO)) CUSTOMER_NAME,
    L.ORDER_NO PO_NO,
    L.PART_NO,
    L.DESCRIPTION,
    L.QTY_ON_ORDER,
    TO_DATE(SUBSTR(L.OBJVERSION, 1, 8), 'YYYY-MM-DD') REGISTER_DATE,
    L.VENDOR_NO,
    IFSAPP.CUSTOMER_ORDER_API.Get_State(L.DEMAND_ORDER_NO) STATUS,
    L.state,
    L.objstate,
    Purchase_Order_API.Get_ObjState(L.ORDER_NO)
from IFSAPP.PURCHASE_ORDER_LINE_PART L 
where 
  /*L.contract IN (SELECT contract FROM IFSAPP.site_public WHERE contract = IFSAPP.User_Allowed_Site_API.Authorized(contract)) AND 
  L.OBJSTATE not in ('Released','Confirmed', 'Arrived', 'Received') AND 
  --(DEMAND_CODE = IFSAPP.Order_Supply_Type_API.Get_Client_Value(5) OR DEMAND_CODE = IFSAPP.Order_Supply_Type_API.Get_Client_Value(14)) AND
  L.demand_code IN (IFSAPP.Order_Supply_Type_API.Get_Client_Value(5), IFSAPP.Order_Supply_Type_API.Get_Client_Value(14)) AND
  IFSAPP.Purchase_Order_API.Get_ObjState(ORDER_NO) not in ('Planned') and  
  TO_DATE(SUBSTR(L.OBJVERSION, 1, 8), 'YYYY-MM-DD') between to_date('&DATE','YYYY-MM-DD') and to_date('&DATE1','YYYY-MM-DD') and 
  IFSAPP.CUSTOMER_ORDER_API.Get_State(L.DEMAND_ORDER_NO) not in ('Invoiced/Closed')*/
  L.DEMAND_ORDER_NO = 'WSM-R10122'
