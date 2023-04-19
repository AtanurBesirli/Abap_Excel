*&---------------------------------------------------------------------*
*& Report ZAB_P_0012
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_p_0012.

INCLUDE zab_i_0012_top.
INCLUDE zab_i_0012_cls.
INCLUDE zab_i_0012_pbo.
INCLUDE zab_i_0012_pai.
INCLUDE zab_i_0012_frm.

AT SELECTION-SCREEN.

  CASE sscrfields-ucomm.
    WHEN 'BUT1'.
      PERFORM f_download_template.
    WHEN 'BUT2'.
      PERFORM f_upload_file.
  ENDCASE.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_excel.
  PERFORM f_folder_directory.

AT SELECTION-SCREEN OUTPUT.

  PERFORM f_dynamic_screen.

START-OF-SELECTION.
  PERFORM f_get_data.
  PERFORM f_call_screen.
