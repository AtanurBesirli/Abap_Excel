*&---------------------------------------------------------------------*
*& Include          ZAB_I_0003_PAI
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN '&BACK'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
