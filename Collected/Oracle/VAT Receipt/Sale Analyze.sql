--no hire type sale in this table
select * from HPNRET_CUSTOMER_ORDER_TAB t where t.order_no like '%-H%'
select * from HPNRET_CUSTOMER_ORDER_TAB t where t.sales_type = 'CREDIT'

select DISTINCT(t.Pay_Term_Id) from HPNRET_CUSTOMER_ORDER_TAB t
select distinct(t.sales_type) from HPNRET_CUSTOMER_ORDER_TAB t


--customer order table both cash & hire
select * from CUSTOMER_ORDER_TAB c where c.order_no like 'JKP-H794'

select DISTINCT(C.ROWSTATE) from CUSTOMER_ORDER_TAB c
select DISTINCT(c.bill_addr_no) from CUSTOMER_ORDER_TAB c order by c.bill_addr_no
select DISTINCT(C.Order_Id) from CUSTOMER_ORDER_TAB c
select DISTINCT(C.Pay_Term_Id) from CUSTOMER_ORDER_TAB c
select DISTINCT(C.Order_Consignment_Creation) from CUSTOMER_ORDER_TAB c
select DISTINCT(C.Customer_Po_No) from CUSTOMER_ORDER_TAB c
select DISTINCT(C.District_Code) from CUSTOMER_ORDER_TAB c


select * from CUSTOMER_ORDER_LINE_TAB o
where o.order_no = 'JKP-H794'

SELECT * FROM HPNRET_HP_DTL_TAB HD
where hd.account_no = 'JKP-H794'


select * from HPNRET_SALES_RET_LINE_TAB sr
where sr.order_no = 'JKP-H794'

select * from HPNRET_HP_HEAD_TAB hh
where hh.account_no = 'JKP-H794'

select * from INVENTORY_BALANCE
