--***** Hire Cash Sales Comparison
select extract(year from u.sales_date) "YEAR",
       extract(month from u.sales_date) period,
       /*u.product_family*/
       'COMPUTER' product_family,
       sum(decode(substr(u.order_no, 4, 2), '-R', u.sales_quantity, 0)) cash_qtn,
       sum(decode(substr(u.order_no, 4, 2), '-H', u.sales_quantity, 0)) hire_qtn,
       sum(u.sales_quantity) total_qtn,
       round(((sum(decode(substr(u.order_no, 4, 2),
                          '-R',
                          u.sales_quantity,
                          0)) / sum(u.sales_quantity)) * 100),
             2) "Cash(%)",
       round(((sum(decode(substr(u.order_no, 4, 2),
                          '-H',
                          u.sales_quantity,
                          0)) / sum(u.sales_quantity)) * 100),
             2) "Hire(%)"
  from (select s.site,
               (SELECT H.AREA_CODE
                  FROM IFSAPP.SHOP_DTS_INFO H
                 WHERE H.SHOP_CODE = S.SITE) AREA_CODE,
               (SELECT H.DISTRICT_CODE
                  FROM IFSAPP.SHOP_DTS_INFO H
                 WHERE H.SHOP_CODE = S.SITE) DISTRICT_CODE,
               s.order_no,
               s.line_no,
               s.rel_no,
               s.comp_no,
               s.status,
               s.sales_date,
               s.product_code,
               p.product_family,
               p.brand,
               s.sales_quantity,
               s.unit_nsp,
               s.discount "DISCOUNT(%)",
               s.sales_price,
               s.vat,
               s.amount_rsp,
               s.customer_no
          from (select *
                  from IFSAPP.SBL_JR_SALES_DTL_INV i
                union all
                select * from IFSAPP.SBL_JR_SALES_DTL_PKG_COMP c) s
         inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
            on s.product_code = p.product_code
         where s.sales_price != 0
           and s.sales_date between to_date('&FROM_DATE', 'YYYY/MM/DD') and
               to_date('&TO_DATE', 'YYYY/MM/DD')
           and s.site not in
               ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM')
           and s.site not in
               ('SAPM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM', 'SCSM')
           and s.status in
               ('HireSale', 'CashSale', 'Returned', 'ReturnCompleted')
           and p.product_family in ('COMPUTER-DESKTOP', 'COMPUTER-LAPTOP')
        /*= 'TV-PANEL'*/
        ) u
 group by extract(year from u.sales_date), extract(month from u.sales_date) /*,
          u.product_family*/
 order by 2
