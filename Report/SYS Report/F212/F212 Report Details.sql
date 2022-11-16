/* Formatted on 9/5/2022 9:17:56 AM (QP5 v5.381) */
SELECT hrt.contract                                       shop_code,
       hrt.sequence_no                                    rsl_no,
       (SELECT SUM (hrit.amount)     val_amount
          FROM hpnret_rsl_item_tab hrit
         WHERE     1 = 1
               AND hrit.rsl_item_type = 'RECEIPT'
               AND hrit.rsl_item_category = 'DOWNINSTALL'
               AND hrit.contract = hrt.contract
               AND hrit.sequence_no = hrt.sequence_no)    cash_in,
       (SELECT SUM (hrit.amount)     val_amount
          FROM hpnret_rsl_item_tab hrit
         WHERE     1 = 1
               AND hrit.rsl_item_id = 'CASHSALES'
               AND hrit.rsl_item_category = 'CASHSALES'
               AND hrit.contract = hrt.contract
               AND hrit.sequence_no = hrt.sequence_no)    cash_sale,
       (SELECT SUM (hrit.amount)     val_amount
          FROM hpnret_rsl_item_tab hrit
         WHERE     1 = 1
               AND hrit.rsl_item_type = 'RECEIPT'
               AND hrit.rsl_item_category = 'SALESRETURN'
               AND hrit.contract = hrt.contract
               AND hrit.sequence_no = hrt.sequence_no)    sales_return,
       (SELECT SUM (hrit.amount)     val_amount
          FROM hpnret_rsl_item_tab hrit
         WHERE     1 = 1
               AND hrit.rsl_item_type = 'RECEIPT'
               AND hrit.rsl_item_category = 'PENALTY'
               AND hrit.contract = hrt.contract
               AND hrit.sequence_no = hrt.sequence_no)    hp_penalty,
       (SELECT SUM (hrit.amount)     val_amount
          FROM hpnret_rsl_item_tab hrit
         WHERE     1 = 1
               AND hrit.rsl_item_type = 'RECEIPT'
               AND hrit.rsl_item_category = 'CASHPENALTY'
               AND hrit.contract = hrt.contract
               AND hrit.sequence_no = hrt.sequence_no)    cash_penalty,
       (SELECT SUM (hrit.amount)     val_amount
          FROM hpnret_rsl_item_tab hrit
         WHERE     1 = 1
               AND hrit.rsl_item_type = 'FIRSTDUE'
               AND hrit.rsl_item_category = 'FIRSTDUE'
               AND hrit.contract = hrt.contract
               AND hrit.sequence_no = hrt.sequence_no)    unpaid_amount,
       (SELECT SUM (hrit.amount)     val_amount
          FROM hpnret_rsl_item_tab hrit
         WHERE     1 = 1
               AND hrit.rsl_item_category = 'EXPENSE'
               AND hrit.contract = hrt.contract
               AND hrit.sequence_no = hrt.sequence_no)    expanse_summary,
       (SELECT SUM (hrit.amount)     val_amount
          FROM hpnret_rsl_item_tab hrit
         WHERE     1 = 1
               AND hrit.rsl_item_type = 'RECEIPT'
               AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
               AND hrit.contract = hrt.contract
               AND hrit.sequence_no = hrt.sequence_no)    rem_sum_add,
       (SELECT SUM (hrit.amount)     val_amount
          FROM hpnret_rsl_item_tab hrit
         WHERE     1 = 1
               AND hrit.rsl_item_type = 'EXPENSE'
               AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
               AND hrit.contract = hrt.contract
               AND hrit.sequence_no = hrt.sequence_no)    rem_sum_less,
       (SELECT SUM (hrit.amount)     val_amount
          FROM hpnret_rsl_item_tab hrit
         WHERE     1 = 1
               AND hrit.rsl_item_type = 'RECEIPT'
               AND hrit.rsl_item_category = 'DOCCUMENTSUMMARY'
               AND hrit.contract = hrt.contract
               AND hrit.sequence_no = hrt.sequence_no)    total_bank_doc,
       (SELECT SUM (hrit.amount)     val_amount
          FROM hpnret_rsl_item_tab hrit
         WHERE     1 = 1
               AND hrit.rsl_item_type = 'EXPENSE'
               AND hrit.rsl_item_category = 'CREDITSALEADJUSTMENT'
               AND hrit.contract = hrt.contract
               AND hrit.sequence_no = hrt.sequence_no)    credit_sales
  FROM hpnret_rsl_tab hrt
 WHERE 1 = 1 AND hrt.contract = 'DUTB' AND hrt.sequence_no = 'DUTRSL-741'