*&---------------------------------------------------------------------*
*& Include          ZAB_I_0009_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE sy-ucomm.
    WHEN '&BACK'.
      LEAVE TO SCREEN 0.
    WHEN '&CON'.
      CALL SCREEN '0200'.
    WHEN '&BCK'.
      LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  save_ok = ok_code.
  CLEAR ok_code.
  CASE save_ok.
    WHEN '&DWN'.
      line = line + 1.
      limit = fill - lines.
      IF line > limit.
        line = limit.
      ENDIF.
    WHEN '&UP'.
      line = line - 1.
      IF line < 0.
        line = 0.
      ENDIF.
    WHEN '&LPG'.
      line =  fill - lines.
    WHEN '&FPG'.
      line = 0.
    WHEN '&BACK'.
      LEAVE TO SCREEN 0.
    WHEN '&BCK'.
      LEAVE PROGRAM.
    WHEN '&ADD'.
      PERFORM f_add.
    WHEN '&DEL'.
      PERFORM f_del.
    WHEN '&SAVE'.
      PERFORM f_save.
  ENDCASE.

ENDMODULE.
