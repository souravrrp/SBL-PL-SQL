CREATE OR REPLACE PACKAGE BODY IFSAPP.PURCHASE_ORDER_TOTAL_RPI AS

PROCEDURE Report_Overview (
   report_attr_    IN VARCHAR2,
   parameter_attr_ IN VARCHAR2 )
IS
   result_key_ NUMBER;
   row_no_     NUMBER := 1;
   po_no_         VARCHAR2(12);
   company_       VARCHAR2(15);
   addr_id_       VARCHAR2(5);
   del_addr_id_   VARCHAR2(5);
   temp_contract_ VARCHAR2(12);
   i_ NUMBER := 0;
   deliver_      VARCHAR2(500);
   supplier_     VARCHAR2(500);
   note_id_      NUMBER;
   sum_          NUMBER;
   doc_txt_l1_   VARCHAR2(2000);
   doc_txt_v1_   VARCHAR2(2000);

   CURSOR get_po_rec IS
     SELECT v1.order_no,v1.vendor_no,v1.order_date,v1.delivery_terms_desc,v1.currency_code,v2.contract,
     v2.part_no,v2.unit_meas,v2.buy_qty_due,v2.fbuy_unit_price,v1.note_id,NVL(v2.estimated_shipment_date,v2.wanted_delivery_date) est_del_date,v1.lc_no,v1.label_note,v1.note_text
     FROM purchase_order v1,purchase_order_line_part v2
     WHERE v1.order_no = v2.order_no
     AND v1.order_no = po_no_
     AND v2.state <> 'Cancelled'
     UNION ALL
     SELECT v1.order_no,v1.vendor_no,v1.order_date,v1.delivery_terms_desc,v1.currency_code,v2.contract,
     v2.description,NULL,v2.buy_qty_due,v2.fbuy_unit_price,v1.note_id,NVL(v2.estimated_shipment_date,v2.wanted_delivery_date) est_del_date,v1.lc_no,v1.label_note,v1.note_text
     FROM purchase_order v1,purchase_order_line_nopart v2
     WHERE v1.order_no = v2.order_no
     AND v1.order_no = po_no_
     AND v2.state <> 'Cancelled';

   CURSOR get_addr_id(supp_id_ IN VARCHAR2) IS
     SELECT v.address_id
     FROM Supplier_Info_Address v
     WHERE v.supplier_id = supp_id_;

   CURSOR get_note_text(note_id_ IN NUMBER) IS
     SELECT output_type_API.Get_Description(v.output_type) lbl,v.note_text
     FROM document_text v
     WHERE v.note_id = note_id_;

  CURSOR get_sub_tot_sum IS
     SELECT x1.del_name,ROUND(SUM(x1.tot_amt),2) sub_tot
     FROM purchase_order_total_rep x1
     WHERE x1.result_key = result_key_
     GROUP BY x1.del_name;

   CURSOR get_tot_sum IS
     SELECT ROUND(SUM(x1.tot_amt),2)
     FROM purchase_order_total_rep x1
     WHERE x1.result_key = result_key_;

BEGIN
   result_key_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('RESULT_KEY', report_attr_));
   po_no_      := Client_SYS.Get_Item_Value('PO_NO', parameter_attr_);
   User_Finance_API.Get_Default_Company(company_);

   FOR rec_ IN get_po_rec LOOP
      OPEN get_addr_id(rec_.vendor_no);
       FETCH get_addr_id INTO addr_id_;
      CLOSE get_addr_id;

      OPEN get_addr_id(rec_.contract);
       FETCH get_addr_id INTO del_addr_id_;
      CLOSE get_addr_id;

      IF((temp_contract_ IS NULL) OR (temp_contract_ = rec_.contract)) THEN
        temp_contract_ := rec_.contract;
        i_ := i_ +1;
      ELSE
        i_ := 1;
      END IF;

      INSERT INTO Info_Services_Rpt(RESULT_KEY,                              --RESULT_KEY,
                                    ROW_NO,                                  --ROW_NO,
                                    PARENT_ROW_NO,                           --PARENT_ROW_NO,
                                    s1,                                      --COMPANY,
                                    s2,                                      --COMPANY_NAME,
                                    s3,                                      --VAT_NO,
                                    s4,                                      --SUPP_NAME,
                                    s5,                                      --SUPP_ADDRESS1,
                                    s6,                                      --SUPP_ADDRESS2,
                                    s7,                                      --SUPP_ADDRESS3,
                                    d1,                                      --ORDER_DATE,
                                    s8,                                      --PO_NO,
                                    s9,                                      --DEL_TERMS,
                                    s10,                                      --CURRENCY,
                                    s11,                                     --DEL_NAME,
                                    s12,                                     --DEL_ADDRESS1,
                                    s13,                                     --DEL_ADDRESS2,
                                    s14,                                     --DEL_ADDRESS3,
                                    n1,                                      --LINE_NO,
                                    s15,                                     --PART_NO,
                                    s16,                                     --PART_DESC,
                                    n2,                                      --QTY,
                                    s17,                                     --UOM,
                                    n3,                                      --PRICE,
                                    n4,                                     --TOT_AMT
                                    n5,
                                    d2,
                                    s21,
                                    s22,
                                    s24)
      VALUES(result_key_,                             --RESULT_KEY,
             row_no_,                                 --ROW_NO,
             0,                                       --PARENT_ROW_NO,
             company_,                                --COMPANY,
             Company_API.Get_Name(company_),          --COMPANY_NAME,
             Company_Invoice_Info_API.Get_Vat_No(company_),  --VAT_NO,
             Supplier_API.Get_Vendor_name(rec_.vendor_no),   --SUPP_NAME,
             Supplier_Info_Address_API.Get_Address1(rec_.vendor_no,addr_id_), --SUPP_ADDRESS1,
             Supplier_Info_Address_API.Get_Address2(rec_.vendor_no,addr_id_), --SUPP_ADDRESS2,
             Supplier_Info_Address_API.Get_Zip_Code(rec_.vendor_no,addr_id_), --SUPP_ADDRESS3,
             rec_.order_date,                                    --ORDER_DATE,
             rec_.order_no,                                      --PO_NO,
             rec_.delivery_terms_desc,                           --DEL_TERMS,
             rec_.currency_code,                                 --CURRENCY,
             Site_API.Get_Description(rec_.contract),            --DEL_NAME,
             Supplier_Info_Address_API.Get_Address1(rec_.contract,del_addr_id_),                                     --DEL_ADDRESS1,
             Supplier_Info_Address_API.Get_Address2(rec_.contract,del_addr_id_),                                     --DEL_ADDRESS2,
             Supplier_Info_Address_API.Get_Zip_Code(rec_.contract,del_addr_id_),                                     --DEL_ADDRESS3,
             i_,                                      --LINE_NO,
             rec_.part_no,                            --PART_NO,
             Purchase_Part_API.Get_Description(rec_.contract,rec_.part_no),   --PART_DESC,
             rec_.buy_qty_due,                        --QTY,
             rec_.unit_meas,                          --UOM,
             rec_.fbuy_unit_price,                    --PRICE,
             rec_.buy_qty_due*rec_.fbuy_unit_price,  --TOT_AMT
             0,
             rec_.est_del_date,
             rec_.lc_no,
             rec_.label_note,
             rec_.note_text);

      note_id_   := rec_.note_id;
      deliver_   := Site_API.Get_Description(rec_.contract);
      supplier_  := Supplier_API.Get_Vendor_name(rec_.vendor_no);
      row_no_ := row_no_ +1;
   END LOOP;

   FOR note_rec_ IN get_note_text(note_id_) LOOP
     /*INSERT INTO Info_Services_Rpt(RESULT_KEY,                              --RESULT_KEY,
                                   ROW_NO,                                  --ROW_NO,
                                   PARENT_ROW_NO,
                                   s4,                                      --SUPP_NAME,
                                   s11,                                     --DEL_NAME,
                                   s18,                                      --DOC_TXT_L1,
                                   s19,                                      --DOC_TXT_V1,
                                   n5)                                       --DISPLAY
     VALUES(result_key_,                              --RESULT_KEY,
            row_no_,                                  --ROW_NO,
            0,
            supplier_,                                      --SUPP_NAME,
            deliver_,                                       --DEL_NAME,
            note_rec_.lbl,                                  --DOC_TXT_L1,
            note_rec_.note_text,                            --DOC_TXT_V1,
            1);                                       --DISPLAY
     row_no_ := row_no_ +1;*/
     doc_txt_l1_ := doc_txt_l1_||CHR(13)||note_rec_.lbl;
     doc_txt_v1_ := doc_txt_v1_||CHR(13)||note_rec_.note_text;
   END LOOP;

   OPEN get_tot_sum;
     FETCH get_tot_sum INTO sum_;
   CLOSE get_tot_sum;

   UPDATE Info_Services_Rpt
   SET s20 = Get_Amount_In_Word(sum_),
       s18 = doc_txt_l1_,
       s19 = doc_txt_v1_
   WHERE result_key = result_key_;

   FOR sub_tot_rec_ IN get_sub_tot_sum LOOP
     UPDATE Info_Services_Rpt
     SET s23 = Get_Amount_In_Word(sub_tot_rec_.sub_tot)
     WHERE result_key = result_key_
     AND s11 = sub_tot_rec_.del_name;
   END LOOP;
END Report_Overview;

FUNCTION Get_Amount_In_Word (
   amount_ IN NUMBER ) RETURN VARCHAR2
IS
   l_amount    NUMBER(12,2);
   l_len       SMALLINT;
   l_start      NUMBER(12,2);
   l_second      NUMBER(12,2);
   L_string2   VARCHAR2(320);
   l_string      VARCHAR2(320);
   l_text      VARCHAR2(320);
   L_stringcent   VARCHAR2(200);
   L_PAISA      VARCHAR2(200);
   L_PAISA2      NUMBER(12,2);
   l_second1   NUMBER(12,2);
   l_third      NUMBER(12,2);
   L_string3   VARCHAR2(320);
   l_desc      VARCHAR2(320);
BEGIN
   l_amount := amount_;
   IF l_AMOUNT IS NULL OR L_AMOUNT <=0 THEN
       l_desc:=('(ZERO)');
   ELSIF TRUNC(L_AMOUNT)=0 THEN
       L_PAISA:= (L_AMOUNT*100);
       IF L_PAISA<>0 THEN
       SELECT TO_CHAR(TO_DATE(L_PAISA,'J'),'JSP') INTO L_STRINGCENT FROM DUAL;
       l_desc:=(L_STRINGCENT||' '||'ONLY.');
       ELSE
       l_desc:=('" NULL "');
       END IF;
   ELSE
      BEGIN
        L_START:= TRUNC(L_AMOUNT/1000000);
        L_SECOND:=TRUNC(MOD(L_AMOUNT,1000000));
        L_PAISA2:= ((L_AMOUNT-TRUNC(L_AMOUNT))*100);
      IF L_START <>0 AND  L_SECOND<>0  THEN
       SELECT TO_CHAR(TO_DATE(L_START,'J'),'JSP') INTO L_STRING FROM DUAL;
       SELECT TO_CHAR(TO_DATE(L_SECOND,'J'),'JSP') INTO L_STRING2 FROM DUAL;
       IF L_PAISA2<>0 THEN
          SELECT TO_CHAR(TO_DATE(L_PAISA2,'J'),'JSP') INTO L_STRINGCENT FROM DUAL;
          l_desc:=(L_STRING||' MILLION AND '||L_STRING2||' AND '||L_STRINGCENT||' ONLY.');
       ELSE
          l_desc:=(L_STRING||' MILLION AND '||L_STRING2||' ONLY.');
       END IF;
      ELSIF L_START <>0 AND  L_SECOND=0  THEN
       SELECT TO_CHAR(TO_DATE(L_START,'J'),'JSP') INTO L_STRING FROM DUAL;
       IF L_PAISA2<>0 THEN
          SELECT TO_CHAR(TO_DATE(L_PAISA2,'J'),'JSP') INTO L_STRINGCENT FROM DUAL;
          l_desc:=(L_STRING||' '||'MILLION  AND '||L_STRINGCENT||' ONLY.');
       ELSE
          l_desc:=(L_STRING||' '||'MILLION ONLY.');
       END IF;
     ELSIF L_START=0 AND  L_SECOND<>0  THEN
        L_second1:= TRUNC(L_SECOND/1000);
        L_Third:= TRUNC(MOD(L_SECOND,1000));
        if L_second1<>0 and L_Third=0 then
          SELECT TO_CHAR(TO_DATE(L_second1,'J'),'JSP') INTO L_STRING2 FROM DUAL;
           IF L_PAISA2<>0 THEN
               SELECT TO_CHAR(TO_DATE(L_PAISA2,'J'),'JSP') INTO L_STRINGCENT FROM DUAL;
               l_desc:=(L_STRING2||' THOUSAND  AND '||L_STRINGCENT||' ONLY.');
           ELSE
               l_desc:=(L_STRING2||' THOUSAND ONLY.');
           END IF;
        elsif L_second1<>0 and L_Third<>0 then
         SELECT TO_CHAR(TO_DATE(L_second1,'J'),'JSP') INTO L_STRING2 FROM DUAL;
         SELECT TO_CHAR(TO_DATE(L_Third,'J'),'JSP') INTO L_STRING3 FROM DUAL;
           IF L_PAISA2<>0 THEN
               SELECT TO_CHAR(TO_DATE(L_PAISA2,'J'),'JSP') INTO L_STRINGCENT FROM DUAL;
               l_desc:=(L_STRING2||' THOUSAND '||L_STRING3||' AND '||L_STRINGCENT||' ONLY.');
           ELSE
               l_desc:=(L_STRING2||' THOUSAND '||L_STRING3||' ONLY.');
           END IF;
        elsif L_second1=0 and L_Third<>0 then
         SELECT TO_CHAR(TO_DATE(L_Third,'J'),'JSP') INTO L_STRING3 FROM DUAL;
           IF L_PAISA2<>0 THEN
               SELECT TO_CHAR(TO_DATE(L_PAISA2,'J'),'JSP') INTO L_STRINGCENT FROM DUAL;
               l_desc:=(L_STRING3||'  AND '||L_STRINGCENT||' ONLY.');
           ELSE
               l_desc:=(L_STRING3||' ONLY.');
           END IF;
       end if;
     END IF;
   END;
   END IF;
   l_desc := LOWER(l_desc);
   l_desc := INITCAP(l_desc);
   RETURN l_desc;
END Get_Amount_In_Word;

END PURCHASE_ORDER_TOTAL_RPI;



/
