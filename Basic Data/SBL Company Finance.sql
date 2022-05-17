/* Formatted on 4/4/2022 11:41:25 AM (QP5 v5.381) */
SELECT cf.description      company_description,
       uf.userid           user_id,
       uf.description      full_name,
       ugmf.default_group,
       ugmf.user_group,
       ugf.description     shop_description
  --,cf.*
  --,uf.*
  --,ugmf.*
  --,ugf.
  FROM ifsapp.company_finance            cf,
       ifsapp.user_finance               uf,
       ifsapp.user_group_member_finance  ugmf,
       ifsapp.user_group_finance         ugf
 WHERE     1 = 1
       AND cf.company = uf.company
       AND uf.userid = ugmf.userid
       AND ugmf.default_group = 'Yes'
       AND ugmf.user_group = ugf.user_group
       AND (   :p_user_id IS NULL
            OR (UPPER (uf.userid) LIKE UPPER ('%' || :p_user_id || '%')))
       AND (   :p_full_name IS NULL
            OR (UPPER (uf.description) LIKE
                    UPPER ('%' || :p_full_name || '%')));

--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.company_finance cf;

SELECT *
  FROM ifsapp.user_finance uf;

SELECT * FROM ifsapp.user_group_finance;

SELECT *
  FROM ifsapp.user_group_member_finance ugmf;