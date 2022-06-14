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

--041 데이터 분석 함수로 순위 출력 (RANK)

-- 직업이 ANALYST, MANGER인 사원들의 이름, 직업, 월급, 월급의 순위를 출력
-- RANK는 순위를 출력하는 데이터 분석 함수, RANK() OVER 다음에 나오는 괄호 안에 출력하고 싶은 데이터를 정렬하는 SQL문장을 넣기
-- 1등이 2명이어서 2등이 출력되지 않고 3등으로 바로 출력된다. 
-- 2등을 출력하고 싶다면 DENSE_RANK사용하기
SELECT ename, job, sal, RANK() over (ORDER BY sal DESC) 순위
  FROM emp 
  WHERE job in ('ANALYST','MANAGER');

-- 직업별로 월급이 높은 순서대로 순위를 부여해서 출력
-- 직업별로 묶어서 순위를 정하기 위해 ORDER BY 앞에 PARTITION BY를 사용한다.
SELECT ename, sal, RANK() over (PARTITION BY job ORDER BY sal DESC) as 순위
FROM emp;

--042 데이터 분석 함수로 순위 출력하기 (DENSE_RANK)
-- 앞서 RANK() over 사용할 시 동일한 등수라면 2등을 출력하지 않고 3등으로 넘어갔다.
-- DENSE_RANK함수는 1등이 2명이라도 2명모두 1등으로 출력하고 다음 등수를 2등으로 출력

-- 직업이 ANALYST, MANAGER인 사원들의 이름, 월급, 월급의 순위를 출력
SELECT ename, job, DENSE_RANK() over (ORDER BY sal DESC) 순위
FROM emp
WHERE job in ('ANALYST', 'MANAGER');

-- 81년도에 입사한 사원들의 직업, 이름, 월급, 순위를 출력 (직업별로 월급의 높은 순위)
SELECT job, ename, sal, DENSE_RANK() over (PARTITION BY job ORDER BY sal DESC) as 순위
FROM emp
WHERE hiredate BETWEEN to_date('1981/01/01', 'RRRR/MM/DD')
                       AND to_date('1981/12/31', 'RRRR/MM/DD');
                    

-- DENSE RANK 바로 다음에 나오는 괄호에도 다음과 같이 데이터를 넣고 사용하기
-- DENSE_RANK뒤의 괄호에 숫자를 넣으면 sal의 값에 맞는 순위 출력
-- 월급이 2975인 사원은 사원 테이블에서 월급의 순위가 어떻게 되는지 출력 WITHIN은 ~이내라는 뜻
-- 어느 그룹 이내에서 2975의 순위가 어떻게 되는지 보겠다.
SELECT DENSE_RANK(2975) within group (ORDER BY sal DESC) 순위
FROM emp;

-- 81년 11월 17일인 사원의 테이블에서 몇 번쨰로 입사한 것인지 출력
SELECT DENSE_RANK('81/11/17') within group (ORDER BY hiredate ASC) 순위
FROM emp;

--043 데이터 분석 함수로 등급 출력하기 (NTILE)

--이름과 월급, 직업, 월급의 등급을 출력 
-- 월급의 등급은 4등급으로 나누어서 1등급은 25%, 2등급은 25 ~ 50%, 3등급은 50 ~ 75% 4등급은 75% ~ 100%
-- NTILE을 사용하게 되면 %로 나누는데 숫자에 맞게끔 나누어진다. 
-- 이떄 NULLS last를 사용하면 NULL을 마지막에 출력하겠다는 의미이다
-- 통상적으로 NULL은 제일 먼저 나온다. 그뒤에 숫자 정렬 사용된다.
SELECT ename, job, sal, NTILE(4) over (order by sal desc nulls last) 등급
FROM emp
WHERE job in ('ANALYST', 'MANAGER', 'CLERK');

--044 데이터 분석 함수로 순위의 비율 출력(CUME_DIST)

-- 이름과 월급, 월급의 순위, 월급의 순위 비율을 출력
-- CUME_DIST는 등수에 대한 누적 비율을 출력한다.
-- 사원은 14명으로 1등마다 1등의 비율인 0.7가 증가한다.
SELECT ename, sal, RANK() over (order by sal desc) as RANK,
                   DENSE_RANK() over (order by sal desc) as DENSE_RANK,
                   CUME_DIST() over (order by sal desc) as CUM_DIST
FROM emp;

-- PARTITION BY JOB을 사용해 직업별로 CUME_DIST를 출력
SELECT job, ename, sal, RANK() over (partition by job order by sal desc) as RANK,
                        CUME_DIST() over (partition by job order by sal desc) as CUM_DIST
FROM emp;

--045 데이터 분석 함수로 데이터를 가로로 출력하기(LISTAGG)

--부서번호를 출력하고 부서 번호 옆에 해당 부서에 속하는 사원들의 이름을 가로로 출력하기
-- LISTAGG 함수는 데이터를 가로로 출력하는 함수 ,를 사용해서 ,로 구분되어 나타난다.
-- WHITIN GROUP은 ~이내라는 뜻으로 group 함수 뒤에 나오는 괄호에 속한 그룹의 데이터를 출력하겠다.
-- GROUP BY는 LISTAGG 함수를 사용하려면 필수로 사용해야 한다.
SELECT deptno, LISTAGG(ename, ',') within group (order by ename) as EMPLOYEE
FROM emp
GROUP BY deptno;

--직업과 그 직업에 속한 사원들의 이름을 가로로 출력
SELECT job, LISTAGG(ename, ',') within group (ORDER BY ename asc) as employee
FROM emp
GROUP BY job;

--옆에 월급도 같이 출력하려면 이전에 배웠던 연결 연산자 || 사용하기
SELECT job, LISTAGG(ename||'('||sal||')',',') within group(ORDER BY ename ASC) as employee
FROM emp
GROUP BY job;

--046 데이터 분석 함수로 바로 전 행과 다음 행 출력하기

--사원 번호, 이름, 월급을 출력하고 그 옆에 바로 전 행의 월급을 출력하고 또 옆에 다음 행의 월급 출력하기
-- LAG 함수는 바로 전행의 데이터를 출력하는 함수, 숫자 1을 사용하면 바로 전 행이 출력된다.
-- LEAD 함수는 바로 다음행의 데이터를 출력하는 함수. 숫자 1을 사용하면 바로 다음 행이 출력된다.
SELECT empno, ename, sal, LAG(sal,1) over (order by sal asc) "전 행", 
                          LEAD(sal, 1) over (order by sal asc) "다음 행"
FROM emp
WHERE job in ('ANALYST', 'MANAGER');

-- 직업이 ANALYST, MANAGER인 사원들의 사원 번호, 이름, 입사일, 바로 전에 입사한 사원의 입사일, 바로 다음에 입사한 사원의 입사일을 출력 & 부서번호 별로 구분해서 출력하기!
SELECT empno, ename, hiredate, LAG(hiredate,1) over (PARTITION BY deptno order by  hiredate asc) "전 입사일",
                               LEAD(hiredate,1) over (PARTITION BY deptno order by  hiredate asc) "다음 입사일"
FROM emp
WHERE job in ('ANALYST', 'MANAGER');

--047 COLUMN을 ROW로 출력하기 (SUM+DECODE)

--부서번호, 부서 번호별 토탈 월급을 출력하는데 가로로 출력하기
SELECT SUM(DECODE(deptno, 10, sal)) as "10", -- 부서번호가 10번이면 SUM으로 더한 sal 출력하기
       SUM(DECODE(deptno, 20, sal)) as "20",
       SUM(DECODE(deptno, 30, sal)) as "30"
FROM emp;

-- 직업, 직업별 토탈 월급 출력(가로로)   
SELECT SUM(DECODE(job,'ANALYST',sal)) as "ANALYST",
          SUM(DECODE(job,'CLERK',sal))  as "CLERK",
          SUM(DECODE(job,'MANAGER',sal)) as "MANAGER",
          SUM(DECODE(job,'SALESMAN',sal)) as "SALESMAN"
  FROM emp;

--048 COLUMNS을 ROW로 출력하기 (PIVOT)
--부서번호, 부서 번호별 토탈 월급을 PIVOT문을 사용해서 가로로 출력하기
-- 앞서 DECODE를 사용한 출력 결과를 PIVOT을 사용하면 좀 더 간단히 출력 가능하다.
SELECT *
FROM (SELECT deptno, sal from emp)
PIVOT(sum(sal) for deptno in (10,20,30));

-- 문자형 데이터를 다뤄보기, PIVOT문을 사용하여 직업과 직업별 토탈 월급을 가로로 출력하기
SELECT * 
FROM (SELECT job, sal from emp)
PIVOT(sum(sal) for job in ('ANALYST', 'CLERK', 'MANAGER', 'SALESMAN'));

--049 ROW를 COLUMN으로 출력하기(UNPIVOT)

--UNPIVOT을 사용해서 컬럼을 로우로 출력하기
SELECT *
drop  table order2;

create table order2
( ename  varchar2(10),
  bicycle  number(10),
  camera   number(10),
  notebook  number(10) );

insert  into  order2  values('SMITH', 2,3,1);
insert  into  order2  values('ALLEN',1,2,3 );
insert  into  order2  values('KING',3,2,2 );

commit;

-- UNPIVOT은 가로로 저장되어 있는 데이터를 세로로 UNPIVOT시킬 출력 열 이름이다. for 다음에 '아이템'은 가로로 되어 있는 order2 테이블에 컬럼명을 unpivt시켜 세로로 출력할 열 이름이다.
SELECT *
 FROM order2
 UNPIVOT (건수 for 아이템 in (BICYCLE, CAMERA, NOTEBOOK));
 
SELECT * 
FROM order2
UNPIVOT(건수 for 아이템 in (BICYCLE as 'B', CAMERA as 'C', NOTEBOOK as 'N'));

-- 만약 order2 테이블에 NULL이 포함되어 있으면 UNPIVOT의 결과에서 출력이 되지 않는다.
UPDATE ORDER2 SET NOTEBOOK = NULL WHERE ENAME = 'SMITH';
SELECT * 
FROM order2
UNPIVOT(건수 for 아이템 in (BICYCLE as 'B', CAMERA as 'C', NOTEBOOK as 'N'));

-- 만약 NULL값인 행도 포함하려면 INCLUDE NULLS를 사용하기
SELECT *
FROM order2
UNPIVOT INCLUDE NULLS (건수 for 아이템 in (BICYCLE as 'B', CAMERA as 'C', NOTEBOOK as 'N'));

--050 데이터 분석 함수로 누적 데이터 출력하기 (SUM OVER)
-- 직업이 ANALYST, MANAGER인 사원들의 사원 번호, 이름, 월급, 월급의 누적치를 출력하는 예제입니다.
-- OVER 다음의 괄호 안에는 값을 누적할 윈도우를 지정할 수 있다. 
-- ORDER BY empno를 통해 사원 번호를 오름차순으로 정렬을 하고 정렬된 것을 기준으로 월급의 누적치를 출력
-- UNBOUNDED PRECENDING은 제일 첫 번쨰 행을 가리킨다. 제일 첫 번쨰 행의 값은 2975이다.
-- BETWEEN UNBOUNDED AND CURRENT ROW는 제일 첫 번째 행부터 현재 행까지의 값을 말한다.
SELECT empno, ename, sal, SUM(SAL) OVER(ORDER BY empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 누적치
FROM emp
WHERE job in ('ANALYST', 'MANAGER');

