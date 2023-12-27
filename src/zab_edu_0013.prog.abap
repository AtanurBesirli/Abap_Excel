*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0013
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0013.

DATA : gs_sflight TYPE sflight.

PARAMETERS : p_carrid TYPE s_carr_id,
             p_connid TYPE s_conn_id,
             p_fldate TYPE s_date.

START-OF-SELECTION.

  SELECT SINGLE * FROM sflight
    INTO gs_sflight
    WHERE carrid EQ p_carrid
    AND   connid EQ p_connid
    AND   fldate EQ p_fldate.

  CALL SCREEN 0100.

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN '&BCK'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
