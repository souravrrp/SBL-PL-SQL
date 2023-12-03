--Area or Districtwise Product Sales Summary
select n.district_code,
       'FUR' "FURNITURE",
       sum(n.TOTAL_SALES_PRICE) TOTAL_SALES_PRICE
  from (select t.c10,
               (select s.area_code
                  from ifsapp.SHOP_DTS_INFO s
                 where s.shop_code = t.c10) area_code,
               (select s.district_code
                  from ifsapp.SHOP_DTS_INFO s
                 where s.shop_code = t.c10) district_code,
               SUM(t.net_curr_amount) TOTAL_SALES_PRICE
          from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
         where t.invoice_id = i.invoice_id
           and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
           and t.rowstate = 'Posted'
           and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in
               ('INV', 'PKG')
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
           and ifsapp.get_sbl_account_status(t.c1,
                                             t.c2,
                                             t.c3,
                                             t.c5,
                                             t.net_curr_amount,
                                             i.invoice_date) in
               ('CashSale', 'ReturnCompleted', 'HireSale', 'Returned')
           and t.c5 like '%FUR-%'
         GROUP BY t.c10) n
 group by n.district_code
 order by 1
