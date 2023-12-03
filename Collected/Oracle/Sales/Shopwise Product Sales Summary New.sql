--***** Shopwise Product Sales Summary
select s.SITE,
       s.PRODUCT_CODE,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             s.PRODUCT_CODE)) product_family,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         s.PRODUCT_CODE)) brand,
       /*IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('SCOM',
                                                                                                 s.PRODUCT_CODE)) commodity_group2,*/
       sum(s.SALES_QUANTITY) TOTAL_SALES_QUANTITY,
       sum(s.SALES_PRICE) TOTAL_SALES_PRICE
  from (
        --***** Shopwise Product Sales Summary (INV)
        select t.c10 "SITE",
                t.c1 ORDER_NO,
                t.c2 LINE_NO,
                t.c3 REL_NO,
                t.n1 LINE_ITEM_NO,
                case
                  when t.net_curr_amount = 0 then
                   ifsapp.GET_SBL_FREE_ISSUE_LINE_STATE(t.invoice_id,
                                                        t.item_id,
                                                        t.c1)
                  else
                   ifsapp.get_sbl_account_status(t.c1,
                                                 t.c2,
                                                 t.c3,
                                                 t.c5,
                                                 t.net_curr_amount,
                                                 i.invoice_date)
                end status,
                to_char(i.invoice_date, 'YYYY/MM/DD') SALES_DATE,
                t.identity CUSTOMER_NO,
                t.c5 PRODUCT_CODE,
                (case
                  when t.net_curr_amount != 0 then
                   t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
                  else
                   IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                      t.item_id,
                                                      T.N2) --t.n2
                end) SALES_QUANTITY,
                t.net_curr_amount SALES_PRICE,
                t.vat_curr_amount VAT,
                (t.net_curr_amount + t.vat_curr_amount) "RSP"
          from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
         where t.invoice_id = i.invoice_id
           and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
           and t.rowstate = 'Posted'
           and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'INV'
           and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
               to_date('&to_date', 'yyyy/mm/dd')
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
           and t.c10 not in
               ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM', 'WITM') --Wholesale Sites
           and t.c10 not in
               ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') --Corporate, Employee, & Scrap Sites
           and t.c10 = 'PTYB'
           and t.net_curr_amount != 0
           and t.c5 /*in ('SRFUR-MCR201F',
                        'SRFUR-MCR101F',
                        'SRFUR-MTR201F',
                        'SRFUR-MTR101F')*/ like '%WM-%'
        
        union all
        
        --***** Shopwise Product Sales Summary (PKG)
        select t.c10 "SITE",
               L.ORDER_NO,
               L.LINE_NO,
               L.REL_NO,
               L.LINE_ITEM_NO,
               case
                 when t.net_curr_amount = 0 then
                  ifsapp.GET_SBL_FREE_ISSUE_LINE_STATE(t.invoice_id,
                                                       t.item_id,
                                                       t.c1)
                 else
                  ifsapp.get_sbl_account_status(t.c1,
                                                t.c2,
                                                t.c3,
                                                t.c5,
                                                t.net_curr_amount,
                                                i.invoice_date)
               end status,
               to_char(i.invoice_date, 'YYYY/MM/DD') SALES_DATE,
               t.identity CUSTOMER_NO,
               L.CATALOG_NO PRODUCT_CODE,
               L.QTY_INVOICED SALES_QUANTITY,
               IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Sale_Price_Total(t.c1,
                                                                   t.c2,
                                                                   t.c3,
                                                                   L.LINE_ITEM_NO) SALES_PRICE,
               ROUND((L.COST * L.QTY_INVOICED * t.vat_curr_amount) /
                     (select L2.COST
                        from IFSAPP.CUSTOMER_ORDER_LINE_TAB L2
                       WHERE L2.ORDER_NO = t.c1
                         AND L2.LINE_NO = t.c2
                         AND L2.REL_NO = t.c3
                         AND L2.CATALOG_TYPE = 'PKG'),
                     2) VAT,
               IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Sale_Price_Total(t.c1,
                                                                   t.c2,
                                                                   t.c3,
                                                                   L.LINE_ITEM_NO) +
               ROUND((L.COST * L.QTY_INVOICED * t.vat_curr_amount) /
                     (select L2.COST
                        from IFSAPP.CUSTOMER_ORDER_LINE_TAB L2
                       WHERE L2.ORDER_NO = t.c1
                         AND L2.LINE_NO = t.c2
                         AND L2.REL_NO = t.c3
                         AND L2.CATALOG_TYPE = 'PKG'),
                     2) AMOUNT_RSP
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
           and t.c10 not in
               ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM', 'WITM') --Wholesale Sites
           and t.c10 not in
               ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') --Corporate, Employee, & Scrap Sites
           and t.c10 = 'PTYB'
           and t.net_curr_amount != 0
           and L.Catalog_No /*in ('SRFUR-MCR201F',
                                'SRFUR-MCR101F',
                                'SRFUR-MTR201F',
                                'SRFUR-MTR101F')*/ like '%WM%') s
 group by s.SITE, s.PRODUCT_CODE
 order by 1, 3, 4, 2

/*
'Returned',
'ReturnCompleted',
'ReturnAfterCashConv',
'ExchangedIn',
'PositiveExchangedIn'*/