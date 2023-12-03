--SBL_VW_WS_SUPP_INV
CREATE OR REPLACE VIEW SBL_VW_WS_SUPP_INV AS
select s.identity dealer_id,
       IFSAPP.SUPPLIER_INFO_API.Get_Name(s.identity) dealer_name,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(s.identity) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(s.identity, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(s.identity, 1) dealer_address,
       'ADJUSTMENT' "TYPE",
       nvl(s.ledger_date, s.due_date) INV_DATE,
       /*decode(s.open_amount, 0, s.inv_amount * (-1), s.inv_amount) inv_amount,*/
       s.inv_amount * (-1) inv_amount,
       s.ncf_reference "DESCRIPTION",
       s.ledger_item_series_id invoice_series,
       s.ledger_item_id invoice_no
  from ifsapp.LEDGER_ITEM_SU_QRY s
 where s.ledger_item_series_id = 'SI'
   and ifsapp.cust_ord_customer_api.get_cust_grp(s.identity) = '003'
   and s.auth_id != '009'
   and s.objstate != 'Cancelled';
