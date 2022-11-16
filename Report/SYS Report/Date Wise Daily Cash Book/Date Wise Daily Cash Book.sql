/* Formatted on 10/27/2022 10:16:47 AM (QP5 v5.381) */
  SELECT shop_code,
         (  (  SUM (cash_in)
             + SUM (cash_sale)
             + SUM (sales_return)
             + SUM (hp_penalty)
             + SUM (cash_penalty)
             + NVL (SUM (rem_sum_add), 0)
             + SUM (rem_sum_less))
          - (SUM (expanse_summary) + SUM (total_bank_doc)))    closing_balance
    FROM (  SELECT hrit.contract                               shop_code,
                   TO_DATE (hrit.rowversion, 'DD-MON-RRRR')    rsl_start_date,
                   (CASE
                        WHEN     hrit.rsl_item_type = 'RECEIPT'
                             AND hrit.rsl_item_category = 'DOWNINSTALL'
                        THEN
                            NVL (SUM (hrit.amount), 0)
                    END)                                       cash_in,
                   (CASE
                        WHEN     hrit.rsl_item_id = 'CASHSALES'
                             AND hrit.rsl_item_category = 'CASHSALES'
                        THEN
                            NVL (SUM (hrit.amount), 0)
                    END)                                       cash_sale,
                   (CASE
                        WHEN     hrit.rsl_item_type = 'RECEIPT'
                             AND hrit.rsl_item_category = 'SALESRETURN'
                        THEN
                            NVL (SUM (hrit.amount), 0)
                    END)                                       sales_return,
                   (CASE
                        WHEN     hrit.rsl_item_type = 'RECEIPT'
                             AND hrit.rsl_item_category = 'PENALTY'
                        THEN
                            NVL (SUM (hrit.amount), 0)
                    END)                                       hp_penalty,
                   (CASE
                        WHEN     hrit.rsl_item_type = 'RECEIPT'
                             AND hrit.rsl_item_category = 'CASHPENALTY'
                        THEN
                            NVL (SUM (hrit.amount), 0)
                    END)                                       cash_penalty,
                   (CASE
                        WHEN hrit.rsl_item_category = 'EXPENSE'
                        THEN
                            NVL (SUM (hrit.amount), 0)
                    END)                                       expanse_summary,
                   (CASE
                        WHEN     hrit.rsl_item_type = 'RECEIPT'
                             AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
                        THEN
                            NVL (SUM (hrit.amount), 0)
                    END)                                       rem_sum_add,
                   (CASE
                        WHEN     hrit.rsl_item_type = 'EXPENSE'
                             AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
                        THEN
                            NVL (SUM (hrit.amount), 0)
                    END)                                       rem_sum_less,
                   (CASE
                        WHEN     hrit.rsl_item_type = 'RECEIPT'
                             AND hrit.rsl_item_category = 'DOCCUMENTSUMMARY'
                        THEN
                            NVL (SUM (hrit.amount), 0)
                    END)                                       total_bank_doc
              FROM hpnret_rsl_item_tab hrit
             WHERE TO_DATE (hrit.rowversion, 'DD-MON-RRRR') BETWEEN (SELECT   TO_DATE (
                                                                                  MAX (
                                                                                      rsl.TO_DATE),
                                                                                  'DD-MON-RRRR')
                                                                            + 1
                                                                       FROM hpnret_rsl_tab
                                                                            rsl
                                                                      WHERE rsl.row_type =
                                                                            'RSL')
                                                                AND TO_DATE (
                                                                        :p_as_on_date,
                                                                        'DD-MON-RRRR')
          --AND hrit.contract = 'DUTB'
          GROUP BY hrit.contract,
                   hrit.rsl_item_type,
                   hrit.rsl_item_id,
                   hrit.rsl_item_category,
                   TO_DATE (hrit.rowversion, 'DD-MON-RRRR'))
GROUP BY shop_code;