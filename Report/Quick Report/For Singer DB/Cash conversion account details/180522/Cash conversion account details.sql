/* Formatted on 5/18/2022 9:35:31 AM (QP5 v5.381) */
SELECT h.ACCOUNT_NO,
       h.CATALOG_NO,
       SALES_PART_API.Get_Catalog_Desc (h.CONTRACT, h.CATALOG_NO)
           P_NAME,
       NVL (
           Hpnret_Hp_Head_API.Get_Gross_Hire_Value (h.account_no,
                                                    h.account_rev),
           0)
           gross_sale_value,
       Hpnret_Hp_Head_API.Get_Total_Out_Bal (h.account_no, h.account_rev)
           Out_Bal,
       Hpnret_Hp_Head_API.Get_Total_Amt_Paid (h.account_no, h.account_rev)
           Total_Amt_Paid,
       NVL (CUSTOMER_ORDER_API.Get_Gross_Amount (h.account_no), 0)
           CASH_VALUE_RSP,
         NVL (CUSTOMER_ORDER_API.Get_Gross_Amount (h.account_no), 0)
       - Hpnret_Hp_Head_API.Get_Total_Amt_Paid (h.account_no, h.account_rev)
       + 270
           CASH_BALANCE,
         (  NVL (CUSTOMER_ORDER_API.Get_Gross_Amount (h.account_no), 0)
          + 270
          - Hpnret_Hp_Head_API.Get_Total_Amt_Paid (h.account_no,
                                                   h.account_rev))
       * .04
           CASH_BALANCE_4PER,
       GREATEST (
           (SELECT h.sales_date + t.to_days     cash_conv_date
              FROM Hpnret_Cash_Con_dtl_Tab t
             WHERE     t.product_code = h.catalog_no
                   AND t.level_id =
                       hpnret_level_h_util_api.get_higher_level (
                           hpnret_level_h_util_api.get_channel_site (
                               h.CONTRACT))
                   AND h.sales_date BETWEEN t.eff_from AND t.eff_to
                   AND h.CASH_PRICE > 0),
           h.sales_date + 60)
           CASH_CONVERSION_DATE,
         GREATEST (
             (SELECT h.sales_date + t.to_days     cash_conv_date
                FROM Hpnret_Cash_Con_dtl_Tab t
               WHERE     t.product_code = h.catalog_no
                     AND t.level_id =
                         hpnret_level_h_util_api.get_higher_level (
                             hpnret_level_h_util_api.get_channel_site (
                                 h.CONTRACT))
                     AND h.sales_date BETWEEN t.eff_from AND t.eff_to
                     AND h.CASH_PRICE > 0),
             h.sales_date + 60)
       + 30
           VALIDITY_DATE
  FROM Hpnret_Hp_Dtl_Tab h
 WHERE h.account_no = '&account_no' AND h.CASH_PRICE > 0