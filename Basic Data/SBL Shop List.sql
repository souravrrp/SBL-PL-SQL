/* Formatted on 4/13/2022 11:39:45 AM (QP5 v5.381) */
SELECT sdi.area_code,
       sdi.district_code,
       sdi.shop_code,
       ugft.description     shop_description
  FROM ifsapp.shop_dts_info sdi, ifsapp.user_group_finance_tab ugft
 WHERE     1 = 1
       AND sdi.shop_code = ugft.user_group
       AND (   :p_shop_code IS NULL
            OR (UPPER (sdi.shop_code) LIKE UPPER ('%' || :p_shop_code || '%')));

--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.shop_dts_info sdi;

SELECT *
  FROM user_group_finance_tab ugft;

--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.user_group_finance ugf;