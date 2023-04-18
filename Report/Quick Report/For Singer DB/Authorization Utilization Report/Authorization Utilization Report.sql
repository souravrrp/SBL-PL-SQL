select t.account_no "Account No",
       t.variation_db "Variation ID",
       ifsapp.Variation_API.Decode(t.variation_db) "Variation Name",
       to_char(t.from_date, 'YYYY/MM/DD') "Permission Date",
       to_char(t.to_date, 'YYYY/MM/DD') "Last Date",
       t.utilized "Service Utilized",
       t.discount            "Discount",
       t.discount_percentage "Discount Percent",
       t.service_charge      "Service Charge"
  from IFSAPP.HPNRET_AUTH_VARIATION t
 where t.utilized = 1
   and t.variation_db = '&VARIATION'
   and t.from_date between to_date('&FROMDATE', 'YYYY/MM/DD') and to_date('&TODATE', 'YYYY/MM/DD')
 order by t.from_date, t.account_no