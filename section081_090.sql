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

--081 데이터 저장 및 취소하기

-- 사원 테이블에 사원 테이블에 입력한 데이터가 데이터베이스에 저장되도록 하기
INSERT INTO emp(empno, ename, sal, deptno)
    VALUES(1122, 'JACK', 3000, 20);
    
COMMIT; -- 커밋

-- ename이 SCOTT인 회원의 SAL을 4000으로 변경한다.
UPDATE emp SET sal = 4000
WHERE ename = 'SCOTT';

SELECT * from emp;

ROLLBACK;
-- ROLLBACK시 마지막 COMMIT했던 데이터베이스로 돌아간다. 
-- UPDATE문이 취소 된다. 
SELECT * from emp;

-- 082 데이터 입력, 수정, 삭제 한번에 하기(MERGE)
-- 사원 테이블에 부서 위치 컬럼을 추가하고, 부서 테이블을 이용하여 해당 사원의 부서 위치로 값이 갱신하기
-- 만약 부서 테이블에는 존재하는 부서인데 사원 테이블에 없는 부서번호라면 새롭게 사원 테이블에 입력
ALTER TABLE emp
   ADD loc varchar2(10);
-- MERGE문은 데이터 입력과 수정, 삭제를 한 번에 수행할 수 있게 해주는 명령어이다. emp테이블에 부서 위치(loc)컬럼에 해당 사원의 부서 위치로 값을 갱신
MERGE INTO emp e --MERGE 대상이 되는 TARGET 테이블명을 작성 
USING dept d -- USING절 다음에는 SOURCE 테이블명을 작성, SOURCE 테이블인 DEPT로부터 데이터를 읽어와 DEPT테이블의 데이터로 EMP 테이블에 MERGE
ON (e.deptno = d.deptno)-- TARGET테이블과 SOURCE테이블을 조인하는 구문. 조인에 성공하면 MERGE UPDATE절을 실행, 실패하면 MERGE INSERT절을 실행
WHEN MATCHED THEN  --조인에 성공시 수행되는 절(조인에 성공하면 사원 테이블의 부서위치 컬럼을 부서 테이블의 부서 위치로 갱신)
UPDATE set e.loc = d.loc 
WHEN NOT MATCHED THEN  --조인에 실패하면 수행되는 절, 조인에 실패하면 실패한 부서 테이블의 데이터를 사원 테이블에 입력
INSERT (e.empno, e.deptno, e.loc) VALUES (1111,d.deptno, d.loc) ;

SELECT *
  FROM EMP;

ALTER TABLE emp
   DROP  COLUMN  loc;
   
DELETE FROM emp
  WHERE empno = 1111;

COMMIT;

SELECT *
  FROM EMP;

--083 락(LOCK)이해하기
--같은 데이터를 동시에 갱신할 수 없도록 하는 락(LOCK)를 이해하기
-- LOCK은 같은 데이터를 갱신하고 바로 또 갱신할 수 없다. 갱신을 하려면 TCL구문을 통해서 저장을 하고 진행해야 한다.
-- LOCK은 데이터의 일관성을 보장하기 위해서 필요하다.

--084 SELECT FOR UPDATE절 이해하기 

--JONES의 이름과 월급과 부서 번호를 조회하는 동안 다른 세션에서 JONES의 데이터를 갱신하지 못하도록 해보자
-- SELECT... FOR UPDATE문은 검색하는 행에 락(LOCK)를 거는 SQL문이다.
/*
SELECT ename, sal, deptno
FROM emp
WHERE ename = 'JONES'
FOR UPDATE; 실행시 JONES의 행에 자동으로 락이 걸린다. */

/*
UPDATE emp
SET sal = 9000
WHERE ename = 'JONES'; -- 실행멈춤(변경이 안된 상태)
*/
-- COMMIT; COMMIT 실행시 처음 JONES에 대해 UPDATE한 COMMIT이 완료 되고
-- 그 뒤에 2번째 구문이 실행된다.

--085 서브 쿼리를 사용하여 데이터 입력하기
--EMP 테이블의 구조를 그대로 복제한 EMP2 테이블에 부서 번호가 10번인 사원들의 사원 번호, 이름, 월급, 부서 번호를 한 번에 입력하기
CREATE TABLE emp2
    as
       SELECT *
          FROM emp
          WHERE 1=2;

SELECT *
  FROM emp2;

--기본 INSERT문은 한 번에 하나의 행만 입력된다. 서브 쿼리를 사용하여 INSERT를 수행하면 여러 개의 행을 한 번에 테이블에 입력가능
-- deptno가 10인 데이터의 empno, ename, sal, deptno를 emp2테이블에 삽입하는 구문이다.
INSERT INTO emp2(empno, ename, sal, deptno)
 SELECT empno, ename, sal, deptno
    FROM emp
    WHERE deptno = 10; 

SELECT *
  FROM emp2;

DROP  TABLE  emp2;

--086 서브 쿼리를 사용하여 데이터 수정하기
--직업이 SALESMAN인 사원들의 월급을 ALLEN의 월급으로 변경해보기
-- UPDATE문은 모든 절에서 서브쿼리 사용가능하다.
UPDATE emp -- emp테이블을 변경하는데
    SET sal = (SELECT sal --SET절에 서브쿼리를 사용하여 직업이 SALESMAN인 사원들의 월급을 ALLEN의 월급으로 갱신한다.
                FROM emp
                WHERE ename = 'ALLEN')
WHERE job = 'SALESMAN';

--087 서브쿼리를 사용하여 데이터 삭제하기
--SCOTT보다 더 많은 월급을 받는 사원들을 삭제해보자
DELETE FROM emp --emp테이블에서 DELETE를 실행하는데
WHERE sal > (SELECT sal FROM emp --이름이 SCOTT인 sal데이터보다 많은 사원들이 삭제된다.
             WHERE ename = 'SCOTT');

-- 월급이 해당 사원이 속한 부서 번호의 평균 월급보다 크면 삭제하는 서브쿼리
-- 삭제 대상인 emp테이블의 별칭을 사용한 m.deptno가 서브 쿼리 안으로 들어와서 사원의 월급이 자기가 속한 부서 번호의 평균 월급보다 크면 삭제하고 작으면 삭제하지 않는다.
DELETE FROM emp m
WHERE sal > (SELECT avg(sal) FROM emp s
             WHERE s.deptno = m.deptno);

-- 088 서브 쿼리를 사용하여 데이터 합치기
--부서 테이블에 숫자형으로 SUMSAL컬럼을 추가한다. 사원 테이블을 이용하여 SUMSAL 컬럼의 데이터를 부서 테이블의 부서 번호별 토탈 월급으로 갱신

--DEPT 테이블에 SUMSAL 컬럼 추가하기
ALTER TABLE dept --dept TABLE을 변경하는데 
   ADD sumsal number(10); -- sumsal이라는 컬럼을 추가

MERGE INTO dept d
USING ( SELECT deptno, sum(sal) sumsal --USING절에서 서브 쿼리를 사용하여 출력하는 데이터로 DEPT테이블을 MERGE한다. 서브 쿼리에서 반환하는 데이터는 부서 번호와 부서 번호별 토탈 월급이다.
        FROM emp
        GROUP BY deptno) v
ON (d.deptno = v.deptno) -- 서브 쿼리에서 반환하는 ㄷ에ㅣ터인 부서 번호와 사원 테이블의 부서 번호로 조인 조건을 준다.
WHEN MATCHED THEN -- 서브쿼레이서 반환하는 부서 번호와 사원 테이블의 부서 번호가 서로 일치하는지 확인하여 일치하면 해당 부서 번호의 토탈 월급으로 값을 갱신한다.
UPDATE set d.sumsal = v.sumsal;

--089 계층형 질의문으로 서열을 주고 데이터 출력하기
-- 계층형 질의문을 시용하여 사원 이름, 월급, 직업을 출력하는데 사원들 간의 서열(LEVEL)을 같이 출력하기
-- 계층형 질의문을 사용하여 사원 테이블에서 사원들 간의 서열을 출력하는 쿼리. 
/* 
NODE 표시된 항목
LEVEL 트리 구조에서 각각의 계층
ROOT 트리 구조에서 최상위의 노드
PARENT 트리 구조에서 상위의 노드
CHILD 트리 구조에서 하위에 있는 노드
*/
SELECT rpad(' ', level*3)  || ename  as  employee , level, sal, job
  FROM emp
  START WITH ename='KING'
  CONNECT BY prior empno = mgr;
  
--090 계층형 질의문으로 서열을 주고 데이터 출력하기
--089의 결과에서 BLAKE와 BLAKE의 직속 부하들은 출력되지 않게 하기
SELECT rpad(' ', level*3) || ename as employee, level, sal, job
FROM emp
START WITH ename = 'KING'
CONNECT BY prior empno = mgr AND ename !='BLAKE';