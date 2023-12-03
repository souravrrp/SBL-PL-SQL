SELECT i.s5 As_At_Date,
       i.S1  "Main Group",
       sum(i.n6) Units_Less_than_3_Months,
       sum(i.n2) Cost_Less_than_3_Months,
       sum(i.N7) Units_Between_4_to_6_Months,
       sum(i.N3) Cost_Between_4_to_6_Months,
       sum(i.n8) Units_Between_7_to_12_Months,
       sum(i.n4) Cost_Between_4_to_6_Months,
       sum(i.N9) Units_Over_12_Months,
       sum(i.n5) Cost_Over_12_Months,
       sum(i.N10) Total_Units,
       sum(i.N11) Total_Cost
FROM ifsapp.info_services_rpv i
WHERE i.RESULT_KEY = '&Report_Key'
GROUP BY i.s5,i.S1
