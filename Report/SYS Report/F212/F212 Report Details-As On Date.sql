/* Formatted on 9/5/2022 2:45:15 PM (QP5 v5.381) */
SELECT shop_code,
       (cash_in + cash_sale + sales_return + hp_penalty + cash_penalty)
           total_cash_in,
       expanse_summary
           total_expanse,
       rem_sum_add
           total_remittance
  FROM (SELECT hrt.shop_code
                   shop_code,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'DOWNINSTALL'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE 1 = 1 AND rsl.contract = hrt.shop_code))
                   cash_in,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_id = 'CASHSALES'
                       AND hrit.rsl_item_category = 'CASHSALES'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE 1 = 1 AND rsl.contract = hrt.shop_code))
                   cash_sale,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'SALESRETURN'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE 1 = 1 AND rsl.contract = hrt.shop_code))
                   sales_return,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'PENALTY'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE 1 = 1 AND rsl.contract = hrt.shop_code))
                   hp_penalty,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'CASHPENALTY'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE 1 = 1 AND rsl.contract = hrt.shop_code))
                   cash_penalty,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'FIRSTDUE'
                       AND hrit.rsl_item_category = 'FIRSTDUE'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE 1 = 1 AND rsl.contract = hrt.shop_code))
                   unpaid_amount,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_category = 'EXPENSE'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE 1 = 1 AND rsl.contract = hrt.shop_code))
                   expanse_summary,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE 1 = 1 AND rsl.contract = hrt.shop_code))
                   rem_sum_add,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'EXPENSE'
                       AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE 1 = 1 AND rsl.contract = hrt.shop_code))
                   rem_sum_less,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'DOCCUMENTSUMMARY'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE 1 = 1 AND rsl.contract = hrt.shop_code))
                   total_bank_doc,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'EXPENSE'
                       AND hrit.rsl_item_category = 'CREDITSALEADJUSTMENT'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE 1 = 1 AND rsl.contract = hrt.shop_code))
                   credit_sales
          FROM shop_dts_info hrt
         WHERE 1 = 1 AND hrt.shop_code = 'DUTB')