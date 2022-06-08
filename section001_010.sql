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

drop  table  salgrade;

create table salgrade
( grade   number(10),
  losal   number(10),
  hisal   number(10) );

insert into salgrade  values(1,700,1200);
insert into salgrade  values(2,1201,1400);
insert into salgrade  values(3,1401,2000);
insert into salgrade  values(4,2001,3000);
insert into salgrade  values(5,3001,9999);

commit;
-- 모든 테이블 출력하기
select * from emp;
-- 003

-- 컬럼 별칭을 주어 컬럼명 변경하여 출력하기 (as)
SELECT empno as "사원 번호", ename as "사원 이름", sal as "Salary" FROM emp;

-- 컬럼 별칭을 사용하지 않는다면 ENAME, SAL*(12+3000)의 컬럼2개가 출력된다.
SELECT ename, sal * (12 + 3000) FROM emp;
-- 이를 방지하기 위해서 별칭 사용하기 
SELECT ename, sal * (12+3000) as 월급 FROM emp;

-- 004

-- 만약 컬럼간의 내용을 붙여서 출력하고 싶다면 ||을 사용한다.
SELECT ename || sal FROM emp; 

-- 응용하기
SELECT ename || '의 월급은' || sal || '입니다' as "월급정보" FROM emp;


-- 005

-- 중복된 데이터를 제거해서 출력하기 UNIQUE를 사용해도 된다.
SELECT DISTINCT job FROM emp;

--006

-- 정렬해서 출력하기 asc를 사용하면 오름차순 desc를 사용하면 내림차순이다. 
SELECT ename, sal FROM emp
ORDER BY sal asc;

-- 여러개의 ORDER BY 절 사용하기 처음의 deptno를 먼저 오름차순 정렬 후 뒤의 sal을 내림차순 정렬한다.
SELECT ename, deptno, sal FROM emp
    ORDER BY deptno asc, sal desc ;

-- SELECT 절 컬럼의 숫자를 적어서 ORDER BY도 사용이 가능하다.
SELECT ename, deptno, sal FROM emp
ORDER BY 2 asc, 3 desc;

-- 007
-- 조건을 통해서 뽑기 위해서는 WHERE 을 사용하면 된다.
SELECT ename, sal, job FROM emp
WHERE sal = 3000;

/*
> 크다
< 작다
>= 크거나 같다
<= 작거나 같다
!= 같지 않다
^= 같지 않다
<> 같지 않다
IS NULL NULL값인지 여부
IN 값 리스트 중 일치하는 값 검색
BETWEEN AND ~ 사이에 있는
LIKE 일치하는 문자 패턴 검색
*/

--008

-- ename이 SCOTT인 ename, sal, job, hiredate, deptno 출력
SELECT ename, sal, job, hiredate, deptno FROM emp
WHERE ename = 'SCOTT';

-- hiredate가 81/11/17인 데이터의 ename, hiredate 출력
SELECT ename, hiredate FROM emp
WHERE hiredate = '81/11/17';

-- 접속한 세션의 날짜 형식은 NSL_SESSION_PARAMETERS를 통해서 조회한다.
-- RR은 년도, MM은 달, DD는 일
SELECT * 
FROM NLS_SESSION_PARAMETERS
WHERE PARAMETER = 'NLS_DATE_FORMAT';

-- 009

-- 연봉이 3600이상인 사원들의 이름과 연봉을 출력한다.
SELECT ename, sal*12 as 연봉 FROM emp
WHERE sal*12 >=3600;

-- NULL이 더해지면 값은 NULL로 생성된다.
-- 값이 없는 컬럼인 comm 과 salary 컬럼을 더한 컬럼 출력하기 
SELECT ename, sal, comm, sal+comm FROM emp
WHERE deptno = 10;

/* NVL함수를 사용하면 NULL값을 처리할 수 있다.
NULL 값을 0으로 출력하여 산술연산을 가능하게 한다.
*/
SELECT sal + NVL(comm, 0) FROM emp 
WHERE ename = 'KING';

--010

--월급이 1200 이하인 사원들의 이름과 월급, 직업, 부서 번호를 출력
SELECT ename, sal, job, deptno FROM emp
WHERE sal <=1200;