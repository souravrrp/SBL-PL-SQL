/* Formatted on 9/1/2022 10:43:29 AM (QP5 v5.381) */
SELECT rd.report_id,
       NVL (rd.report_title, rld.layout_title)     report_title,
       rd.method,
       rld.layout_name                             qrp_name
  --,rd.*
  --,rld.*
  FROM report_definition rd, report_layout_definition rld
 WHERE     1 = 1
       AND rd.report_id = rld.report_id
       AND (   :p_report_title IS NULL
            OR (UPPER (rd.report_title) LIKE
                    UPPER ('%' || :p_report_title || '%')))
       AND (   :p_report_id IS NULL
            OR (UPPER (rd.report_id) LIKE UPPER ('%' || :p_report_id || '%')))
       AND (   :p_report_title IS NULL
            OR (UPPER (rld.layout_title) LIKE
                    UPPER ('%' || :p_report_title || '%')));

--------------------------------------------------------------------------------

SELECT *
  FROM report_definition rd
 WHERE     1 = 1
       AND (   :p_report_title IS NULL
            OR (UPPER (rd.report_title) LIKE
                    UPPER ('%' || :p_report_title || '%')))
       AND (   :p_report_id IS NULL
            OR (UPPER (rd.report_id) LIKE UPPER ('%' || :p_report_id || '%')));

SELECT rld.layout_title report_title, rld.layout_title qrp_name, rld.*
  FROM report_layout_definition rld
 WHERE     1 = 1
       AND (   :p_report_title IS NULL
            OR (UPPER (rld.layout_title) LIKE
                    UPPER ('%' || :p_report_title || '%')))
       AND (   :p_report_id IS NULL
            OR (UPPER (rld.report_id) LIKE UPPER ('%' || :p_report_id || '%')));