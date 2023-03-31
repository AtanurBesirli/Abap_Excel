*&---------------------------------------------------------------------*
*& Include          ZLIB_P_AB_0001_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN '&BACK'.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0110 INPUT.
  CASE sy-ucomm.
    WHEN '&BACK'.
      SET SCREEN 0.
    WHEN '&SEARCH'.
      PERFORM f_data_search.
    WHEN '&SAVE'.
      PERFORM f_data_save.
    WHEN '&DEL'.
      PERFORM f_data_del.
    WHEN '&SALL'.
      PERFORM f_data_sall.
    WHEN '&BOR'.
      PERFORM f_data_bor.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0120  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0120 INPUT.
  CASE sy-ucomm.
    WHEN '&BACK'.
      SET SCREEN 0.
      PERFORM f_clear_member.
    WHEN '&SAVE'.
      PERFORM f_member_save.
    WHEN '&DEL'.
      PERFORM f_member_del.
    WHEN '&SEARCH'.
      PERFORM f_member_search.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0130  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0130 INPUT.
  CASE sy-ucomm.
    WHEN '&BACK'.
      SET SCREEN 0.
      PERFORM f_clear_shelf.
    WHEN '&CREATE'.
      PERFORM f_shelf_create.
    WHEN '&SAVE'.
      PERFORM f_shelf_save.
    WHEN '&DEL'.
      PERFORM f_shelf_delete.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0140  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0140 INPUT.
  CASE sy-ucomm.
    WHEN '&BACK'.
      SET SCREEN 0.
      PERFORM f_clear_var.
    WHEN '&SAVE'.
      PERFORM f_borrow_save.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0111  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0111 INPUT.
  CASE sy-ucomm.
    WHEN '&OK'.
      LEAVE TO SCREEN 0.
    WHEN '&EXIT'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0300 INPUT.
  CASE sy-ucomm.
    WHEN '&BACK'.
      SET SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  FIELD_VALIDATION  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE field_validation INPUT.
  CASE sy-ucomm.
    WHEN '&SAVE'.

      IF gv_bookid_bo IS INITIAL.
        MESSAGE 'Kitap Numarası Giriniz' TYPE 'E'.
      ENDIF.

      IF gv_id IS INITIAL.
        MESSAGE 'Üye Numarası Giriniz' TYPE 'E'.
      ENDIF.

  ENDCASE.

ENDMODULE.
