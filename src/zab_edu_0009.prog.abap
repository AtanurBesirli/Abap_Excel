*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0009
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0009.

TYPES : BEGIN OF gty_bseg,
          bukrs TYPE bukrs,
          belnr	TYPE belnr_d,
          gjahr	TYPE gjahr,
          buzei	TYPE buzei,
*          buzid  TYPE buzid,
*          bschl  TYPE bschl,
*          koart  TYPE koart,
*          shkzg  TYPE shkzg,
          dmbtr	TYPE dmbtr,
*          wrbtr  TYPE wrbtr,
*          pswsl TYPE pswsl,
          zuonr TYPE dzuonr,
        END OF gty_bseg.

DATA : gt_bseg  TYPE TABLE OF gty_bseg,
       gs_bseg  TYPE gty_bseg,
       gv_belnr TYPE belnr_d.

START-OF-SELECTION.

*  SELECT * UP TO 50 ROWS FROM bseg INTO CORRESPONDING FIELDS OF TABLE gt_bseg.

*   SELECT belnr buzei dmbtr FROM bseg INTO CORRESPONDING FIELDS OF
*   TABLE gt_bseg.
*   READ TABLE gt_bseg INTO gs_bseg WITH KEY belnr = '4900000001'
*                                            buzei = '001'.
*   WRITE : gs_bseg-dmbtr.

*  SELECT belnr buzei dmbtr FROM bseg INTO CORRESPONDING FIELDS OF TABLE gt_bseg.
*  READ TABLE gt_bseg INTO gs_bseg INDEX 1.
*  WRITE gs_bseg-dmbtr.

  SELECT * FROM bseg INNER JOIN bsis on bseg~belnr eq bsis~belnr
                                    and bseg~bukrs eq bsis~bukrs
    INTO CORRESPONDING FIELDS OF TABLE gt_bseg.

  BREAK-POINT.
