--***** Product-wise Sales Summary (Yearly)
select extract(year from SALES_DATE) "YEAR",
       /*extract(month from SALES_DATE) PERIOD,*/
       /*s.sales_channel,*/
       s.part_no,
       s.brand,
       s.product_family,
       sum(s.SALES_QUANTITY) TOTAL_SALES_QUANTITY,
       sum(s.NSP) TOTAL_NSP,
       sum(s.SALES_PRICE) TOTAL_SALES_PRICE,
       sum(s.VAT) TOTAL_VAT,
       sum(s.RSP) TOTAL_RSP
  from (select i.invoice_date SALES_DATE,
               t.c10 "Shop_Code",
               case
                 when t.c10 in ('JWSS', 'SAOS', 'SWSS', 'WSMO') then
                  'WHOLESALE'
                 when t.c10 = 'SCSM' then
                  'CORPORATE'
                 when t.c10 = 'SITM' then
                  'IT CHANNEL'
                 when t.c10 = 'SOSM' then
                  'ONLINE CHANNEL'
                 when t.c10 in ('SAPM', 'SESM', 'SHOM', 'SISM', 'SFSM') then
                  'STAFF SCRAP & ACQUISITION'
                 when t.c10 in (select t.shop_code
                                  from ifsapp.shop_dts_info t
                                 where t.shop_code = t.c10) then
                  'RETAIL'
                 else
                 /*'BLANK'*/
                  'SERVICE'
               end sales_channel,
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
               t.c5 part_no,
               IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code(t.c10,
                                                                                                                 t.c5)) brand,
               decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5),
                      'PKG',
                      ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.sales_part_api.Get_Part_Product_Family(t.c10,
                                                                                                                        t.c5)),
                      ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family(t.c10,
                                                                                                                            t.c5))) product_family,
               decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5),
                      'PKG',
                      IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group(t.c10,
                                                                                                     t.c5)),
                      IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity(t.c10,
                                                                                                                t.c5))) commodity_group2,
               case
                 when t.net_curr_amount != 0 then
                  (t.n2 * (t.net_curr_amount / abs(t.net_curr_amount)))
                 else
                  IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                     t.item_id,
                                                     T.N2) --t.n2
               end SALES_QUANTITY,
               case
                 when t.net_curr_amount < 0 and t.n1 = 0 then
                  (select l.base_sale_unit_price
                     from IFSAPP.CUSTOMER_ORDER_LINE l
                    where l.order_no = t.c1
                      and l.line_no = t.c2
                      and l.rel_no = t.c3
                      and l.line_item_no = t.n1) *
                  (t.net_curr_amount / abs(t.net_curr_amount))
                 when t.net_curr_amount < 0 and t.n1 > 0 then
                  (select l.part_price
                     from IFSAPP.CUSTOMER_ORDER_LINE l
                    where l.order_no = t.c1
                      and l.line_no = t.c2
                      and l.rel_no = t.c3
                      and l.line_item_no = t.n1) *
                  (t.net_curr_amount / abs(t.net_curr_amount))
                 else
                  (select l.base_sale_unit_price
                     from IFSAPP.CUSTOMER_ORDER_LINE l
                    where l.order_no = t.c1
                      and l.line_no = t.c2
                      and l.rel_no = t.c3
                      and l.line_item_no = t.n1)
               end UNIT_NSP,
               (case
                 when t.net_curr_amount != 0 then
                  (t.n2 * (t.net_curr_amount / abs(t.net_curr_amount)))
                 else
                  IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                     t.item_id,
                                                     T.N2) --t.n2
               end) * abs(case
                            when t.net_curr_amount < 0 and t.n1 = 0 then
                             (select l.base_sale_unit_price
                                from IFSAPP.CUSTOMER_ORDER_LINE l
                               where l.order_no = t.c1
                                 and l.line_no = t.c2
                                 and l.rel_no = t.c3
                                 and l.line_item_no = t.n1) *
                             (t.net_curr_amount / abs(t.net_curr_amount))
                            when t.net_curr_amount < 0 and t.n1 > 0 then
                             (select l.part_price
                                from IFSAPP.CUSTOMER_ORDER_LINE l
                               where l.order_no = t.c1
                                 and l.line_no = t.c2
                                 and l.rel_no = t.c3
                                 and l.line_item_no = t.n1) *
                             (t.net_curr_amount / abs(t.net_curr_amount))
                            else
                             (select l.base_sale_unit_price
                                from IFSAPP.CUSTOMER_ORDER_LINE l
                               where l.order_no = t.c1
                                 and l.line_no = t.c2
                                 and l.rel_no = t.c3
                                 and l.line_item_no = t.n1)
                          end) NSP,
               t.net_curr_amount SALES_PRICE,
               t.vat_curr_amount VAT,
               t.net_curr_amount + t.vat_curr_amount RSP
          from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
         where t.invoice_id = i.invoice_id
           and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
           and t.rowstate = 'Posted'
           and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in
               ('INV', 'PKG'/*, 'NON'*/)
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
           /*and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
               to_date('&to_date', 'yyyy/mm/dd')*/) s
 where s.commodity_group2 like 'BEKO-%'
/*and s.status in (\*'Returned', 'ReturnCompleted',*\ 'Reverted')*/
 group by extract(year from SALES_DATE),
          /*extract(month from SALES_DATE),*/
          /*s.sales_channel,*/
          s.part_no,
          s.brand,
          s.product_family
 order by extract(year from SALES_DATE),
          /*extract(month from SALES_DATE),*/
          /*s.sales_channel,*/
          s.product_family,
          s.brand,
          s.part_no
