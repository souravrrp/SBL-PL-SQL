-- Sales First or Last Ten
select t.invoice_id,
       t.item_id,
       t.c10 "SITE",
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
       case
         when t.net_curr_amount != 0 then
          t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
         else
          IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id, t.item_id, T.N2) --t.n2
       end SALES_QUANTITY,
       t.net_curr_amount SALES_PRICE,
       t.vat_code,
       t.vat_curr_amount VAT,
       (t.net_curr_amount + t.vat_curr_amount) "RSP",
       /*round((select c.cost
               from ifsapp.INVENT_ONLINE_COST_TAB c
              where c.year = extract(year from i.invoice_date)
                and c.period = extract(month from i.invoice_date)
                and c.contract = t.c10
                and c.part_no = t.c5),
             2) unit_cost,
       round((case
               when t.net_curr_amount != 0 then
                (t.n2 * (t.net_curr_amount / abs(t.net_curr_amount)))
               else
                IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id, t.item_id, T.N2) --t.n2
             end) * (select c.cost
                       from ifsapp.INVENT_ONLINE_COST_TAB c
                      where c.year = extract(year from i.invoice_date)
                        and c.period = extract(month from i.invoice_date)
                        and c.contract = t.c10
                        and c.part_no = t.c5),
             2) total_cost,*/
       i.pay_term_id
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id
      /*and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'*/
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in ('INV', 'PKG')
   and t.invoice_id in
       (select *
          from (select t2.invoice_id
                  from ifsapp.invoice_item_tab t2, ifsapp.INVOICE_TAB i2
                 where t2.invoice_id = i2.invoice_id
                   and t2.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                   and t2.rowstate = 'Posted'
                   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T2.C5) in
                       ('INV', 'PKG')
                   and t2.c10 not in ('BSCP',
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
                   and (case
                         when t2.net_curr_amount = 0 then
                          ifsapp.GET_SBL_FREE_ISSUE_LINE_STATE(t2.invoice_id,
                                                               t2.item_id,
                                                               t2.c1)
                         else
                          ifsapp.get_sbl_account_status(t2.c1,
                                                        t2.c2,
                                                        t2.c3,
                                                        t2.c5,
                                                        t2.net_curr_amount,
                                                        i2.invoice_date)
                       end) not in ('CashConverted', 'PositiveCashConv')
                   and i2.invoice_date between
                       to_date('&from_date', 'yyyy/mm/dd') and
                       to_date('&to_date', 'yyyy/mm/dd')
                 group by t2.invoice_id
                 order by t2.invoice_id desc
                )
         where rownum <= 10)
 order by t.invoice_id /*, t.item_id*/ desc
;
