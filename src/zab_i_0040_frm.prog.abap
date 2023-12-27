*&---------------------------------------------------------------------*
*& Include          ZEGT_I_0018_F01
*&---------------------------------------------------------------------*

FORM f_numeric_oprt.
**** Nümerik Karşılaştırma Operatörleri ****

*=, !=, >=, <=, >, <
*EQ, NE, GE, LE, GT, LT

  SELECT * FROM sflight
    INTO TABLE gt_sflight.
*    where seatsmax_b eq 31
*      and seatsocc_f ge 10
*      and seatsocc   lt 350.


  LOOP AT gt_sflight INTO gs_sflight WHERE seatsocc_f >= 10 AND seatsocc_f LT 15.
    gv_seatsocc_f = gs_sflight-seatsocc_f.
    CLEAR: gv_seatsocc_f.
  ENDLOOP.

*  read table gt_sflight into gs_sflight index 25.
*
*  if gs_sflight-seatsocc_f <= 18.
*    gv_seatsocc_f = gs_sflight-seatsocc_f * 10.
*  endif.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_string_oprt
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_string_oprt .
**** String Karşılaştırma Operatörleri ****

  DATA: gv_string1(30) TYPE c VALUE 'KİTAPLIK',
        gv_string2(30) TYPE c VALUE 'KİTAP',
        gv_string3(30) TYPE c VALUE 'ABCDQQQEFG',
        gv_string4(30) TYPE c VALUE 'QQQ',
        gv_string5(30) TYPE c VALUE 'ABCDQ'.

*CO: Contains Only
*CN: Not Contain Only

*CA: Contains Any
*NA: Contains Not Any

*CS: Contains String
*NS: Not Contain String

*CP: Contains Pattern
*NP: Not Contain Pattern
    IF gv_string1 Co gv_string2.
    WRITE: / gv_string2.
  ENDIF.

*    IF gv_string1 Ca gv_string2.
*    WRITE: / gv_string2.
*  ENDIF.

  IF gv_string1 Cs gv_string2.
    WRITE: / gv_string2.
  ENDIF.

*  IF gv_string2 CO gv_string1.
*    WRITE: / gv_string2.
*  ENDIF.
*
*  IF gv_string1 CS gv_string2.
*    WRITE: / gv_string2.
*  ENDIF.
*
*  IF gv_string1 CP gv_string2.
*    WRITE: / gv_string3.
*  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_itab_oprt
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_itab_oprt .
*** Internal Table & Structure ***
  SELECT * UP TO 10 ROWS FROM sflight
    INTO TABLE gt_sflight_new
    WHERE seatsocc_f GE 15.

  SELECT * UP TO 10 ROWS FROM sflight
    INTO TABLE gt_sflight_new2
    WHERE seatsocc_f LT 15.

** append **
*  loop at gt_sflight_new into gs_sflight_new.
*    append gs_sflight_new to gt_sflight_new2.
*  endloop.
*
*  append gs_sflight_new to gt_sflight_new2.
*  append lines of gt_sflight_new to gt_sflight_new2.
*
*  append lines of gt_sflight_new from 3 to 10 to gt_sflight_new2.
*
*  APPEND INITIAL LINE TO gt_sflight_new.
*  CLEAR: gs_sflight_new, gs_sflight_new2.

*  read table gt_sflight_new into gs_sflight_new index 10.

** insert **
*  insert gs_sflight_new into table gt_sflight_new2.
*  insert gs_sflight_new into gt_sflight_new2 index 15.

** modify **
*  clear: gt_sflight_new2[].
*
*  append gs_sflight_new to gt_sflight_new2.

*  read table gt_sflight_new into gs_sflight_new index 50.
*  modify table gt_sflight_new2 from gs_sflight_new.
*  modify gt_sflight_new2 from gs_sflight_new index 1.

*  loop at gt_sflight_new into gs_sflight_new where carrid = 'DL'.
*    gs_sflight_new-carrid = 'XX'.
*    modify gt_sflight_new from gs_sflight_new.
*  endloop.

  gt_sflight_new3[] = gt_sflight_new[].

  LOOP AT gt_sflight_new3 WHERE carrid = 'DL'
                            AND connid = 64.

    gt_sflight_new3-carrid = 'XX'.
    MODIFY gt_sflight_new3.
  ENDLOOP.


**delete

*  delete gt_sflight_new index 20.
*  delete gt_sflight_new where carrid = 'DL'.
*
*  loop at gt_sflight_new into gs_sflight_new where carrid = 'DL'.
*    delete gt_sflight_new.
*  endloop.

*** read table ***
*  read table gt_sflight_new into gs_sflight_new with key carrid = 'AA' connid = 64.
*  read table gt_sflight_new into gs_sflight_new index 15.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_str_trnc
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_str_trnc .
******************String İşlemleri ****************************

*write - ekrana yazdırmak için
*      - iki karakter tipi değişken arası değer atama
*concatanate
*condense
*shift
*replace
*search
*STRLEN
*translate

  DATA: lv_lowercase TYPE char30,
        lv_uppercase TYPE char30.

  gv_char1 = 'ABAP EĞİTİM GÜN 2'.
  gv_char2 = 'ABGÜNABC'.
  gv_char3 = 'XXXGXXÜXXN...'.
  gv_char4 = '12344321'.
  gv_int1 = 142.
*  write gv_char1.
*  write gv_int1 to gv_char2.
*
*  write / gv_char2.

*  concatenate gv_char1 gv_char2 gv_char3 gv_char4 into gv_char5 separated by space.
*  write / gv_char5.

*  shift gv_char4 left deleting leading '0'.
*
*  shift gv_char3 right deleting trailing '0'.

*  write / gv_char4.


*  replace gv_char3 in gv_char4 with gv_char2.
*  write / gv_char3.
*  write / gv_char2.
*  write / gv_char4.

*  SEARCH gv_char1 FOR 'GÜN'.
*  SEARCH gv_char2 FOR 'GÜN'.
*  SEARCH gv_char3 FOR 'GÜN'.
*
*
*  CHECK sy-fdpos EQ 0.
*
*  gv_int1 = strlen( gv_char1 ).
*
*
*  CONDENSE gv_char1 NO-GAPS.
*  CONDENSE gv_char1.
*
*  gv_char5 = gv_char4+6(2).
*
*  lv_lowercase = 'ufuk pehlevan'.
*  TRANSLATE lv_lowercase TO UPPER CASE.
*
*  lv_uppercase = 'ATANUR BEŞİRLİ'.
*  TRANSLATE lv_uppercase TO LOWER CASE.


*** check ***
*  clear: gt_sflight_new2[].
*
*  select * from sflight
*    into table gt_sflight_new2
*    where carrid eq 'AA'.
*
*  loop at gt_sflight_new2 into gs_sflight_new2.
*    search gv_char3 for 'GÜN'.
*    check sy-subrc = 0.
*    concatenate gv_char1 gv_char2 gv_char3 gv_char4 into gv_char5 separated by space.
*  endloop.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_matnr_conv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_matnr_conv .
  SELECT * FROM mara
    INTO TABLE @DATA(lt_mara)
    UP TO 150 ROWS.

  READ TABLE lt_mara INTO DATA(ls_mara) WITH KEY matnr = '000000000000000309'.


  CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
    EXPORTING
      input  = ls_mara-matnr
    IMPORTING
      output = gv_matnr.

  CHECK sy-subrc = 0.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_string_oprt_2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GV_USING
*&---------------------------------------------------------------------*
FORM f_string_oprt_2  USING p_gv_using
                      CHANGING p_lv_changing TYPE char50
                               p_lv_sayi_1 TYPE i
                               p_lv_sayi_2 TYPE i.
  WRITE / p_gv_using.
  p_lv_changing = 'son değer'.

  p_lv_sayi_1 = p_lv_sayi_1 + p_lv_sayi_2.
  p_lv_sayi_2 = p_lv_sayi_1 * p_lv_sayi_2.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_form_using_changing
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_form_using_changing .
  DATA: lv_using    TYPE char50,
        lv_changing TYPE char50.
  DATA: lv_sayi1 TYPE i,
        lv_sayi2 TYPE i.

  lv_using = 'perform with using'.
  lv_changing = 'ilk değer'.

  lv_sayi1 = 23.
  lv_sayi2 = 99.

  PERFORM f_string_oprt_2 USING lv_using
                          CHANGING lv_changing
                                   lv_sayi1
                                   lv_Sayi2.
  WRITE: / lv_changing.
  WRITE: / lv_sayi1.
  WRITE: / lv_sayi2.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_initial_lines
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_initial_lines.

  DATA: lv_int TYPE i VALUE 1,
        lv_mod TYPE i.

  SELECT ebeln, bukrs, bstyp, bsart, bsakz,   loekz
  FROM ekko
  INTO TABLE @DATA(lt_data)
  UP TO 100 ROWS.

  LOOP AT lt_data INTO DATA(ls_data).

    lv_mod = lv_int MOD 2.

    IF lv_mod EQ 0.
      INSERT INITIAL LINE INTO lt_data INDEX lv_int.
    ENDIF.

    lv_int += 1. "===== lv_int = lv_int + 1.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_initial_lines_2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_DATA
*&      <-- GT_DATA_NEW
*&---------------------------------------------------------------------*
FORM f_initial_lines_2  TABLES p_gt_data STRUCTURE gs_data.
  DATA: lv_int TYPE i VALUE 1,
        lv_mod TYPE i.


  LOOP AT p_gt_data[] INTO DATA(ls_data).

    lv_mod = lv_int MOD 2.

    IF lv_mod EQ 0.
      INSERT INITIAL LINE INTO p_gt_data INDEX lv_int.
    ENDIF.

    lv_int += 1. "===== lv_int = lv_int + 1.
  ENDLOOP.

ENDFORM.
