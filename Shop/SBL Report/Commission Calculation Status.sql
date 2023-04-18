/* Formatted on 4/10/2023 11:37:56 AM (QP5 v5.381) */
  SELECT ROW_NUMBER () OVER (ORDER BY cbic.site)               AS SL_No,
         TO_DATE (cbic.objversion, 'YYYY-MM-DD HH24:MI:SS')    claim_datetime,
         cbic.site                                             AS shop_code,
         (SELECT h.area_code
            FROM ifsapp.shop_dts_info h
           WHERE h.shop_code = cbic.site)                      area_code,
         TO_NUMBER ((SELECT h.district_code
                       FROM ifsapp.shop_dts_info h
                      WHERE h.shop_code = cbic.site))          district_code,
         cbic.entitlement_type,
         cbic.state
    FROM ifsapp.comm_bons_incen_claim cbic
   WHERE     1 = 1
         AND EXISTS
                 (SELECT 1
                    FROM ifsapp.shop_dts_info h
                   WHERE     h.shop_code = cbic.site
                         AND (   :p_area_code IS NULL
                              OR (h.area_code = :p_area_code)))
         AND TRUNC (cbic.calculated_date) BETWEEN NVL (
                                                      :p_date_from,
                                                      TRUNC (
                                                          cbic.calculated_date))
                                              AND NVL (
                                                      :p_date_to,
                                                      TRUNC (
                                                          cbic.calculated_date))
         AND EXISTS
                 (SELECT 1
                    FROM ifsapp.user_allowed_site d
                   WHERE     d.contract = cbic.site
                         AND d.userid =
                             (SELECT ifsapp.fnd_session_api.get_fnd_user
                                FROM DUAL))
ORDER BY 4, 2, 1