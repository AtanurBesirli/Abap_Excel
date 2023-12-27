*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0011
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0011.


START-OF-SELECTION.

  CALL SCREEN 0100.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS0100'.
  SET TITLEBAR '0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA : lv_text TYPE char100.

  CONCATENATE 'You Selected' sy-ucomm INTO lv_text SEPARATED BY space.

  MESSAGE lv_text TYPE 'I'.

  CASE sy-ucomm.
    WHEN '&BACK'.
      LEAVE TO SCREEN 0.
    WHEN '&EXIT'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
