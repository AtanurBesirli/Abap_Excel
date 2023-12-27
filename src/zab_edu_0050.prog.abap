*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0050
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAB_EDU_0050.

TABLES : mara.

*PARAMETERS p_input(10) TYPE c.
*WRITE : p_input RIGHT-JUSTIFIED.
*PARAMETERS : p_input1 TYPE char20.
*PARAMETERS : p_input2 TYPE c LENGTH 10.

SELECT-OPTIONS s_matnr for mara-matnr.

*Billing document header structure
TYPES: BEGIN OF TY_VBRK,
VBELN TYPE VBELN_VF, "Document Number
FKDAT TYPE FKDAT, "Bill Date
NETWR TYPE NETWR, "Net Value
KUNRG TYPE KUNRG, "Payer
END OF TY_VBRK.
*Billing document item structure
TYPES: BEGIN OF TY_VBRP,
VBELN TYPE VBELN_VF, "Document Number
POSNR TYPE POSNR_VF, "Item Number
ARKTX TYPE ARKTX, "Description
FKIMG TYPE FKIMG, "Qty
VRKME TYPE VRKME, "Sales Unit
NETWR TYPE NETWR_FP, "Net Value
MATNR TYPE MATNR, "Material Num
MWSBP TYPE MWSBP, "Tax amt
END OF TY_VBRP.
DATA: it_vbrp TYPE TABLE OF ty_vbrp,
it_vbrk TYPE TABLE OF ty_vbrk,
wa_vbrk TYPE ty_vbrk,
wa_vbrp TYPE ty_vbrp.
*Selection screen declaration for user selection criteria
SELECT-OPTIONS: s_vbeln FOR wa_vbrp-vbeln.
START-OF-SELECTION.
*Select Header Data
SELECT VBELN FKDAT NETWR KUNRG FROM VBRK
INTO TABLE it_vbrk
WHERE VBELN in s_matnr.
"Select Item Data.
  SELECT VBELN POSNR ARKTX FKIMG VRKME NETWR MATNR MWSBP
FROM vbrp INTO TABLE it_vbrp WHERE vbeln in s_vbeln.
END-OF-SELECTION.
*The SORT statement ensures the control break is consistent if
*the table is not a sorted table.
SORT it_vbrp BY vbeln.
LOOP AT it_vbrp INTO wa_vbrp.
AT FIRST. "Print Column Headings
WRITE AT: /05 'ITEM',
15 'DESCRIPTION',
60 'BILLED QUANTITY',
80 'UNITS',
105 'NET VALUE',
130 'MATERIAL NUMBER',
150 'TAX AMOUNT'.
WRITE SY-ULINE.
ENDAT.
AT NEW VBELN. " To print header data once per new document
READ TABLE it_vbrk into wa_vbrk WITH KEY
VBELN = wa_vbrp-vbeln.
WRITE AT : /5 'Billing Document' LEFT-JUSTIFIED.
WRITE AT : 30 wa_vbrk-vbeln LEFT-JUSTIFIED COLOR 2.
WRITE AT : /5 'Payer' LEFT-JUSTIFIED.
WRITE AT : 30 wa_vbrk-kunrg LEFT-JUSTIFIED COLOR 3.
WRITE AT: /5 'BILLING DATE' LEFT-JUSTIFIED.
WRITE AT: 30 wa_vbrk-fkdat LEFT-JUSTIFIED COLOR 5.
WRITE AT: /5 'NET VALUE' LEFT-JUSTIFIED.
WRITE AT: 30 wa_vbrk-netwr LEFT-JUSTIFIED COLOR 6.
ENDAT.
*Print Item details
WRITE : /5 wa_vbrp-posnr LEFT-JUSTIFIED,
15 wa_vbrp-arktx LEFT-JUSTIFIED,
60 wa_vbrp-fkimg LEFT-JUSTIFIED,
80 wa_vbrp-vrkme LEFT-JUSTIFIED,
105 wa_vbrp-netwr LEFT-JUSTIFIED,
130 wa_vbrp-matnr LEFT-JUSTIFIED,
150 wa_vbrp-mwsbp LEFT-JUSTIFIED.
*To print document total net value at the end of last item in the
*document. The code in AT END OF will execute before the next new
*document.
AT END OF vbeln.
*The keyword SUM can be used within a control break to
*automatically add up the column.
SUM.
*Prints total Sum for document
WRITE : / '105' , WA_VBRP-NETWR LEFT-JUSTIFIED.
ENDAT.
*To identify the last record in the table
AT LAST.
WRITE : / 'END OF REPORT'.
ENDAT.
ENDLOOP.



BREAK-POINT.
