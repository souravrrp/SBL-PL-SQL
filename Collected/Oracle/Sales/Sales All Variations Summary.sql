--*****Shopwise Product Sales Summary (INV)
select t.c10 "SITE",
       t.c5 PRODUCT_CODE,
       t.c10 || '-' || t.c5 "SITE-PRODUCT_CODE",
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code( /*'SCOM'*/t.c10,
                                                                                                         t.c5)) brand,
       decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5),
              'PKG',
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.sales_part_api.Get_Part_Product_Family( /*'SCOM'*/t.c10,
                                                                                                                t.c5)),
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family( /*'SCOM'*/t.c10,
                                                                                                                    t.c5))) product_family,
       decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5),
              'PKG',
              IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group( /*'SCOM'*/t.c10,
                                                                                             t.c5)),
              IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity( /*'SCOM'*/t.c10,
                                                                                                        t.c5))) commodity_group2,
       sum(case
             when t.net_curr_amount != 0 then
              t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
             else
              IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id, t.item_id, T.N2) --t.n2
           end) SALES_QUANTITY,
       sum(t.net_curr_amount) SALES_PRICE,
       sum(round((case
                   when t.net_curr_amount != 0 then
                    (t.n2 * (t.net_curr_amount / abs(t.net_curr_amount)))
                   else
                    IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id, t.item_id, T.N2) --t.n2
                 end) *
                 (select c.cost
                    from ifsapp.INVENT_ONLINE_COST_TAB c
                   where c.year = extract(year from i.invoice_date)
                     and c.period = extract(month from i.invoice_date)
                     and c.contract = t.c10
                     and c.part_no = t.c5),
                 2)) total_cost
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id
   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'INV' /*in ('INV', 'PKG')*/
   and t.c10 not in ('BSCP',
                     'BLSP',
                     'CLSP',
                     'CSCP',
                     'CXSP',
                     'DSCP',
                     'JSCP',
                     'KSCP', --New Service Center
                     'MSCP',
                     'NSCP', --New Service Center
                     'RPSP',
                     'RSCP',
                     'SSCP',
                     'MS1C',
                     'MS2C',
                     'BTSC') --Service Sites
   and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and (case
         when t.net_curr_amount = 0 then
          ifsapp.GET_SBL_FREE_ISSUE_LINE_STATE(t.invoice_id, t.item_id, t.c1)
         else
          ifsapp.get_sbl_account_status(t.c1,
                                        t.c2,
                                        t.c3,
                                        t.c5,
                                        t.net_curr_amount,
                                        i.invoice_date)
       end) not in ('HireSale', 'CashSale', 'CashConverted', 'PositiveCashConv')
/*and t.c10 not in ('JWSS', 'SAOS', 'SWSS', 'WSMO') --Wholesale Sites
and t.c10 not in
    ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM', 'SITM')*/ --Corporate, Employee, & Scrap Sites
/*and t.net_curr_amount != 0*/
 group by t.c10, t.c5

union all

--*****Shopwise Product Sales Summary (PKG)
select t.c10 "SITE",
       L.CATALOG_NO PRODUCT_CODE,
       t.c10 || '-' || L.CATALOG_NO "SITE-PRODUCT_CODE",
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code( /*'SCOM'*/t.c10,
                                                                                                         L.CATALOG_NO)) brand,
       decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(L.CATALOG_NO),
              'PKG',
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.sales_part_api.Get_Part_Product_Family( /*'SCOM'*/t.c10,
                                                                                                                L.CATALOG_NO)),
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family( /*'SCOM'*/t.c10,
                                                                                                                    L.CATALOG_NO))) product_family,
       decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(L.CATALOG_NO),
              'PKG',
              IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group( /*'SCOM'*/t.c10,
                                                                                             L.CATALOG_NO)),
              IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity( /*'SCOM'*/t.c10,
                                                                                                        L.CATALOG_NO))) commodity_group2,
       sum(L.QTY_INVOICED) SALES_QUANTITY,
       sum(IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Sale_Price_Total(t.c1,
                                                               t.c2,
                                                               t.c3,
                                                               L.LINE_ITEM_NO)) SALES_PRICE,
       sum(round(L.QTY_INVOICED *
                 (select c.cost
                    from ifsapp.INVENT_ONLINE_COST_TAB c
                   where c.year = extract(year from i.invoice_date)
                     and c.period = extract(month from i.invoice_date)
                     and c.contract = t.c10
                     and c.part_no = L.CATALOG_NO),
                 2)) total_cost
  from IFSAPP.CUSTOMER_ORDER_LINE_TAB L
  LEFT JOIN ifsapp.invoice_item_tab t
    on L.ORDER_NO = t.c1
   AND L.LINE_NO = t.c2
   AND L.REL_NO = t.c3
 inner join ifsapp.INVOICE_TAB i
    on t.invoice_id = i.invoice_id
 where L.CATALOG_TYPE = 'KOMP'
   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'PKG'
   and t.c10 not in ('BSCP',
                     'BLSP',
                     'CLSP',
                     'CSCP',
                     'CXSP',
                     'DSCP',
                     'JSCP',
                     'KSCP', --New Service Center
                     'MSCP',
                     'NSCP', --New Service Center
                     'RPSP',
                     'RSCP',
                     'SSCP',
                     'MS1C',
                     'MS2C',
                     'BTSC')
   and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and (case
         when t.net_curr_amount = 0 then
          ifsapp.GET_SBL_FREE_ISSUE_LINE_STATE(t.invoice_id, t.item_id, t.c1)
         else
          ifsapp.get_sbl_account_status(t.c1,
                                        t.c2,
                                        t.c3,
                                        t.c5,
                                        t.net_curr_amount,
                                        i.invoice_date)
       end) not in ('HireSale', 'CashSale', 'CashConverted', 'PositiveCashConv')
/*and t.c10 not in ('JWSS', 'SAOS', 'SWSS', 'WSMO') --Wholesale Sites
and t.c10 not in
    ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM', 'SITM')*/ --Corporate, Employee, & Scrap Sites
/*and t.net_curr_amount != 0*/
 group by t.c10, L.CATALOG_NO
 order by 1, 5, 2

/*
'Returned',
'ReturnCompleted',
'ReturnAfterCashConv',
'ExchangedIn',
'PositiveExchangedIn'*/
