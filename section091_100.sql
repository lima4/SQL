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

--091 계층형 질의문으로 서열을 주고 데이터 출력하기

-- 계층형 질의문을 이용하여 사원 이름, 월급, 직업을 서열과 같이 출력하는데, 서열 순서를 유지하면서 월급이 높은 사원부터 출력
-- ORDER와 BY의 사이에 SIBLINGS를 사용하여 정렬하면 계층형 질의문의 서열 순서를 깨트리지 않고 출력 가능
--만약 사용하지 않았다면 월급이 높은 순서대로만 출력되면서 서열 순서가 섞인다.
SELECT rpad(' ', level*3) || ename as employee, level, sal, job
FROM emp
START WITH ename = 'KING'
CONNECT BY prior empno = mgr
ORDER SIBLINGS BY sal desc;

-- ORDER 사이에 SIBLING 사용하지 않았을 때
SELECT rpad(' ', level*3) || ename as employee, level, sal, job
FROM emp
START WITH ename = 'KING'
CONNECT BY prior empno = mgr
ORDER BY sal desc;

--092 계층형 질의문으로 서열을 주고 데이터 출력하기
-- 계층형 질의문과 SYS_CONNECT_BY 함수를 이용하여 서열 순서를 가로로 출력
-- SYS_CONNECT_BY_PATH 함수에 두 번째 인자값으로 /를 사용하여 이름과 이름 사이의 연결을 /로 출력한다. 
SELECT ename, SYS_CONNECT_BY_PATH(ename, '/') as path
FROM emp
START WITH ename = 'KING'
CONNECT BY prior empno = mgr;

--LTRIM을 사용하여 PATH 맨앞의 / 삭제하기
SELECT ename, LTRIM(SYS_CONNECT_BY_PATH(ename, '/'), '/') as path
FROM emp
START WITH ename = 'KING'
CONNECT BY prior empno = mgr;

--093 일반 테이블 생성하기(CREATE TABLE)

--사원 번호, 이름, 월급, 입사일을 저장할 수 있는 테이블을 생성
/* 테이블명 작성시 규칙
반드시 문자로 시작해야 한다.
이름의 길이는 30자 이하여야 한다.
대문자 알파벳과 소문자 알파벳과 숫자를 포함할 수 있다
특수문자는 $, _, #만 포함할 수 있다.
*/
/* 테이블 생성시 데이터 유형
CHAR 고정 길이 문자 데이터 유형, 최대 길이는 2000
VARCHAR2 가변 길이 문자 데이터 유형 최대 길이는 4000
LONG 가변 길이 문자 데이터 유형, 최대 2GB의 문자 데이터 허용
BLOB 바이너리 데이터 유형이며 최대 4GB의 문자 데이터 허용
NUMBER 숫자 데이터 유형이며 십진 숫자의 자릿수는 최대 38자리
DATE 날짜 데이터 유형 
*/

CREATE TABLE EMP01
(EMPNO  NUMBER(10), --EMPNO는 숫자를 담을 컬럼이므로 데이터 유형을 NUMBER로 지정, 숫자의 자릿수는 1 ~ 38까지 가능
 ENAME  VARCHAR(10), -- ENAME 컬럼은 문자형 데이터를 담을 컬럼으로 데이터 유형을 VARCHAR2로 지정, 길이는 10으로 지정한다. 길이 10은 알파벳 철자 10개 최대는 4000개이다.
 SAL    NUMBER(10,2), -- SAL은 숫자형 데이터를 담을 컬럼으로 NUMBER형으로 지정, NUMBER(10,2)는 숫자를 전체 10자리 허용인데 소수점 2자리를 허용한다. 즉 8자리 + 소수점 2자리 
 HIREDATE   DATE); -- 날짜형 데이터를 담을 컬럼으로 DATE로 지정한다. 

-- 테이블 확인하기
SELECT * FROM EMP01;

--094 임시 테이블 생성하기 (CREATE TEMPORARY TABLE)
--사원 번호, 이름, 월급을 저장할 수 있는 테이블을 생성하는데 COMMIT할 때 까지만 데이터를 저장
-- 임시 테이블 생성임을 나타내기 위해 CREATE와 TABLE 사이에 GLOBAL TEMPORARY를 기술한다. 임시 테이블은 데이터를 영구히 저장하지는 않는다.
-- ON COMMIT DELETE ROWS : 임시 테이블에 데이터를 입력하고 COMMIT할 때 까지만 데이터를 보관
-- ON COMMIT PRESERVE ROWS : 임시 테이블에 데이터를 입력하고 세션이 종료될 때까지 데이터를 보관
CREATE GLOBAL TEMPORARY TABLE EMP37
(EMPNO NUMBER(10),
 ENAME VARCHAR2(10),
 SAL NUMBER(10))
 ON COMMIT DELETE ROWS;
 
SELECT * FROM EMP37;

INSERT INTO EMP37 values(1111, 'scott', 3000);
INSERT INTO EMP37 values(2222, 'smith', 4000);

SELECT * FROM EMP37;

COMMIT;

-- COMMIT을 하게 되면 데이터가 사라진다.
SELECT * FROM EMP37;

--095 복잡한 쿼리를 단순하게 하기(VIEW)
--직업이 SALESMAN인 사원들의 사원 번호, 이름, 월급, 직업, 부서 번호를 출력하는 VIEW를 생성하기
-- CREATE VIEW 이름 다음에 AS 이후에 뷰를 통해서 보여줘야 할 쿼리를 생성한다. 
CREATE VIEW EMP_VIEW
AS
SELECT empno, ename, sal, job, deptno
FROM emp
WHERE job = 'SALESMAN';

SELECT * FROM EMP_VIEW;

-- VIEW를 변경하면 실제 테이블도 변경이 될까?
UPDATE EMP_VIEW SET sal=0 WHERE ename = 'MARTIN';

-- VIEW 확인하기
SELECT * FROM EMP_VIEW;
-- 실제 테이블 확인하기
SELECT * FROM emp where job = 'SALESMAN';

--확인해본 결과 VIEW 테이블을 변경했는데 실제 테이블도 변경이 되었다. 
-- VIEW는 데이터를 가지고 있지 않고 단순히 테이블을 바로 보는 객체이다. 

--096 복잡한 쿼리를 단순하게 하기(VIEW)
-- 부서 번호와 부서 번호별 평균 월급을 출력하는 VIEW를 생성하자
-- view의 커리문에 그룹 함수를 사용시 반드시 컬럼 별칭을 사용해야 한다. 
-- 뷰에 함수나 그룹 함수가 포함되어 있으면 복합 뷰라고한다. 
/* View의 종류
              단순 VIEW     복합 VIEW
테이블의 개수    1개             2개 이상
함수 포함 여부   포함 안함        포함
데이터 수정 여부 수정 가능         수정 불가능 할 수 있음
*/

CREATE VIEW EMP_VIEW2
AS
SELECT deptno, round(avg(sal)) 평균월급
FROM emp
GROUP BY deptno;

SELECT * FROM EMP_VIEW2;
-- EMP_VIEW2의 결과 데이터 중 30번 부서 번호의 평균 월급을 1567에서 3000으로 수정이 가능할까?
-- 불가능하다. 만약 변경이 된다면 실제 테이블의 데이터가 변경이 되는것인데 평균으로하는 복합뷰는 실제 데이터를 어떻게 변환시켜야 할지 애매하다.
UPDATE emp_view2
set 평균월급 = 3000
WHERE deptno = 30;

--097 데이터 검색 속도를 높이기(INDEX)
--월급을 조회할 때 검색 속도를 높이기 위해 월급에 인덱스를 생성해 보기
-- INDEX는 테이블에서 데이터를 검색할 때 검색 속도를 높이기 위해 사용되는 데이터 베이스 객체이다.
-- 인덱스 이름 지정 방법은 테이블 이름과 컬럼 이름의 규칙과 동일하다. 
CREATE INDEX EMP_SAL
ON EMP(SAL);

-- 기존까지의 스캔 방법
-- 월급을 처음부터 스캔한다.
-- 스캔 중에 월급이 1600을 찾는다.
-- 뒤쪽에 1600이 있는지 몰라서 전체를 스캔한다.
-- BUT INDEX를 통한 스캔은 FULL SCAN을 하지 않는다.
SELECT ename, sal
FROM emp
WHERE sal = 1600;

-- 절대로 중복되지 않는 번호 만들기(SEQUENCE)
-- 숫자 1번부터 100번까지 출력하는 시퀀스를 생성하기
CREATE SEQUENCE SEQ1 --SEQ1의 시퀀스 생성
START WITH 1 -- 첫 시작 숫자를 1로 지정
INCREMENT BY 1 -- 숫자의 증가치를 1로 지정
MAXVALUE 100 -- 최대 숫자를 100으로 지정
NOCYCLE; -- 100까지 생성된 이후 다시 1번부터 생성할지 여부

-- 시퀀스는 일련번호 생성기로써 새로운 값을 입력할때 번거로운 작업을 피할 수 있다.
CREATE TABLE EMP02
(EMPNO NUMBER(10),
 ENAME VARCHAR2(10),
 SAL NUMBER(10));
 
-- 시퀀스를 사용하여 데이터 입력하기 
SELECT * FROM EMP02;

INSERT INTO EMP02 VALUES(SEQ1.NEXTVAL, 'JACK', 3500);
INSERT INTO EMP02 VALUES(SEQ1.NEXTVAL, 'JAMES', 4500);

SELECT * FROM EMP02;

--099 실수로 지운 데이터 복구하기(FLASHBACK QUERY) 
-- 사원 테이블의 5분 전 KING 데이터를 검색
-- AS OF TIMESTAMP절에 과거 시점을 작성한다. SYSTIMESTAMP는 현재 시간을 나타낸다.
-- SYSTIMESTAMP - INTERVAL '5' MINUTE는 현재 시간에서 5분을 뺀 시간이다. 
SELECT * 
FROM EMP
AS OF TIMESTAMP( SYSTIMESTAMP - INTERVAL '5' MINUTE)
WHERE ENAME = 'KING';

-- KING의 월급을 조회한다,
SELECT * 
FROM EMP
WHERE ENAME = 'KING';

-- KING의 월급을 0으로 변경하기
UPDATE EMP
SET SAL = 0
WHERE ENAME = 'KING';

SELECT * FROM EMP
WHERE ENAME = 'KING';

COMMIT;
-- 과거 sal을 0으로 바꾸기전 확인하기
SELECT ename, sal
FROM EMP
AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '5' MINUTE)
WHERE ENAME = 'KING';

-- 데이터를 플래쉬 백할 수 있는 골든 타임은 15분이다. 
-- 이는 데이터 베이스의 파라미터인 UNDO_RETENTION으로 확인 가능하다. 
SELECT name, value
FROM V$PARAMETER
WHERE name = 'unod_retention';

-- 실수로 지운 데이터 복구하기(FLASHBACK TABLE)
-- 사원 테이블을 5분전으로 되돌려 보기
-- FLASH BACK 하려면 먼저 FLASHBACK이 가능한 상태로 변경을 해주기
-- ALTER 명령어로 테이블을 플래쉬백이 가능한 사애톨 설정한다. 
ALTER TABLE emp ENABLE ROW MOVEMENT;

FLASHBACK TABLE EMP TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '5' MINUTE);

SELECT * FROM emp;