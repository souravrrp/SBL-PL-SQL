--***** Channel-wise Monthly Product Sales & Return Summary
select extract(year from SALES_DATE) "YEAR",
       extract(month from SALES_DATE) PERIOD,
       s.sales_channel,
       s.part_no,
       s.product_family,
       s.commodity_group2,
       s.brand,
       sum(s.SALES_QUANTITY) TOTAL_SALES_QUANTITY,
       sum(s.total_cost) TOTAL_COST,
       sum(s.NSP) TOTAL_NSP,
       sum(s.SALES_PRICE) TOTAL_SALES_PRICE,
       sum(s.VAT) TOTAL_VAT,
       sum(s.RSP) TOTAL_RSP
  from (select i.invoice_date SALES_DATE, --****** INV Sales
               t.c10 "SITE",
               case
                 when t.c10 in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'WITM') then
                  'WHOLESALE'
                 when t.c10 = 'SCSM' then
                  'CORPORATE'
                 when t.c10 = 'SITM' then
                  'IT CHANNEL'
                 when t.c10 = 'SSAM' then
                  'SMALL APPLIANCE CHANNEL'
                 when t.c10 = 'SOSM' then
                  'ONLINE CHANNEL'
                 when t.c10 in ('SAPM', 'SESM', 'SHOM', 'SISM', 'SFSM') then
                  'STAFF SCRAP & ACQUISITION'
                 when t.c10 in (select t.shop_code
                                  from ifsapp.shop_dts_info t
                                 where t.shop_code = t.c10) then
                  'RETAIL'
                 else
                  'BLANK' /*'RETAIL'*/
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
                      IFSAPP.SALES_PART_API.Get_Catalog_Group(t.c10, t.c5),
                      IFSAPP.INVENTORY_PART_API.Get_Second_Commodity(t.c10,
                                                                     t.c5)) commodity_group2,
               case
                 when t.net_curr_amount != 0 then
                  (t.n2 * (t.net_curr_amount / abs(t.net_curr_amount)))
                 else
                  IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                     t.item_id,
                                                     T.N2) --t.n2
               end SALES_QUANTITY,
               /*case
               when t.net_curr_amount >= 0 then
                (select c.cost
                   from ifsapp.CUSTOMER_ORDER_LINE c
                  where c.order_no = t.c1
                    and c.line_no = t.c2
                    and c.rel_no = t.c3
                    and c.line_item_no = t.n1)
               else*/
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
                            and c1.part_no = t.c5
                         /*and c1.location = 'NORMAL'*/
                         ) != 0) then
                   (select c1.cost
                      from ifsapp.INVENT_ONLINE_COST_TAB c1
                     where c1.year =
                           extract(year from(trunc(i.invoice_date, 'MM') - 1))
                       and c1.period =
                           extract(month from(trunc(i.invoice_date, 'MM') - 1))
                       and c1.contract = t.c10
                       and c1.part_no = t.c5
                    /*and c1.location = 'NORMAL'*/
                    )
                  else
                   (select c2.cost
                      from ifsapp.INVENT_ONLINE_COST_TAB c2
                     where c2.year = extract(year from i.invoice_date)
                       and c2.period = extract(month from i.invoice_date)
                       and c2.contract = t.c10
                       and c2.part_no = t.c5)
                end
               /*end*/ unit_cost,
               round((case
                       when t.net_curr_amount != 0 then
                        (t.n2 * (t.net_curr_amount / abs(t.net_curr_amount)))
                       else
                        IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN(t.invoice_id,
                                                           t.item_id,
                                                           T.N2) --t.n2
                     end) * ( /*case
                                                                                      when t.net_curr_amount >= 0 then
                                                                                       (select c.cost
                                                                                          from ifsapp.CUSTOMER_ORDER_LINE c
                                                                                         where c.order_no = t.c1
                                                                                           and c.line_no = t.c2
                                                                                           and c.rel_no = t.c3
                                                                                           and c.line_item_no = t.n1)
                                                                                      else*/
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
                                  and c1.part_no = t.c5
                               /*and c1.location = 'NORMAL'*/
                               ) != 0) then
                         (select c1.cost
                            from ifsapp.INVENT_ONLINE_COST_TAB c1
                           where c1.year =
                                 extract(year from(trunc(i.invoice_date, 'MM') - 1))
                             and c1.period =
                                 extract(month from(trunc(i.invoice_date, 'MM') - 1))
                             and c1.contract = t.c10
                             and c1.part_no = t.c5
                          /*and c1.location = 'NORMAL'*/
                          )
                        else
                         (select c2.cost
                            from ifsapp.INVENT_ONLINE_COST_TAB c2
                           where c2.year = extract(year from i.invoice_date)
                             and c2.period = extract(month from i.invoice_date)
                             and c2.contract = t.c10
                             and c2.part_no = t.c5)
                      end /*end*/
                     ),
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
           and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'INV'
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
           and i.invoice_date between to_date('&from_date', 'yyyy/mm/dd') and
               to_date('&to_date', 'yyyy/mm/dd')
        
        UNION ALL
        
        --****** PKG Sales Break down into COMP
        select P.SALES_DATE,
               p.c10 "SITE",
               case
                 when p.c10 in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'WITM') then
                  'WHOLESALE'
                 when p.c10 = 'SCSM' then
                  'CORPORATE'
                 when p.c10 = 'SITM' then
                  'IT CHANNEL'
                 when p.c10 = 'SSAM' then
                  'SMALL APPLIANCE CHANNEL'
                 when p.c10 = 'SOSM' then
                  'ONLINE CHANNEL'
                 when p.c10 in ('SAPM', 'SESM', 'SHOM', 'SISM', 'SFSM') then
                  'STAFF SCRAP & ACQUISITION'
                 when p.c10 in (select t.shop_code
                                  from ifsapp.shop_dts_info t
                                 where t.shop_code = p.c10) then
                  'RETAIL'
                 else
                  'BLANK' /*'RETAIL'*/
               end sales_channel,
               case
                 when p.net_curr_amount = 0 then
                  ifsapp.GET_SBL_FREE_ISSUE_LINE_STATE(p.invoice_id,
                                                       p.item_id,
                                                       p.c1)
                 else
                  ifsapp.get_sbl_account_status(p.c1,
                                                p.c2,
                                                p.c3,
                                                p.c5,
                                                p.net_curr_amount,
                                                P.SALES_DATE)
               end status,
               L.CATALOG_NO part_no,
               IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code(p.c10,
                                                                                                                 L.CATALOG_NO)) brand,
               decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(L.CATALOG_NO),
                      'PKG',
                      ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.sales_part_api.Get_Part_Product_Family(p.c10,
                                                                                                                        L.CATALOG_NO)),
                      ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family(p.c10,
                                                                                                                            L.CATALOG_NO))) product_family,
               decode(IFSAPP.SALES_PART_API.Get_Catalog_Type(L.CATALOG_NO),
                      'PKG',
                      IFSAPP.SALES_PART_API.Get_Catalog_Group(p.c10,
                                                              L.CATALOG_NO),
                      IFSAPP.INVENTORY_PART_API.Get_Second_Commodity(p.c10,
                                                                     L.CATALOG_NO)) commodity_group2,
               L.QTY_INVOICED SALES_QUANTITY,
               ROUND(L.COST, 2) unit_cost,
               ROUND((L.COST * L.QTY_INVOICED), 2) TOTAL_COST,
               ROUND(L.PART_PRICE, 2) UNIT_NSP,
               ROUND(L.QTY_INVOICED * ABS(L.PART_PRICE), 2) NSP,
               IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Sale_Price_Total(p.c1,
                                                                   p.c2,
                                                                   p.c3,
                                                                   L.LINE_ITEM_NO) SALES_PRICE,
               ROUND((L.COST * L.QTY_INVOICED * p.vat_curr_amount) /
                     (select L2.COST
                        from IFSAPP.CUSTOMER_ORDER_LINE_TAB L2
                       WHERE L2.ORDER_NO = p.c1
                         AND L2.LINE_NO = p.c2
                         AND L2.REL_NO = p.c3
                         AND L2.CATALOG_TYPE = 'PKG'),
                     2) VAT,
               IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Sale_Price_Total(p.c1,
                                                                   p.c2,
                                                                   p.c3,
                                                                   L.LINE_ITEM_NO) +
               ROUND((L.COST * L.QTY_INVOICED * p.vat_curr_amount) /
                     (select L2.COST
                        from IFSAPP.CUSTOMER_ORDER_LINE_TAB L2
                       WHERE L2.ORDER_NO = p.c1
                         AND L2.LINE_NO = p.c2
                         AND L2.REL_NO = p.c3
                         AND L2.CATALOG_TYPE = 'PKG'),
                     2) RSP
          from IFSAPP.CUSTOMER_ORDER_LINE_TAB L
          LEFT JOIN (select t.*,
                            i.invoice_date SALES_DATE,
                            i.pay_term_id,
                            i.series_id,
                            i.invoice_no,
                            i.voucher_type_ref,
                            i.voucher_no_ref,
                            i.voucher_date_ref,
                            ifsapp.hpnret_hp_head_api.Get_Budget_Book_Id(t.c1,
                                                                         1) bb_no
                       from ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
                      where t.invoice_id = i.invoice_id
                        and t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
                        and t.rowstate = 'Posted'
                        and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) =
                            'PKG') p
            ON L.ORDER_NO = P.c1
           AND L.LINE_NO = P.c2
           AND L.REL_NO = P.c3
         where L.CATALOG_TYPE = 'KOMP'
           AND P.SALES_DATE between to_date('&from_date', 'yyyy/mm/dd') and
               to_date('&to_date', 'yyyy/mm/dd')) s
 /*where s.status in ('Returned', 'ReturnCompleted', 'Reverted')*/
 where s.status not in ('CashConverted', 'PositiveCashConv')
 group by extract(year from SALES_DATE),
          extract(month from SALES_DATE),
          s.sales_channel,
          s.part_no,
          s.product_family,
          s.commodity_group2,
          s.brand
 order by extract(year from SALES_DATE),
          extract(month from SALES_DATE),
          s.sales_channel,
          s.product_family,
          s.commodity_group2,
          s.brand,
          s.part_no
