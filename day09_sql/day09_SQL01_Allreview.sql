-- SELECT , UPDATE , INSERT , DELETE
-- JOIN (INNER, LEFT), SELF JOIN

SELECT *            -- * ���°� �����ض�, �ʿ��� �÷��� ����Ҽ��ֵ��� ����ȭ �ض�
FROM EMP
WHERE SAL >= 1500 AND SAL <= 2000;

SELECT *
FROM EMP E
INNER JOIN DEPT D ON E.DEPTNO = D.DEPTNO
;

-- STUDENT , ENROL JOIN

SELECT *
FROM STUDENT S
INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
INNER JOIN SUBJECT S2 ON E.SUB_NO = S2.SUB_NO
;

-- ������ ���� ��޸��̱�

SELECT E.EMPNO , E.DEPTNO
FROM EMP E
INNER JOIN DEPT D ON E.DEPTNO = D.DEPTNO
INNER JOIN SALGRADE S ON E.SAL BETWEEN S.LOSAL AND S.HISAL
;

SELECT COUNT(*) , DEPTNO
FROM EMP
GROUP BY DEPTNO
;
SELECT *
FROM EMP
;
SELECT ROUND(AVG(SAL),2) , DEPTNO
FROM EMP
GROUP BY DEPTNO
;

-- �μ��� ��� �޿��� �ִ밪�� �ּҰ��� ����

SELECT MAX(AVG_S) - MIN(AVG_S)
FROM (
        SELECT ROUND(AVG(SAL),2) AVG_S , DEPTNO
        FROM EMP
        GROUP BY DEPTNO
        )
;

-- ��ü ��պ��� �޿��� �� �޴� ģ�� ���ϱ�

SELECT *
FROM EMP
WHERE SAL > (
            SELECT AVG(SAL) AVG_S
            FROM EMP
            )
;

-- ��簡 ������ �˻�
-- ��� , �̸� , ����� �̸� ���

SELECT E.EMPNO , E.ENAME , E2.EMPNO , E2.ENAME
FROM EMP E
INNER JOIN EMP E2 ON E.MGR = E2.EMPNO
ORDER BY E.EMPNO
;

-- ���������� ���� ���� ����� �̸��� �����
SELECT *
FROM EMP E
INNER JOIN (
            SELECT COUNT(*) CNT , MGR
            FROM EMP
            GROUP BY MGR
            ORDER BY CNT DESC
            )A ON A.MGR = E.EMPNO
WHERE ROWNUM = 1
;

SELECT *
FROM(
    SELECT COUNT(*) CNT , MGR
    FROM EMP 
    GROUP BY MGR
    ORDER BY CNT DESC
    )E
INNER JOIN EMP E2 ON E.MGR = E2.EMPNO
WHERE ROWNUM = 1;

-- ���� �μ��� ��ձ޿����� ���� �޿��� �޴� ����� ��� ���

SELECT *
FROM (
    SELECT ROUND(AVG(SAL),2) AVG_S , DEPTNO
    FROM EMP
    GROUP BY DEPTNO
    )A 
INNER JOIN EMP E ON A.DEPTNO = E.DEPTNO AND SAL > AVG_S
;

-- ���� �а��� ��� Ű���� ū �л����� ���� ���

SELECT *
FROM STUDENT
;

SELECT *
FROM
    (
    SELECT ROUND(AVG(STU_HEIGHT),2) AVG_H , STU_DEPT
    FROM STUDENT
    GROUP BY STU_DEPT
    )  A
INNER JOIN STUDENT S ON S.STU_DEPT = A.STU_DEPT AND STU_HEIGHT > AVG_H
;


-- ��ǻ������ �а����� ����� ���� �а��� ���� ���


SELECT *
FROM STUDENT
;

SELECT *
FROM ENROL
;

SELECT *
FROM SUBJECT
;

SELECT AVG_GRADE , STU_DEPT
FROM
    (
    SELECT AVG(ENR_GRADE) AVG_GRADE , STU_DEPT
    FROM ENROL E
    INNER JOIN STUDENT S ON E.STU_NO = S.STU_NO
    GROUP BY STU_DEPT
    )
WHERE AVG_GRADE < (
                SELECT AVG(ENR_GRADE)
                FROM ENROL E
                INNER JOIN STUDENT S ON E.STU_NO = S.STU_NO
                WHERE S.STU_DEPT = '��ǻ������'
                    )
;

------------HAVING ���-------------

SELECT AVG(ENR_GRADE) , STU_DEPT
FROM ENROL E
INNER JOIN STUDENT S ON E.STU_NO = S.STU_NO
GROUP BY STU_DEPT
HAVING AVG(ENR_GRADE) < (
                        SELECT AVG(ENR_GRADE)
                        FROM ENROL E
                        INNER JOIN STUDENT S ON E.STU_NO = S.STU_NO
                        WHERE S.STU_DEPT = '��ǻ������'
                        )
;

-- ���� 1. ��ǻ�� ���� ������ ��� �л����� ��� ��������
-- ���� ������ ������ �ִ� ��ǻ�������� �л� ���

SELECT AVG_GRADE , STU_DEPT
FROM
    (
    SELECT AVG(ENR_GRADE) AVG_GRADE , STU_DEPT
    FROM ENROL E
    INNER JOIN STUDENT S ON E.STU_NO = S.STU_NO
    GROUP BY STU_DEPT
    )
WHERE AVG_GRADE < (
                SELECT AVG(ENR_GRADE)
                FROM ENROL E
                INNER JOIN STUDENT S ON E.STU_NO = S.STU_NO
                WHERE S.STU_DEPT = '��ǻ�Ͱ���'
                    )

SELECT *
FROM STUDENT
;

SELECT *
FROM ENROL
;

SELECT *
FROM SUBJECT
;

-- ���� 2. 2���� ������ ��� �л����� ���������
-- 1���� ������ ��� �л����� ��������� ����


