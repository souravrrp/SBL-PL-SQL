--***** Starts HP Variations
select 
    --*
    h.account_no,
    h.ref_line_no LINE_NO,
    h.ref_rel_no REL_NO,
    h.ref_line_item_no LINE_ITEM_NO,    
    h.contract,
    h.catalog_no PART_NO,
    IFSAPP.customer_order_line_api.Get_Catalog_Desc(h.account_no, h.ref_line_no, h.ref_rel_no, h.ref_line_item_no) PART_DESCRIPTION,
    h.catalog_type PART_TYPE,
    trunc(h.sales_date) sales_date,
    --h.serial_no,
    (-1) * h.quantity quantity,
    h.sale_unit_price,
    h.cash_price,
    h.hire_price,
    IFSAPP.customer_order_line_api.Get_Sale_Price_Total(h.account_no, h.ref_line_no, h.ref_rel_no, h.ref_line_item_no) NSP,
    h.discount,
    IFSAPP.Customer_Order_Line_API.Get_Total_Tax_Amount(h.account_no, h.ref_line_no, h.ref_rel_no, h.ref_line_item_no) VAT,
    h.service_charge,
    h.down_payment,
    h.amt_finance,
    h.install_amt,
    ifsapp.Hpnret_Hp_Head_Api.Get_Length_Of_Contract(h.account_no, h.account_rev) Length_Of_Contract,
    --h.part_no,    
    --h.fee_code_normal,
    --h.cash_price_normal,    
    trunc(h.rowversion) rowversion,
    h.rowstate STATUS,
    trunc(h.closed_date) closed_date,
    trunc(h.variated_date) variated_date,
    trunc(h.reverted_date) reverted_date,
    ifsapp.customer_order_line_api.Get_Customer_No(h.account_no, h.ref_line_no, h.ref_rel_no, h.ref_line_item_no) Customer_No,
    ifsapp.customer_info_api.Get_Name
      (ifsapp.customer_order_line_api.Get_Customer_No(h.account_no, h.ref_line_no, h.ref_rel_no, h.ref_line_item_no)) customer_name,
    ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No
      (ifsapp.customer_order_line_api.Get_Customer_No(h.account_no, h.ref_line_no, h.ref_rel_no, h.ref_line_item_no)) phone_no,
    IFSAPP.CUSTOMER_INFO_API.Get_NIC_No
      (ifsapp.customer_order_line_api.Get_Customer_No(h.account_no, h.ref_line_no, h.ref_rel_no, h.ref_line_item_no)) NIC_NO,
    (select a.address1 from CUSTOMER_INFO_ADDRESS a where a.customer_id = ifsapp.customer_order_line_api.Get_Customer_No(h.account_no, h.ref_line_no, h.ref_rel_no, h.ref_line_item_no)) || ' ' ||
    (select a.address2 from CUSTOMER_INFO_ADDRESS a where a.customer_id = ifsapp.customer_order_line_api.Get_Customer_No(h.account_no, h.ref_line_no, h.ref_rel_no, h.ref_line_item_no)) Customer_Address
from 
  ifsapp.hpnret_hp_dtl_tab h,
  --IFSAPP.HPNRET_HP_HEAD_TAB T
where
  --H.ACCOUNT_NO = T.ACCOUNT_NO AND
  --H.CONTRACT = T.CONTRACT AND
  trunc(H.VARIATED_DATE) >= to_date('2014/9/1', 'YYYY/MM/DD') and  
  h.catalog_type != 'KOMP' and
  h.contract not in ('SCOM', /*'BWHW', 'KWHW', 'RWHW', 'TWHW', 'CMWH', 'SPWH', 'SWHW', 'CTGW', 'APWH', 'SYWH', 'MYWH', 
      'BSCP', 'CSCP', 'DSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C', 'BTSC',*/ 
      'WSMO', 'SWSS', 'SAOS', 'JWSS', 'SCSM', 'SAPM', 'SESM') and
  h.rowstate in ('AssumeClosed', 'ExchangedIn', 'Returned', 'Reverted', 'TermChanged', 'TransferAccount') --and
  --h.account_no = 'DJB-H3244'
--***** Ends HP Variations 

--***** Starts Revert Reversed Accounts
select 
    --*
    h.account_no,
    h.ref_line_no LINE_NO,
    h.ref_rel_no REL_NO,
    h.ref_line_item_no LINE_ITEM_NO,    
    h.contract,
    h.catalog_no PART_NO,
    IFSAPP.customer_order_line_api.Get_Catalog_Desc(h.account_no, h.ref_line_no, h.ref_rel_no, h.ref_line_item_no) PART_DESCRIPTION,
    h.catalog_type PART_TYPE,
    trunc(h.sales_date) sales_date,
    --h.serial_no,
    (-1) * h.quantity quantity,
    h.sale_unit_price,
    h.cash_price,
    h.hire_price,
    IFSAPP.customer_order_line_api.Get_Sale_Price_Total(h.account_no, h.ref_line_no, h.ref_rel_no, h.ref_line_item_no) NSP,
    h.discount,
    IFSAPP.Customer_Order_Line_API.Get_Total_Tax_Amount(h.account_no, h.ref_line_no, h.ref_rel_no, h.ref_line_item_no) VAT,
    h.service_charge,
    h.down_payment,
    h.amt_finance,
    h.install_amt,
    ifsapp.Hpnret_Hp_Head_Api.Get_Length_Of_Contract(h.account_no, h.account_rev) Length_Of_Contract,
    --h.part_no,    
    --h.fee_code_normal,
    --h.cash_price_normal,    
    trunc(h.rowversion) rowversion,
    h.rowstate STATUS,
    trunc(h.closed_date) closed_date,
    trunc(h.variated_date) variated_date,
    trunc(h.reverted_date) reverted_date,
    ifsapp.customer_order_line_api.Get_Customer_No(h.account_no, h.ref_line_no, h.ref_rel_no, h.ref_line_item_no) Customer_No,
    ifsapp.customer_info_api.Get_Name
      (ifsapp.customer_order_line_api.Get_Customer_No(h.account_no, h.ref_line_no, h.ref_rel_no, h.ref_line_item_no)) customer_name,
    ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No
      (ifsapp.customer_order_line_api.Get_Customer_No(h.account_no, h.ref_line_no, h.ref_rel_no, h.ref_line_item_no)) phone_no,
    IFSAPP.CUSTOMER_INFO_API.Get_NIC_No
      (ifsapp.customer_order_line_api.Get_Customer_No(h.account_no, h.ref_line_no, h.ref_rel_no, h.ref_line_item_no)) NIC_NO,
    (select a.address1 from CUSTOMER_INFO_ADDRESS a where a.customer_id = ifsapp.customer_order_line_api.Get_Customer_No(h.account_no, h.ref_line_no, h.ref_rel_no, h.ref_line_item_no)) || ' ' ||
    (select a.address2 from CUSTOMER_INFO_ADDRESS a where a.customer_id = ifsapp.customer_order_line_api.Get_Customer_No(h.account_no, h.ref_line_no, h.ref_rel_no, h.ref_line_item_no)) Customer_Address
from 
  ifsapp.hpnret_hp_dtl_tab h,
  --IFSAPP.HPNRET_HP_HEAD_TAB T
where
  --H.ACCOUNT_NO = T.ACCOUNT_NO AND
  --H.CONTRACT = T.CONTRACT AND
  trunc(H.VARIATED_DATE) >= to_date('2014/9/1', 'YYYY/MM/DD') and  
  h.catalog_type != 'KOMP' and
  h.contract not in ('SCOM', /*'BWHW', 'KWHW', 'RWHW', 'TWHW', 'CMWH', 'SPWH', 'SWHW', 'CTGW', 'APWH', 'SYWH', 'MYWH', 
      'BSCP', 'CSCP', 'DSCP', 'JSCP', 'RSCP', 'SSCP', 'MS1C', 'MS2C', 'BTSC',*/ 
      'WSMO', 'SWSS', 'SAOS', 'JWSS', 'SCSM', 'SAPM', 'SESM') and
  h.rowstate in ('RevertReversed') --and
  --h.account_no = 'DJB-H3244'
--***** Ends Revert Reversed Accounts
