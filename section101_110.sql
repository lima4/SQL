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

--101 실수로 지운 데이터 복구하기(FLASHBACK DROP)
-- DROP된 사원 테이블을 휴지통에서 복원해보기
-- EMP테이블을 DROP하여 휴지통에 있다면 휴지통에서 다시 복구한다. 
FLASHBACK TABLE emp TO BEFORE DROP;

-- 테이블 DROP 후 휴지통 확인하기
-- 테이블 삭제하기
DROP TABLE emp;
-- 휴지통 확인하기
SELECT original_name, droptime
  FROM user_recyclebin;
  
-- 복구하기
FLASHBACK TABLE emp TO BEFORE DROP;

-- 테이블 확인하기
SELECT * FROM emp;

--102 실수로 지운 데이터 복구하기
--사원 테비을의 데이터가 과거 특정 시점부터 지금까지 어떻게 변경되어 왔는지 이력 정보 출력

-- 현재 시간 확인하기
SELECT SYSTIMESTAMP FROM DUAL;

-- KING의 데이터 확인하기
SELECT ename, sal 
    FROM emp
    WHERE ename = 'KING';
    
-- KING의 월급을 8000으로 변경하기
UPDATE emp
    SET sal = 8000
    WHERE ename = 'KING';
    
-- KING의 부서 번호를 20번으로 변경
UPDATE emp
    SET deptno = 20
    WHERE ename = 'KING';

COMMIT;

SELECT * FROM emp
WHERE ename = 'KING';

-- 변경된 이력정보 확인하기 
SELECT ename, sal, deptno, versions_starttime, versions_endtime, versions_operation
  FROM emp
  VERSIONS BETWEEN TIMESTAMP TO_TIMESTAMP('2022-06-27 08:20:00','RRRR-MM-DD HH24:MI:SS')
                AND MAXVALUE
  WHERE ename='KING'
  ORDER BY versions_starttime;

-- 104 데이터 품질 높이기(PRIMARY KEY)
-- DEPTNO 컬럼에 PRIMARY KEY 제약을 걸면서 테이블을 생성하는 예제
-- PRIMARY KEY 제약이 걸린 컬럼에는 중복된 데이터와 NULL 값을 입력할 수 없다. 예를 들어 사원 번호, 주민 등록번호 
CREATE TABLE DEPT2
(DEPTNO NUMBER(10) CONSTRAINT DPET2_DEPTNO_PK PRIMARY KEY, -- CONSTRAINT 키워드 제약 (테이블명_ 컬럼명_제약종류축약)으로 명시해준다. 
 DNAME VARCHAR2(14),
 LOC VARCHAR2(10));
 
SELECT * FROM DEPT2;

-- 테이블 생성 후에도 제약을 걸기
CREATE TABLE DEPT2
(DEPTNO NUMBER(10),
 DNAME VARCHAR2(13),
 LOC VARCHAR2(10));
-- 제약 추가하기 
ALTER TABLE DEPT2
ADD CONSTRAINT DEPT2_DEPTNO_PK PRIMARY KEY(DEPTNO);

-- 105 데이터의 품질 높이기(UNIQUE)
-- 테이블의 컬럼 중에는 중복된 데이터가 있어서는 안 되는 컬럼이 있다. 
-- 이떄는 UNIQUE 제약을 사용하여 테이블의 특정 컬럼에 중복된 데이터가 입력되지 않게 제약을 건다.
-- PRIMARY KEY 제약과는 달리 UNIQUE 제약이 걸린 컬럼에는 NULL값을 입력 가능하다.
CREATE TABLE DEPT3
(DEPTNO NUMBER(10),
 DNAME VARCHAR2(14) CONSTRAINT DEPT3_DNAME_UN UNIQUE,
 LOC VARCHAR2(10));
 
-- 테이블이 생성된 후에 제약을 걸기
CREATE TABLE DEPT4 
(DEPTNO NUMBER(10),
 DNAME VARCHAR2(13),
 LOC VARCHAR2(10));
 
ALTER TABLE DEPT4
ADD CONSTRAINT DEPT4_DNAME_UN UNIQUE(DNAME);

--106 데이터의 품질 높이기 (NOT NULL)
-- NOT NULL 제약은 특정 컬럼에 NOT NULL 값 입력을 허용하지 않게 한다.
CREATE TABLE DEPT5
(DEPTNO NUMBER(10),
 DNAME VARCHAR2(14),
 LOC VARCHAR2(10) CONSTRAINT DEPT5_LOC_NN NOT NULL);
 
-- 생성 이후 제약 걸기 (BUT 기존 테이블의 데이터 중에 NULL값이 존재하지 않아야만 제약 생성)
CREATE TABLE DEPT6
(DEPTNO NUMBER(10),
 DNAME VARCHAR2(13),
 LOC VARCHAR2(10));

-- 다른 제약과 다르게 NOT NULL 제약은 ADD가 아니라 MODIFY로 생성한다. 
-- 또한 NOT NULL 다음에는 괄호를 열고 컬럼명을 명시하지 않는다. 
ALTER TABLE DEPT6
    MODIFY LOC CONSTRAINT DEPT6_LOC_NN NOT NULL;

--107 데이터의 품질 높이기(CHECK)
-- 사원 테이블을 생성하는데 월급이 0에서 6000사이의 데이터만 입력되거나 수정될 수 있도록 제약하기
-- CHECK 제약은 특정 컬럼에 특정 조건의 데이터만 입력되거나 수정되도록 제한을 거는 제약이다. 
-- 예를 들면 성별의 경우 남자, 여자만 입력되도록 한다.
CREATE TABLE EMP6
(EMPNO NUMBER(10),
 ENAME VARCHAR2(20),
 SAL NUMBER(10) CONSTRAINT EMP6_SAL_CK
 CHECK (SAL BETWEEN 0 AND 6000));
 
SELECT * FROM EMP6;

-- 만약 SAL컬럼을 9000으로 변경시키고 싶다면 불가능하다.
UPDATE EMP6
SET sal = 9000
WHERE ename = 'CLARK';

-- CHECK 제약에 위배되었다고 나온다. 
INSERT INTO emp6 VALUES(7566, 'ADAMS', 9000);

-- 만약 수정하거나 입력하려면 체크 제약을 삭제해야 한다. 
ALTER TABLE EMP6
DROP CONSTRAINT emp6_sal_ck;

INSERT INTO emp6 VALUES(7566, 'ADAMS', 9000);

--108 데이터의 품질 높이기 (FOREIGN KEY)
-- 사원 테이블의 부서 번호에 데이터를 입력할 때 부서 테이블에 존재하는 부서 번호만 입력될 수 있도록 제약 생성
-- DEPTNO 컬럼에 PRIMARY KEY 제약을 걸어서 DEPT7 테이블을 생성한다.
CREATE TABLE DEPT7
(DEPTNO NUMBER(10) CONSTRAINT DEPT7_DEPTNO_PK PRIMARY KEY,
 DNAME VARCHAR2(14),
 LOC VARCHAR2(10));

-- EMP7 테이블을 생성하는데 DEPTNO에 자식키(FOREIGN KEY)를 걸어서 생성한다. 
-- REFERENCES를 통해서 참조하겠다고 기술한다. 즉 DEPT7테이블은 부모 테이블, EMP7테이블은 자식 테이블이된다. 
CREATE TABLE EMP7
(EMPNO NUMBER(10),
 ENAME VARCHAR2(20),
 SAL NUMBER(10),
 DEPTNO NUMBER(10)
 CONSTRAINT EMP7_DEPTNO_FK REFERENCES DEPT7(DEPTNO));
 
 SELECT * FROM EMP7;
/*
EMP7 테이블의 DEPTNO가 DEPT7 테이블의 DEPTNO를 참조하고 있어서 EMP7 테이블의 DEPTNO에 데이터를 입력 또는 수정할 때 
DEPT7테이블의 DEPTNO에 존재하는 부서 번호에 대해서만 입력, 수정이 가능하다. 
서로 제약이 걸린 상황에서 DEP7 테이블의 PRIMARY KEY를 삭제하려면 삭제 되지 않는다. 자식 테이블이 EMP7 테이블이 부모 테이블인 DEPT7 테이블을 참조하고있다.
CASCADE 옵션을 붙여야 삭제 가능하다. 이떄는 EMP7 테이블의 FOREIGN KEY 제약도 같이 삭제된다. 
*/
 
 --109 WITH 절 사용하기(WITH ~ AS)
 -- WITH 절을 이용하여 직업과 직업별 토탈 월급을 출력하는데 직업별 토탈 월급들의 평균값보다 더 큰 값들로 출력
 -- SQL의 검색시간이 오래 걸리는 점을 위해서 성능을 높이기 위한 방법으로 WITH절을 사용한다
 -- SQL이 두 번 반복되는 것을 WITH절로 수행한 예제이다. 

 WITH JOB_SUMSAL AS (SELECT JOB, SUM(SAL) as 토탈 -- 직업과 직업별 토탈 월급을 출력하여 임시 저장 영역에 테이블 명을 JOB_SUMSAL로 명명지어 저장한다. 
                     FROM EMP
                     GROUP BY JOB)
SELECT JOB, 토탈 -- 그 후 JOB_SUMSAL에 저장된 데이터들을 불러와서 직업별 토탈 월급들의 평균값보다 더 큰 직업별 토탈 월급을 출력한다. 
    FROM JOB_SUMSAL
    WHERE 토탈 > (SELECT AVG(토탈)
                  FROM JOB_SUMSAL);
                  
-- 만약 WITH절을 수행하지 않고 SUB QUERY사용시는 다음과 같다.
SELECT job, sum(sal) as 토탈
    FROM emp
    GROUP BY JOB
    HAVING SUM(SAL) > (SELECT AVG(SUM(SAL))
                       FROM EMP
                       GROUP BY JOB);
                       
-- 110 WITH절 사용하기(SUQBUERY FACTORING)
WITH JOB_SUMSAL AS (SELECT JOB, SUM(SAL) 토탈
                    FROM EMP
                    GROUP BY JOB),
    DEPTNO_SUMSAL AS (SELECT DEPTNO, SUM(SAL) 토탈
                      FROM EMP
                      GROUP BY DEPTNO
                      HAVING SUM(SAL) > (SELECT AVG(토탈) + 3000
                                         FROM JOB_SUMSAL)
                    )
    SELECT DEPTNO, 토탈
    FROM DEPTNO_SUMSAL;
