/* Formatted on 3/12/2023 9:37:57 AM (QP5 v5.381) */
SELECT pit.name full_name, pit.person_id user_name
--, pit.*
  FROM PERSON_INFO_TAB pit
 WHERE     1 = 1
       AND (   :p_user_id IS NULL
            OR (UPPER (pit.person_id) LIKE UPPER ('%' || :p_user_id || '%')))
       AND (   :p_full_name IS NULL
            OR (UPPER (pit.name) LIKE UPPER ('%' || :p_full_name || '%')));