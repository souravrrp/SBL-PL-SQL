--*****Sales Data Comparison
select t.SALES_DATE,
       t.ORDER_NO,
       t.Status,
       t.PRODUCT_CODE,
       sum(t.SALES_QUANTITY) SALES_QUANTITY,
       sum(t.SALES_PRICE) SALES_PRICE,
       sum(t.AMOUNT_RSP) AMOUNT_RSP
  from SBL_JR_SALES_INV_PKG_VIEW t
 where t.SALES_DATE = to_date('2017/12/31', 'YYYY/MM/DD')
 group by t.SALES_DATE, t.ORDER_NO, t.PRODUCT_CODE, t.Status
 order by t.SALES_DATE, t.ORDER_NO, t.PRODUCT_CODE, t.Status
