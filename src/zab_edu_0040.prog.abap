*&---------------------------------------------------------------------*
*& Report ZEGT_P_0018
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0040.

INCLUDE zab_i_0040_top.
INCLUDE zab_i_0040_frm.

INITIALIZATION.

*  PERFORM f_numeric_oprt.
*  PERFORM f_string_oprt.
*  PERFORM f_itab_oprt.
*  PERFORM f_str_trnc.
*  PERFORM f_matnr_conv.
*  PERFORM f_form_using_changing.
*  PERFORM f_initial_lines.
*
*  SELECT ebeln bukrs bstyp bsart bsakz loekz
*    FROM ekko
*    INTO TABLE gt_data
*    UP TO 100 ROWS.
*
*  PERFORM f_initial_lines_2 TABLES gt_data.
*
*  CHECK sy-subrc = 0.
*
*
*  gm_demo 'abcd'.
