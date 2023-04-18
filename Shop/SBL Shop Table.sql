/* Formatted on 3/30/2023 1:09:35 PM (QP5 v5.381) */
SELECT site_id,
       hpnret_level_h_util_api.get_district (t.level_id)
           district_id,
       hpnret_level_api.get_description (
           hpnret_level_h_util_api.get_district (t.level_id))
           district,
       hpnret_level_h_util_api.get_area (t.level_id)
           geo_area_id,
       hpnret_level_api.get_description (
           hpnret_level_h_util_api.get_area (t.level_id))
           geo_area,
       hpnret_level_h_util_api.get_higher_level (
           hpnret_level_h_util_api.get_district (t.level_id))
           area_id,
       hpnret_level_api.get_description (
           hpnret_level_h_util_api.get_higher_level (
               hpnret_level_h_util_api.get_district (t.level_id)))
           area,
       hpnret_level_h_util_api.get_channel (t.level_id)
           channel_id,
       hpnret_level_api.get_description (
           hpnret_level_h_util_api.get_channel (t.level_id))
           channel
  FROM ifsapp.hpnret_level_hierarchy_tab t
 WHERE t.site_id IS NOT NULL;

SELECT *
  FROM ifsapp.hpnret_levels_overview hlo;
  
  
SELECT *
  FROM ifsapp.user_group_finance ugf;
  
SELECT sdi.shop_code, sdi.*
  FROM ifsapp.shop_dts_info sdi
 WHERE     1 = 1
       AND (   :p_shop_code IS NULL
            OR (UPPER (sdi.shop_code) LIKE UPPER ('%' || :p_shop_code || '%')));

SELECT *
  FROM user_group_finance_tab ugft
 WHERE     1 = 1
       AND (   :p_shop_code IS NULL
            OR (UPPER (ugft.user_group) LIKE
                    UPPER ('%' || :p_shop_code || '%')));