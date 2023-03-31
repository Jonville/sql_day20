-- SELECT , UPDATE , INSERT , DELETE
-- JOIN (INNER, LEFT), SELF JOIN

SELECT *            -- * 쓰는걸 지양해라, 필요한 컬럼만 출력할수있도록 습관화 해라
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

-- 범위에 따라 등급먹이기

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

-- 부서별 평균 급여의 최대값과 최소값의 차이

SELECT MAX(AVG_S) - MIN(AVG_S)
FROM (
        SELECT ROUND(AVG(SAL),2) AVG_S , DEPTNO
        FROM EMP
        GROUP BY DEPTNO
        )
;

-- 전체 평균보다 급여를 더 받는 친구 구하기

SELECT *
FROM EMP
WHERE SAL > (
            SELECT AVG(SAL) AVG_S
            FROM EMP
            )
;

-- 상사가 누군지 검색
-- 사번 , 이름 , 사수의 이름 출력

SELECT E.EMPNO , E.ENAME , E2.EMPNO , E2.ENAME
FROM EMP E
INNER JOIN EMP E2 ON E.MGR = E2.EMPNO
ORDER BY E.EMPNO
;

-- 부하직원이 가장 많은 사람의 이름과 사람수
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

-- 본인 부서의 평균급여보다 많은 급여를 받는 사람의 목록 출력

SELECT *
FROM (
    SELECT ROUND(AVG(SAL),2) AVG_S , DEPTNO
    FROM EMP
    GROUP BY DEPTNO
    )A 
INNER JOIN EMP E ON A.DEPTNO = E.DEPTNO AND SAL > AVG_S
;

-- 본인 학과의 평균 키보다 큰 학생들의 정보 출력

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


-- 컴퓨터정보 학과보다 평균이 낮은 학과와 점수 출력


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
                WHERE S.STU_DEPT = '컴퓨터정보'
                    )
;

------------HAVING 사용-------------

SELECT AVG(ENR_GRADE) , STU_DEPT
FROM ENROL E
INNER JOIN STUDENT S ON E.STU_NO = S.STU_NO
GROUP BY STU_DEPT
HAVING AVG(ENR_GRADE) < (
                        SELECT AVG(ENR_GRADE)
                        FROM ENROL E
                        INNER JOIN STUDENT S ON E.STU_NO = S.STU_NO
                        WHERE S.STU_DEPT = '컴퓨터정보'
                        )
;

-- 문제 1. 컴퓨터 개론 수업을 듣는 학생들의 평균 점수보다
-- 높은 점수를 가지고 있는 컴퓨터정보과 학생 출력

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
                WHERE S.STU_DEPT = '컴퓨터개론'
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

-- 문제 2. 2개의 수업을 듣는 학생들의 평균점수와
-- 1개의 수업을 듣는 학생들의 평균점수의 차이


