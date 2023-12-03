--Shopwise Sales Summary
select t.c10 "SITE",
       (select s.area_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = t.c10) area_code,
       (select s.district_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = t.c10) district_code,
       'TV', --TV, REF
       SUM(case
         when t.net_curr_amount != 0 then
          (t.n2 * (t.net_curr_amount / abs(t.net_curr_amount)))
         else
          t.n2
       end) SALES_QUANTITY,
       SUM(t.net_curr_amount) TOTAL_SALES_PRICE --,
       /*SUM(t.vat_curr_amount) TOTAL_VAT,
       SUM(t.net_curr_amount + t.vat_curr_amount) "TOTAL_RSP"*/
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id
   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in
       ('INV', 'PKG'/*, 'NON'*/)
   and t.c10 not in ('BSCP',
                     'BLSP',
                     'CLSP', --New Service Center
                     'CSCP',
                     'DSCP',
                     'JSCP',
                     'RSCP',
                     'SSCP',
                     'MS1C',
                     'MS2C',
                     'BTSC') --Service Sites
   and t.c10 not in ('JWSS', 'SAOS', 'SWSS', 'WSMO') --Wholesale Sites
   and t.c10 not in ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM') --Corporate, Employee, & Scrap Sites
   and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and t.net_curr_amount != 0
   and t.c5 like '%TV%' --TV, REF
 GROUP BY T.C10
 order by 2,3,1
