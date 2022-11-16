/* Formatted on 5/29/2022 11:26:43 AM (QP5 v5.381) */
SELECT ifsapp.fnd_session_api.Get_Fnd_User     "User_ID",
       IFSAPP.sbl_pass_USER ()                 "Password"
  FROM DUAL