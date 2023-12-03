select t.c10 "SITE",
       t.c1  ORDER_NO,
       /*t.c2,
       t.c3,*/
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
       case
         when t.net_curr_amount != 0 then
          t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
         else
          IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id, t.item_id, T.N2) --t.n2
       end SALES_QUANTITY,
       case
         when t.net_curr_amount < 0 and t.n1 = 0 then
           (select l.base_sale_unit_price
             from CUSTOMER_ORDER_LINE l
            where l.order_no = t.c1
              and l.line_no = t.c2
              and l.rel_no = t.c3
              and l.catalog_no = t.c5) *
          (t.net_curr_amount / abs(t.net_curr_amount))
         when t.net_curr_amount < 0 and t.n1 > 0 then
           (select l.part_price
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
       t.vat_curr_amount VAT,
       (t.net_curr_amount + t.vat_curr_amount) "RSP",
       /*(select d.discount_type
          from ifsapp.CUST_ORDER_LINE_DISCOUNT_TAB d
         where d.Order_No = t.c1
           and d.line_no = t.c2
           and d.rel_no = t.c3
           and d.line_item_no = 0
           and d.discount_no = 1) discount_type,*/
       /*nvl((select d.discount_amount
             from ifsapp.CUST_ORDER_LINE_DISCOUNT_TAB d
            where d.Order_No = t.c1
              and d.line_no = t.c2
              and d.rel_no = t.c3
              and d.line_item_no = 0
              and d.discount_no = 1),
           0) type_discount_amount,*/
       nvl(case
             when t.net_curr_amount != 0 then
              (select r.amount
                 from IFSAPP.HPNRET_RULE          r,
                      IFSAPP.HPNRET_RULE_TEMP_DET t,
                      IFSAPP.HPNRET_RULE_LINK     l
                where r.rule_no = t.rule_no
                  and t.template_id = l.template_id
                  and r.rule_type_no = 'DISCOUNT'
                  and r.mandotary = 'TRUE'
                  and l.channel in ('ALL', '24')
                  and r.transaction_no = 1
                  and trunc(i.invoice_date) between r.valid_from and r.valid_to
                  and l.part_no = t.c5) *
              (t.net_curr_amount / abs(t.net_curr_amount))
             else
              (select r.amount
                 from IFSAPP.HPNRET_RULE          r,
                      IFSAPP.HPNRET_RULE_TEMP_DET t,
                      IFSAPP.HPNRET_RULE_LINK     l
                where r.rule_no = t.rule_no
                  and t.template_id = l.template_id
                  and r.rule_type_no = 'DISCOUNT'
                  and r.mandotary = 'TRUE'
                  and l.channel in ('ALL', '24')
                  and r.transaction_no = 1
                  and trunc(i.invoice_date) between r.valid_from and r.valid_to
                  and l.part_no = t.c5)
           end,
           0) hp_discount_promo,
       nvl(case
             when t.net_curr_amount != 0 then
              (select r.amount
                 from IFSAPP.HPNRET_RULE          r,
                      IFSAPP.HPNRET_RULE_TEMP_DET t,
                      IFSAPP.HPNRET_RULE_LINK     l
                where r.rule_no = t.rule_no
                  and t.template_id = l.template_id
                  and r.rule_type_no = 'DISCOUNT'
                  and r.mandotary = 'TRUE'
                  and l.channel in ('ALL', '24')
                  and r.transaction_no = 2
                  and trunc(i.invoice_date) between r.valid_from and r.valid_to
                  and l.part_no = t.c5) *
              (t.net_curr_amount / abs(t.net_curr_amount))
             else
              (select r.amount
                 from IFSAPP.HPNRET_RULE          r,
                      IFSAPP.HPNRET_RULE_TEMP_DET t,
                      IFSAPP.HPNRET_RULE_LINK     l
                where r.rule_no = t.rule_no
                  and t.template_id = l.template_id
                  and r.rule_type_no = 'DISCOUNT'
                  and r.mandotary = 'TRUE'
                  and l.channel in ('ALL', '24')
                  and r.transaction_no = 2
                  and trunc(i.invoice_date) between r.valid_from and r.valid_to
                  and l.part_no = t.c5)
           end,
           0) co_discount_promo,
       (select r.description
          from IFSAPP.HPNRET_RULE          r,
               IFSAPP.HPNRET_RULE_TEMP_DET t,
               IFSAPP.HPNRET_RULE_LINK     l
         where r.rule_no = t.rule_no
           and t.template_id = l.template_id
           and r.rule_type_no = 'DISCOUNT'
           and r.mandotary = 'TRUE'
           and l.channel in ('ALL', '24')
           and r.transaction_no = 1
           and trunc(i.invoice_date) between r.valid_from and r.valid_to
           and l.part_no = t.c5) hp_promotion_desc,
       (select r.description
          from IFSAPP.HPNRET_RULE          r,
               IFSAPP.HPNRET_RULE_TEMP_DET t,
               IFSAPP.HPNRET_RULE_LINK     l
         where r.rule_no = t.rule_no
           and t.template_id = l.template_id
           and r.rule_type_no = 'DISCOUNT'
           and r.mandotary = 'TRUE'
           and l.channel in ('ALL', '24')
           and r.transaction_no = 2
           and trunc(i.invoice_date) between r.valid_from and r.valid_to
           and l.part_no = t.c5) co_promotion_desc
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
                     'BTSC') --Service Sites
   and t.c10 not in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM', 'WITM') --Wholesale Sites
   and t.c10 not in ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM') --Corporate, Employee, & Scrap Sites
   and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and t.net_curr_amount != 0
   and ifsapp.get_sbl_account_status(t.c1,
                                     t.c2,
                                     t.c3,
                                     t.c5,
                                     t.net_curr_amount,
                                     i.invoice_date) in
       ('HireSale', 'Returned')
   /*and substr(t.c1, 4, 2) = '-H'
   and t.n5 > 0
   and (select d.user_id
          from ifsapp.CUST_ORDER_LINE_DISCOUNT_TAB d
         where d.Order_No = t.c1
           and d.line_no = t.c2
           and d.rel_no = t.c3
           and d.line_item_no = 0
           and d.discount_no = 1) = 'PROMO'
   and (select r.amount
          from IFSAPP.HPNRET_RULE          r,
               IFSAPP.HPNRET_RULE_TEMP_DET t,
               IFSAPP.HPNRET_RULE_LINK     l
         where r.rule_no = t.rule_no
           and t.template_id = l.template_id
           and r.rule_type_no = 'DISCOUNT'
           and r.mandotary = 'TRUE'
           and l.channel in ('ALL', 24)
           and r.transaction_no = 1
           and trunc(i.invoice_date) between r.valid_from and r.valid_to
           and l.part_no = t.c5) is null*/
 order by 4, 2
