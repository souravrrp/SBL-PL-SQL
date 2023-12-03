SELECT
    W.PRODUCT_CODE,
    SUM(W.SALES_QUANTITY),
    SUM(W.SALES_PRICE),
    SUM(W.DISCOUNT),
    SUM(W.VAT),
    P.GROUP_NO
FROM 
  ifsapp.sbl_vw_wholesale_sales W,
  IFSAPP.product_category_info p
WHERE
  W.PRODUCT_CODE = P.PRODUCT_CODE AND
  W.SALES_DATE between to_date('&from_date', 'yyyy/mm/dd') and to_date('&to_date', 'yyyy/mm/dd') and
  W.SITE in ('JWSS', 'SAOS', 'SCSM', 'SWSS', 'WSMO')
GROUP BY P.GROUP_NO, W.PRODUCT_CODE
