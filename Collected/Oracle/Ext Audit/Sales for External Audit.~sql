--***** Sales for External Audit
select t.invoice_id,
       t.c10 "SITE",
       (select s.area_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = t.c10) area_code,
       (select s.district_code
          from ifsapp.SHOP_DTS_INFO s
         where s.shop_code = t.c10) district_code,
       t.c1 ORDER_NO,
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
       extract(month from i.invoice_date) month_of_sale,
       to_char(i.invoice_date, 'YYYY/MM/DD') SALES_DATE,
       t.identity CUSTOMER_ID,
       ifsapp.customer_info_api.Get_Name(t.identity) CUSTOMER_NAME,
       (select c.vendor_no
          from ifsapp.CUSTOMER_ORDER_LINE_TAB c
         where c.order_no = t.c1
           and c.line_no = t.c2
           and c.rel_no = t.c3
           and c.catalog_no = t.c5) DELIVERY_SITE,
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
       IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) Catalog_Type,
       case
         when t.net_curr_amount != 0 then
          (t.n2 * (t.net_curr_amount / abs(t.net_curr_amount)))
         else
          IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id, t.item_id, T.N2) --t.n2
       end SALES_QUANTITY,
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
       t.net_curr_amount SALES_PRICE,
       t.vat_code,
       t.vat_curr_amount VAT,
       t.net_curr_amount + t.vat_curr_amount "AMOUNT(RSP)",
       (select h.cash_conv
          from HPNRET_CUSTOMER_ORDER_TAB h
         where h.order_no = t.c1) CASH_CONV,
       (select h.Remarks
          from HPNRET_CUSTOMER_ORDER_TAB h
         where h.order_no = t.c1) REMARKS,
       round((select c.cost
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
             2) total_cost,
       i.pay_term_id,
       case
         when t.net_curr_amount >= 0 then
          (select d.down_payment
             from HPNRET_HP_DTL_TAB d
            where d.account_no = t.c1
              and d.ref_line_no = t.c2
              and d.ref_rel_no = t.c3
              and d.catalog_no = t.c5)
         else
          0
       end down_payment,
       case
         when t.net_curr_amount >= 0 then
          (select d.Amt_Finance
             from HPNRET_HP_DTL_TAB d
            where d.account_no = t.c1
              and d.ref_line_no = t.c2
              and d.ref_rel_no = t.c3
              and d.catalog_no = t.c5)
         else
          0
       end Amt_Finance,
       case
         when t.net_curr_amount >= 0 then
          (select hd.length_of_contract
             from HPNRET_HP_HEAD_TAB hd
            where hd.account_no = t.c1)
         else
          0
       end length_of_contract,
       case
         when t.net_curr_amount >= 0 then
          (select d.install_amt
             from HPNRET_HP_DTL_TAB d
            where d.account_no = t.c1
              and d.ref_line_no = t.c2
              and d.ref_rel_no = t.c3
              and d.catalog_no = t.c5)
         else
          0
       end install_amt,
       case
         when t.net_curr_amount >= 0 then
          (select d.service_charge
             from HPNRET_HP_DTL_TAB d
            where d.account_no = t.c1
              and d.ref_line_no = t.c2
              and d.ref_rel_no = t.c3
              and d.catalog_no = t.c5)
         else
          0
       end service_charge
  from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
 where t.invoice_id = i.invoice_id
   and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in
       ('INV', 'PKG' /*, 'NON'*/)
   and t.c10 not in ('BSCP',
                     'BLSP',
                     'CLSP',
                     'CSCP',
                     'CXSP', --New Service Center
                     'DSCP',
                     'MSCP', --New Service Center
                     'JSCP',
                     'RPSP', --New Service Center
                     'RSCP',
                     'SSCP',
                     'MS1C',
                     'MS2C',
                     'BTSC')
   and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
/*and t.net_curr_amount != 0*/
 order by 3, 4, 2, 5
