select t.account_no "Account No",
       t.variation_db "Variation ID",
       Variation_API.Decode(t.variation_db) "Variation Name",
       to_char(t.from_date, 'YYYY/MM/DD') "Permission Date",
       to_char(t.to_date, 'YYYY/MM/DD') "Last Date",
       t.utilized "Service Utilized",
       t.discount            "Discount",
       t.discount_percentage "Discount Percent",
       t.service_charge      "Service Charge" /*count(*)*/
  from IFSAPP.HPNRET_AUTH_VARIATION t
 where t.utilized = 1
   and t.variation_db = '&variation'
   and t.to_date >= to_date('&fromdate', 'YYYY/MM/DD')
   and t.from_date <= to_date('&todate', 'YYYY/MM/DD')
   /*and t.to_date between to_date('&fromdate', 'YYYY/MM/DD') and to_date('&todate', 'YYYY/MM/DD')*/
   /*and t.service_charge > 0*/
 order by t.from_date, t.account_no;
--and t.variation = Variation_API.encode('&client_code');
/*Variation ID
1 = Early Closure
2 = Exchange
3 = Return
4 = Term Extension
5 = Revert Reverse
6 = Cash Conversion
8 = Transfer Account
9 = Assume
10 = CO Exchange
11 = CO Returns*/
