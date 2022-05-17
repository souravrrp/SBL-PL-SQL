/* Formatted on 4/5/2022 1:34:18 PM (QP5 v5.381) */
SELECT *
  FROM ifsapp.hpnret_rsl hr
 WHERE     1 = 1
       --AND hr.contract = 'DGNB'
       AND (   :p_shop_code IS NULL
            OR (UPPER (hr.contract) = UPPER ( :p_shop_code)))
       AND hr.from_date BETWEEN TO_DATE ('&FROM_DATE', 'YYYY/MM/DD')
                            AND TO_DATE ('&TO_DATE', 'YYYY/MM/DD');


SELECT * FROM ifsapp.user_allowed_site_lov2;