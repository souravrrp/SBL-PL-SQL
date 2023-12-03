--*****Gross HP Booking
select --count(*)
       t.c10 SITE,
       t.c1 ORDER_NO,
       ifsapp.get_sbl_account_status(t.c1,
                                     t.c2,
                                     t.c3,
                                     t.c5,
                                     t.net_curr_amount,
                                     i.invoice_date) status,
       to_char(i.invoice_date, 'YYYY/MM/DD') SALES_DATE,
       t.c5 PRODUCT_CODE,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             t.c5)) product_family,
       IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('SCOM',
                                                                                                 t.c5)) commodity_group2,
       IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) Catalog_Type,
       IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group('SCOM', t.c5)) sales_group,
       case
         when t.net_curr_amount != 0 then
          (t.n2 * (t.net_curr_amount / abs(t.net_curr_amount)))
         else
          t.n2
       end SALES_QUANTITY,
       t.net_curr_amount SALES_PRICE,
       t.n5 "DISCOUNT(%)",
       t.vat_curr_amount VAT,
       t.net_curr_amount + t.vat_curr_amount "AMOUNT(RSP)"
  from ifsapp.invoice_item_tab t
 inner join ifsapp.INVOICE_TAB i
    on t.invoice_id = i.invoice_id
 where t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in
       ('INV', 'PKG'/*, 'NON'*/)
   and t.c10 not in ('BSCP',
                     'BLSP',
                     'CLSP',
                     'CSCP',
                     'CXSP',
                     'DSCP',
                     'FSCP', --New Service Center
                     'JSCP',
                     'KSCP',
                     'MSCP',
                     'NSCP',
                     'RPSP',
                     'RSCP',
                     'SSCP',
                     'MS1C',
                     'MS2C',
                     'BTSC') --Service Sites
   and t.c10 not in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM', 'WITM') --Wholesale Sites
   and t.c10 not in ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') --Corporate, Employee, & Scrap Sites
   and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and t.net_curr_amount <> 0
   and substr(t.c1, 4, 2) = '-H'
   and ifsapp.get_sbl_account_status(t.c1,
                                     t.c2,
                                     t.c3,
                                     t.c5,
                                     t.net_curr_amount,
                                     i.invoice_date) in ('HireSale', 'Returned')
   

--*****Monthwise Gross HP Booking Summary
select extract(year from i.invoice_date) "YEAR",
       extract(month from i.invoice_date) "PERIOD",
       count(distinct(t.c1)) TOTAL_HP_BOOKINGS,
       sum(t.net_curr_amount) TOTAL_HP_AMOUNT
  from ifsapp.invoice_item_tab t
 inner join ifsapp.INVOICE_TAB i
    on t.invoice_id = i.invoice_id
 where t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in
       ('INV', 'PKG'/*, 'NON'*/)
   and t.c10 not in ('BSCP',
                     'BLSP',
                     'CLSP',
                     'CSCP',
                     'CXSP',
                     'DSCP',
                     'FSCP', --New Service Center
                     'JSCP',
                     'KSCP',
                     'MSCP',
                     'NSCP',
                     'RPSP',
                     'RSCP',
                     'SSCP',
                     'MS1C',
                     'MS2C',
                     'BTSC') --Service Sites
   and t.c10 not in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM', 'WITM') --Wholesale Sites
   and t.c10 not in ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') --Corporate, Employee, & Scrap Sites
   and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and t.net_curr_amount <> 0
   and substr(t.c1, 4, 2) = '-H'
   and ifsapp.get_sbl_account_status(t.c1,
                                     t.c2,
                                     t.c3,
                                     t.c5,
                                     t.net_curr_amount,
                                     i.invoice_date) in
       ('HireSale', 'Returned')
 group by extract(year from i.invoice_date),
          extract(month from i.invoice_date)
 order by 2



--*****Sales Group or Product Familywise HP Sale Summary
select IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group('SCOM',
                                                                                      t.c5)) sales_group,
       /*ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
       t.c5)) product_family,*/
       sum(t.net_curr_amount) TOTAL_HP_AMOUNT
  from ifsapp.invoice_item_tab t
 inner join ifsapp.INVOICE_TAB i
    on t.invoice_id = i.invoice_id
 where t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in
       ('INV', 'PKG'/*, 'NON'*/)
   and t.c10 not in ('BSCP',
                     'BLSP',
                     'CLSP',
                     'CSCP',
                     'CXSP',
                     'DSCP',
                     'FSCP', --New Service Center
                     'JSCP',
                     'KSCP',
                     'MSCP',
                     'NSCP',
                     'RPSP',
                     'RSCP',
                     'SSCP',
                     'MS1C',
                     'MS2C',
                     'BTSC') --Service Sites
   and t.c10 not in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM', 'WITM') --Wholesale Sites
   and t.c10 not in ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') --Corporate, Employee, & Scrap Sites
   and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and substr(t.c1, 4, 2) = '-H'
   and ifsapp.get_sbl_account_status(t.c1,
                                     t.c2,
                                     t.c3,
                                     t.c5,
                                     t.net_curr_amount,
                                     i.invoice_date) in
       ('HireSale', 'Returned')
 group by IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group('SCOM',
                                                                                         t.c5))
/*ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
t.c5))*/
 order by 1
