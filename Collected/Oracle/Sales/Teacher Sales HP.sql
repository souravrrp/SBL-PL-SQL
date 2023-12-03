--Teacher Sales HP
select t.c10 "SITE",
       (select s.area_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = t.c10) area_code,
       (select s.district_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = t.c10) district_code,
       t.c1 ORDER_NO,
       t.c2 LINE_NO,
       t.c3 REL_NO,
       case
         when t.net_curr_amount = 0 then
          ifsapp.GET_SBL_FREE_ISSUE_LINE_STATE(t.invoice_id, t.item_id, t.c1)
         else
          ifsapp.get_sbl_account_status(t.c1,
                                        t.c2,
                                        t.c3,
                                        t.c5,
                                        t.net_curr_amount,
                                        i.invoice_date)
       end status,
       to_char(i.invoice_date, 'YYYY/MM/DD') SALES_DATE,
       t.c5 PRODUCT_CODE,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         t.c5)) brand,
       decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5),
              'PKG',
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.sales_part_api.Get_Part_Product_Family('SCOM',
                                                                                                                t.c5)),
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                                    t.c5))) product_family,
       decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5),
              'PKG',
       IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group('SCOM',
                                                                                      t.c5)),
       IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('SCOM',
                                                                                                 t.c5))) commodity_group2,
       IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group('SCOM',
                                                                                      t.c5)) sales_group,
       (select g.product_group
          from ifsapp.product_category_info p
         inner join ifsapp.product_info g
            on p.group_no = g.group_no
         where p.product_code = t.c5) product_group,
       --IFSAPP.HPNRET_HP_HEAD_API.Get_Budget_Book_Id(t.c1, 1) Budget_Book_Id,
       case
         when t.net_curr_amount != 0 then
          t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
         else
          IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id, t.item_id, T.N2) --t.n2
       end SALES_QUANTITY,
       t.net_curr_amount SALES_PRICE,
       case
         when t.net_curr_amount != 0 then
          (select l.base_sale_unit_price
             from CUSTOMER_ORDER_LINE l
            where l.order_no = t.c1
              and l.line_no = t.c2
              and l.rel_no = t.c3
              and l.catalog_no = t.c5) *
          (t.net_curr_amount / abs(t.net_curr_amount))
         else
          (select l.base_sale_unit_price
             from CUSTOMER_ORDER_LINE l
            where l.order_no = t.c1
              and l.line_no = t.c2
              and l.rel_no = t.c3
              and l.catalog_no = t.c5)
       end UNIT_NSP,
       t.n5 "DISCOUNT(%)",
       t.vat_curr_amount VAT,
       (t.net_curr_amount + t.vat_curr_amount) "RSP"
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id
   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in ('INV', 'PKG')
   and t.c10 not in ('BSCP',
                     'BLSP',
                     'CLSP',
                     'CSCP',
                     'CXSP', --New Service Center
                     'DSCP',
                     'JSCP',
                     'MSCP',
                     'RPSP', --New Service Center
                     'RSCP',
                     'SSCP',
                     'MS1C',
                     'MS2C',
                     'BTSC') --Service Sites
   and t.c10 not in ('JWSS', 'SAOS', 'SWSS', 'WSMO') --Wholesale Sites
   and t.c10 not in
       ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') --Corporate, Employee, & Scrap Sites
   and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   /*and t.net_curr_amount != 0*/
   and ifsapp.get_sbl_account_status(t.c1,
                                     t.c2,
                                     t.c3,
                                     t.c5,
                                     t.net_curr_amount,
                                     i.invoice_date) in
       ('HireSale', 'Returned', 'ExchangedIn', 'PositiveExchangedIn')
   and t.c5 like '%COM-%'
   and IFSAPP.HPNRET_HP_HEAD_API.Get_Budget_Book_Id(t.c1, 1) = 'GR-19'
 order by area_code, district_code, t.c10, t.c1, i.invoice_date
