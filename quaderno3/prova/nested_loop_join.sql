EXPLAIN PLAN FOR SELECT /*+ USE NL(TAB3, TAB4) */ * FROM TAB3 WHERE ID3 IN (SELECT ID4 FROM TAB4);
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);