/* Formatted on 5/16/2022 2:30:57 PM (QP5 v5.381) */
  SELECT p.order_no,
         p.line_no,
         p.release_no,
         p.contract                               shop_code,
         p.vendor                                 warehouse,
         TO_CHAR (p.order_date, 'YYYY/MM/DD')     order_date,
         p.part_no,
         p.part_desc,
         p.qty_ordered,
         p.qty_received,
         p.qty_remain,
         p.head_state,
         p.line_state
    FROM IFSAPP.SBL_VW_ACTIVE_PO p
         INNER JOIN ifsapp.shop_dts_info s ON p.contract = s.shop_code
         INNER JOIN ifsapp.ware_house_info w ON p.vendor = w.ware_house_name
   WHERE     p.qty_remain > 0
         AND p.order_date BETWEEN TO_DATE ('&from_date', 'YYYY/MM/DD')
                              AND TO_DATE ('&to_date', 'YYYY/MM/DD')
         AND p.contract IN
                 (SELECT a.contract
                    FROM ifsapp.USER_ALLOWED_SITE_TAB a
                   WHERE a.userid = ifsapp.fnd_session_api.Get_Fnd_User)
ORDER BY 4,
         5,
         1,
         2,
         3