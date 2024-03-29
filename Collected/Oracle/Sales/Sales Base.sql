select t.invoice_id,
       t.item_id,
       t.c10 "SITE",
       t.c1 ORDER_NO,
       t.c2 LINE_NO,
       t.c3 REL_NO,
       t.n1 LINE_ITEM_NO,
       CASE
         WHEN SUBSTR(t.c1, 4, 2) = '-H' THEN
          (select D.LINE_NO
             from IFSAPP.HPNRET_HP_DTL_TAB D
            where D.ACCOUNT_NO = t.c1
              AND D.REF_LINE_NO = t.c2
              AND D.REF_REL_NO = t.c3
              AND D.CATALOG_NO = t.c5)
         ELSE
          t.c4
       END ACCT_LINE_NO,
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
       t.identity CUSTOMER_NO,
       (select c.vendor_no
          from ifsapp.CUSTOMER_ORDER_LINE c
         where c.order_no = t.c1
           and c.line_no = t.c2
           and c.rel_no = t.c3
           and c.line_item_no = t.n1) DELIVERY_SITE,
       t.c5 PRODUCT_CODE,
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
       IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group(t.c10,
                                                                                      t.c5)) sales_group,
       IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) Catalog_Type,
       case
         when t.net_curr_amount != 0 then
          t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
         else
          IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id, t.item_id, T.N2) --t.n2
       end SALES_QUANTITY,
       case
       /*when t.net_curr_amount > 0 and t.n1 <= 0 then
       (select l.base_sale_unit_price
          from CUSTOMER_ORDER_LINE l
         where l.order_no = t.c1
           and l.line_no = t.c2
           and l.rel_no = t.c3
           and l.catalog_no = t.c5)*/
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
       t.n5 "DISCOUNT(%)",
       t.net_curr_amount SALES_PRICE,
       t.vat_code,
       IFSAPP.STATUTORY_FEE_API.Get_Fee_Rate('SBL', t.vat_code) vat_rate,
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
       i.pay_term_id,
       i.series_id,
       i.invoice_no,
       i.voucher_type_ref,
       i.voucher_no_ref,
       i.voucher_date_ref,
       ifsapp.hpnret_hp_head_api.Get_Budget_Book_Id(t.c1, 1) bb_no
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id
   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted' /*'Unposted'*/ /*'Prepared'*/
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in ('INV', 'PKG')
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
   /*and t.c10 not in
       ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM', 'WITM') --Wholesale Sites
   and t.c10 not in
       ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM')*/ --Corporate, Employee, & Scrap Sites
   and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
/*and t.net_curr_amount != 0*/
/*and t.c10 = \*'IBRD'*\ 'DITF'*/
/*and t.c1 = '&ACCT_NO'*/
/*and IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code(t.c10,
t.c5)) = 'V-GUARD'*/
/*and t.c5 LIKE \*'%12L78%'*\ '%REF-%'*/ --'SRBAT-HPD-100T'
/*and ifsapp.get_sbl_account_status(t.c1,
                              t.c2,
                              t.c3,
                              t.c5,
                              t.net_curr_amount,
                              i.invoice_date) in
('HireSale',
 'CashSale',
 'Returned',
 'ReturnCompleted',
 'ReturnAfterCashConv',
 'ExchangedIn',
 'PositiveExchangedIn')*/
 order by 4, 5, 6, 7
