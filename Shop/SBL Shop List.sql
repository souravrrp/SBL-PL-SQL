/* Formatted on 3/30/2023 2:12:31 PM (QP5 v5.381) */
SELECT sdi.area_code,
       sdi.district_code,
       NVL (ugft.user_group, sdi.shop_code)    shop_code,
       ugft.description                        shop_description,
       CASE
           WHEN NVL (ugft.user_group, sdi.shop_code) IN ('JWSS',
                                                         'SAOS',
                                                         'SWSS',
                                                         'WSMO',
                                                         'WITM')
           THEN
               'WHOLESALE'
           WHEN NVL (ugft.user_group, sdi.shop_code) = 'SCSM'
           THEN
               'CORPORATE'
           WHEN NVL (ugft.user_group, sdi.shop_code) = 'SITM'
           THEN
               'IT CHANNEL'
           WHEN NVL (ugft.user_group, sdi.shop_code) = 'SSAM'
           THEN
               'SMALL APPLIANCE CHANNEL'
           WHEN NVL (ugft.user_group, sdi.shop_code) = 'SOSM'
           THEN
               'ONLINE CHANNEL'
           WHEN NVL (ugft.user_group, sdi.shop_code) IN ('SAPM',
                                                         'SESM',
                                                         'SHOM',
                                                         'SISM',
                                                         'SFSM')
           THEN
               'STAFF SCRAP AND ACQUISITION'
           WHEN NVL (ugft.user_group, sdi.shop_code) LIKE '%WW'
           THEN
               'WHOLESALE WAREHOUSE'
           WHEN NVL (ugft.user_group, sdi.shop_code) LIKE '%CW'
           THEN
               'CORPORATE WAREHOUSE'
           WHEN ugft.description LIKE '%(Damage)%'
           THEN
               'DAMAGE WAREHOUSE'
           WHEN UPPER (ugft.description) LIKE '%WARE%HOUSE%'
           THEN
               'RETAIL WAREHOUSE'
           WHEN    SUBSTR (NVL (ugft.user_group, sdi.shop_code), 3, 2) = 'SP'
                OR SUBSTR (NVL (ugft.user_group, sdi.shop_code), 3, 2) = 'CP'
                OR NVL (ugft.user_group, sdi.shop_code) = 'SC'
           THEN
               'SERVICE CENTER'
           WHEN sdi.shop_code IS NOT NULL
           THEN
               'RETAIL'
           WHEN UPPER (ugft.description) LIKE '%FACTORY%'
           THEN
               'FACTORY'
           ELSE
               'OTHERS'
       END                                     sales_channel
  FROM ifsapp.user_group_finance_tab ugft, ifsapp.shop_dts_info sdi
 WHERE     1 = 1
       AND ugft.user_group = sdi.shop_code(+)
       AND (   :p_shop_code IS NULL
            OR (UPPER (NVL (ugft.user_group, sdi.shop_code)) LIKE
                    UPPER ('%' || :p_shop_code || '%')))
       --and (:p_shop_code is null or (ugft.user_group = :p_shop_code))
       AND ( :p_district_code IS NULL OR sdi.district_code = :p_district_code);

--------------------------------------------------------------------------------

SELECT sdi.shop_code, sdi.*
  FROM ifsapp.shop_dts_info sdi
 WHERE     1 = 1
       AND (   :p_shop_code IS NULL
            OR (UPPER (sdi.shop_code) LIKE UPPER ('%' || :p_shop_code || '%')));

--------------------------------------------------------------------------------
