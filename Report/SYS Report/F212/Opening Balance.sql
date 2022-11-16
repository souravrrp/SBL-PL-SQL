/* Formatted on 9/19/2022 3:15:05 PM (QP5 v5.381) */
SELECT o.opening_balance
  FROM (  SELECT hrit.contract                                   shop_code,
                 TO_DATE (hrit.rowversion, 'DD-MON-RRRR') + 1    rsl_date,
                 NVL (SUM (hrit.amount), 0)                      opening_balance
            FROM hpnret_rsl_item_tab hrit
           WHERE     1 = 1
                 AND hrit.contract = :p_shop_code
                 AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
                 AND hrit.rsl_item_id = 'BCBOPENCURRWEEK'
                 AND hrit.rsl_item_type = 'EXPENSE'
                 AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') =
                     (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                        FROM hpnret_rsl_tab rsl
                       WHERE     1 = 1
                             AND rsl.contract = :p_shop_code
                             AND rsl.row_type = 'RSL')
        GROUP BY hrit.contract, TO_DATE (hrit.rowversion, 'DD-MON-RRRR')
        UNION ALL
          SELECT shop_code,
                 rsl_date,
                 (  (  SUM (cash_in)
                     + SUM (cash_sale)
                     + SUM (sales_return)
                     + SUM (hp_penalty)
                     + SUM (cash_penalty)
                     + SUM (rem_sum_add)
                     + SUM (rem_sum_less))
                  - (SUM (expanse_summary) + SUM (total_bank_doc)))    opening_balance
            FROM (  SELECT hrit.contract
                               shop_code,
                           TO_DATE (hrit.rowversion, 'DD-MON-RRRR') + 1
                               rsl_date,
                           (CASE
                                WHEN     hrit.rsl_item_type = 'RECEIPT'
                                     AND hrit.rsl_item_category = 'DOWNINSTALL'
                                THEN
                                    NVL (SUM (hrit.amount), 0)
                            END)
                               cash_in,
                           (CASE
                                WHEN     hrit.rsl_item_id = 'CASHSALES'
                                     AND hrit.rsl_item_category = 'CASHSALES'
                                THEN
                                    NVL (SUM (hrit.amount), 0)
                            END)
                               cash_sale,
                           (CASE
                                WHEN     hrit.rsl_item_type = 'RECEIPT'
                                     AND hrit.rsl_item_category = 'SALESRETURN'
                                THEN
                                    NVL (SUM (hrit.amount), 0)
                            END)
                               sales_return,
                           (CASE
                                WHEN     hrit.rsl_item_type = 'RECEIPT'
                                     AND hrit.rsl_item_category = 'PENALTY'
                                THEN
                                    NVL (SUM (hrit.amount), 0)
                            END)
                               hp_penalty,
                           (CASE
                                WHEN     hrit.rsl_item_type = 'RECEIPT'
                                     AND hrit.rsl_item_category = 'CASHPENALTY'
                                THEN
                                    NVL (SUM (hrit.amount), 0)
                            END)
                               cash_penalty,
                           (CASE
                                WHEN hrit.rsl_item_category = 'EXPENSE'
                                THEN
                                    NVL (SUM (hrit.amount), 0)
                            END)
                               expanse_summary,
                           (CASE
                                WHEN     hrit.rsl_item_type = 'RECEIPT'
                                     AND hrit.rsl_item_category =
                                         'REMITTANCESUMMARY'
                                THEN
                                    NVL (SUM (hrit.amount), 0)
                            END)
                               rem_sum_add,
                           (CASE
                                WHEN     hrit.rsl_item_type = 'EXPENSE'
                                     AND hrit.rsl_item_category =
                                         'REMITTANCESUMMARY'
                                THEN
                                    NVL (SUM (hrit.amount), 0)
                            END)
                               rem_sum_less,
                           (CASE
                                WHEN     hrit.rsl_item_type = 'RECEIPT'
                                     AND hrit.rsl_item_category =
                                         'DOCCUMENTSUMMARY'
                                THEN
                                    NVL (SUM (hrit.amount), 0)
                            END)
                               total_bank_doc
                      FROM hpnret_rsl_item_tab hrit
                     WHERE     1 = 1
                           AND hrit.contract = :p_shop_code
                           AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                               (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                                  FROM hpnret_rsl_tab rsl
                                 WHERE     1 = 1
                                       AND rsl.contract = :p_shop_code
                                       AND rsl.row_type = 'RSL')
                  GROUP BY hrit.contract,
                           hrit.rsl_item_type,
                           hrit.rsl_item_id,
                           hrit.rsl_item_category,
                           TO_DATE (hrit.rowversion, 'DD-MON-RRRR'))
        GROUP BY shop_code, rsl_date
        ORDER BY rsl_date) o
 WHERE o.shop_code = :p_shop_code AND o.rsl_date = :p_rsl_date;


--------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION IFSAPP.cash_book_opening_balance (
    p_shop_code   IN VARCHAR2,
    p_rsl_date    IN DATE)
    RETURN NUMBER
IS
    ln_val   NUMBER;
-- CREATED BY : SOURAV PAUL
-- CREATION DATE : 19-SEP-2022
-- LAST UPDATE DATE :19-SEP-2022
-- PURPOSE : Get Daily Cash Book Opening Balance
BEGIN
    SELECT NVL (o.opening_balance, 0)
      INTO ln_val
      FROM (  SELECT hrit.contract                                   shop_code,
                     TO_DATE (hrit.rowversion, 'DD-MON-RRRR') + 1    rsl_date,
                     NVL (SUM (hrit.amount), 0)                      opening_balance
                FROM hpnret_rsl_item_tab hrit
               WHERE     1 = 1
                     AND hrit.contract = p_shop_code
                     AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
                     AND hrit.rsl_item_id = 'BCBOPENCURRWEEK'
                     AND hrit.rsl_item_type = 'EXPENSE'
                     AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') =
                         (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                            FROM hpnret_rsl_tab rsl
                           WHERE     1 = 1
                                 AND rsl.contract = p_shop_code
                                 AND rsl.row_type = 'RSL')
            GROUP BY hrit.contract, TO_DATE (hrit.rowversion, 'DD-MON-RRRR')
            UNION ALL
              SELECT shop_code,
                     rsl_date,
                     (  (  SUM (cash_in)
                         + SUM (cash_sale)
                         + SUM (sales_return)
                         + SUM (hp_penalty)
                         + SUM (cash_penalty)
                         + SUM (rem_sum_add)
                         + SUM (rem_sum_less))
                      - (SUM (expanse_summary) + SUM (total_bank_doc)))    opening_balance
                FROM (  SELECT hrit.contract
                                   shop_code,
                               TO_DATE (hrit.rowversion, 'DD-MON-RRRR') + 1
                                   rsl_date,
                               (CASE
                                    WHEN     hrit.rsl_item_type = 'RECEIPT'
                                         AND hrit.rsl_item_category =
                                             'DOWNINSTALL'
                                    THEN
                                        NVL (SUM (hrit.amount), 0)
                                END)
                                   cash_in,
                               (CASE
                                    WHEN     hrit.rsl_item_id = 'CASHSALES'
                                         AND hrit.rsl_item_category = 'CASHSALES'
                                    THEN
                                        NVL (SUM (hrit.amount), 0)
                                END)
                                   cash_sale,
                               (CASE
                                    WHEN     hrit.rsl_item_type = 'RECEIPT'
                                         AND hrit.rsl_item_category =
                                             'SALESRETURN'
                                    THEN
                                        NVL (SUM (hrit.amount), 0)
                                END)
                                   sales_return,
                               (CASE
                                    WHEN     hrit.rsl_item_type = 'RECEIPT'
                                         AND hrit.rsl_item_category = 'PENALTY'
                                    THEN
                                        NVL (SUM (hrit.amount), 0)
                                END)
                                   hp_penalty,
                               (CASE
                                    WHEN     hrit.rsl_item_type = 'RECEIPT'
                                         AND hrit.rsl_item_category =
                                             'CASHPENALTY'
                                    THEN
                                        NVL (SUM (hrit.amount), 0)
                                END)
                                   cash_penalty,
                               (CASE
                                    WHEN hrit.rsl_item_category = 'EXPENSE'
                                    THEN
                                        NVL (SUM (hrit.amount), 0)
                                END)
                                   expanse_summary,
                               (CASE
                                    WHEN     hrit.rsl_item_type = 'RECEIPT'
                                         AND hrit.rsl_item_category =
                                             'REMITTANCESUMMARY'
                                    THEN
                                        NVL (SUM (hrit.amount), 0)
                                END)
                                   rem_sum_add,
                               (CASE
                                    WHEN     hrit.rsl_item_type = 'EXPENSE'
                                         AND hrit.rsl_item_category =
                                             'REMITTANCESUMMARY'
                                    THEN
                                        NVL (SUM (hrit.amount), 0)
                                END)
                                   rem_sum_less,
                               (CASE
                                    WHEN     hrit.rsl_item_type = 'RECEIPT'
                                         AND hrit.rsl_item_category =
                                             'DOCCUMENTSUMMARY'
                                    THEN
                                        NVL (SUM (hrit.amount), 0)
                                END)
                                   total_bank_doc
                          FROM hpnret_rsl_item_tab hrit
                         WHERE     1 = 1
                               AND hrit.contract = p_shop_code
                               AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') >
                                   (SELECT TO_DATE (MAX (rsl.TO_DATE),
                                                    'DD-MON-RRRR')
                                      FROM hpnret_rsl_tab rsl
                                     WHERE     1 = 1
                                           AND rsl.contract = p_shop_code
                                           AND rsl.row_type = 'RSL')
                      GROUP BY hrit.contract,
                               hrit.rsl_item_type,
                               hrit.rsl_item_id,
                               hrit.rsl_item_category,
                               TO_DATE (hrit.rowversion, 'DD-MON-RRRR'))
            GROUP BY shop_code, rsl_date
            ORDER BY rsl_date) o
     WHERE o.shop_code = p_shop_code AND o.rsl_date = p_rsl_date;

    RETURN ln_val;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN '0';
--DBMS_OUTPUT.put_line ('ERROR: ' || SQLERRM);
END;
/

--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION IFSAPP.cash_book_opening_balance (
    p_shop_code   IN VARCHAR2,
    p_rsl_date    IN DATE)
    RETURN NUMBER
IS
    ln_val   NUMBER;
-- CREATED BY : SOURAV PAUL
-- LAST UPDATE DATE :19-SEP-2022
-- PURPOSE : Get Daily Cash Book Opening Balance
BEGIN
    SELECT NVL (o.opening_balance, 0)
      INTO ln_val
      FROM (  SELECT hrit.contract                                   shop_code,
                     TO_DATE (hrit.rowversion, 'DD-MON-RRRR') + 1    rsl_date,
                     NVL (SUM (hrit.amount), 0)                      opening_balance
                FROM hpnret_rsl_item_tab hrit
               WHERE     1 = 1
                     AND hrit.contract = p_shop_code
                     AND hrit.rsl_item_category = 'REMITTANCESUMMARY'
                     AND hrit.rsl_item_id = 'BCBOPENCURRWEEK'
                     AND hrit.rsl_item_type = 'EXPENSE'
                     AND TO_DATE (hrit.rowversion, 'DD-MON-RRRR') =
                         (SELECT TO_DATE (MAX (rsl.TO_DATE), 'DD-MON-RRRR')
                            FROM hpnret_rsl_tab rsl
                           WHERE     1 = 1
                                 AND rsl.contract = p_shop_code
                                 AND rsl.row_type = 'RSL')
            GROUP BY hrit.contract, TO_DATE (hrit.rowversion, 'DD-MON-RRRR'))
           o
     WHERE o.shop_code = p_shop_code AND o.rsl_date = p_rsl_date;

    RETURN ln_val;
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN '0';
--DBMS_OUTPUT.put_line ('ERROR: ' || SQLERRM);
END;
/


