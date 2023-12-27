*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0016
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAB_EDU_0016.

DATA : l_where TYPE string,
       i_marc TYPE STANDARD TABLE OF marc.

CONSTANTS: l_quote TYPE char1 VALUE ''''.

PARAMETERS : p_plant TYPE marc-werks.

CONCATENATE 'WERKS' space '=' space l_quote p_plant l_quote space
            'AND' space 'PERKZ' space '=' space l_quote 'M' l_quote
       INTO l_where RESPECTING BLANKS.

SELECT * FROM marc INTO TABLE i_marc WHERE (l_where).

  BREAK-POINT.
