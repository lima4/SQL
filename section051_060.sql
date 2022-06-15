alter session set nls_date_format='RR/MM/DD';

drop table emp;
drop table dept;

CREATE TABLE DEPT
       (DEPTNO number(10),
        DNAME VARCHAR2(14),
        LOC VARCHAR2(13) );

INSERT INTO DEPT VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO DEPT VALUES (20, 'RESEARCH',   'DALLAS');
INSERT INTO DEPT VALUES (30, 'SALES',      'CHICAGO');
INSERT INTO DEPT VALUES (40, 'OPERATIONS', 'BOSTON');

CREATE TABLE EMP (
 EMPNO               NUMBER(4) NOT NULL,
 ENAME               VARCHAR2(10),
 JOB                 VARCHAR2(9),
 MGR                 NUMBER(4) ,
 HIREDATE            DATE,
 SAL                 NUMBER(7,2),
 COMM                NUMBER(7,2),
 DEPTNO              NUMBER(2) );

INSERT INTO EMP VALUES (7839,'KING','PRESIDENT',NULL,'81-11-17',5000,NULL,10);
INSERT INTO EMP VALUES (7698,'BLAKE','MANAGER',7839,'81-05-01',2850,NULL,30);
INSERT INTO EMP VALUES (7782,'CLARK','MANAGER',7839,'81-05-09',2450,NULL,10);
INSERT INTO EMP VALUES (7566,'JONES','MANAGER',7839,'81-04-01',2975,NULL,20);
INSERT INTO EMP VALUES (7654,'MARTIN','SALESMAN',7698,'81-09-10',1250,1400,30);
INSERT INTO EMP VALUES (7499,'ALLEN','SALESMAN',7698,'81-02-11',1600,300,30);
INSERT INTO EMP VALUES (7844,'TURNER','SALESMAN',7698,'81-08-21',1500,0,30);
INSERT INTO EMP VALUES (7900,'JAMES','CLERK',7698,'81-12-11',950,NULL,30);
INSERT INTO EMP VALUES (7521,'WARD','SALESMAN',7698,'81-02-23',1250,500,30);
INSERT INTO EMP VALUES (7902,'FORD','ANALYST',7566,'81-12-11',3000,NULL,20);
INSERT INTO EMP VALUES (7369,'SMITH','CLERK',7902,'80-12-11',800,NULL,20);
INSERT INTO EMP VALUES (7788,'SCOTT','ANALYST',7566,'82-12-22',3000,NULL,20);
INSERT INTO EMP VALUES (7876,'ADAMS','CLERK',7788,'83-01-15',1100,NULL,20);
INSERT INTO EMP VALUES (7934,'MILLER','CLERK',7782,'82-01-11',1300,NULL,10);

commit;

--051 데이터 분석 함수로 비율 출력하기 (RATIO_TO_REPORT)

--부서번호가 20번인 사원들의 사원번호, 이름, 월급을 출력하고 20번 부서 내에서 자신의 월급 비율 출력
--RATIO_TO_REPORT는 자신의 월급 / 20번인 사원들의 총 월급 합계 의 비율을 나타낸다.
SELECT deptno, ename, sal, RATIO_TO_REPORT(sal) OVER () as 비율
FROM emp
WHERE deptno = 20;

--052 데이터분석 함수로 집계 결과 출력하기(ROLLUP)

--직업과 직업별 토탈 월급을 출력하는데, 맨 마지막 행에 토탈 월급을 출력
-- ROLLUP을 이용하여 직업과 직업별 토탈월급을 출력하고 맨 마지막 행에 전체 합계를 추가로 출력한다.
SELECT job, sum(sal)
FROM emp
GROUP BY ROLLUP(job);

-- ROLLUP컬럼에 2개를 사용하면 2개에 맞게끔 합계를 내준다.
SELECT deptno, job, sum(sal)
FROM emp
GROUP BY ROLLUP(deptno, job);


--053 데이터분석 함수로 집계 결과 출력하기(CUBE)

--직업, 직업별 토탈 월급을 출력하는데, 첫 번쨰 행에 토탈 월급을 출력
SELECT job, sum(sal)
FROM emp
GROUP BY CUBE(job);

-- CUBE에 컬럼 2개를 사용한 쿼리
--전체 토탈 월급, 직업별 토탈월급, 부서 번호별 토탈월급, 부서 번호별 직업별 토탈월급의 4가지 집계
SELECT deptno, job, sum(sal)
FROM emp
GROUP BY CUBE(deptno, job);

--054 데이터 분석 함수로 집계 결과 출력하기(GROUPING SETS)

--부서번호와 직업, 부서 번호별 토탈 월급과 직업별 토탈 월급, 전체 토탈 월급을 출력
/*
GROUPING SETS((deptno), (job), ()) 부서 번호별 집계, 직업별 집계, 전체 집계
GROUPING SETS((deptno), (job)) 부서 번호별 집계, 직업별 집계
GROUPING SETS((deptno, job) ()) 부서 번호와 직업별 집계, 전체 집계
GROUPING SETS((deptno, job)) 부서 번호와 직업별 집계
*/
SELECT deptno, job, sum(sal)
FROM emp
GROUP BY GROUPING SETS((deptno), (job), ());

-- 055 데이터 분석 함수로 출력 결과 넘버링 하기(ROW_NUMBER)
-- ROW_NUMBER()는 출력되는 각 행에 고유한 숫자 값을 부여하는 데이터 분석 함수.
-- ROW_NUMBER() 뒤에는 반드시 OVER()안에 ORDER BY 절을 넣어주어야 한다.
SELECT empno, ename, sal, RANK() OVER (ORDER BY sal DESC) RANK,
                        DENSE_RANK() OVER(ORDER BY sal DESC) DENSE_RANK,
                        ROW_NUMBER() OVER (ORDER BY sal DESC) 번호
   FROM emp
   WHERE deptno = 20;

-- 부서 번호별 월급에 대한 순위 출력
SELECT deptno, ename, sal, ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) 번호
   FROM emp
   WHERE deptno in (10, 20);
   
-- 056 출력되는 행 제한하기(ROWNUM)

-- 사원 테이블에서 사원 번호, 이름, 직업, 월급을 상단 5개 행만 출력
-- ROWNUM은 가짜의 컬럼으로 WHERE절을 통해서 출력되는 행을 제한할 수 있다.
SELECT ROWNUM, empno, ename, job, sal
FROM emp
WHERE ROWNUM <=5;

--057 출력되는 행 제한하기(SIMPLE TOP-n Queries)

-- 월급이 높은 사원 순으로 사원번호, 이름, 직업, 월급을 4개의 행으로 제한해서 출력
-- TOP-N QUERY는 정렬된 결과로부터 위쪽 또는 아래쪽의 N개의 행을 반환하는 쿼리
-- 이전의 ROWNUM을 사용하면 FROM절의 서브쿼리를 사용할 때 SQL이 복잡해진다. 그러나
-- FETCH FIRST ROWS ONLY를 사용하면 편리하다.
SELECT empno, ename, job, sal
FROM emp
ORDER BY sal DESC FETCH FIRST 4 ROWS ONLY;

-- 월급이 높은 사원들 중에서 20%에 해당하는 사원들만 출력
SELECT empno, ename, job, sal 
FROM emp
ORDER BY sal desc FETCH FIRST 20 PERCENT ROWS ONLY;

-- WHIT TIES 옵션을 이용하면 여러 행이 N번쨰 행의 값과 동일하다면 같이 출력
SELECT empno, ename, job, sal
FROM emp
ORDER BY sal DESC FETCH FIRST 2 ROWS WITH TIES;

-- OFFSET 옵션을 사용하면 출력이 시작하는 행의 위치를 지정한다.
-- (9+1)번쨰 행부터 출력한다. 
SELECT empno, ename, job, sal
FROM emp
ORDER BY sal DESC OFFSET 9 ROWS;

-- OFFSET과 FETCH를 사용해서 출력하기
SELECT empno, ename, job, sal
FROM emp
ORDER BY sal DESC OFFSET 9 ROWS
FETCH FIRST 2 ROWS ONLY;

--058 여러 테이블의 데이터를 조인해서 출력하기

-- 사원 테이블과 부서 테이블을 조인하여 이름과 부서 위치를 출력
-- 서로 다른 테이블에 있는 컬럼들을 하나의 결과로 출력하려면 JOIN을 사용해야 한다.
-- ename은 emp테이블에, loc는 dept 테이블에 존재하므로 ename과 loc를 하나의 결과로 출력하기 위해서는 
-- from절에 emp와 dept를 둘다 기술하고 조인하기 위한 컬럼인 deptno를 where에 같다는 조건을 준다.
-- 만약 조건문을 주지 않았다면 14 *4의 56개의 행이 조인이 되어 출력된다.
SELECT ename, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--직업이 ANALYST인 사원들만 출력한다.
SELECT ename, loc, job
FROM emp, dept
WHERE emp.deptno = dept.deptno and emp.job = 'ANALYST';

-- 만약 join을 위한 컬럼인 deptno를 출력하고 싶다면 
-- SELECT ename, loc, job, deptno를 하면 에러가 발생한다.
-- deptno는 emp에도 dept에도 존재하는 컬럼으로 어느 테이블을 쓸 것인지 적어야 한다.
SELECT ename, loc, job, emp.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno and emp.job = 'ANALYST';

-- 테이블을 앞에 붙여서 출력을 하면 쿼리가 길어져 이를 방지하기 위해 별칭을 사용한다.
SELECT e.ename, d.loc, e.job
FROM emp e, dept d
WHERE e.deptno = d.deptno and e.job = 'ANALYST';

--059 여러 테이블의 데이터를 조인해서 출력하기 (NON EQUI JOIN)
-- 사원(EMP) 테이블과 급여 등급(SALGRADE) 테이블을 조인하여 이름, 월급, 급여 등급을 출력
-- emp테이블과 salgrade 테이블을 조인해서 ename과 grade를 하나의 결과로 출력하고자 한다.
-- 그러나 emp, dept와 같이 동일한 컬럼이 없다. 그럴때 사용할 수 있는 non euio join이다.
-- 두 테이블 사이에 동일한 컬럼은 없지만 비슷한 컬럼은 있다. 바로 emp테이블의 sal 컬럼과 salgrade 테이블의 hisal 컬럼
-- emp 테이블의 월급은 salgrade 테이블의 losal과 hisal 사이에 있다. 
SELECT e.ename, e.sal, s.grade
FROM emp e, salgrade s
WHERE e.sal between s.losal and s.hisal;

--060 여러 테이블의 데이터를 조인해서 출력하기(OUTER JOIN)
-- 사원(EMP) 테이블과 부서(DEPT) 테이블을 조인해서 이름과 부서 위치를 출력하는데 BOSTON도 같이 출력되게 하기
-- OUTER JOIN은 (+) = 를 사용해서 한다. (+) 사인은 테이블 중 결과가 덜 나오는쪽에 붙여준다.
/*
EQUI JOIN = 교집합
RIGHTER OUTER JOIN = 오른쪽 전체
LEFT OUTER JOIN = 왼쪽 전체
*/
SELECT e.ename, d.loc
FROM emp e, dept d
WHERE e.deptno (+) = d.deptno;