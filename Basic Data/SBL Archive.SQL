/* Formatted on 10/11/2022 10:43:12 AM (QP5 v5.381) */
  SELECT at.sender              user_name,
         afnt.rowversion        execution_time,
         afnt.pdf_file_name     file_name
    --, at.*
    --, afnt.*
    FROM ifsapp.archive_tab at, ifsapp.archive_file_name_tab afnt
   WHERE     1 = 1
         AND at.result_key = afnt.result_key
         AND (   :p_owner_name IS NULL
              OR (UPPER (at.sender) LIKE UPPER ('%' || :p_owner_name || '%')))
         AND (   :p_pdf_file_name IS NULL
              OR (UPPER (afnt.pdf_file_name) LIKE
                      UPPER ('%' || :p_pdf_file_name || '%')))
         AND TO_CHAR (at.exec_time, 'DD-MM-RRRR') =
             TO_CHAR (NVL ( :p_sysdate, SYSDATE), 'DD-MM-RRRR')
ORDER BY at.rowversion DESC;

--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.archive_file_name_tab
 WHERE     1 = 1
       AND TO_CHAR (rowversion, 'DD-MM-RRRR') =
           TO_CHAR (SYSDATE, 'DD-MM-RRRR');

  SELECT *
    FROM ifsapp.archive_tab at
   WHERE     1 = 1
         AND (   :p_owner_name IS NULL
              OR (UPPER (at.sender) LIKE UPPER ('%' || :p_owner_name || '%')))
         AND TO_CHAR (at.exec_time, 'DD-MM-RRRR') =
             TO_CHAR (NVL ( :p_sysdate, SYSDATE), 'DD-MM-RRRR')
ORDER BY at.rowversion DESC;