/* Formatted on 9/13/2022 9:47:35 AM (QP5 v5.381) */
SELECT shop_code,
       rsl_start_date,
       (cash_in + cash_sale + sales_return + hp_penalty + cash_penalty)
           total_cash_in,
       cash_in,
       cash_sale,
       sales_return,
       hp_penalty,
       cash_penalty,
       expanse_summary
           total_expanse,
       expanse_sum_comm
           expanse_commision,
       expanse_f600,
       expanse_advance,
       (expanse_summary - (expanse_sum_comm + expanse_advance + expanse_f600))
           expanse_others,
       rem_sum_add
           total_remittance,
       rem_advance,
       rem_fin_service,
       rem_corp_afr,
       rem_neg_com,
       rem_sum_less,
       total_bank_doc,
       credit_sales,
       (  (cash_in + cash_sale + sales_return + hp_penalty + cash_penalty)
        - (expanse_summary + total_bank_doc))
           cash_in_hand
  FROM (SELECT hrt.shop_code
                   shop_code,
               (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR') + 1
                  FROM hpnret_rsl_tab rsl
                 WHERE     1 = 1
                       AND rsl.contract = hrt.shop_code
                       AND rsl.row_type = 'RSL')
                   rsl_start_date,
               (SELECT NVL (SUM (hrit.amount), 0)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'DOWNINSTALL'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE     1 = 1
                                   AND rsl.contract = hrt.shop_code
                                   AND rsl.row_type = 'RSL'))
                   cash_in,
               (SELECT NVL (SUM (hrit.amount), 0)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_id = 'CASHSALES'
                       AND hrit.rsl_item_category = 'CASHSALES'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE     1 = 1
                                   AND rsl.contract = hrt.shop_code
                                   AND rsl.row_type = 'RSL'))
                   cash_sale,
               (SELECT NVL (SUM (hrit.amount), 0)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'SALESRETURN'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE     1 = 1
                                   AND rsl.contract = hrt.shop_code
                                   AND rsl.row_type = 'RSL'))
                   sales_return,
               (SELECT NVL (SUM (hrit.amount), 0)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'PENALTY'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE     1 = 1
                                   AND rsl.contract = hrt.shop_code
                                   AND rsl.row_type = 'RSL'))
                   hp_penalty,
               (SELECT NVL (SUM (hrit.amount), 0)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'CASHPENALTY'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE     1 = 1
                                   AND rsl.contract = hrt.shop_code
                                   AND rsl.row_type = 'RSL'))
                   cash_penalty,
               (SELECT NVL (SUM (hrit.amount), 0)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'FIRSTDUE'
                       AND hrit.rsl_item_category = 'FIRSTDUE'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE     1 = 1
                                   AND rsl.contract = hrt.shop_code
                                   AND rsl.row_type = 'RSL'))
                   unpaid_amount,
               (SELECT NVL (SUM (hrit.amount), 0)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_category = 'EXPENSE'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE     1 = 1
                                   AND rsl.contract = hrt.shop_code
                                   AND rsl.row_type = 'RSL'))
                   expanse_summary,
               (SELECT NVL (SUM (hrit.amount), 0)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_category = 'EXPENSE'
                       AND hrit.RSL_ITEM_ID IN ('BE002',
                                                'BE007',
                                                'BE006',
                                                'BE009',
                                                'BE010',
                                                'BE008',
                                                'BE039',
                                                'BE001',
                                                'BE010',
                                                'BE003',
                                                'BE005')
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE     1 = 1
                                   AND rsl.contract = hrt.shop_code
                                   AND rsl.row_type = 'RSL'))
                   expanse_sum_comm,
               (SELECT NVL (SUM (hrit.amount), 0)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_category = 'EXPENSE'
                       AND hrit.RSL_ITEM_ID IN ('BE050', 'BE051', 'BE040')
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE     1 = 1
                                   AND rsl.contract = hrt.shop_code
                                   AND rsl.row_type = 'RSL'))
                   expanse_advance,
               (SELECT NVL (SUM (hrit.amount), 0)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_category = 'EXPENSE'
                       AND hrit.RSL_ITEM_ID IN ('BA044',
                                                'BA043',
                                                'BE042',
                                                'BE043',
                                                'BE036',
                                                'BE023',
                                                'BE035',
                                                'BE034',
                                                'BE033',
                                                'BE032',
                                                'BE022',
                                                'BE017',
                                                'BE031',
                                                'BE030',
                                                'BE029',
                                                'BE027',
                                                'BE026',
                                                'BE025',
                                                'BE024',
                                                'BE021',
                                                'BE020',
                                                'BE019',
                                                'BE018',
                                                'BE016',
                                                'BE015',
                                                'BE014',
                                                'BE013',
                                                'BE012',
                                                'BE011')
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE     1 = 1
                                   AND rsl.contract = hrt.shop_code
                                   AND rsl.row_type = 'RSL'))
                   expanse_f600,
               (SELECT NVL (SUM (hrit.amount), 0)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE     1 = 1
                                   AND rsl.contract = hrt.shop_code
                                   AND rsl.row_type = 'RSL'))
                   rem_sum_add,
               (SELECT NVL (SUM (hrit.amount), 0)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
                       AND hrit.RSL_ITEM_ID IN ('GVOVERPAY',
                                                'GV',
                                                'DDCMR',
                                                'APPFC',
                                                '586A',
                                                'HP586',
                                                'LFINE',
                                                'APESD',
                                                'APFIB')
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE     1 = 1
                                   AND rsl.contract = hrt.shop_code
                                   AND rsl.row_type = 'RSL'))
                   rem_advance,
               (SELECT NVL (SUM (hrit.amount), 0)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
                       AND hrit.RSL_ITEM_ID IN ('BKOIN',
                                                'BKRIM',
                                                'APGPB',
                                                'APGPF',
                                                'CWBP',
                                                'CWOIN',
                                                'BL001',
                                                'BI002',
                                                'CBBP')
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE     1 = 1
                                   AND rsl.contract = hrt.shop_code
                                   AND rsl.row_type = 'RSL'))
                   rem_fin_service,
               (SELECT NVL (SUM (hrit.amount), 0)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
                       AND hrit.RSL_ITEM_ID IN ('CUSTINVPAYMENTS',
                                                'OVERSHORT',
                                                'SOAL',
                                                'BI003',
                                                'BL014',
                                                'STF-P',
                                                'APTIR',
                                                'URADJ',
                                                'BCBOPENPREVWEEK',
                                                'CUSTINVPAYMENTS')
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE     1 = 1
                                   AND rsl.contract = hrt.shop_code
                                   AND rsl.row_type = 'RSL'))
                   rem_corp_afr,
               (SELECT NVL (SUM (hrit.amount), 0)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
                       AND hrit.RSL_ITEM_ID = 'Negative Commissions'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE     1 = 1
                                   AND rsl.contract = hrt.shop_code
                                   AND rsl.row_type = 'RSL'))
                   rem_neg_com,
               (SELECT NVL (SUM (hrit.amount), 0)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'EXPENSE'
                       AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE     1 = 1
                                   AND rsl.contract = hrt.shop_code
                                   AND rsl.row_type = 'RSL'))
                   rem_sum_less,
               (SELECT NVL (SUM (hrit.amount), 0)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'DOCCUMENTSUMMARY'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE     1 = 1
                                   AND rsl.contract = hrt.shop_code
                                   AND rsl.row_type = 'RSL'))
                   total_bank_doc,
               (SELECT NVL (SUM (hrit.amount), 0)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'EXPENSE'
                       AND hrit.rsl_item_category = 'CREDITSALEADJUSTMENT'
                       AND hrit.contract = hrt.shop_code
                       AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                           (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                              FROM hpnret_rsl_tab rsl
                             WHERE     1 = 1
                                   AND rsl.contract = hrt.shop_code
                                   AND rsl.row_type = 'RSL'))
                   credit_sales
          FROM shop_dts_info hrt
         WHERE 1 = 1 AND hrt.shop_code = 'DUTB')