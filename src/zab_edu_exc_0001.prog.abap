*&---------------------------------------------------------------------*
*& Report ZAB_EDU_EXC_0001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_exc_0001.

DATA : application TYPE ole2_object,
       workbook    TYPE ole2_object,
       sheet       TYPE ole2_object,
       cells       TYPE ole2_object.

DATA : gt_scarr TYPE TABLE OF scarr,
       gs_scarr TYPE scarr,
       gv_row   TYPE i.

START-OF-SELECTION.

select * FROM scarr INTO TABLE gt_scarr.

  CREATE OBJECT application 'excel.application'.
  SET PROPERTY OF application 'visible' = 1.
  CALL METHOD OF application 'workbooks' = workbook.
  CALL METHOD OF workbook 'add'.

  CALL METHOD OF application 'worksheets' = sheet
  EXPORTING #1 = 1.
  CALL METHOD OF sheet 'Activate'.
  SET PROPERTY OF sheet 'Name' = 'Sheet1'.

PERFORM fill_cell USING 1 1 'A'.
PERFORM fill_cell USING 1 2 'B'.
PERFORM fill_cell USING 1 3 'C'.
PERFORM fill_cell USING 1 4 'D'.
PERFORM fill_cell USING 1 5 'E'.

LOOP AT gt_scarr INTO gs_scarr.
  gv_row = sy-tabix + 1.
 PERFORM fill_cell USING gv_row 1 gs_scarr-mandt.
 PERFORM fill_cell USING gv_row 2 gs_scarr-carrid.
 PERFORM fill_cell USING gv_row 3 gs_scarr-carrname.
 PERFORM fill_cell USING gv_row 4 gs_scarr-currcode.
 PERFORM fill_cell USING gv_row 5 gs_scarr-url.
ENDLOOP.

FORM fill_cell USING row col val.
  CALL METHOD OF sheet 'Cells' = cells EXPORTING #1 = row #2 = col.
  SET PROPERTY OF cells 'Value' = Val.
ENDFORM.
