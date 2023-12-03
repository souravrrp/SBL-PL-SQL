select t.invoice_id,
       t.c10 SITE,
       t.c1 ORDER_NO,
       (select W.WO_NO
          from IFSAPP.WORK_ORDER_CODING_TAB W
         WHERE W.INVOICE_ID = t.invoice_id
           and W.invoice_item_id = t.item_id) WO_NO,
       ifsapp.get_sbl_account_status(t.c1,
                                     t.c2,
                                     t.c3,
                                     t.c5,
                                     t.net_curr_amount,
                                     i.invoice_date) status,
       to_char(i.invoice_date, 'YYYY/MM/DD') SALES_DATE,
       t.identity CUSTOMER_NO,
       ifsapp.customer_info_api.Get_Name(t.identity) CUSTOMER_NAME,
       (select c.vendor_no
          from ifsapp.CUSTOMER_ORDER_LINE_TAB c
         where c.order_no = t.c1
           and c.line_no = t.c2
           and c.rel_no = t.c3
           and c.catalog_no = t.c5) DELIVERY_SITE,
       t.c5 PRODUCT_CODE,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             t.c5)) product_family,
       IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity('SCOM',
                                                                                                 t.c5)) commodity_group2,
       IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) Catalog_Type,
       case
         when t.net_curr_amount < 0 then
          (t.n2 * (t.net_curr_amount / abs(t.net_curr_amount)))
         else
          t.n2
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
       t.net_curr_amount + t.vat_curr_amount "AMOUNT(RSP)"
  from ifsapp.invoice_item_tab t
 inner join ifsapp.INVOICE_TAB i
    on t.invoice_id = i.invoice_id
 right join (select c.order_no,
                    c.line_no,
                    c.rel_no,
                    c.contract,
                    c.catalog_no,
                    c.catalog_desc,
                    c.catalog_type,
                    c.demand_order_ref1,
                    c.location_no,
                    c.job_id,
                    c.rowstate
               from customer_order_line_tab c
              where c.contract in ('BSCP',
                                   'BLSP',
                                   'CLSP', --New Service Center
                                   'CSCP',
                                   'DSCP',
                                   'JSCP',
                                   'RSCP',
                                   'SSCP',
                                   'MS1C',
                                   'MS2C',
                                   'BTSC')
                and c.rowstate not in ('Cancelled', 'Released')
                and c.demand_order_ref1 is null
                and c.catalog_type = 'INV') co
    on t.c1 = co.order_no
   and t.c2 = co.line_no
   and t.c3 = co.rel_no
   and t.c10 = co.contract
   and t.c5 = co.catalog_no
 where t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'INV'
   and t.c10 in ('BSCP',
                 'BLSP',
                 'CLSP', --New Service Center
                 'CSCP',
                 'DSCP',
                 'JSCP',
                 'RSCP',
                 'SSCP',
                 'MS1C',
                 'MS2C',
                 'BTSC')
   and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and t.net_curr_amount != 0
   --and t.c1 = 'DSC-R123068'
 order by t.c10, t.c1, i.invoice_date
