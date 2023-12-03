--Wholesale & Corporate Sales Shop Delivery with VAT Receipt
SELECT W.SITE,
       W.ORDER_NO,
       W.LINE_NO,
       W.REL_NO,
       TO_CHAR(W.SALES_DATE, 'YYYY/MM/DD') SALES_DATE,
       W.CUSTOMER_NO,
       W.CUSTOMER_NAME,
       W.DELIVERY_SITE,
       (select c.vat_receipt
          from ifsapp.hpnret_customer_order_tab c
         where c.order_no = W.ORDER_NO) VAT_RECEIPT_NO
--count(*)
  FROM ifsapp.sbl_vw_wholesale_sales W
 WHERE W.SALES_DATE between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and W.SITE in ('JWSS', 'SAOS', 'SCSM', 'SESM', 'SHOM', 'SWSS', 'WSMO') --Wholesale & Corporate Sites
   and W.DELIVERY_SITE NOT IN ('APWH',
                               'BBWH',
                               'BWHW',
                               'CMWH',
                               'CTGW',
                               'KWHW',
                               'MYWH',
                               'RWHW',
                               'SPWH',
                               'SWHW',
                               'SYWH',
                               'TWHW',
                               'ABWW',
                               'BAWW',
                               'BGWW',
                               'CLWW',
                               'CTWW',
                               'KHWW',
                               'MHWW',
                               'RHWW',
                               'SDWW',
                               'SVWW',
                               'SLWW',
                               'TUWW', --Wareghous Sites
                               'JWSS',
                               'SAOS',
                               'WSMO',
                               'SCSM',
                               'SESM',
                               'SHOM',
                               'SWSS') --Wholesale & Corporate Sites
 ORDER BY VAT_RECEIPT_NO
