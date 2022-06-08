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

-- 011 

--월급이 1000에서 3000사이인 사원들의 이름과 월급을 출력 (BETWEEN 하한가 AND 상한가) 순으로 적어야 한다. 또한 BETWEEN AND 는 >= AND <=와 같다.
SELECT ename, sal FROM emp WHERE sal BETWEEN 1000 AND 3000;

-- 월급이 1000에서 3000사이가 아닌 사원들의 이름과 월급을 조회
SELECT ename, sal FROM emp 
WHERE sal NOT BETWEEN 1000 AND 3000;

--012

-- 첫글자가 S로 시작하는 사원들의 이름과 월급을 출력 %는 와일드 카드라고 하며 첫 글자가 S로 시작하면 모든 검색대상이다. 
SELECT ename, sal FROM emp WHERE ename LIKE 'S%';

-- 두번째 글자가 M으로 시작하는 사원의 이름 출력 (몇 번쨰를 맞추기 위해서 앞에 _를 넣는다.)
SELECT ename FROM emp WHERE ename LIKE '_M%';

-- 끝 글자가 T로 끝나는 사원들의 이름을 출력
SELECT ename FROM emp WHERE ename LIKE '%T';

-- 이름에 A가 포함된 모든 사원들을 검색하라
SELECT ename FROM emp WHERE ename LIKE '%A%';

--013

-- NULL인 사원들의 이름과 커미션 출력하기 (NULL은 데이터가 할당되지 않은 상태라고도 하고 알 수 없는 값이다.) 즉 = 로는 비교 불가능 
SELECT ename, comm FROM emp WHERE comm is null;

--014

-- 직업이 SALESMAN, ANALYST, MANAGER인 사원들의 이름, 월급, 직업을 출력
-- in을 사용하여 in안의 문자와 일치하는 데이터 추출
SELECT ename, sal, job FROM emp WHERE job in ('SALESMAN', 'ANALYST','MANAGER');

-- SALESMAN, ANALYST, MANAGER가 아닌 사원들의 이름, 월급, 직업 출력
SELECT ename, sal, job FROM emp WHERE job NOT in ('SALESMAN', 'ANALYST', 'MANAGER');

-- 015



