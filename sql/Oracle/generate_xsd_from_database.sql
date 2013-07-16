CREATE OR REPLACE
PROCEDURE GEN_XML_SCHEMA_OUTPUT
AS
  CURSOR C_TABLE_COLUMNS(C_TABLE_NAME VARCHAR2)
  IS
    SELECT
      COLUMN_NAME,
      DATA_TYPE,
      DATA_LENGTH,
      DATA_PRECISION,
      DATA_DEFAULT
    FROM
      USER_TAB_COLUMNS
    WHERE
      TABLE_NAME = C_TABLE_NAME;
  CURSOR C_TABLE
  IS
    SELECT
      TABLE_NAME
    FROM
      USER_TABLES
    ORDER BY
      TABLE_NAME;
  L_COL_STR VARCHAR2(2000);
BEGIN
  DBMS_OUTPUT.PUT_LINE('<?xml version="1.0" encoding="UTF-8"?>');
  DBMS_OUTPUT.PUT_LINE(
  '<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">');
  FOR L_CUR_TABLE IN C_TABLE
  LOOP
    DBMS_OUTPUT.PUT_LINE('<xs:complexType name ="'|| UPPER(
    L_CUR_TABLE.TABLE_NAME) ||'">');
    DBMS_OUTPUT.PUT_LINE('<xs:sequence>');
    FOR L_CUR_TABLE_COLUMNS IN C_TABLE_COLUMNS(L_CUR_TABLE.TABLE_NAME)
    LOOP
      L_COL_STR := '<xs:element name= "' || L_CUR_TABLE_COLUMNS.COLUMN_NAME ||
      '"';
      IF L_CUR_TABLE_COLUMNS.DATA_TYPE = 'VARCHAR2' OR
        L_CUR_TABLE_COLUMNS.DATA_TYPE  = 'CHAR' THEN
        L_COL_STR                     := L_COL_STR || '>';
        L_COL_STR                     := L_COL_STR ||
        '<xs:simpleType><xs:restriction base="';
        L_COL_STR := L_COL_STR || 'xs:string' || '">';
        L_COL_STR := L_COL_STR ||
        '<xs:minLength value="0"/><xs:maxLength value="' ||
        L_CUR_TABLE_COLUMNS.DATA_LENGTH || '"/>';
        L_COL_STR := L_COL_STR ||
        '</xs:restriction></xs:simpleType></xs:element>';
      ELSIF L_CUR_TABLE_COLUMNS.DATA_TYPE = 'NUMBER' THEN
        L_COL_STR                        := L_COL_STR ||
        ' type = "xs:integer"/>';
      ELSIF L_CUR_TABLE_COLUMNS.DATA_TYPE = 'DATE' THEN
        L_COL_STR                        := L_COL_STR ||
        ' type = "xs:dateTime"/>';
      END IF;
      DBMS_OUTPUT.PUT_LINE( L_COL_STR);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE( '</xs:sequence>');
    DBMS_OUTPUT.PUT_LINE( '</xs:complexType>');
  END LOOP;
  DBMS_OUTPUT.PUT_LINE( '</xs:schema>');
END GEN_XML_SCHEMA_OUTPUT;
