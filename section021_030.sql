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

-- 021 특정 철자를 N개 만큼 채우기

-- 이름과 월급을 출력하는데 월급 컬럼의 자릿수를 10자리로 하고 월급을 출력, 남은 나머지에 별표로 채우기
-- LPAD는 (컬럼, 자릿수, 나머지)므로 왼쪽에 위치시키며 나머지 자릿수는 *로 채운다. SALARY 컬럼은 4자리로 왼쪽 6자리가 *로 채워진다.
-- RPAD는 (컬럼, 자릿수, 나머지)므로 오른쪽에 위치시키며 나머지 자릿수는 *로 채운다. 
SELECT ename, LPAD(sal, 10, '*') as salary1, RPAD(sal, 10, '*') as salary2 FROM emp;

-- lpad를 사용해서 bar_chart를 그리는데 처음에 들어갈 컬럼을 *로 지정하여 *로 채워지게 한다. 
SELECT ename, sal, lpad('*', round(sal/100), '*') as bar_chart From emp;

--021 특정 철자 잘라내기

-- 첫 번째 컬럼은 영어 단어 smith 철자를 출력, 두 번째 컬럼은 영어 단어 smith에서 s를 잘라서 출력, 세 번째 컬럼은 영어 단어 smith에서 h를 잘라 출력, 네 번째 컬럼은 영어 단어 smiths의 양쪽 s를 잘라서 출력한다
-- LTRIM은 왼쪽 철자 자르기, RTRIM은 오른쪽 철자 자르기, TRIM은 양쪽 철자 자르기 
SELECT 'smith', LTRIM('smith', 's'), RTRIM('smith', 'h'), TRIM('s' from 'smiths') FROM dual;

-- INSERT 문장으로 사원(EMP) 테이블에서 JACK 사원에 오른쪽 공백 넣어서 입력하기
INSERT INTO emp(empno, ename, sal, job, deptno) values(8291, 'JACK ', 3000, 'SALESMAN', 30);

commit;

-- JACK이라는 사원의 이름과 월급 조회하기 JACK의 오른쪽에 공백으로 인해서 조회 불가능하다.
SELECT ename, sal FROM emp WHERE ename = 'JACK';

-- 공백 제거하여 검색하기 
SELECT ename, sal FROM emp WHERE RTRIM(ename)='JACK';

-- JACK 데이터 삭제하기
DELETE FROM emp WHERE TRIM(ename) ='JACK';

commit;

-- 023 반올림해서 출력하기

--876.567이라는 숫자를 출력하는데 소수점 두 번쨰 자리인 6에서 반올림해서 출력하기
-- ROUND 함수는 (값, 자릿수) 로 출력한다. 즉 2번쨰 자리에서 반올림 하기
SELECT '876.567' as 숫자, ROUND(876.567, 1) FROM dual;

--024 숫자를 버리고 출력하기 

-- 876.567숫자를 출력하는데 소수점 두 번째 자리인 6과 그 이후의 숫자들을 모두 버리기
-- TRUNC(값, 기준 소수점 자릿수) 기준 소수점 자릿수 이하는 전부 버린다.
SELECT '876.567' as 숫자, TRUNC(876.567,1) FROM dual;

--025 나눈 나머지 값 출력하기(MOD)

--숫자 10을 3으로 나눈 나머지 값이 어떻게 되는지 출력하기
SELECT MOD(10,3) FROM dual;

-- 사원번호가 홀수이면 1, 짝수이면 0을 출력하는 쿼리 2로 나누었을 때 나머지가 0이면 짝수, 1이면 홀수이다.
SELECT empno, MOD(empno, 2) FROM emp;

-- 사원 번호가 짝수인 사언들의 사원 번호와 이름을 출력
SELECT empno, ename FROm emp WHERE MOD(empno,2) =0;

-- 10을 3으로 나눈 몫을 출력하라 FLOOR 함수 나눈 목은 3.333333이지만 FLOOR은 3과 4사이에서 가장 낮은수로 출력한다.
SELECT FLOOR(10/3) FROM DUAL; --3.3333333
-- 15/4 = 3.75
SELECT FLOOR(15/4) FROM DUAL; --3.75이나 가장 낮은 숫자로서 3이 출력된다.

-- 026 날짜 간 개월 수 출력하기

-- 이름을 출력하고 입사한 날짜부터 오늘까지 총 몇달을 근무했는지 출력해보기
-- MONTHS_BETWEEN는 날짜를 다루는 함수로서 (최신날짜, 예전 날짜)로 입력한다. 
-- sysdate는 오늘을 의미한다. 
SELECT ename, MONTHS_BETWEEN(sysdate, hiredate) FROM emp;

-- 027 개월 수 더한 날짜 출력하기 (ADD_MONTHS)

-- 2019년 5월 1일로부터 100달 뒤의 날짜는 ?
-- 100달을 더하기 위해서 ADD_MONTHS 사용하기 
SELECT ADD_MONTHS(TO_DATE('2019-05-01', 'RRRR-MM-DD'), 100) FROM DUAL;

-- 100일 후를 출력하는 쿼리 작성하기
-- 일이 아닌 달이 되면 기준을 30일로 할지 31일로 할 지 기준이 어렵기 떄문에 ADD_MONTHS 사용하기
SELECT TO_DATE('2019-05-01', 'RRRR-MM-DD') + 100 FROM DUAL;

-- 028 특정 날짜 뒤에 오는 요일 날짜 출력하기 (NEXT_DAY)

-- 2019년 5월 22일로부터 바로 돌아올 월요일의 날짜 출력하기
-- NEXT_DAY(기준 날짜, 원하는 요일) 을 통해서 다음 요일의 날짜를 출력한다.
SELECT '2019/05/22' as 날짜, NEXT_DAY('2019/05/22', '월요일') FROM DUAL;

-- 오늘 날짜를 출력하기
SELECT SYSDATE as "오늘 날짜" FROM DUAL;

-- 앞으로 돌아올 화요일의 날짜 출력
SELECT NEXT_DAY(SYSDATE, '화요일')as "다음주 화요일" FROM DUAL;

--029 특정 날짜가 있는 달의 마지막 날짜 출력하기(LAST_DAY)

--2019년 5월 22일 해당 달의 마지막 날짜 출력
-- LAST_DAY(기준날짜)를 통해서 기준 날짜의 달의 마지막 날짜 출력한다.
SELECT '2019/05/22' as "날짜", LAST_DAY('2019/05/22') as "마지막 날짜" FROM DUAL;

-- 이번달 말일까지 남은 총 일 출력
SELECT LAST_DAY(SYSDATE) - SYSDATE as "남은 날짜" FROM DUAL;

--030 문자형으로 데이터 유형 변환하기

--이름이 SCOTT인 사원의 이름과 입사한 요일을 출력하고 SCOTT의 월급에 천 단위를 구할 수 있는 ,를 붙여 출력
-- TO_CAHR(hiredate, 'DAY')는 입사일을 요일로 출력한다. TO_CHAR(sal, '999,999')는 월급을 출력할 때 천 단위로 표시해서 출력한다. 
-- 숫자형 데이터 유형을 문자로 변환하거나 날짜형 데이터 유형을 문자형으로 변환할 때 TO_DATE 함수를 사용한다. 
SELECT ename, TO_CHAR(hiredate, 'DAY') as 요일, TO_CHAR(sal, '999,999') as 월급 FROM emp WHERE ename = 'SCOTT';

--날짜를 문자열로 변환하면 년, 월, 일, 요일을 추출해서 출력할 수 있다.
SELECT hiredate, TO_CHAR(hiredate, 'RRRR') as 연도, TO_CHAR(hiredate, 'MM') as 월, TO_CHAR(hiredate, 'DD') as 일, TO_CHAR(hiredate, 'DAY') as 요일 FROM emp WHERE ename='KING';

/* 날짜 포맷
연도 RRRR YYYY RR YY
월 MM MON
일 DD
요일 DAY DY
주 WW IW W
시간 HH HH24
분 MI
초 SS */

-- 1981년도에 입사한 사원의 이름과 입사일을 출력
SELECT ename, hiredate FROM emp WHERE TO_CHAR(hiredate, 'RRRR') = 1981;

-- 날짜 컬럼에서 연도/월/일/시간/분/초를 추출하기 위해서 EXTRACT 함수를 사용해도 된다.
SELECT ename as 이름, EXTRACT(year from hiredate) as 연도, 
                     EXTRACT(MONTH from hiredate) as 달,
                     EXTRACT(day from hiredate) as 일 FROM emp;

