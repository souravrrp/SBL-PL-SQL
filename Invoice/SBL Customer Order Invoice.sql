/* Formatted on 3/28/2023 1:59:20 PM (QP5 v5.381) */


--------------------------------------------------------------------------------
select *
  from ifsapp.customer_order_inv_head
 where 1 = 1 and creators_reference = 'TKG-H11074';

select *
  from ifsapp.cust_invoice_pub_util_head
 where creator = 'CUSTOMER_ORDER_INV_HEAD_API' and party_type_db = 'CUSTOMER';

select * from customer_order_inv_item;