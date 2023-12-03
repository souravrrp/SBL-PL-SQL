select t.c10 "SITE",
       (select s.area_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = t.c10) area_code,
       (select s.district_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = t.c10) district_code,
       t.c1 ORDER_NO,
       ifsapp.get_sbl_account_status(t.c1,
                                     t.c2,
                                     t.c3,
                                     t.c5,
                                     t.net_curr_amount,
                                     i.invoice_date) status,
       to_char(i.invoice_date, 'YYYY/MM/DD') SALES_DATE,
       t.c5 PRODUCT_CODE,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         t.c5)) brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             t.c5)) product_family,
       IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('SCOM',
                                                                                                 t.c5)) commodity_group2,
       IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group('SCOM',
                                                                                      t.c5)) sales_group,
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
       (t.net_curr_amount + t.vat_curr_amount) "RSP",
       case
         when substr(t.c1, 4, 2) = '-R' then
          nvl((select ct.amount
                from COMMISSION_AGREE_LINE_TAB ct
               where ct.AGREEMENT_ID = 'SP_SC_RTL'
                 and ct.COMMISSION_SALES_TYPE = 'CASH'
                 and ct.location_no = 'NORMAL'
                 and i.invoice_date between ct.valid_from and ct.valid_to
                 and ct.catalog_no = t.c5),
              0) * (t.net_curr_amount / abs(t.net_curr_amount))
         else
          nvl((select ct.amount
                from COMMISSION_AGREE_LINE_TAB ct
               where ct.AGREEMENT_ID = 'SP_SC_RTL'
                 and ct.COMMISSION_SALES_TYPE = 'HP'
                 and ct.location_no = 'NORMAL'
                 and i.invoice_date between ct.valid_from and ct.valid_to
                 and ct.catalog_no = t.c5),
              0) * (t.net_curr_amount / abs(t.net_curr_amount))
       end COMISSION
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id
   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in
       ('INV', 'PKG' /*, 'NON'*/)
      /*and t.c10 not in ('BSCP',
      'BLSP',
      'CLSP', --New Service Center
      'CSCP',
      'DSCP',
      'JSCP',
      'RSCP',
      'SSCP',
      'MS1C',
      'MS2C',
      'BTSC')*/ --Service Sites
      /*and t.c10 not in ('JWSS', 'SAOS', 'SWSS', 'WSMO')*/ --Wholesale Sites
      /*and t.c10 not in ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM')*/ --Corporate, Employee, & Scrap Sites
   and t.c10 = 'GPBB'
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
 order by area_code, district_code, t.c10, t.c1, i.invoice_date
