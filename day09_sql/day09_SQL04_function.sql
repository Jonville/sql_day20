
                            ---- FUNCTION ----

    -- �ڹ��� �Լ��� ��������

    -- �ش� �μ��� ���� ���� �޿� ��                            
CREATE OR REPLACE FUNCTION MAX_TEST
    (P_DEPTNO IN EMP.DEPTNO%TYPE)
    RETURN NUMBER       -- RETURN Ÿ���� ��������Ѵ� . �ڹ�ó��
IS
    MAX_SAL EMP.SAL%TYPE;
BEGIN
    SELECT MAX(SAL)
    INTO MAX_SAL    -- MAX(SAL) ���� MAX_SAL �� �־��شٴ� �ǹ�
    FROM EMP
    WHERE DEPTNO = P_DEPTNO
    ;
    RETURN MAX_SAL      -- MAX_SAL �� �ٽ� ���� ���ش�
    ;
    
END;
/

SELECT MAX_TEST(10)
FROM EMP
;

--------------------------------------------------------------------------------

                            ---- ����Ǯ��1 ----         --!�������� ���̾�!--
                            
    -- DATE_TEST1 �Լ�
    -- DATE_TEST1(��¥������, �����ͺ�ȯ����)
    -- �����ͺ�ȯ���� => 'DATETIME' -> YYYY-MM-DD HH24:MI:SS
    -- �����ͺ�ȯ���� => 'DATE' -> YYYY-MM-DD
    -- �����ͺ�ȯ���� => 'TIME' -> HH24:MI:SS

SELECT TO_CHAR(SYSDATE , 'YYYY-MM-DD HH24:MI:SS')
FROM EMP;

SELECT * FROM EMP;

CREATE OR REPLACE FUNCTION DATE_TEST1
    (P_DATE IN DATE
    , P_KIND IN VARCHAR2)
    RETURN VARCHAR2      -- RETURN Ÿ���� ��������Ѵ� . �ڹ�ó��
IS
    V_DATE VARCHAR2(50);
BEGIN
    IF P_KIND = 'DATETIME' THEN
        V_DATE := TO_CHAR(P_DATE, 'YYYY-MM-DD HH24:MI:SS');
    ELSIF P_KIND = 'DATE' THEN
        V_DATE := TO_CHAR(P_DATE, 'YYYY-MM-DD');
    ELSIF P_KIND = 'TIME' THEN
        V_DATE := TO_CHAR(P_DATE, 'HH24:MI:SS');
    END IF;
    
    RETURN V_DATE;
END;
/

SELECT DATE_TEST1(HIREDATE , 'DATETIME')
FROM EMP;