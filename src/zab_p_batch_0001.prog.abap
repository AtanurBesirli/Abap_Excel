report ZAB_P_BATCH_0001
       no standard page heading line-size 255.

* Include bdcrecx1_s:
* The call transaction using is called WITH AUTHORITY-CHECK!
* If you have own auth.-checks you can use include bdcrecx1 instead.
include bdcrecx1_s.

parameters: dataset(132) lower case.
***    DO NOT CHANGE - the generated data section - DO NOT CHANGE    ***
*
*   If it is nessesary to change the data section use the rules:
*   1.) Each definition of a field exists of two lines
*   2.) The first line shows exactly the comment
*       '* data element: ' followed with the data element
*       which describes the field.
*       If you don't have a data element use the
*       comment without a data element name
*   3.) The second line shows the fieldname of the
*       structure, the fieldname must consist of
*       a fieldname and optional the character '_' and
*       three numbers and the field length in brackets
*   4.) Each field must be type C.
*
*** Generated data section with specific formatting - DO NOT CHANGE  ***
data: begin of record,
* data element: MATNR
        MATNR_001(040),
* data element: XFELD
        KZSEL_01_002(001),
* data element: MAKTX
        MAKTX_003(040),
* data element: MEINS
        MEINS_004(003),
* data element: MSTAE
        MSTAE_005(002),
* data element: BRGEW
        BRGEW_006(017),
* data element: GEWEI
        GEWEI_007(003),
      end of record.

*** End generated data section ***

start-of-selection.

perform open_dataset using dataset.
perform open_group.

do.

read dataset dataset into record.
if sy-subrc <> 0. exit. endif.

perform bdc_dynpro      using 'SAPLMGMM' '0060'.
perform bdc_field       using 'BDC_CURSOR'
                              'RMMG1-MATNR'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'RMMG1-MATNR'
                              record-MATNR_001.
perform bdc_dynpro      using 'SAPLMGMM' '0070'.
perform bdc_field       using 'BDC_CURSOR'
                              'MSICHTAUSW-DYTXT(01)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'MSICHTAUSW-KZSEL(01)'
                              record-KZSEL_01_002.
perform bdc_dynpro      using 'SAPLMGMM' '4004'.
perform bdc_field       using 'BDC_OKCODE'
                              '=BU'.
perform bdc_field       using 'BDC_CURSOR'
                              'MAKT-MAKTX'.
perform bdc_field       using 'MAKT-MAKTX'
                              record-MAKTX_003.
perform bdc_field       using 'MARA-MEINS'
                              record-MEINS_004.
perform bdc_field       using 'MARA-MSTAE'
                              record-MSTAE_005.
perform bdc_field       using 'MARA-BRGEW'
                              record-BRGEW_006.
perform bdc_field       using 'MARA-GEWEI'
                              record-GEWEI_007.
perform bdc_transaction using 'MM02'.

enddo.

perform close_group.
perform close_dataset using dataset.
