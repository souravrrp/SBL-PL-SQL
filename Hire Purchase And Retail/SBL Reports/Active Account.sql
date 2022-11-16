SELECT H.CONTRACT
           SHOP_CODE,
       H.ACCOUNT_NO,
       ifsapp.customer_info_comm_method_api.get_any_phone_no (
           ifsapp.hpnret_hp_head_api.get_id (h.account_no, h.account_rev))
           phone_no,
       H.ROWSTATE
           STATUS
  FROM HPNRET_HP_HEAD_TAB H
 WHERE 1 = 1 AND CONTRACT = 'JPBB' --AND ACCOUNT_NO = 'JPB-H2798'
                                   AND ROWSTATE = 'Active';