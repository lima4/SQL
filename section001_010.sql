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


