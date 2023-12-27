REPORT zab_edu_0045.

*TYPES: BEGIN OF t_itab,
*         col1 TYPE i,
*         col2 TYPE i,
*       END OF t_itab.

TYPES: BEGIN OF ty_itab,
         matnr TYPE mara-matnr,
         meins TYPE mara-meins,
       END OF ty_itab.

DATA : gt_data TYPE STANDARD TABLE OF ty_itab,
       gs_data type ty_itab.

*DATA: itab TYPE STANDARD TABLE OF t_itab,
*      wa   LIKE LINE OF itab,
data:      fill TYPE i.

DATA: idx   TYPE i,
      line  TYPE i,
      lines TYPE i,
      limit TYPE i,
      c     TYPE i,
      n1    TYPE i VALUE 5,
      n2    TYPE i VALUE 25.

DATA:  ok_code TYPE sy-ucomm,
       save_ok TYPE sy-ucomm.

START-OF-SELECTION.

SELECt matnr meins up to 10 rows FROM mara into TABLE gt_data.

*  itab = VALUE #( FOR j = 1 UNTIL j > 40
*                  ( col1 = j col2 = j ** 2 ) ).
*
*  fill = lines( itab ).
  fill = lines( gt_data ).

  CALL SCREEN 100.

MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_100' EXCLUDING 'PREVIOUS'.
ENDMODULE.

MODULE status_0200 OUTPUT.
  SET PF-STATUS 'STATUS_200' EXCLUDING 'NEXT'.
ENDMODULE.

MODULE transp_itab_out OUTPUT.
  idx = sy-stepl + line.
*  wa = itab[ idx ].
*  gs_data = gt_data[ idx ].
ENDMODULE.
MODULE transp_gt_data_out OUTPUT.
  idx = sy-stepl + line.
  gs_data = gt_data[ idx ].
ENDMODULE.

MODULE transp_itab_in INPUT.
  lines = sy-loopc.
  idx = sy-stepl + line.
*  MODIFY itab FROM wa INDEX idx.
*  MODIFY gt_data FROM gs_data INDEX idx.
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
    WHEN 'NEXT'.
      c = line + 1.
      LEAVE TO SCREEN 200.
  ENDCASE.
ENDMODULE.

MODULE get_first_line INPUT.
  line = c - 1.
ENDMODULE.

MODULE user_command_0200 INPUT.
  save_ok = ok_code.
  CASE save_ok.
    WHEN 'PREVIOUS'.
      LEAVE TO SCREEN 100.
  ENDCASE.
ENDMODULE.

MODULE cancel INPUT.
  LEAVE PROGRAM.
ENDMODULE.
