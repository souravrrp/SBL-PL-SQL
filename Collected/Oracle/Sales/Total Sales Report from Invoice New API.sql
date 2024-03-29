select t.invoice_id,
       t.c10 SITE,
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
       to_char(i.invoice_date, 'YYYY/MM/DD') SALES_DATE,
       t.identity CUSTOMER_NO,
       ifsapp.customer_info_api.Get_Name(t.identity) CUSTOMER_NAME,
       (select c.vendor_no
          from ifsapp.CUSTOMER_ORDER_LINE c
         where c.order_no = t.c1
           and c.line_no = t.c2
           and c.rel_no = t.c3
           and c.line_item_no = t.n1) DELIVERY_SITE,
       t.c5 PRODUCT_CODE,
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
       IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group( /*'SCOM'*/t.c10,
                                                                                      t.c5)) sales_group,
       /*(select g.product_group
        from ifsapp.product_category_info p
       inner join ifsapp.product_info g
          on p.group_no = g.group_no
       where p.product_code = t.c5) product_group,*/
       IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) Catalog_Type,
       case
         when t.net_curr_amount != 0 then
          (t.n2 * (t.net_curr_amount / abs(t.net_curr_amount)))
         else
          IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id, t.item_id, T.N2) --t.n2
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
       t.n5 "DISCOUNT(%)",
       t.net_curr_amount SALES_PRICE,
       t.vat_code,
       IFSAPP.STATUTORY_FEE_API.Get_Fee_Rate('SBL', t.vat_code) vat_rate,
       t.vat_curr_amount VAT,
       t.net_curr_amount + t.vat_curr_amount "AMOUNT(RSP)",
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
       --t.c2 LINE_NO,
       --t.c3 REL_NO,
       --t.c6,    
       --t.c13 CUSTOMER_NO,    
       --t.n4,
       i.pay_term_id,
       (select h.cash_conv
          from HPNRET_CUSTOMER_ORDER_TAB h
         where h.order_no = t.c1) CASH_CONV,
       (select h.Remarks
          from HPNRET_CUSTOMER_ORDER_TAB h
         where h.order_no = t.c1) REMARKS,
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
                     'BTSC')
   and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
/*and t.net_curr_amount != 0*/
/*and substr(t.c1, 4, 2) = '-R'
and t.c10 = 'TSLB'
and t.c1 = 'FEN-R7705'
and t.c5 in ('SGTV-UA23F4003ARSER',
             'SGTV-UA32EH4003RSER',
             'SGTV-UA32FH4003RSER',
             'SGTV-UA40EH5000RSER',
             'SGTV-UA40H5100ARSER',
             'SGTV-UA48H5500ARSER')*/
 order by t.c10, t.c1, i.invoice_date
