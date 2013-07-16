CREATE OR REPLACE
PROCEDURE GEN_XML_SCHEMA_OUTPUT(
    P_TABLE_NAME VARCHAR2)
AS
  CURSOR C_TABLE_COLUMNS(C_TABLE_NAME VARCHAR2)
  IS
    SELECT
      COLUMN_NAME,
      DATA_TYPE,
      DATA_DEFAULT
    FROM
      USER_TAB_COLUMNS
    WHERE
      TABLE_NAME = C_TABLE_NAME;
  L_COL_STR VARCHAR2(2000);
BEGIN
  DBMS_OUTPUT.PUT_LINE('<?xml version="1.0" encoding="UTF-8"?>');
  DBMS_OUTPUT.PUT_LINE(
  '<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">');
  DBMS_OUTPUT.PUT_LINE('<' || UPPER(P_TABLE_NAME) || '>');
  DBMS_OUTPUT.PUT_LINE('<xs:complexType>');
  DBMS_OUTPUT.PUT_LINE('<xs:sequence>');
  FOR L_CUR_TABLE_COLUMNS IN C_TABLE_COLUMNS(P_TABLE_NAME)
  LOOP
    L_COL_STR := '<xs:element name= "' || L_CUR_TABLE_COLUMNS.COLUMN_NAME ||
    '" type="' ;
    IF L_CUR_TABLE_COLUMNS.DATA_TYPE    = 'VARCHAR2' THEN
      L_COL_STR                        := L_COL_STR || 'xs:string' || '"';
    ELSIF L_CUR_TABLE_COLUMNS.DATA_TYPE = 'NUMBER' THEN
      L_COL_STR                        := L_COL_STR || 'xs:integer' || '"';
    ELSIF L_CUR_TABLE_COLUMNS.DATA_TYPE = 'DATE' THEN
      L_COL_STR                        := L_COL_STR || 'xs:date' || '"';
    END IF;
    IF L_CUR_TABLE_COLUMNS.DATA_DEFAULT IS NOT NULL THEN
      L_COL_STR                         := L_COL_STR || ' default="' || TRIM(
      L_CUR_TABLE_COLUMNS.DATA_DEFAULT) || '"';
    END IF;
    L_COL_STR := L_COL_STR || '/>';
    DBMS_OUTPUT.PUT_LINE( L_COL_STR);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE( '</xs:sequence>');
  DBMS_OUTPUT.PUT_LINE( '</xs:complexType>');
  DBMS_OUTPUT.PUT_LINE( '</' || UPPER(P_TABLE_NAME) || '>');
END GEN_XML_SCHEMA_OUTPUT;
