/* Formatted on 3/9/2023 12:54:24 PM (QP5 v5.381) */
  SELECT hav.account_no                                     "Account No",
         hav.variation_db                                   "Variation ID",
         ifsapp.Variation_API.DECODE (hav.variation_db)     "Variation Name",
         TO_CHAR (hav.from_date, 'YYYY/MM/DD')              "Permission Date",
         TO_CHAR (hav.TO_DATE, 'YYYY/MM/DD')                "Last Date",
         hav.utilized                                       "Service Utilized",
         hav.discount                                       "Discount",
         hav.discount_percentage                            "Discount Percent",
         hav.service_charge                                 "Service Charge"
    FROM ifsapp.hpnret_auth_variation hav
   WHERE 1=1
   --and hav.utilized = 1
AND (   :p_account_no IS NULL OR (UPPER (hav.account_no) = UPPER ( :p_account_no)))
--AND (   :p_shop_code IS NULL OR (UPPER (substr(hav.account_no,0,3)) = UPPER ( :p_shop_code)))
--AND t.variation_db = '&VARIATION'
--AND hav.from_date between to_date('&FROMDATE', 'YYYY/MM/DD') and to_date('&TODATE', 'YYYY/MM/DD')
ORDER BY hav.from_date, hav.account_no;

--------------------------------------------------------------------------------

--Authorization---Status--
--TransferAccount	8
--Return	        3
--Exchange	        2
--TermExtension	    4
--CO Returns	    11
--Assume	        9
--CO Exchange	    10
--EarlyClosure	    1
--RevertReverse	    5
--CashConversion	6


SELECT hav.account_no,
       hav.variation,
       hav.variation_db,
       TO_CHAR (hav.from_date, 'YYYY/MM/DD')     permission_date
       --,hav.*
  FROM ifsapp.hpnret_auth_variation hav
 WHERE 1 = 1
--AND hav.account_no = 'SCT-R333'
AND (   :p_account_no IS NULL
            OR (UPPER (hav.account_no) = UPPER ( :p_account_no)))
;

--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.hpnret_auth_variation_tab havt
 WHERE 1 = 1 AND havt.account_no = 'SCT-R333';


SELECT *
  FROM ifsapp.hpnret_auth_variation hav
 WHERE 1 = 1 AND hav.account_no = 'SCT-R333';