*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0008
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0008.

DATA : gt_scarr TYPE TABLE OF scarr,
       gs_scarr TYPE scarr.

FIELD-SYMBOLS : <gfs_scarr> TYPE scarr.

START-OF-SELECTION.

SELECT * FROM scarr INTO TABLE gt_scarr.

*LOOP AT gt_scarr INTO gs_scarr.
*  IF  gs_scarr-carrid eq 'AF'.
*    gs_scarr-carrname = 'Air Force'.
*    MODIFY gt_scarr FROM gs_scarr.
*  ENDIF.
*ENDLOOP.

*LOOP AT gt_scarr ASSIGNING <gfs_scarr>.
*  IF <gfs_scarr>-carrid eq 'AF'.
*     <gfs_scarr>-carrname = 'Pegasus'.
*  ENDIF.
*ENDLOOP.

READ TABLE gt_scarr ASSIGNING <gfs_scarr> WITH KEY carrid = 'AF'.
  <gfs_scarr>-carrname = 'Airlines'.

BREAK-POINT.
