/* Formatted on 7/20/2022 4:23:39 PM (QP5 v5.381) */
  SELECT t.invoice_id,
         t.c10
             SITE,
         t.c1
             ORDER_NO,
         CASE
             WHEN t.net_curr_amount = 0
             THEN
                 ifsapp.GET_SBL_FREE_ISSUE_LINE_STATE (t.invoice_id,
                                                       t.item_id,
                                                       t.c1)
             ELSE
                 ifsapp.get_sbl_account_status (t.c1,
                                                t.c2,
                                                t.c3,
                                                t.c5,
                                                t.net_curr_amount,
                                                i.invoice_date)
         END
             status,
         TO_CHAR (i.invoice_date, 'YYYY/MM/DD')
             SALES_DATE,
         t.identity
             CUSTOMER_NO,
         ifsapp.customer_info_api.Get_Name (t.identity)
             CUSTOMER_NAME,
         (SELECT c.vendor_no
            FROM ifsapp.CUSTOMER_ORDER_LINE_TAB c
           WHERE     c.order_no = t.c1
                 AND c.line_no = t.c2
                 AND c.rel_no = t.c3
                 AND c.catalog_no = t.c5)
             DELIVERY_SITE,
         t.c5
             PRODUCT_CODE,
         IFSAPP.INVENTORY_PRODUCT_CODE_API.Get_Description (
             ifsapp.inventory_part_api.Get_Part_Product_Code (      /*'SCOM'*/
                                                              t.c10, t.c5))
             brand,
         DECODE (
             IFSAPP.SALES_PART_API.Get_Catalog_Type (T.C5),
             'PKG', ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description (
                        ifsapp.sales_part_api.Get_Part_Product_Family ( /*'SCOM'*/
                                                                       t.c10,
                                                                       t.c5)),
             ifsapp.INVENTORY_PRODUCT_FAMILY_API.Get_Description (
                 ifsapp.inventory_part_api.Get_Part_Product_Family ( /*'SCOM'*/
                                                                    t.c10,
                                                                    t.c5)))
             product_family,
         DECODE (
             IFSAPP.SALES_PART_API.Get_Catalog_Type (T.C5),
             'PKG', IFSAPP.SALES_GROUP_API.Get_Description (
                        IFSAPP.SALES_PART_API.Get_Catalog_Group (   /*'SCOM'*/
                                                                 t.c10, t.c5)),
             IFSAPP.COMMODITY_GROUP_API.Get_Description (
                 IFSAPP.INVENTORY_PART_API.Get_Second_Commodity (   /*'SCOM'*/
                                                                 t.c10, t.c5)))
             commodity_group2,
         IFSAPP.SALES_GROUP_API.Get_Description (
             IFSAPP.SALES_PART_API.Get_Catalog_Group (              /*'SCOM'*/
                                                      t.c10, t.c5))
             sales_group,
         /*(select g.product_group
            from ifsapp.product_category_info p
           inner join ifsapp.product_info g
              on p.group_no = g.group_no
           where p.product_code = t.c5) product_group,*/
         IFSAPP.SALES_PART_API.Get_Catalog_Type (T.C5)
             Catalog_Type,
         CASE
             WHEN t.net_curr_amount != 0
             THEN
                 (t.n2 * (t.net_curr_amount / ABS (t.net_curr_amount)))
             ELSE
                 IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN (t.invoice_id,
                                                     t.item_id,
                                                     T.N2)              --t.n2
         END
             SALES_QUANTITY,
         t.net_curr_amount
             SALES_PRICE,
         CASE
             WHEN t.net_curr_amount != 0
             THEN
                   (SELECT l.base_sale_unit_price
                      FROM CUSTOMER_ORDER_LINE l
                     WHERE     l.order_no = t.c1
                           AND l.line_no = t.c2
                           AND l.rel_no = t.c3
                           AND l.catalog_no = t.c5)
                 * (t.net_curr_amount / ABS (t.net_curr_amount))
             ELSE
                 (SELECT l.base_sale_unit_price
                    FROM CUSTOMER_ORDER_LINE l
                   WHERE     l.order_no = t.c1
                         AND l.line_no = t.c2
                         AND l.rel_no = t.c3
                         AND l.catalog_no = t.c5)
         END
             UNIT_NSP,
         t.n5
             "DISCOUNT(%)",
         /*t.vat_code,
         IFSAPP.STATUTORY_FEE_API.Get_Fee_Rate('SBL', t.vat_code) vat_rate,*/
         t.vat_curr_amount
             VAT,
         t.net_curr_amount + t.vat_curr_amount
             "AMOUNT(RSP)",
         ROUND (
             (SELECT c.cost
                FROM ifsapp.INVENT_ONLINE_COST_TAB c
               WHERE     c.year = EXTRACT (YEAR FROM i.invoice_date)
                     AND c.period = EXTRACT (MONTH FROM i.invoice_date)
                     AND c.contract = t.c10
                     AND c.part_no = t.c5),
             2)
             unit_cost,
         ROUND (
               (CASE
                    WHEN t.net_curr_amount != 0
                    THEN
                        (t.n2 * (t.net_curr_amount / ABS (t.net_curr_amount)))
                    ELSE
                        IFSAPP.GET_SBL_FREE_ITEM_SALES_QTN (t.invoice_id,
                                                            t.item_id,
                                                            T.N2)       --t.n2
                END)
             * (SELECT c.cost
                  FROM ifsapp.INVENT_ONLINE_COST_TAB c
                 WHERE     c.year = EXTRACT (YEAR FROM i.invoice_date)
                       AND c.period = EXTRACT (MONTH FROM i.invoice_date)
                       AND c.contract = t.c10
                       AND c.part_no = t.c5),
             2)
             total_cost,
         --t.c2 LINE_NO,
         --t.c3 REL_NO,
         --t.c6,
         --t.c13 CUSTOMER_NO,
         --t.n4,
         i.pay_term_id,
         (SELECT h.cash_conv
            FROM HPNRET_CUSTOMER_ORDER_TAB h
           WHERE h.order_no = t.c1)
             CASH_CONV,
         (SELECT h.Remarks
            FROM HPNRET_CUSTOMER_ORDER_TAB h
           WHERE h.order_no = t.c1)
             REMARKS,
         CASE
             WHEN t.net_curr_amount >= 0
             THEN
                 (SELECT d.Amt_Finance
                    FROM HPNRET_HP_DTL_TAB d
                   WHERE     d.account_no = t.c1
                         AND d.ref_line_no = t.c2
                         AND d.ref_rel_no = t.c3
                         AND d.catalog_no = t.c5)
             ELSE
                 0
         END
             Amt_Finance,
         CASE
             WHEN t.net_curr_amount >= 0
             THEN
                 (SELECT d.down_payment
                    FROM HPNRET_HP_DTL_TAB d
                   WHERE     d.account_no = t.c1
                         AND d.ref_line_no = t.c2
                         AND d.ref_rel_no = t.c3
                         AND d.catalog_no = t.c5)
             ELSE
                 0
         END
             down_payment,
         CASE
             WHEN t.net_curr_amount >= 0
             THEN
                 (SELECT hd.length_of_contract
                    FROM HPNRET_HP_HEAD_TAB hd
                   WHERE hd.account_no = t.c1)
             ELSE
                 0
         END
             length_of_contract,
         CASE
             WHEN t.net_curr_amount >= 0
             THEN
                 (SELECT d.install_amt
                    FROM HPNRET_HP_DTL_TAB d
                   WHERE     d.account_no = t.c1
                         AND d.ref_line_no = t.c2
                         AND d.ref_rel_no = t.c3
                         AND d.catalog_no = t.c5)
             ELSE
                 0
         END
             install_amt,
         CASE
             WHEN t.net_curr_amount >= 0
             THEN
                 (SELECT d.service_charge
                    FROM HPNRET_HP_DTL_TAB d
                   WHERE     d.account_no = t.c1
                         AND d.ref_line_no = t.c2
                         AND d.ref_rel_no = t.c3
                         AND d.catalog_no = t.c5)
             ELSE
                 0
         END
             service_charge
    FROM ifsapp.invoice_item_tab t, ifsapp.INVOICE_TAB i
   WHERE     t.invoice_id = i.invoice_id
         AND t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
         AND t.rowstate = 'Posted'
         AND IFSAPP.SALES_PART_API.Get_Catalog_Type (T.C5) IN ('INV', 'PKG' /*, 'NON'*/
                                                                           )
         AND t.c10 NOT IN ('BSCP',
                           'BLSP',
                           'CLSP',
                           'CSCP',
                           'CXSP',
                           'DSCP',
                           'JSCP',
                           'KSCP',                        --New Service Center
                           'MSCP',
                           'NSCP',                        --New Service Center
                           'RPSP',
                           'RSCP',
                           'SSCP',
                           'MS1C',
                           'MS2C',
                           'BTSC')
         AND i.invoice_date BETWEEN :P_From_Date AND :P_To_Date
ORDER BY t.c10, t.c1, i.invoice_date