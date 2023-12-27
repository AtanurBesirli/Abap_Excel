*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0007
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0007.

*TYPES : BEGIN OF gty_z1,
*          ebeln TYPE ebeln,
*          ebelp TYPE ebelp,
*          txz01 TYPE txz01,
*          bukrs TYPE bukrs,
*        END OF gty_z1.
*
*DATA : gt_z1 TYPE TABLE OF gty_z1.
*
*START-OF-SELECTION.

*SELECT ekpo~ebeln
*       ekpo~ebelp
*       ekpo~txz01
*       ekko~bukrs FROM ekko INNER JOIN ekpo
*       ON ekpo~ebeln eq ekko~ebeln INTO CORRESPONDING FIELDS OF TABLE
*       gt_z1.

*SELECT * FROM ekko INNER JOIN ekpo ON ekpo~ebeln EQ ekko~ebeln
*                   INNER JOIN ekbo ON ekbo~ebeln EQ ekko~ebeln
*                   INTO CORRESPONDING FIELDS OF TABLE gt_z1.


*BREAK-POINT.

DATA : gt_ekko TYPE TABLE OF ekko,
       gt_ekpo TYPE TABLE OF ekpo.

START-OF-SELECTION.

SELECT * FROM ekko INTO TABLE gt_ekko.

IF gt_ekko IS NOT INITIAL.
  SELECT * FROM ekpo INTO TABLE gt_ekpo
    FOR ALL ENTRIES IN gt_ekko
    WHERE ebeln eq gt_ekko-ebeln.

ENDIF.

BREAK-POINT.
