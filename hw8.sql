-- CPS 541 HW 8 VENKATA SAI MADHAV KAZA
-- cr-company.sql
-- creates the COMPANY DB-schema
-- part 1 

-- ALSO SEE figures 4.1 and 4.2 of Text (Elmasri 6th Ed.)

-- keep these two commands at the top of every sql file
set echo on
set linesize 120

drop table Employee cascade constraints;
commit;

create table Employee 
(
	fname varchar2(15)  NOT NULL,
	minit char, -- can be char
	lname varchar2(15) NOT NULL,
	ssn char(9) NOT NULL,
	bdate date,
	address varchar2(50),
	sex char 	CHECK(sex = 'M' or sex = 'F'),
	salary number		CHECK(salary>=20000 AND salary<=100000),-- need to put check on salary 
	superssn char(9),
	dno int,
	constraint EMPPK
	    primary key(ssn),
	constraint EMPSUPERVRFK
	    foreign key(superssn) references Employee(ssn)
	    	ON DELETE SET NULL
--
--   Note:
--	ON DELETE SET DEFAULT, ON UPDATE CASCADE
-- Oracle does not support cascading updates, and does not allow you to set the value to the default 
-- when the parent row is deleted. Your two options for an on delete behavior are cascade or set null. 
-- Tested: February 05, 2018
--	, constraint EMPDEPTFK 
--		foreign key(dno) references Department(dnumber) 
--			ON DELETE SET NULL
-- ERROR - Department table has not been created yet
-- need to postpone this constraint
-- use alter table command to add this constraint
-- alter table Employee add constraint EMPDEPTFK 
--     foreign key(dno) references Department(dnumber) 
--     ON DELETE SET NULL
--
);

drop table Department cascade constraints;
commit;
create table Department 
(
	dname varchar2(15) 	NOT NULL,
	dnumber int NOT NULL,
	mgrssn char(9)		DEFAULT '000000000',
	mgrstartdate date,
	constraint DEPTPK
	    primary key(dnumber),
	constraint DEPTMGRFK
	    foreign key(mgrssn) references Employee(ssn)
			ON DELETE SET NULL 
--
--		ON DELETE SET DEFAULT, ON UPDATE CASCADE  
--
-- The above actions for DELETE SET DEFAULT and for UPDATE CASCADE does not work
-- with  the current SQL-plus version we have at this time. 
-- Just use SET NULL for delete and disable the update action part of the constraint.
--
);

alter table Employee add 
	constraint EMPDEPTFK foreign key(dno) references Department(dnumber) 
	ON DELETE SET NULL;

-- ADD the rest
drop table Dept_locations cascade constraints;
commit;
create table Dept_locations
(
	dnumber int NOT NULL,
	dlocation varchar2(15) NOT NULL,
	constraint DEPTLCTNSPK
		primary key(dnumber,dlocation),
	constraint DEPLCTNSFK
		foreign key(dnumber) references Department(dnumber)
			ON DELETE SET NULL
);

drop table Project cascade constraints;
commit;
create table Project
(
	pname varchar2(15) NOT NULL,
	pnumber int NOT NULL,
	plocation varchar2(15) NOT NULL,
	dnumber int NOT NULL,
	constraint PRJCTPK
		primary key(pnumber),
	constraint PRJCTFK
		foreign key(dnumber) references Department(dnumber)
			ON DELETE SET NULL
);

drop table Workson cascade constraints;
commit;
create table Workson
(
	essn char(9),
	pno int,
	hours decimal,
	constraint WRKONPK
		primary key(essn,pno),
	constraint WRKONFK
		foreign key(essn) references Employee(ssn) ON DELETE SET NULL,
	constraint WRKNFK
		foreign key(pno) references Project(pnumber)
			ON DELETE SET NULL
);

--alter table Workson add
--	constraint WRKONFK foreign key(pno) references Project(pnumber)
--	ON DELETE SET NULL;

drop table Dependent cascade constraints;
commit;
create table Dependent
(
	essn char(9) 	DEFAULT '000000000',
	dependentname varchar2(15) NOT NULL,
	sex char 	CHECK(sex = 'M' or sex = 'F'),
	bdate date,
	relationship varchar2(8),
	constraint DPNDNTPK
		primary key(essn,dependentname),
	constraint DPNDNTFK
		foreign key(essn) references Employee(ssn)
			ON DELETE SET NULL	
);

-- CPS 541 HW 8 VENKATA SAI MADHAV KAZA
-- ins-company.sql
-- inserts tuples into the COMPANY DB
-- part 2

-- keep these two commands at the top of every sql file
set echo on
set linesize 120

delete from Employee;
commit;

-- insert only managers first with their dno is null
INSERT INTO employee VALUES 
  ('James','E','Borg','888665555','10-NOV-27','450 Stone, Houston, TX','M',55000,null,null);
INSERT INTO employee VALUES 
  ('Franklin','T','Wong','333445555','08-DEC-45','638 Voss, Houston, TX','M',40000,'888665555',null);
INSERT INTO employee VALUES
  ('Jennifer','S','Wallace','987654321','20-JUN-41','291 Berry, Bellaire, TX','F',43000,'888665555',null);
INSERT INTO employee VALUES
  ('John','B','Smith','123456789','09-JAN-1965','731 Fondren, Houston, TX','M',30000,'333445555',null);
INSERT INTO employee VALUES 
  ('Alicia','J','Zelaya','999887777','19-JAN-1968','3321 Castle, Spring, TX','F',25000,'987654321',null);
INSERT INTO employee VALUES
  ('Ramesh','K','Narayan','666884444','15-SEP-1962','975 Fire Oak, Humble, TX', 'M',38000,'333445555',null);
INSERT INTO employee VALUES
  ('Joyce','A','English','453453453','31-JUL-1972','5631 Rice, Houston, TX','F',25000,'333445555',null);
INSERT INTO employee VALUES
  ('Ahmad','V','Jabbar','987987987','29-MAR-1969','980 Dallas, Houston, TX','M',25000,'987654321',null);
-- need more manager inserts to employee

delete from Department;
commit;
insert into Department values ('Research',5,'333445555','22-MAY-1988');
insert into Department values ('Headquarters',1,'888665555','19-JUN-1981');
insert into Department values ('Administration',4,'987654321','01-JAN-1995');
-- need more inserts to department

-- now, update employee.dno for managers
UPDATE employee SET dno = 1 WHERE ssn = '888665555';
UPDATE employee SET dno = 5 WHERE ssn = '333445555';
UPDATE employee SET dno = 4 WHERE ssn = '987654321';
UPDATE employee SET dno = 5 WHERE ssn = '123456789';
UPDATE employee SET dno = 4 WHERE ssn = '999887777';
UPDATE employee SET dno = 5 WHERE ssn = '666884444';
UPDATE employee SET dno = 5 WHERE ssn = '453453453';
UPDATE employee SET dno = 4 WHERE ssn = '987987987';
-- need to update the rest of managers

-- insert the rest of non-manager employees, supervisors first
-- insert into Employee values ('John','B','Smith','123456789','09-JAN-1965','731 Fondren, Houston, TX','M',30000,'333445555',5);
-- insert into Employee values ('Alicia','J','Zelaya','999887777','19-JAN-1968','3321 Castle, Spring, TX','F',25000,'987654321',4);
-- insert into Employee values ('Ramesh','K','Narayan','666884444','15-SEP-1962','975 Fire Oak, Humble, TX', 'M',38000,'333445555',5);
-- insert into Employee values ('Joyce','A','English','453453453','31-JUL-1972','5631 Rice, Houston, TX','F',25000,'333445555',5);
-- insert into Employee values ('Ahmad','V','Jabbar','987987987','29-MAR-1969','980 Dallas, Houston, TX','M',25000,'987654321',4);	
-- need more inserts to employee

-- ADD the rest
delete from Dept_locations;
commit;
insert into Dept_locations values (1,'Houston');
insert into Dept_locations values (4,'Stafford');
insert into Dept_locations values (5,'Bellaire');
insert into Dept_locations values (5,'Sugarland');
insert into Dept_locations values (5,'Houston');

delete from Project;
commit;
insert into Project values ('ProductX',1,'Bellaire',5);
insert into Project values ('ProductY',2,'Sugarland',5);
insert into Project values ('ProductZ',3,'Houston',5);
insert into Project values ('Computerization',10,'Stafford',4);
insert into Project values ('Reorganization',20,'Houston',1);
insert into Project values ('Newbenefits',30,'Stafford',4);

delete from Workson;
commit;
insert into Workson values ('123456789',1,32.5);
insert into Workson values ('123456789',2,7.5);
insert into Workson values ('666884444',3,40.0);
insert into Workson values ('453453453',1,20.0);
insert into Workson values ('453453453',2,20.0);
insert into Workson values ('333445555',2,10.0);
insert into Workson values ('333445555',3,10.0);
insert into Workson values ('333445555',10,10.0);
insert into Workson values ('333445555',20,10.0);
insert into Workson values ('999887777',30,30.0);
insert into Workson values ('999887777',10,10.0);
insert into Workson values ('987987987',10,35.0);
insert into Workson values ('987987987',30,5.0);
insert into Workson values ('987654321',30,20.0);
insert into Workson values ('987654321',20,15.0);
insert into Workson values ('888665555',20,null);

delete from Dependent;
commit;
insert into Dependent values ('333445555','Alice','F','05-APR-1986','Daughter');
insert into Dependent values ('333445555','Theodore','M','25-OCT-1983','Son');
insert into Dependent values ('333445555','Joy','F','03-MAY-1958','Spouse');
insert into Dependent values ('987654321','Abner','M','28-FEB-1942','Spouse');
insert into Dependent values ('123456789','Michael','M','04-JAN-1988','Son');
insert into Dependent values ('123456789','Alice','F','30-DEC-1988','Daughter');
insert into Dependent values ('123456789','Elizabeth','F','05-MAY-1967','Spouse');

-- CPS 541/ITC 341, 441 - PLSQL Trigger 
-- Dr. Ugur
-- CPS 541 HW 8 VENKATA SAI MADHAV KAZA

set linesize 120;
set echo on;
set serveroutput on;
set timing on;

-- Part 3
create or replace trigger emp_trigger
after insert on employee
begin 
	update employee SET fname = upper(fname),lname = upper(lname), address = upper(address);
end;
/
show errors

create or replace trigger dept_trigger
after insert on department
begin
	update department SET dname = upper(dname);
end;
/
show errors

create or replace trigger deptlctns_trigger
after insert on dept_locations
begin 
	update dept_locations SET dlocation = upper(dlocation);
end;
/
show errors 

create or replace trigger prjct_trigger
after insert on project 
begin 
	update project SET pname = upper(pname),plocation = upper(plocation);
end;
/ 
show errors

create or replace trigger wrkson_trigger
after insert on workson 
begin 
	update workson SET essn = upper(essn);
end;
/ 
show errors

create or replace trigger dpndnt_trigger
after insert on dependent
begin 
	update dependent SET dependentname = upper(dependentname),relationship = upper(relationship);
end;
/
show errors

-- **** Part 3: Triggers implementation to change character datatype of all table columns into upper case character datatype columns **** --

-- before update
select * from employee; 

-- update - lowercase fname, lname and address
insert into Employee values ('Rahul','J','Chopra','543216789','29-DEC-1998','480 Oak street, sugarland, TX','M',68000,'999887777',1);

-- notice that fname, lname and address are all uppercase now
select * from employee; 

-- undo the update (insert)
rollback; 

-- notice that fname, lname and address are all lowercase now
select * from employee;

-- before update
select * from department; 

-- update - lowercase dname
insert into Department values ('Lab', 9, '333445555', null);

-- notice that dnames are all uppercase now
select * from department; 

-- undo the update (insert)
rollback; 

-- notice that dnames are all lowercase now
select * from department;

-- before update
select * from dept_locations; 

-- update - lowercase dlocation
insert into Dept_locations values (1,'Canton');

-- notice that dlocations are all uppercase now
select * from dept_locations; 

-- undo the update (insert)
rollback; 

-- notice that dlocation are all lowercase now
select * from dept_locations;

-- before update
select * from project; 

-- update - lowercase pname and plocation
insert into Project values ('ProductW',40,'Canton',1);

-- notice that pname and plocation are all uppercase now
select * from project; 

-- undo the update (insert)
rollback; 

-- notice that pname and plocation are all lowercase now
select * from project;

-- before update
select * from workson; 

-- update - lowercase essn
insert into Workson values ('123456789',20,56.5);

-- notice that essn are all uppercase now
select * from workson; 

-- undo the update (insert)
rollback; 

-- notice that essn are all lowercase now
select * from workson;

-- before update
select * from dependent; 

-- update - lowercase dependentname and relationship
insert into Dependent values ('987654321','Robert','M','29-FEB-1996','Son');

-- notice that dependentname and relationship are all uppercase now
select * from dependent; 

-- undo the update (insert)
rollback; 

-- notice that dependentname and relationship are all lowercase now
select * from dependent;

-- CPS 541/ITC 341, 441 - PLSQL Function example-1 
-- Dr. Ugur
-- CPS 541 HW 8 VENKATA SAI MADHAV KAZA

set linesize 120;
set echo on;
set serveroutput on;
set timing on;

-- part 4
-- Function that returns Dname from Department for any given employee. 
-- The parameter to the function is the SSN.

CREATE OR REPLACE FUNCTION get_dept_name(EMPSSN IN employee.ssn%type)
   RETURN department.dname%type
IS 
   mm department.dname%type;
BEGIN
   mm := '';  -- initially empty value 

   SELECT dname into mm FROM EMPLOYEE E, DEPARTMENT D 
   WHERE E.DNO = D.DNUMBER AND E.SSN = EMPSSN ;

   RETURN(mm);

-- exception handling

   exception
     when NO_DATA_FOUND then
       dbms_output.put_line('No data found');
       RETURN(mm);

END;
/
show errors

-- **** Part 4 answer **** -- function call
declare 
	deptname department.dname%type;
begin
-- function call
	deptname := get_dept_name('123456789'); 
	dbms_output.put_line('dept name for ' || '123456789' || ' is ' || deptname);

-- function call   
	deptname := get_dept_name('111111111');
	if deptname != '' then
		dbms_output.put_line('dept name for ' || '111111111' || ' is ' || deptname);
	end if;
end;
/

-- using the function in a query

select ssn, fname, lname, get_dept_name(ssn) as DEPTNAME
from employee;

select lname || ', ' || fname || ' ' || 'works at ' || get_dept_name(ssn) || '.' as EMP_DEPT_INFO
from employee;

-- undo changes that are done for testing, if you make a change to a table, 
-- you can undo that change by 'rollback'
-- rollback; 

-- part 5
-- Implement a Function that returns manager’s full name for any given department. 
-- The parameter to the function would be the department name.
CREATE OR REPLACE FUNCTION get_manager_name(DEPNAME IN department.dname%type)
   RETURN VARCHAR2
IS 
   mh VARCHAR2(100);
   ml employee.lname%type;
   mm employee.minit%type;
   mf employee.fname%type;
BEGIN
   mh := '';-- initially empty value 
 
   SELECT lname,minit,fname into ml,mm,mf FROM EMPLOYEE E, DEPARTMENT D 
   WHERE E.SSN = D.MGRSSN AND E.DNO = D.DNUMBER AND D.DNAME = DEPNAME ;
   
   mh := mf || ' ' || mm || ' ' || ml;

   RETURN(mh);

-- exception handling

   exception
     when NO_DATA_FOUND then
       dbms_output.put_line('No data found');
       RETURN(mh);

END;
/
show errors

-- **** Part 5 answer **** -- function call
declare 
	empfname VARCHAR2(100);
begin
-- function call
	empfname := get_manager_name('Research');
	dbms_output.put_line('Managers full name for ' || 'Research' || ' is ' || empfname);

-- function call   
	empfname := get_manager_name('Lab');
	if empfname != '' then
		dbms_output.put_line('Managers full name  for ' || 'Lab' || ' is ' || empfname);
	end if;
end;
/

-- using the function in a query

select D.dname, get_manager_name(D.dname) as EMPNAME_DEPNAME
from department D;

select D.dname || ' department has manager as' || ' ' || get_manager_name(D.dname) || '.' as DEPARTMENT_INFO
from department D;

-- undo changes that are done for testing, if you make a change to a table, 
-- you can undo that change by 'rollback'
-- rollback; 

-- part 6
-- Implement a Function that returns manager’s full name for any given department. 
-- The parameter to the function would be the department number.
CREATE OR REPLACE FUNCTION get_manager_deptnum_name(DEPNUMBER IN department.dnumber%type)
   RETURN VARCHAR2
IS 
   mh VARCHAR2(100);
   ml employee.lname%type;
   mm employee.minit%type;
   mf employee.fname%type;
BEGIN
   mh := '';-- initially empty value 
 
   SELECT lname,minit,fname into ml,mm,mf FROM EMPLOYEE E, DEPARTMENT D 
   WHERE E.SSN = D.MGRSSN AND E.DNO = D.DNUMBER AND D.DNUMBER = DEPNUMBER ;
  
   mh := mf || ' ' || mm || ' ' || ml;

   RETURN(mh);

-- exception handling

   exception
     when NO_DATA_FOUND then
       dbms_output.put_line('No data found');
       RETURN(mh);

END;
/
show errors

-- **** Part 6 answer **** -- function call
declare 
	empfname VARCHAR2(100);
begin
-- function call
	empfname := get_manager_deptnum_name(1);
	dbms_output.put_line('Managers full name for ' || '1' || ' department number is ' || empfname);

-- function call   
	empfname := get_manager_deptnum_name(6);
	if empfname != '' then
		dbms_output.put_line('Managers full name  for ' || '6' || ' department number is ' || empfname);
	end if;
end;
/

-- using the function in a query

select D.dnumber, get_manager_deptnum_name(D.dnumber) as EMPNAME_DEPNUMBER
from department D;

select D.dnumber || ' department number has manager as' || ' ' || get_manager_deptnum_name(D.dnumber) || '.' as DEPARTMENT_INFO
from department D;

-- undo changes that are done for testing, if you make a change to a table, 
-- you can undo that change by 'rollback'
-- rollback; 

-- CPS 541/ITC 341, 441 - PLSQL stored procedure example-1
-- Dr. Ugur
-- CPS 541 HW 8 VENKATA SAI MADHAV KAZA

set linesize 120;
set echo on;
set serveroutput on;
set timing on;

-- part 7
-- given empssn, percent increase (x) find new salary of the employee and display it.
CREATE OR REPLACE PROCEDURE get_sal_new_sp(EMPSSN IN employee.ssn%type,PERCNT IN number)
AS 
   sal_new number;
BEGIN 
   sal_new := '';  -- initially empty value 
 
   SELECT SALARY*(1+PERCNT/100) into sal_new FROM EMPLOYEE
   WHERE SSN = EMPSSN;
   
   dbms_output.put_line('New Salary  is '|| sal_new);

-- exception handling

   exception
     when NO_DATA_FOUND then
       dbms_output.put_line('No data found');

END;
/
show errors

-- **** Test **** -- sp call
-- calling the stored procedure get_dept_name_sp
exec get_sal_new_sp('123456789',10);
exec get_sal_new_sp('987654321',30);

-- using the store procedure in a query
-- ERROR, does not work
-- since a SP does not return a value
-- select ssn, fname, lname, exec get_dept_name_sp(ssn)
-- from employee;

-- undo changes that are done for testing, if you make a change to a table, 
-- you can undo that change by 'rollback'
-- rollback; 

-- CPS 541/ITC 341, 441 - PLSQL- Package example-1
-- Dr. Ugur
-- CPS 541 HW 8 VENKATA SAI MADHAV KAZA

set linesize 120;
set echo on;
set serveroutput on;
set timing on;

-- Question 8 Answer Code Begins Here ---
-- Package that includes methods to:
-- 1. Count the number of dependents for a valid employee
-- 2. Check whether the ssn number given is valid for an employee or not
-- 3. Check whether the department name given is valid for a department or not 
-- 4. Average number of dependents for a particular department name
-- 5. Check whether the ssn and dependent name is a valid one or not
-- 6. Remove a dependent tuple if there is a match of ssn and dependent name in input

-- **** Package Declaration **** --
create or replace package dependent_package as
    procedure get_dependent_num(eno in employee.ssn%type);
	procedure valid_emp_ssn(eno in employee.ssn%type);
	procedure valid_dpt_name(DEPNAME in department.dname%type);
	procedure get_dependents_avg(DEPNAME in department.dname%type);
	procedure valid_remove_dependent(eno in employee.ssn%type,dpname in dependent.dependentname%type);
	procedure remove_dependent(eno in employee.ssn%type,dpname in dependent.dependentname%type);
end;
/
show errors


-- **** Package Body **** --
create or replace package body dependent_package as

    procedure get_dependent_num(eno in employee.ssn%type)
    as
		dn number;
    begin
		dn := '';  -- initially empty value 
		--select count(*) into dn from employee where ssn = eno;
		
		select count(*) into dn from employee e, dependent d
		where d.essn = e.ssn and d.essn = eno;
    
		dbms_output.put_line('Number of dependents of emp. ' || eno || ' is ' || dn);
		
		-- exception handling
		exception
		when NO_DATA_FOUND then
			dbms_output.put_line('No data found');
    end;
	
	procedure valid_emp_ssn(eno in employee.ssn%type)
	as 
		dn employee.lname%type; 
	begin 
		select lname into dn from employee where ssn = eno;
		
		dbms_output.put_line('Valid SSN number ' || eno || ' is ' ||dn);
		
		-- exception handling
		exception
		when NO_DATA_FOUND then
			dbms_output.put_line('Invalid SSN number ' || eno);
	end;
	
	procedure valid_dpt_name(DEPNAME in department.dname%type)
	as 
		en employee.lname%type;
	begin
		select lname into en from employee e,department d
		where e.ssn = d.mgrssn and e.dno = d.dnumber and d.dname = DEPNAME;
		
		dbms_output.put_line('Valid Department Name ' || DEPNAME || ' is ' ||en);
		
		-- exception handling
		exception
		when NO_DATA_FOUND then
			dbms_output.put_line('Invalid Department Name is ' || DEPNAME);
	end;	
	
	procedure get_dependents_avg(DEPNAME in department.dname%type)
	as 
		dn1 number;
		dn2 number;
		dn number;
	begin
		select count(*) into dn1 from employee e, department d1, dependent d2
		where e.ssn = d1.mgrssn and e.dno = d1.dnumber and d2.essn = e.ssn and d1.dname = DEPNAME;
		
		select count(*) into dn2 from employee e, department d
		where e.dno = d.dnumber and e.ssn = d.mgrssn;
		
		dn := (dn1/dn2); -- the average number of dependents per number of employees match in department table 
		
		dbms_output.put_line('Average number of dependents ' || DEPNAME || ' is ' ||dn);
		
		-- exception handling
		exception
		when NO_DATA_FOUND then
			dbms_output.put_line('No Data Found ');
	end;
	
	procedure valid_remove_dependent(eno in employee.ssn%type,dpname in dependent.dependentname%type)
	as 
		lm employee.lname%type;
		dm dependent.dependentname%type;
	begin
		select e.lname,d.dependentname into lm,dm from employee e, dependent d
		where e.ssn = eno and e.ssn = d.essn and d.dependentname = dpname;
		
		dbms_output.put_line('Valid Dependent and ssn: ' || eno || ' is ' || lm || ' with dependent name as ' || dm );
		
		-- exception handling
		exception
		when NO_DATA_FOUND then
			dbms_output.put_line('Invalid Dependent and SSN combination ');	
	end;
	
	procedure remove_dependent(eno in employee.ssn%type,dpname in dependent.dependentname%type)
	as
		bn number;
		an number;
	begin  
		
		select count(*) into bn from dependent where dependentname = dpname and essn = eno;
		
		delete from dependent where dependentname = dpname and essn = eno;
		
		select count(*) into an from dependent where dependentname = dpname and essn = eno;
		
		if an != bn then 
			dbms_output.put_line('Dependents with dependent name and ssn: ' || dpname || ' and ' || eno || ' is removed from the dependents table' );
		end if;
		if an = bn then
			dbms_output.put_line('Dependents table is not removed by any tuples ');
		end if;
		-- exception handling
		exception
		when NO_DATA_FOUND then
			dbms_output.put_line('No data found ');	
		
	end;
end;
/
show errors


-- **** Question 8 Part 1 **** --

exec dependent_package.valid_emp_ssn('123456789');

exec dependent_package.get_dependent_num('123456789');

exec dependent_package.valid_emp_ssn('111111111');

exec dependent_package.get_dependent_num('111111111');

-- **** Question 8 Part 2 **** --

exec dependent_package.valid_dpt_name('Research');

exec dependent_package.get_dependents_avg('Research'); 

exec dependent_package.valid_dpt_name('Lab');

exec dependent_package.get_dependents_avg('Lab');

exec dependent_package.valid_dpt_name('Administration');

exec dependent_package.get_dependents_avg('Administration'); 

-- **** Question 8 Part 3 **** --
-- Test 1 for remove dependent question -- 
exec dependent_package.valid_remove_dependent('333445555','Alice');

-- Dependents Before Delete Operation
select * from dependent;

exec dependent_package.remove_dependent('333445555','Alice');

-- Dependents After Delete Operation
select * from dependent;

exec dependent_package.valid_remove_dependent('333445555','Alice');

rollback;

exec dependent_package.valid_remove_dependent('333445555','Alice');
-- Test 2 for remove dependent question -- 
exec dependent_package.valid_remove_dependent('331445555','Rohit');

-- Dependents Before Delete Operation
select * from dependent;

exec dependent_package.remove_dependent('333445555','Rohit');

-- Dependents After Delete Operation
select * from dependent;


exec dependent_package.valid_remove_dependent('331445555','Rohit');

rollback;

exec dependent_package.valid_remove_dependent('331445555','Rohit');


-- undo changes that are done for testing, if you make a change to a table, 
-- you can undo that change by 'rollback'
-- rollback; 
