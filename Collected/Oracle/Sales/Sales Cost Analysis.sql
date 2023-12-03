-- Sales Cost Analysis
select a.*,
       case
         when A.SITE in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'WITM') then
          'WHOLESALE'
         when A.SITE = 'SCSM' then
          'CORPORATE'
         when A.SITE = 'SITM' then
          'IT CHANNEL'
         when A.SITE = 'SSAM' then
          'SMALL APPLIANCE CHANNEL'
         when A.SITE = 'SOSM' then
          'ONLINE CHANNEL'
         when A.SITE in ('SAPM', 'SESM', 'SHOM', 'SISM', 'SFSM') then
          'STAFF SCRAP & ACQUISITION'
         when A.SITE in (select t.shop_code
                           from ifsapp.shop_dts_info t
                          where t.shop_code = A.SITE) then
          'RETAIL'
         else
          'BLANK' /*'RETAIL'*/
       end /*'SERVICE'*/ sales_channel,
       (SELECT H.AREA_CODE
          FROM IFSAPP.SHOP_DTS_INFO H
         WHERE H.SHOP_CODE = A.SITE) AREA_CODE,
       (SELECT H.DISTRICT_CODE
          FROM IFSAPP.SHOP_DTS_INFO H
         WHERE H.SHOP_CODE = A.SITE) DISTRICT_CODE,
       /*(select p.brand
          from ifsapp.sbl_jr_product_dtl_info p
         where a.PRODUCT_CODE = p.product_code) brand,
       (select p.product_family
          from ifsapp.sbl_jr_product_dtl_info p
         where a.PRODUCT_CODE = p.product_code) product_family,
       (select p.commodity_group2
          from ifsapp.sbl_jr_product_dtl_info p
         where a.PRODUCT_CODE = p.product_code) commodity_group2,*/
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code(A.SITE,
                                                                                                         a.PRODUCT_CODE)) brand,
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family(A.SITE,
                                                                                                             a.PRODUCT_CODE)) product_family,
       IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity(A.SITE,
                                                                                                 a.PRODUCT_CODE)) commodity_group2,
       IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group('SCOM',
                                                                                      a.PRODUCT_CODE)) sales_group,
       (select p.product_type
          from ifsapp.sbl_jr_product_dtl_info p
         where a.PRODUCT_CODE = p.product_code) catalog_type,
       (select h.cash_conv
          from HPNRET_CUSTOMER_ORDER_TAB h
         where h.order_no = a.ORDER_NO) CASH_CONV,
       (select h.Remarks
          from HPNRET_CUSTOMER_ORDER_TAB h
         where h.order_no = a.ORDER_NO) REMARKS,
       nvl(case
             when a.SALES_PRICE >= 0 then
              (select d.Amt_Finance
                 from HPNRET_HP_DTL_TAB d
                where d.account_no = a.ORDER_NO
                  and d.ref_line_no = a.LINE_NO
                  and d.ref_rel_no = a.REL_NO
                  and d.catalog_no = a.PRODUCT_CODE)
             else
              0
           end,
           0) Amt_Finance,
       nvl(case
             when a.SALES_PRICE >= 0 then
              (select d.down_payment
                 from HPNRET_HP_DTL_TAB d
                where d.account_no = a.ORDER_NO
                  and d.ref_line_no = a.LINE_NO
                  and d.ref_rel_no = a.REL_NO
                  and d.catalog_no = a.PRODUCT_CODE)
             else
              0
           end,
           0) down_payment,
       nvl(case
             when a.SALES_PRICE >= 0 then
              (select hd.length_of_contract
                 from HPNRET_HP_HEAD_TAB hd
                where hd.account_no = a.ORDER_NO)
             else
              0
           end,
           0) length_of_contract,
       nvl(case
             when a.SALES_PRICE >= 0 then
              (select d.install_amt
                 from HPNRET_HP_DTL_TAB d
                where d.account_no = a.ORDER_NO
                  and d.ref_line_no = a.LINE_NO
                  and d.ref_rel_no = a.REL_NO
                  and d.catalog_no = a.PRODUCT_CODE)
             else
              0
           end,
           0) install_amt,
       nvl(case
             when a.sales_price < 0 and a.status != 'Returned' then
              0
             else
              ifsapp.hpnret_hp_dtl_api.Get_Service_Charge(a.order_no,
                                                          1,
                                                          a.line_no) *
              (a.sales_quantity / abs(a.sales_quantity))
           end,
           0) service_revenue
  from (select t.invoice_id, --***** Shopwise Product Sales Summary (INV)
               t.item_id,
               t.c10 "SITE",
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
               ifsapp.customer_info_api.Get_Name(t.identity) CUSTOMER_NAME,
               (select c.vendor_no
                  from ifsapp.CUSTOMER_ORDER_LINE c
                 where c.order_no = t.c1
                   and c.line_no = t.c2
                   and c.rel_no = t.c3
                   and c.line_item_no = t.n1) DELIVERY_SITE,
               t.c5 PRODUCT_CODE,
               (case
                 when t.net_curr_amount != 0 then
                  t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
                 else
                  IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                     t.item_id,
                                                     T.N2) --t.n2
               end) SALES_QUANTITY,
               case
                 when t.net_curr_amount >= 0 then
                  (select c.cost
                     from ifsapp.CUSTOMER_ORDER_LINE c
                    where c.order_no = t.c1
                      and c.line_no = t.c2
                      and c.rel_no = t.c3
                      and c.line_item_no = t.n1)
                 else
                  case
                    when ((select count(c1.part_no)
                             from ifsapp.INVENT_ONLINE_COST_TAB c1
                            where c1.year =
                                  extract(year
                                          from(trunc(i.invoice_date, 'MM') - 1))
                              and c1.period =
                                  extract(month
                                          from(trunc(i.invoice_date, 'MM') - 1))
                              and c1.contract = t.c10
                              and c1.part_no = t.c5) != 0) then
                     (select c1.cost
                        from ifsapp.INVENT_ONLINE_COST_TAB c1
                       where c1.year =
                             extract(year from(trunc(i.invoice_date, 'MM') - 1))
                         and c1.period =
                             extract(month from(trunc(i.invoice_date, 'MM') - 1))
                         and c1.contract = t.c10
                         and c1.part_no = t.c5)
                    else
                     (select c2.cost
                        from ifsapp.INVENT_ONLINE_COST_TAB c2
                       where c2.year = extract(year from i.invoice_date)
                         and c2.period = extract(month from i.invoice_date)
                         and c2.contract = t.c10
                         and c2.part_no = t.c5)
                  end
               end unit_cost,
               round((case
                       when t.net_curr_amount != 0 then
                        (t.n2 * (t.net_curr_amount / abs(t.net_curr_amount)))
                       else
                        IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                           t.item_id,
                                                           T.N2) --t.n2
                     end) * (case
                       when t.net_curr_amount >= 0 then
                        (select c.cost
                           from ifsapp.CUSTOMER_ORDER_LINE c
                          where c.order_no = t.c1
                            and c.line_no = t.c2
                            and c.rel_no = t.c3
                            and c.line_item_no = t.n1)
                       else
                        case
                          when ((select count(c1.part_no)
                                   from ifsapp.INVENT_ONLINE_COST_TAB c1
                                  where c1.year =
                                        extract(year
                                                from(trunc(i.invoice_date, 'MM') - 1))
                                    and c1.period =
                                        extract(month
                                                from(trunc(i.invoice_date, 'MM') - 1))
                                    and c1.contract = t.c10
                                    and c1.part_no = t.c5) != 0) then
                           (select c1.cost
                              from ifsapp.INVENT_ONLINE_COST_TAB c1
                             where c1.year =
                                   extract(year from(trunc(i.invoice_date, 'MM') - 1))
                               and c1.period =
                                   extract(month from(trunc(i.invoice_date, 'MM') - 1))
                               and c1.contract = t.c10
                               and c1.part_no = t.c5)
                          else
                           (select c2.cost
                              from ifsapp.INVENT_ONLINE_COST_TAB c2
                             where c2.year = extract(year from i.invoice_date)
                               and c2.period = extract(month from i.invoice_date)
                               and c2.contract = t.c10
                               and c2.part_no = t.c5)
                        end
                     end),
                     2) total_cost,
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
                  t.n2 * (t.net_curr_amount / abs(t.net_curr_amount))
                 else
                  IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                     t.item_id,
                                                     T.N2) --t.n2
               end) * (case
                 when t.net_curr_amount < 0 and t.n1 = 0 then
                  (select l.base_sale_unit_price
                     from IFSAPP.CUSTOMER_ORDER_LINE l
                    where l.order_no = t.c1
                      and l.line_no = t.c2
                      and l.rel_no = t.c3
                      and l.line_item_no = t.n1) /**
                                                (t.net_curr_amount / abs(t.net_curr_amount))*/
                 when t.net_curr_amount < 0 and t.n1 > 0 then
                  (select l.part_price
                     from IFSAPP.CUSTOMER_ORDER_LINE l
                    where l.order_no = t.c1
                      and l.line_no = t.c2
                      and l.rel_no = t.c3
                      and l.line_item_no = t.n1) /**
                                                (t.net_curr_amount / abs(t.net_curr_amount))*/
                 else
                  (select l.base_sale_unit_price
                     from IFSAPP.CUSTOMER_ORDER_LINE l
                    where l.order_no = t.c1
                      and l.line_no = t.c2
                      and l.rel_no = t.c3
                      and l.line_item_no = t.n1)
               end) NSP,
               t.n5 DISCOUNT,
               t.net_curr_amount SALES_PRICE,
               t.vat_code,
               IFSAPP.STATUTORY_FEE_API.Get_Fee_Rate('SBL', t.vat_code) vat_rate,
               t.vat_curr_amount VAT,
               (t.net_curr_amount + t.vat_curr_amount) "RSP",
               i.pay_term_id
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
        /*and t.c10 not in
            ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM', 'WITM') --Wholesale Sites
        and t.c10 not in
            ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM')*/ --Corporate, Employee, & Scrap Sites
        /*and t.c10 = 'DGNB'*/
        /*and t.net_curr_amount < 0*/
        
        union all
        
        --***** Shopwise Product Sales Summary (PKG)
        select t.invoice_id,
               t.item_id,
               t.c10 "SITE",
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
               ifsapp.customer_info_api.Get_Name(t.identity) CUSTOMER_NAME,
               (select c.vendor_no
                  from ifsapp.CUSTOMER_ORDER_LINE c
                 where c.order_no = L.ORDER_NO
                   and c.line_no = L.LINE_NO
                   and c.rel_no = L.REL_NO
                   and c.line_item_no = L.LINE_ITEM_NO) DELIVERY_SITE,
               L.CATALOG_NO PRODUCT_CODE,
               L.QTY_INVOICED SALES_QUANTITY,
               ROUND(L.COST, 2) unit_cost,
               ROUND((L.COST * L.QTY_INVOICED), 2) total_cost,
               ROUND(L.PART_PRICE, 2) UNIT_NSP,
               ROUND((L.PART_PRICE * L.QTY_INVOICED), 2) NSP,
               t.n5 DISCOUNT,
               IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Sale_Price_Total(t.c1,
                                                                   t.c2,
                                                                   t.c3,
                                                                   L.LINE_ITEM_NO) SALES_PRICE,
               L.FEE_CODE vat_code,
               IFSAPP.STATUTORY_FEE_API.Get_Fee_Rate('SBL', L.FEE_CODE) vat_rate,
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
                     2) AMOUNT_RSP,
               i.pay_term_id
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
              /*and t.c10 not in
                  ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SITM', 'SSAM', 'WITM') --Wholesale Sites
              and t.c10 not in
                  ('SAPM', 'SCSM', 'SESM', 'SHOM', 'SISM', 'SFSM', 'SOSM')*/ --Corporate, Employee, & Scrap Sites
           and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
               to_date('&to_date', 'yyyy/mm/dd')
        /*and t.c10 = 'DGNB'*/
        /*and t.net_curr_amount < 0*/
        ) a
/*where (select p.product_family
 from ifsapp.sbl_jr_product_dtl_info p
where a.PRODUCT_CODE = p.product_code) = 'TV-PANEL'*/
