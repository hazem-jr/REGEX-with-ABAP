*&---------------------------------------------------------------------*
*& Report ZDELETE_COMMENTS
*&---------------------------------------------------------------------*
REPORT ZDELETE_COMMENTS.
TABLES : TRDIR .
PARAMETERS : OLD_PRG TYPE SY-REPID,
 NEW_PRG TYPE SY-REPID.
DATA : GT_OLD TYPE TABLE OF STRING,
 GT_NEW TYPE TABLE OF STRING.
READ REPORT OLD_PRG INTO GT_OLD .
IF SY-SUBRC = 0 .
 PERFORM DELETE_COMMENTS .
*& check the existance of the new program
 SELECT SINGLE * FROM TRDIR WHERE NAME = NEW_PRG .
 IF SY-SUBRC NE 0 .
 INSERT REPORT NEW_PRG FROM GT_NEW .
 IF SY-SUBRC = 0 .
 WRITE : / 'New program created by name : ' , NEW_PRG .
 ELSE .
 WRITE : / 'Program creation failed ' .
 ENDIF .
 ELSE .
 WRITE : / 'Distination program aready exist ' .
 ENDIF .
ENDIF .
*&---------------------------------------------------------------------*
*& delete any line start with * or have " in any position (from ")
*& using Regex
*&---------------------------------------------------------------------*
FORM DELETE_COMMENTS .
replace all OCCURRENCES OF REGEX '(^*.*)|([^"]*)("*.*)' in table gt_old
 with '$2' IGNORING CASE.
delete gt_old where table_line is INITIAL .
append LINES OF gt_old to GT_NEW .
ENDFORM.