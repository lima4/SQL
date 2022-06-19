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

--061 여러 테이블의 데이터를 조인해서 출력하기 (SELF JOIN)

--사원 테이블 자기 자신의 테이블과 조인하여 이름, 직업, 해당 사원의 관리자 이름과 관리자 직업을 출력
-- 기준을 두는 컬럼은 MGR컬럼이다.
SELECT e.ename as 사원, e.job as 직업, m.ename as 관리자, m.job as 직업
FROM emp e, emp m
WHERE e.mgr = m.empno and e.job = 'SALESMAN';

--062 여러 테이블의 데이터를 조인해서 출력하기 (ON절)

-- ON절을 사용한 조인 방법으로 이름과 직업, 월급, 부서 위치를 출력
SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as 부서위치
  FROM emp e JOIN dept d
  ON (e.deptno = d.deptno)
  WHERE e.job='SALESMAN';

--063 여러 테이블의 데이터를 조인해서 출력하기(USING절)

-- USING 절을 사용한 조인 방법으로 이름, 직업, 월급, 부서 위치를 출력
SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as 부서위치
  FROM emp e join dept d
  USING (deptno)
  WHERE e.job='SALESMAN';
  
--064 여러 테이블의 데이터를 조인해서 출력하기(NATURAL JOIN)

--NATURAL 조인 방법으로 이름, 직업, 월급과 부서 위치를 출력
SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as 부서위치
  FROM emp e natural join dept d
  WHERE e.job='SALESMAN';
  
--065 여러 테이블의 데이터를 조인해서 출력하기(LEFT/RIGHT OUTER JOIN)

--RIGHT OUTER 조인 방법으로 이름, 직업, 월급, 부서 위치를 출력
SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as 부서위치
  FROM emp e RIGHT OUTER JOIN dept d
  ON (e.deptno = d.deptno);

INSERT INTO emp(empno, ename, sal, job, deptno)
       VALUES(8282, 'JACK', 3000, 'ANALYST', 50) ;

COMMIT;

-- LEFT OUTER 조인 방법으로 출력하기 
SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as 부서위치
  FROM emp e LEFT OUTER JOIN dept d
  ON (e.deptno = d.deptno);
  
--066 여러 테이블의 데이터를 조인해서 출력하기(FULL OUTER JOIN)

--FULL OUTER JOIN 방법으로 이름, 직업, 월급, 부서 위치를 출력
SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as 부서위치
  FROM emp e FULL OUTER JOIN dept d
  ON (e.deptno = d.deptno);
  
-- 집합 연산자로 데이터를 위아래로 연결하기(UNION ALL)

-- 부서 번호와 부서 번호별 토탈 월급을 출력하는데 맨 아래쪽 행에 토탈 월급을 출력
delete  from  emp
 where ename='JACK';

commit;

SELECT deptno, sum(sal)
  FROM emp
  GROUP BY deptno
UNION ALL
SELECT TO_NUMBER(null) as deptno, sum(sal)
  FROM emp;

-- 068 집합 연산자로 데이터를 위아래로 연결하기(UNION)

-- 부서 번호와 부서 번호별 토탈 월급을 출력하는데, 맨 아래행에 토탈 월급을 출력
SELECT deptno, sum(sal)
  FROM emp
  GROUP BY deptno
UNION 
SELECT null as deptno, sum(sal)
  FROM emp;
  
-- 집합 연산자로 데이터의 교집합을 출력하기(INTERSECT)

-- 부서 번호 10번, 20번인 사원들을 출력하는 쿼리의 결과와 부서 번호 20번, 30번을 출력하는 쿼리 결과의 교집합 출력
SELECT ename, sal, job, deptno
  FROM emp
  WHERE deptno in (10,20)
INTERSECT
SELECT ename, sal, job, deptno
  FROM emp
  WHERE deptno in (20,30);
  
-- 070 집합 연산자로 데이터의 차이를 출력하기(MINUS)

-- 부서번호 10번, 20번을 출력하는 쿼리의 결과에서 부서 번호 20번, 30번을 출력하는 쿼리의 결과 차이 출력
SELECT ename, sal, job, deptno
  FROM emp
  WHERE deptno in (10,20)
MINUS
SELECT ename, sal, job, deptno
  FROM emp
  WHERE deptno in (20,30);
  
  
