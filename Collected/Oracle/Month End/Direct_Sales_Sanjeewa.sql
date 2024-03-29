SELECT '&Year' YEAR,
       '&Period' Period,
       NN.sales_part Sales_Part,
       SUM(NN.TOTAL_CASH_UNITS) Cash_Units,
       SUM(NN.CASH_VALUE) Cash_Value,
       SUM(NN.TOTAL_HIRE_UNITS) Hire_Units, 
       SUM(NN.TOTAL_CASH_UNITS) +  SUM(NN.TOTAL_HIRE_UNITS) Total_Sales_Units,      
       (SUM(NN.TOTAL_NET_HIRE_CASH_VALUE + NN.REVERTS_VALUE -NN.REVERT_REVERSE_VALUE)) HIre_Cash_Value,
       SUM(NN.REVT_CASH_PRICE) Revert_Cash_Value,
       SUM(NN.REVTREV_CASH_PRICE) Revtrev_Cash_Value,
       (SUM(NN.TOTAL_NET_HIRE_CASH_VALUE + NN.REVERTS_VALUE -NN.REVERT_REVERSE_VALUE)-SUM(NN.REVT_CASH_PRICE)+SUM(NN.REVTREV_CASH_PRICE)+SUM(NN.CASH_VALUE)) Total_Value
FROM IFSAPP.HPNRET_DIRECT_SALES NN
WHERE nn.year = '&Year'
AND nn.period = '&Period'
AND NN.CATALOG_TYPE NOT IN ('PKG')
GROUP BY NN.sales_part
ORDER BY NN.sales_part
