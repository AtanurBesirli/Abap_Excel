*&---------------------------------------------------------------------*
*& Include          ZAB_I_0044_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  DATA : y_v_index    TYPE sy-index,
         y_lv_d       TYPE f,
         y_lv_div     TYPE i,
         y_curr_p_num TYPE i.
  save_ok = ok_code.
  CLEAR ok_code.
  IF save_ok(1) = 'F'.
    idx = line + save_ok+1(2).
    READ TABLE gt_data INTO gs_data INDEX idx.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = gs_data-matnr
      IMPORTING
        output       = gs_data-matnr
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    SELECT SINGLE maktx FROM makt INTO gv_maktx
      WHERE matnr EQ gs_data-matnr
      AND spras = 'T'.

  ENDIF.

  CASE save_ok.
    WHEN '&BACK'.
      LEAVE TO SCREEN 0.
    WHEN '&PICK'.
      DATA : lv_field TYPE c LENGTH 30,
             lv_line  TYPE i,
             lv_value TYPE mara-matnr.
      GET CURSOR FIELD lv_field LINE lv_line VALUE lv_value.
      idx = line + lv_line.
      READ TABLE gt_data INTO gs_data INDEX idx.
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING
          input        = gs_data-matnr
        IMPORTING
          output       = gs_data-matnr
        EXCEPTIONS
          length_error = 1
          OTHERS       = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      SELECT SINGLE maktx FROM makt INTO gv_maktx
  WHERE matnr EQ gs_data-matnr
  AND spras = 'T'.

    WHEN 'PGDN'.
      y_lv_d = p_num / 5.
      y_v_div = ceil( y_v_d ).
      y_curr_p_num = y_v_div * 5.
      y_v_index = y_v_next + 1.
      IF y_v_next < y_v_div.
        y_v_next += y_v_next.
      ELSE.
        y_v_next = y_v_div.
      ENDIF.
      y_v_prev = y_v_next.
      IF y_v_next <> y_v_div.
        n2 = p_num - 5 * y_v_next.
        IF n2 > 5.
          n2 = 5 * y_v_next.
        ENDIF.
        n1 = 1.
        line = line + lines.
        limit = y_curr_p_num - lines.
        IF line > limit.
          line = limit.
        ENDIF.
      ELSE.
        y_v_next += y_v_next.
      ENDIF.
    WHEN 'PGUP'.
      n2 = 5 * y_v_next.
      IF n1 < 0.
        n1 = 1.
      ENDIF.
      IF y_v_next > 0.
        y_v_next -= y_v_next.
      ELSE.
        y_v_next = 0.
      ENDIF.
      y_v_prev = y_v_next.
      IF line NE 0 AND y_curr_p_num GT 5.
        line = y_v_next * 5.
      ELSE.
        line = 0.
        y_v_index = y_v_next - 1.

      ENDIF.
      IF line < 0.
        line = 0.
      ENDIF.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  TRANS_DATA_IN  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE trans_data_in INPUT.
  lines = sy-loopc.
  idx = sy-stepl + line.
  MODIFY gt_data FROM gs_data INDEX idx.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CANCEL  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE cancel INPUT.
  LEAVE PROGRAM.
ENDMODULE.
