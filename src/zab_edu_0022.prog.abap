*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0022
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0022.
*DATA : gv_spell TYPE spell.
*PARAMETERS : p_amount like bseg-wrbtr.
*
*CALL FUNCTION 'SPELL_AMOUNT'
*  EXPORTING
*    amount = p_amount
**   CURRENCY        = ' '
**   FILLER = ' '
*   LANGUAGE        = SY-LANGU
* IMPORTING
*   IN_WORDS        = gv_spell
** EXCEPTIONS
**   NOT_FOUND       = 1
**   TOO_LARGE       = 2
**   OTHERS = 3
*  .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.
*
*MESSAGE gv_spell-dig01 TYPE 'I'.

PARAMETERS:
 pLANGU LIKE T002-SPRAS DEFAULT SY-LANGU,
 pCURR LIKE TCURC-WAERS DEFAULT 'USD',
 pAMOUNT LIKE VBAP-MWSBP ,
 pFILLER(1) TYPE C DEFAULT ' '.

DATA :
 WS_SPELL TYPE SPELL.

CALL FUNCTION 'SPELL_AMOUNT'
 EXPORTING
  AMOUNT = pAMOUNT
  CURRENCY = pCURR
  FILLER = pFILLER
  LANGUAGE = pLANGU "SY-LANGU
 IMPORTING
  IN_WORDS = WS_SPELL
 EXCEPTIONS
  NOT_FOUND = 1
  TOO_LARGE = 2
  OTHERS = 3
.
IF sy-subrc <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
  WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ELSE.
 WRITE :/ WS_SPELL-word , WS_SPELL-decword.
ENDIF.

BREAK-POINT.
