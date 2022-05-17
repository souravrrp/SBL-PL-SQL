select * from SBL_JR_SALES_DTL_INV t
INNER JOIN SBL_JR_PRODUCT_DTL_INFO p ON t.product_code=p.product_code
WHERE 
t.order_no IN ('DMP-R29332','SHA-H5181')
--p.product_family='COMPUTER-LAPTOP'
--and p.brand='Dell'
--and t.sales_date>=to_date('2020-12-01','yyyy-MM-dd')
--AND t.status='CashSale'
