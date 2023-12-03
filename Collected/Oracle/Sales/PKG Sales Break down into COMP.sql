--****** PKG Sales Break down into COMP
select P.INVOICE_ID,
       P.ITEM_ID,
       p.c10 "SITE",
       p.c1 ORDER_NO,
       p.c2 LINE_NO,
       p.c3 REL_NO,
       L.LINE_ITEM_NO,
       CASE
         WHEN SUBSTR(p.c1, 4, 2) = '-H' THEN
          (select D.LINE_NO
             from IFSAPP.HPNRET_HP_DTL_TAB D
            where D.ACCOUNT_NO = p.c1
              AND D.REF_LINE_NO = p.c2
              AND D.REF_REL_NO = p.c3
              AND D.CATALOG_NO = L.CATALOG_NO)
         ELSE
          p.c4
       END ACCT_LINE_NO,
       case
         when p.net_curr_amount = 0 then
          ifsapp.GET_SBL_FREE_ISSUE_LINE_STATE(p.invoice_id, p.item_id, p.c1)
         else
          ifsapp.get_sbl_account_status(p.c1,
                                        p.c2,
                                        p.c3,
                                        p.c5,
                                        p.net_curr_amount,
                                        P.SALES_DATE)
       end status,
       P.SALES_DATE,
       p.identity CUSTOMER_NO,
       (select c.vendor_no
          from ifsapp.CUSTOMER_ORDER_LINE c
         where c.order_no = p.c1
           and c.line_no = p.c2
           and c.rel_no = p.c3
           and c.line_item_no = p.n1) DELIVERY_SITE,
       L.CATALOG_NO PRODUCT_CODE,
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
              IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group(p.c10,
                                                                                             L.CATALOG_NO)),
              IFSAPP.COMMODITY_GROUP_API.Get_Description(IFSAPP.INVENTORY_PART_API.Get_Second_Commodity(p.c10,
                                                                                                        L.CATALOG_NO))) commodity_group2,
       IFSAPP.SALES_GROUP_API.Get_Description(IFSAPP.SALES_PART_API.Get_Catalog_Group(p.c10,
                                                                                      L.CATALOG_NO)) sales_group,
       IFSAPP.SALES_PART_API.Get_Catalog_Type(L.CATALOG_NO) Catalog_Type,
       L.QTY_INVOICED SALES_QUANTITY,
       ROUND(L.PART_PRICE, 2) UNIT_NSP,
       p.n5 "DISCOUNT(%)",
       IFSAPP.CUSTOMER_ORDER_LINE_API.Get_Sale_Price_Total(p.c1,
                                                           p.c2,
                                                           p.c3,
                                                           L.LINE_ITEM_NO) SALES_PRICE,
       L.FEE_CODE vat_code,
       IFSAPP.STATUTORY_FEE_API.Get_Fee_Rate('SBL', L.FEE_CODE) VAT_RATE,
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
             2) AMOUNT_RSP,
       ROUND(L.COST, 2) "COST",
       ROUND((L.COST * L.QTY_INVOICED), 2) TOTAL_COST,
       p.pay_term_id,
       p.series_id,
       p.invoice_no,
       p.voucher_type_ref,
       p.voucher_no_ref,
       p.voucher_date_ref,
       p.bb_no
  from IFSAPP.CUSTOMER_ORDER_LINE_TAB L
  LEFT JOIN (select t.*,
                    i.invoice_date SALES_DATE,
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
                and t.rowstate = 'Posted'
                and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) = 'PKG') p
    ON L.ORDER_NO = P.c1
   AND L.LINE_NO = P.c2
   AND L.REL_NO = P.c3
 where L.CATALOG_TYPE = 'KOMP'
   AND P.SALES_DATE between to_date('&from_date', 'yyyy/mm/dd') and
       to_date('&to_date', 'yyyy/mm/dd')
