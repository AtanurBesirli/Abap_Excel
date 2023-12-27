*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0046
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0046.

TYPES: BEGIN OF ty_itab,
         matnr TYPE mara-matnr,
         meins TYPE mara-meins,
       END OF ty_itab.

DATA : gt_data TYPE STANDARD TABLE OF ty_itab,
       gs_data TYPE ty_itab,
       fill    TYPE i.

DATA: idx   TYPE i,
      line  TYPE i,
      lines TYPE i,
      limit TYPE i,
      c     TYPE i.
*      n1    TYPE i VALUE 5,
*      n2    TYPE i VALUE 25.

DATA: ok_code TYPE sy-ucomm,
      save_ok TYPE sy-ucomm.

START-OF-SELECTION.

  SELECT matnr meins UP TO 10 ROWS FROM mara INTO TABLE gt_data.

  fill = lines( gt_data ).

  CALL SCREEN 100.

MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
ENDMODULE.

MODULE transp_gt_data_out OUTPUT.
  idx = sy-stepl + line.
  gs_data = gt_data[ idx ].
ENDMODULE.

MODULE transp_gt_data_in INPUT.
  lines = sy-loopc.
  idx = sy-stepl + line.
  MODIFY gt_data FROM gs_data INDEX idx.
ENDMODULE.

MODULE user_command_0100 INPUT.
  save_ok = ok_code.
  CLEAR ok_code.
  CASE save_ok.
    WHEN 'NEXT_LINE'.
      line = line + 1.
      limit = fill - lines.
      IF line > limit.
        line = limit.
      ENDIF.
    WHEN 'PREV_LINE'.
      line = line - 1.
      IF line < 0.
        line = 0.
      ENDIF.
    WHEN 'NEXT_PAGE'.
      line = line + lines.
      limit = fill - lines.
      IF line > limit.
        line = limit.
      ENDIF.
    WHEN 'PREV_PAGE'.
      line = line - lines.
      IF line < 0.
        line = 0.
      ENDIF.
    WHEN 'LAST_PAGE'.
      line =  fill - lines.
    WHEN 'FIRST_PAGE'.
      line = 0.
    WHEN '&BACK'.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.

MODULE get_first_line INPUT.
  line = c - 1.
ENDMODULE.

MODULE cancel INPUT.
  LEAVE PROGRAM.
ENDMODULE.
