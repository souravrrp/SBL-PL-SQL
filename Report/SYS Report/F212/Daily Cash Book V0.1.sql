/* Formatted on 9/5/2022 12:09:05 PM (QP5 v5.381) */
SET DEFINE OFF

SELECT shop_code,
       rsl_no,
       (cash_in + cash_sale + sales_return + hp_penalty + cash_penalty)
           total_cash_in,
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
       rem_neg_com
  FROM (SELECT hrt.contract
                   shop_code,
               hrt.sequence_no
                   rsl_no,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'DOWNINSTALL'
                       AND hrit.contract = hrt.contract
                       AND hrit.sequence_no = hrt.sequence_no)
                   cash_in,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_id = 'CASHSALES'
                       AND hrit.rsl_item_category = 'CASHSALES'
                       AND hrit.contract = hrt.contract
                       AND hrit.sequence_no = hrt.sequence_no)
                   cash_sale,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'SALESRETURN'
                       AND hrit.contract = hrt.contract
                       AND hrit.sequence_no = hrt.sequence_no)
                   sales_return,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'PENALTY'
                       AND hrit.contract = hrt.contract
                       AND hrit.sequence_no = hrt.sequence_no)
                   hp_penalty,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'CASHPENALTY'
                       AND hrit.contract = hrt.contract
                       AND hrit.sequence_no = hrt.sequence_no)
                   cash_penalty,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'FIRSTDUE'
                       AND hrit.rsl_item_category = 'FIRSTDUE'
                       AND hrit.contract = hrt.contract
                       AND hrit.sequence_no = hrt.sequence_no)
                   unpaid_amount,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_category = 'EXPENSE'
                       AND hrit.contract = hrt.contract
                       AND hrit.sequence_no = hrt.sequence_no)
                   expanse_summary,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_category = 'EXPENSE'
                       AND hrit.rsl_item_description IN
                               ('Collecting Commission-SHOP',
                                'CASH Commission - Agent',
                                'CASH Commission - Shop',
                                'HP Commission - Agent',
                                'Transacting Bonus',
                                'HP Commission - Shop',
                                'Collecting Commission-AGENT',
                                'Selling Commission',
                                'Incentives',
                                'Collecting Bonus',
                                'Extending Warranty Commission')
                       AND hrit.contract = hrt.contract
                       AND hrit.sequence_no = hrt.sequence_no)
                   expanse_sum_comm,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_category = 'EXPENSE'
                       AND hrit.rsl_item_description IN
                               ('Special Petty Cash Advance-WH',
                                'Special Petty Cash Advance-SC',
                                'Employee Advance')
                       AND hrit.contract = hrt.contract
                       AND hrit.sequence_no = hrt.sequence_no)
                   expanse_advance,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_category = 'EXPENSE'
                       AND hrit.rsl_item_description IN
                               ('Prime Cash Withdrawal',
                                'Prime Cash Deposit (NOT TO BE USED)',
                                'Prime Cash Withdrawal (NOT TO BE USED)',
                                'LCD/LED TV Installation Charge',
                                'Miscellaneous Exp.',
                                'Legal Fees',
                                'Fees & Others',
                                'Books & Periodicals',
                                'Subscription',
                                'Conveyance - Sales',
                                'Sales Promotion',
                                'Travel - Sales',
                                'Tax & Others',
                                'Wages',
                                'Salaries',
                                'Installation Charges - AC',
                                'Installation Charges - IPS',
                                'Repair & Maintenance',
                                'Cleaning Expense',
                                'Bank Charges',
                                'Entertainment',
                                'Supplies & Stationeries',
                                'Local Freight/Transport Costs - RETAIL',
                                'Postages',
                                'Telephone Bill',
                                'Water Bills',
                                'Electricity',
                                'Store/Godown Rent',
                                'Shop Rent')
                       AND hrit.contract = hrt.contract
                       AND hrit.sequence_no = hrt.sequence_no)
                   expanse_f600,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
                       AND hrit.contract = hrt.contract
                       AND hrit.sequence_no = hrt.sequence_no)
                   rem_sum_add,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
                       AND hrit.contract = hrt.contract
                       AND hrit.sequence_no = hrt.sequence_no
                       AND hrit.rsl_item_description IN
                               ('Excess Payment made by Gift Voucher',
                                'Gift Voucher',
                                'Commission Refund',
                                'Contribution to Provident Fund',
                                'Customer Order Advance Payment',
                                'Hire Purchase Advance Payment',
                                'Late fine',
                                'Employee Security Deposit',
                                'Fidelity Insurence Bond Premium'))
                   rem_advance,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
                       AND hrit.contract = hrt.contract
                       AND hrit.sequence_no = hrt.sequence_no
                       AND hrit.rsl_item_description IN
                               ('bKash Cash In (Cash Out)',
                                'bKash Reimbursable Charges',
                                'Grameenphone BillPay Service',
                                'Grameenphone Flexiload Service',
                                'Cloudwell Flexiload-Billpay Service',
                                'Cloudwell Cash In (Cash Out)',
                                'Prime Cash Deposit',
                                'Prime Cash Account Opening Fee',
                                'City Bank Billpay Service'))
                   rem_fin_service,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
                       AND hrit.contract = hrt.contract
                       AND hrit.sequence_no = hrt.sequence_no
                       AND hrit.rsl_item_description IN
                               ('Payments for Other Customer Invoices Head Office',
                                'Settlement Of Over and Short Remittance',
                                '(Short)/Over Remittance Adjust Legacy',
                                '(Shot)/Over Remit Adjust (Legacy) (NOT TO BE USED)',
                                'BM Trade-In Remittance (Not Active)',
                                'Staff Purchase',
                                'Trade-In Remittance',
                                'UR Adjustments',
                                'Branch Total Open Amount - Previous Week',
                                'Payments for Other Customer Invoices Head Office'))
                   rem_corp_afr,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
                       AND hrit.contract = hrt.contract
                       AND hrit.sequence_no = hrt.sequence_no
                       AND hrit.rsl_item_description = 'Negative Commissions')
                   rem_neg_com,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'EXPENSE'
                       AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
                       AND hrit.contract = hrt.contract
                       AND hrit.sequence_no = hrt.sequence_no)
                   rem_sum_less,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'RECEIPT'
                       AND hrit.rsl_item_category = 'DOCCUMENTSUMMARY'
                       AND hrit.contract = hrt.contract
                       AND hrit.sequence_no = hrt.sequence_no)
                   total_bank_doc,
               (SELECT SUM (hrit.amount)     val_amount
                  FROM hpnret_rsl_item_tab hrit
                 WHERE     1 = 1
                       AND hrit.rsl_item_type = 'EXPENSE'
                       AND hrit.rsl_item_category = 'CREDITSALEADJUSTMENT'
                       AND hrit.contract = hrt.contract
                       AND hrit.sequence_no = hrt.sequence_no)
                   credit_sales
          FROM hpnret_rsl_tab hrt
         WHERE     1 = 1
               AND hrt.contract = 'DUTB'
               AND hrt.sequence_no = 'DUTRSL-741')