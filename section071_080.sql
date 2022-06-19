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

--071 서브 쿼리 사용하기(단일행 서브쿼리)

--JONES보다 더 많은 월급을 받는 사원들의 이름과 월급을 출력하기
-- JONES보다 더 많은 월급을 받는 사원들을 검색하려면 먼저 JONES의 월급이 얼마인지를 알아야 한다. JONES 에 대한 서브쿼리 작성
SELECT ename, sal
  FROM emp
  WHERE sal > (SELECT sal
                        FROM EMP
                        WHERE ename='JONES');

--072 서브 쿼리 사용하기(다중 행 서브쿼리)

--직업이 SALESMAN인 사원들과 같은 월급을 받는 사원들의 이름과 월급을 출력
-- 직업이 SALESMAN인 사원들이 한 명이 아니라 여러 명이기 때문에 =을 사용하면 에러 발생
-- 이럴 때는 in을 사용해야 한다.

SELECT ename, sal
  FROM emp
  WHERE sal in (SELECT sal
                       FROM emp
                       WHERE job='SALESMAN');

-- 073 서브 쿼리 사용하기(NOT IN) 

-- 관리자가 아닌 사원들의 이름과 월급과 직업을 출력
-- 자기 밑에 직속 부하 사원이 한 명도 없는 사원들을 출력하는 쿼리로 NOT IN을 사용한다.
SELECT ename, sal, job
  FROM emp
  WHERE empno not in (SELECT mgr
                                  FROM emp
                                  WHERE mgr is not null);
                        
-- 074 서브 쿼리 사용하기(EXISTS와 NOT EXISTS) 

-- 부서 테이블에 있는 부서 번호 중에서 사원 테이블에도 존재하는 부서 번호의 부서 번호, 부서 명, 부서 위치를 출력
SELECT *
  FROM dept d
  WHERE EXISTS (SELECT *
                   FROM emp e
                   WHERE e.deptno = d.deptno); 

-- 075 서브 쿼리 사용하기(HAVING절의 서브 쿼리)
-- 직업과 직업별 토탈 월급을 출력하는데, 직업이 SALESMAN인 사원들의 토탈 월급보다 더 큰 값들만 출력하기
SELECT job, sum(sal)
  FROM emp
  GROUP BY job
  HAVING sum(sal) > (SELECT sum(sal)
                       FROM emp
                       WHERE job='SALESMAN');
                       
-- 076 서브 쿼리 사용하기(FROM 절의 서브 쿼리)
-- 이름과 월급과 순위를 출력하는데 순위가 1위인 사원만 출력
SELECT v.ename, v.sal, v.순위
  FROM ( SELECT ename, sal, rank() over (order by sal desc) 순위
               FROM emp) v
  WHERE v.순위 =1; 

-- 077 서브 쿼리 사용하기(SELECT 절의 서브 쿼리)
--직업이 SALESMAN인 사원들의 이름과 월급을 출력하는데 직업이 SALESMAN인 사원들의 최대 월급과 최소 월급도 같이 출력해보자
SELECT ename, sal, (select max(sal) from emp where job='SALESMAN') as 최대월급,
                   (select min(sal) from emp where job='SALESMAN') as 최소월급
  FROM emp
  WHERE job='SALESMAN';
  
--078 데이터 입력하기(INSERT)
-- 사원 테이블에 데이터를 입력하는데 사원 번호 2812, 사원 이름 JACK, 월급 3500, 입사일 2019냔 6월 15일, 직업 ANALYST로 삽입해라
INSERT INTO emp (empno, ename, sal, hiredate, job)
  VALUES(2812, 'JACK', 3500, TO_DATE('2019/06/05','RRRR/MM/DD'), 'ANALYST');
-- 전체 확인하기
SELECT * 
  FROM  emp;
-- 마지막 COMMIT으로 돌아가기
ROLLBACK;

SELECT * 
  FROM  emp;
  
--079 데이터 수정하기(UPDATE)
--SCOTT의 월급을 3200으로 수정해보자
UPDATE emp
   SET sal = 3200
   WHERE ename = 'SCOTT';

-- 080 데이터 삭제하기(DELETE, TRUNCATE, DROP)
-- 사원 테이블에서 SCOTT의 행 데이터를 삭제해 보자
DELETE FROM emp
WHERE ename = 'SCOTT';
