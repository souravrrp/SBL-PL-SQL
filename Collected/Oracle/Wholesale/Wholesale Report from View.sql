SELECT W.SITE,
       W.ORDER_NO,
       W.LINE_NO,
       W.REL_NO,
       TO_CHAR(W.SALES_DATE, 'YYYY/MM/DD') SALES_DATE,
       W.CUSTOMER_NO,
       W.CUSTOMER_NAME,
       --W.creator,
       --W.CUSTOMER_GROUP,
       W.DELIVERY_SITE,
       W.PRODUCT_CODE,
       --W.PRODUCT_DESC,
       --W.CATALOG_TYPE,
       --W.invoice_id,
       IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Code('SCOM',
                                                                                                         W.PRODUCT_CODE)) brand,
       decode(W.CATALOG_TYPE,
              'PKG',
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.sales_part_api.Get_Part_Product_Family('SCOM',
                                                                                                                W.PRODUCT_CODE)),
              ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                                    W.PRODUCT_CODE))) product_family,
       (select l.buy_qty_due
          from IFSAPP.CUSTOMER_ORDER_LINE l
         where l.order_no = W.ORDER_NO
           and l.line_no = W.LINE_NO
           and l.rel_no = W.REL_NO) ORDERED_QUANTITY,
       W.SALES_QUANTITY,
       case
         when ((select count(c1.part_no)
                  from ifsapp.INVENT_ONLINE_COST_TAB c1
                 where c1.year =
                       extract(year from(trunc(W.SALES_DATE, 'MM') - 1))
                   and c1.period =
                       extract(month from(trunc(W.SALES_DATE, 'MM') - 1))
                   and c1.contract = W.SITE
                   and c1.part_no = W.PRODUCT_CODE) != 0) then
          (select c1.cost
             from ifsapp.INVENT_ONLINE_COST_TAB c1
            where c1.year = extract(year from(trunc(W.SALES_DATE, 'MM') - 1))
              and c1.period =
                  extract(month from(trunc(W.SALES_DATE, 'MM') - 1))
              and c1.contract = W.SITE
              and c1.part_no = W.PRODUCT_CODE)
         else
          (select c2.cost
             from ifsapp.INVENT_ONLINE_COST_TAB c2
            where c2.year = extract(year from W.SALES_DATE)
              and c2.period = extract(month from W.SALES_DATE)
              and c2.contract = W.SITE
              and c2.part_no = W.PRODUCT_CODE)
       end unit_cost,
       round(W.SALES_QUANTITY * (case
               when ((select count(c1.part_no)
                        from ifsapp.INVENT_ONLINE_COST_TAB c1
                       where c1.year =
                             extract(year from(trunc(W.SALES_DATE, 'MM') - 1))
                         and c1.period =
                             extract(month from(trunc(W.SALES_DATE, 'MM') - 1))
                         and c1.contract = W.SITE
                         and c1.part_no = W.PRODUCT_CODE) != 0) then
                (select c1.cost
                   from ifsapp.INVENT_ONLINE_COST_TAB c1
                  where c1.year = extract(year from(trunc(W.SALES_DATE, 'MM') - 1))
                    and c1.period =
                        extract(month from(trunc(W.SALES_DATE, 'MM') - 1))
                    and c1.contract = W.SITE
                    and c1.part_no = W.PRODUCT_CODE)
               else
                (select c2.cost
                   from ifsapp.INVENT_ONLINE_COST_TAB c2
                  where c2.year = extract(year from W.SALES_DATE)
                    and c2.period = extract(month from W.SALES_DATE)
                    and c2.contract = W.SITE
                    and c2.part_no = W.PRODUCT_CODE)
             end),
             2) total_cost,
       W.unit_nsp,
       W.SALES_QUANTITY * abs(W.unit_nsp) TOTAL_NSP,
       W.DISCOUNT "DISCOUNT(%)",
       W.SALES_PRICE,
       W.vat_code,
       W.vat_rate,
       W.VAT,
       W.RSP "AMOUNT(RSP)",
       W.pay_term_id
  FROM ifsapp.sbl_vw_wholesale_sales W
 WHERE W.SALES_DATE between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
   and W.SITE /*in ('JWSS', 'SAOS', 'SWSS', 'WSMO', 'SSAM', 'WITM')*/ = /*'SCSM' 'SITM' 'SSAM' 'WITM'*/ 'SOSM'
/*and decode(W.CATALOG_TYPE,
       'PKG',
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.sales_part_api.Get_Part_Product_Family('SCOM',
                                                                                                         W.PRODUCT_CODE)),
       ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description(ifsapp.inventory_part_api.Get_Part_Product_Family('SCOM',
                                                                                                             W.PRODUCT_CODE))) !=
'GIFT'*/
/*and W.SALES_PRICE != 0*/
/*and W.PRODUCT_CODE \*IN ('SRSM-SS-HEAD-15CH1', 'SRSM-STAND-METAL-STEEL', 'SRSM-ZJ9513-G')*\ \*= 'SRSM-ZJ-A6000-G'*\*/
--AND W.CUSTOMER_NO LIKE '&CUSTOMER_ID' 
--and w.ORDER_NO LIKE 'SCS-R1430'
/*AND (select l.buy_qty_due
 from IFSAPP.CUSTOMER_ORDER_LINE l
where l.order_no = W.ORDER_NO
  and l.line_no = W.LINE_NO
  and l.rel_no = W.REL_NO) > W.SALES_QUANTITY*/
 ORDER BY 2, 3, 4, 8
