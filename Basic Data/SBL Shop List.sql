/* Formatted on 4/13/2022 11:39:45 AM (QP5 v5.381) */
SELECT sdi.area_code,
       sdi.district_code,
       nvl(ugft.user_group,sdi.shop_code) shop_code,
       ugft.description     shop_description
  FROM ifsapp.user_group_finance_tab ugft, ifsapp.shop_dts_info sdi
 WHERE     1 = 1
       AND ugft.user_group = sdi.shop_code(+)
       --AND (   :p_shop_code IS NULL OR (UPPER (sdi.shop_code) LIKE UPPER ('%' || :p_shop_code || '%')))
       and (:p_shop_code is null or (ugft.user_group = :p_shop_code))
       AND (   :p_district_code IS NULL OR sdi.district_code = :p_district_code);

--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.shop_dts_info sdi;

SELECT *
  FROM user_group_finance_tab ugft;

--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.user_group_finance ugf;
  
