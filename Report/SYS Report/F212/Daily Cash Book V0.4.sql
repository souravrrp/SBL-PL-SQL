SELECT shop_code,
         rsl_start_date,
         ifsapp.cash_book_opening_balance (shop_code, rsl_start_date) opening_balance,
         (  SUM (cash_in)
          + SUM (cash_sale)
          + SUM (sales_return)
          + SUM (hp_penalty)
          + SUM (cash_penalty))
             total_cash_in,
         SUM (cash_in)
             cash_in,
         SUM (cash_sale)
             cash_sale,
         SUM (sales_return)
             sales_return,
         SUM (hp_penalty)
             hp_penalty,
         SUM (cash_penalty)
             cash_penalty,
         SUM (expanse_summary)
             total_expanse,
         SUM (expanse_sum_comm)
             expanse_commision,
         SUM (expanse_f600)
             expanse_f600,
         SUM (expanse_advance)
             expanse_advance,
         (  SUM (expanse_summary)
          - (  SUM (expanse_sum_comm)
             + SUM (expanse_advance)
             + SUM (expanse_f600)))
             expanse_others,
         (  (  SUM (cash_in)
             + SUM (cash_sale)
             + SUM (sales_return)
             + SUM (hp_penalty)
             + SUM (cash_penalty))
          - SUM (expanse_summary))
             remittable_amount,
         (  SUM (cash_in)
          + SUM (cash_sale)
          + SUM (sales_return)
          + SUM (hp_penalty)
          + SUM (cash_penalty)
          + SUM (rem_advance)
          + SUM (rem_fin_service)
          + SUM (rem_corp_afr)
          + NVL (SUM (rem_neg_com), 0)
          + SUM (rem_sum_less)
          - SUM (expanse_summary))
             total_remittance,
         SUM (rem_advance)
             rem_advance,
         SUM (rem_fin_service)
             rem_fin_service,
         SUM (rem_corp_afr)
             rem_corp_afr,
         NVL (SUM (rem_neg_com), 0)
             rem_neg_com,
         SUM (rem_sum_less)
             rem_sum_less,
         SUM (total_bank_doc)
             total_bank_doc,
         SUM (credit_sales)
             credit_sales,
         (  (  SUM (cash_in)
             + SUM (cash_sale)
             + SUM (sales_return)
             + SUM (hp_penalty)
             + SUM (cash_penalty)
             + SUM (rem_advance)
             + SUM (rem_fin_service)
             + SUM (rem_corp_afr)
             + NVL (SUM (rem_neg_com), 0)
             + SUM (rem_sum_less))
          - (SUM (expanse_summary) + SUM (total_bank_doc)))
             cash_in_hand
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
                        WHEN     hrit.rsl_item_type = 'FIRSTDUE'
                             AND hrit.rsl_item_category = 'FIRSTDUE'
                        THEN
                            NVL (SUM (hrit.amount), 0)
                    END)                                       unpaid_amount,
                   (CASE
                        WHEN hrit.rsl_item_category = 'EXPENSE'
                        THEN
                            NVL (SUM (hrit.amount), 0)
                    END)                                       expanse_summary,
                   (CASE
                        WHEN     hrit.rsl_item_category = 'EXPENSE'
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
                        THEN
                            NVL (SUM (hrit.amount), 0)
                    END)                                       expanse_sum_comm,
                   (CASE
                        WHEN     hrit.rsl_item_category = 'EXPENSE'
                             AND hrit.RSL_ITEM_ID IN ('BE050', 'BE051', 'BE040')
                        THEN
                            NVL (SUM (hrit.amount), 0)
                    END)                                       expanse_advance,
                   (CASE
                        WHEN     hrit.rsl_item_category = 'EXPENSE'
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
                        THEN
                            NVL (SUM (hrit.amount), 0)
                    END)                                       expanse_f600,
                   (CASE
                        WHEN     hrit.rsl_item_type = 'RECEIPT'
                             AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
                        THEN
                            NVL (SUM (hrit.amount), 0)
                    END)                                       rem_sum_add,
                   (CASE
                        WHEN     hrit.rsl_item_type = 'RECEIPT'
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
                        THEN
                            NVL (SUM (hrit.amount), 0)
                    END)                                       rem_advance,
                   (CASE
                        WHEN     hrit.rsl_item_type = 'RECEIPT'
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
                        THEN
                            NVL (SUM (hrit.amount), 0)
                    END)                                       rem_fin_service,
                   (CASE
                        WHEN     hrit.rsl_item_type = 'RECEIPT'
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
                        THEN
                            NVL (SUM (hrit.amount), 0)
                    END)                                       rem_corp_afr,
                   (CASE
                        WHEN     hrit.rsl_item_type = 'RECEIPT'
                             AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
                             AND hrit.RSL_ITEM_ID = 'Negative Commissions'
                        THEN
                            NVL (SUM (hrit.amount), 0)
                    END)                                       rem_neg_com,
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
                    END)                                       total_bank_doc,
                   (CASE
                        WHEN     hrit.rsl_item_type = 'EXPENSE'
                             AND hrit.rsl_item_category = 'CREDITSALEADJUSTMENT'
                        THEN
                            NVL (SUM (hrit.amount), 0)
                    END)                                       credit_sales
              FROM hpnret_rsl_item_tab hrit
             WHERE     1 = 1
                   AND hrit.contract = 'DSCP'
                   AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                       (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                          FROM hpnret_rsl_tab rsl
                         WHERE     1 = 1
                               AND rsl.contract = 'DSCP'
                               AND rsl.row_type = 'RSL')
          GROUP BY hrit.contract,
                   hrit.rsl_item_type,
                   hrit.rsl_item_id,
                   hrit.rsl_item_category,
                   TO_DATE (hrit.rowversion, 'DD-MON-RRRR'))
GROUP BY shop_code, rsl_start_date
ORDER BY rsl_start_date