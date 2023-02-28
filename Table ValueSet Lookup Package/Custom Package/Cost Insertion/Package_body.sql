/* Formatted on 2/26/2023 4:27:09 PM (QP5 v5.381) */
CREATE OR REPLACE PACKAGE BODY ifsapp.sbl_fin_item_cost_pkg
IS
    PROCEDURE update_item_cost
    IS
        CURSOR cur_item_cost IS
            SELECT *
              FROM ifsapp.sbl_fin_item_cost_upld sficu
             WHERE sficu.flag IS NULL;
    BEGIN
        FOR cur_update_cost IN cur_item_cost
        LOOP
            BEGIN
                UPDATE ifsapp.sbl_fin_item_cost sfic
                   SET sfic.end_date =
                           NVL (cur_update_cost.END_DATE, SYSDATE - 1)
                 WHERE     sfic.part_no = cur_update_cost.part_no
                       AND sfic.end_date IS NULL;

                COMMIT;

                BEGIN
                    INSERT INTO ifsapp.sbl_fin_item_cost (COST_ID,
                                                          CREATION_DATE,
                                                          PART_NO,
                                                          ITEM_COST,
                                                          START_DATE,
                                                          END_DATE,
                                                          REMARKS)
                             VALUES (
                                        cur_update_cost.COST_UPLD_ID,
                                        NVL (cur_update_cost.CREATION_DATE,
                                             SYSDATE),
                                        cur_update_cost.PART_NO,
                                        cur_update_cost.ITEM_COST,
                                        NVL (cur_update_cost.START_DATE,
                                             SYSDATE),
                                        cur_update_cost.END_DATE,
                                        cur_update_cost.REMARKS);
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        DBMS_OUTPUT.put_line (
                            'Error while inserting records in lines table');
                END;

                UPDATE ifsapp.sbl_fin_item_cost_upld sficu
                   SET sficu.flag = 'Y'
                 WHERE     sficu.cost_upld_id = cur_update_cost.cost_upld_id
                       AND sficu.flag IS NULL;

                COMMIT;
            END;
        END LOOP;
    END;
END sbl_fin_item_cost_pkg;
/
