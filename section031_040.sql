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

--031

--81년 11월 17일에 입사한 사원의 이름과 입사일을 출력하기
SELECT ename, hiredate FROm emp 
WHERE hiredate = TO_DATE('81/11/17', 'RR/MM/DD');

-- 항상 날짜를 조회하기 위해서는 접속한 세션의 날짜 형식을 확인하기 
-- 날짜 형식 확인하는 쿼리
SELECT * FROM NLS_SESSION_PARAMETERS 
WHERE parameter = 'NLS_DATE_FORMAT';

--세션 날짜형식 변경하기 
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/RR';

-- 세션에 맞게끔 81년 11월 17일생 조회하기
SELECT ename, hiredate FROM emp 
WHERE hiredate = '17/11/81';

-- 세션변경을 사용하지 않고 세션을 명시해서 검색해보자
-- 그럼 위에서 변경했던 날짜 세션포맷과 상관없이 조회 가능하다.
SELECT ename, hiredate FROM emp
WHERE hiredate = TO_DATE('81/11/17', 'RR/MM/DD');

-- 다시 날짜 포맷을 RR/MM/DD로 변경하기
ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';


-- 032

--임시적 형변환 이해하기 

SELECT ename, sal FROM emp
WHERE sal = '3000';
-- 위의 예제의 sal은 숫자형 데이터 컬럼이지만 문자인 '3000'을 사용하여 비교하고 있다.
-- 이는 오라클이 알아서 숫자형 = 문자형 을 숫자형 = 숫자형으로 암시적으로 형 변환을 하기 때문이다. 

-- 간단한 테이블 만들기
CREATE TABLE EMP32
(ENAME VARCHAR2(10),
SAL VARCHAR2(10));

INSERT INTO EMP32 VALUES('SCOTT', '3000');
INSERT INTO EMP32 VALUES('SMITH', '1200');
COMMIT;

SELECT * FROM EMP32;

-- 문자열로 저장한 SAL을 문자열로 검색해보기
SELECT ename, sal FROM emp32 
WHERE sal ='3000';

-- 문자열로 저장한 sal을 숫자로 검색하기
SELECT ename, sal FROM emp32
WHERE sal = 3000;

--033 NULL 값 대신 다른 데이터 출력하기

--이름과 커미션을 출력하는데, 커미션이 NULL인 사원들은 0으로 출력하기
-- NVL(컬럼이름, 대신 출력하는 숫자) 를 통해서 NULL값을 변경해서 출력한다.
SELECT ename, comm, NVL(comm,0) FROM emp;

-- NULL값 + 정수 = NULL
SELECT ename, sal, comm, sal+comm FROM emp
WHERE job IN('SALESMAN', 'ANALYST');

--NULL을 0으로 대신하여 더하기
SELECT ename, sal, comm, NVL(comm, 0), sal+NVL(comm,0) FROM emp
WHERE job IN ('SALESMAN', 'ANALYST');'

/*
NVL2 함수를 사용해서 SAL + COMM 출력하기
NVL2 함수는 ('값' NOTNULL, NULL) 로 생각하면 된다.
처음 값이 NOTNULL이면 NOTNULL의 값을 NULL이면 NULL의 값을 출력한다.
*/

SELECT ename, sal, comm, NVL2(comm, sal+comm, sal) FROM emp 
WHERE job IN ('SALESMAN', 'ANALYST');

--034 IF문을 SQL로 구성하기

-- 부서번호가 10번이면 300, 20번이면 400, 10,20번이 아니라면 0을 출력한다. 
SELECT ename, deptno, DECODE(deptno, 10, 300, 20, 400, 0) as "보너스" FROM emp;

-- 사원번호와 사원번호가 짝수인지 홀수인지를 출력하는 쿼리
-- MOD함수는 나머지를 반환하는 함수로 파이썬으로 %이다.
-- DECODE(컬럼, IF, 값, ELIF, 값, ELSE) ELSE는 생략이 가능하다. 
SELECT empno, mod(empno,2), DECODE(mod(empno,2),0, '짝수',1,'홀수') as "보너스" 
FROM emp;

-- 이름과 직업과 보너스를 출력하는데 직업이 SALESMAN이면 보너스 5000, 나머지 직업은 보너스 2000을 출력
-- elseif 조건을 생략하고 바로 else구문으로 사용가능하다.
SELECT ename, job, DECODE(job, 'SALESMAN', 5000, 2000) FROM emp;




