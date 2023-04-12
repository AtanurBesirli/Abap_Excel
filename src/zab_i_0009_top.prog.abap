*&---------------------------------------------------------------------*
*& Include          ZAB_I_0009_TOP
*&---------------------------------------------------------------------*

TABLES : likp, kna1.

DATA : gv_vbeln TYPE likp-vbeln VALUE '0080000017',
       gv_kunnr TYPE likp-kunnr,
       gv_name1 TYPE kna1-name1.

*mara-matnr malzeme no
*makt-maktx malzeme tanımı matnr
*mara-meins ölçü birimi
*mard-labst miktar      matnr
*vbap-posnr kalem no    vbeln

TYPES : BEGIN OF gty_data,
          vbeln TYPE likp-vbeln,
          kunnr TYPE likp-kunnr,
          name1 TYPE kna1-name1,
          matnr TYPE mara-matnr,
          maktx TYPE makt-maktx,
          meins TYPE mara-meins,
          labst TYPE mard-labst,
          posnr TYPE lips-posnr,
        END OF gty_data.

DATA : gt_data   TYPE TABLE OF gty_data,
       gs_data   TYPE gty_data,
       gv_matnr1 TYPE mara-matnr,
       gv_posnr1 TYPE lips-posnr,
       gv_labst1 TYPE mard-labst,
       gv_page   TYPE int1.

DATA : go_gbt       TYPE REF TO cl_gbt_multirelated_service,
       go_bcs       TYPE REF TO cl_bcs,
       go_doc_bcs   TYPE REF TO cl_document_bcs,
       go_recipient TYPE REF TO if_recipient_bcs,
       gt_soli      TYPE TABLE OF soli,
       gs_soli      TYPE soli,
       gv_status    TYPE bcs_rqst,
       gv_content   TYPE string.

DATA : gv_attachment_size TYPE sood-objlen,
       gt_att_content_hex TYPE solix_tab,
       gv_att_content     TYPE string,
       gv_att_line        TYPE string.

DATA: idx   TYPE i,
      line  TYPE i,
      lines TYPE i,
      limit TYPE i,
      c     TYPE i,
      fill  TYPE i,
      n1    TYPE i VALUE 5,
      n2    TYPE i VALUE 25.

DATA: ok_code TYPE sy-ucomm,
      save_ok TYPE sy-ucomm.
