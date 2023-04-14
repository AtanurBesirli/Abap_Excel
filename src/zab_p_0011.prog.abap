*&---------------------------------------------------------------------*
*& Report ZAB_P_0011
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_p_0011.
INCLUDE zab_i_0011_frm.

*zab_t_0008 -> kitap tablosu
*zab_t_0009 -> tür tablosu
*zab_t_0010 -> yazar tablosu
*zab_t_0011 -> öğrenci tablosu
*zab_t_0012 -> işlem tablosu

PARAMETERS p_soruno TYPE numc2.

START-OF-SELECTION.

PERFORM f_cases CHANGING p_soruno.
