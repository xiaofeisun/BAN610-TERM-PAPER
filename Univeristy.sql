--CREATE DATABASE University;
CREATE DATABASE SCHEDULE;

--USE University;
USE SCHEDULE;

--Location Entity
CREATE TABLE Location (
	LocationID VARCHAR(10)
	,BuildingName VARCHAR(20) NOT NULL
	,RoomNumber INT NOT NULL
	,Floor INT NOT NULL
	,Campus VARCHAR(20) CHECK (Campus in ('Hayward','Concord','Online'))
	,CONSTRAINT Location_PK PRIMARY KEY (LocationID)
);

--PersonType Entity is to implement inheritance 
CREATE TABLE PersonType (
	TypeID INT CHECK (TypeID in ('S','I')
	,PersonType CHAR(7) (PersonType in ('Student','Instructor')
	,CONSTRAINT PersonType_PK PRIMARY KEY (TypeID)
);

-- SuperType: People Entity
CREATE TABLE People (
	NetID CHAR(6)
	,TypeID CHAR(1) NOT NULL
	,PFirstName VARCHAR(30) NOT NULL
	,PLastName VARCHAR(20) NOT NULL
	,Email VARCHAR(40) NOT NULL
	,CONSTRAINT People_PK PRIMARY KEY (NetID)
	,CONSTRAINT People_FK FOREIGN KEY (TypeID) REFERENCES PersonType(TypeID)
--	,CONSTRAINT People_AltPK UNIQUE (NetID, TypeID)
);

-- Subtype: Student Entity
CREATE TABLE Student(
	NetID CHAR(6) NOT NULL
	,TypeID INT DEFAULT 'S' CHECK (TypeID in ('S'))
	,Major VARCHAR(20) NOT NULL
	,GraducationSemester VARCHAR(10) CHECK (GraducationSemester in ('Spring','Summer','Fall','Winter')) NOT NULL
	,GraducationYear INT NOT NULL					  
	,CONSTRAINT Student_PK PRIMARY KEY (NetID)
--	,CONSTRAINT Student_FK FOREIGN KEY (NetID, TypeID) REFERENCES People(NetID, TypeID)
);
-- Subtype: Instructor Entity
CREATE TABLE Instructor (
	NetID CHAR(6) NOT NULL
	,TypeID INT DEFAULT 'I' CHECK (TypeID in ('I'))
	,InstructorOffice VARCHAR(10)
	,CONSTRAINT Instructor_PK PRIMARY KEY (NetID)
	,CONSTRAINT Instructor_FK FOREIGN KEY (InstructorOffice) REFERENCES Location(LocationID)
--	,CONSTRAINT Instructor_FK1 FOREIGN KEY (NetID, TypeID) REFERENCES People(NetID, TypeID)
);

-- Course Table and have unary relationship
CREATE TABLE Course (
	Course# VARCHAR(10) NOT NULL,
	Prerequisite VARCHAR(10),
	Prerequisite_2 VARCHAR (10),
	CourseName VARCHAR(30),
	CreditHours DECIMAL(2,1),
	Desciption TEXT,
	CONSTRAINT Course_PK PRIMARY KEY (Course#),
	CONSTRAINT Course_FK FOREIGN KEY (Prerequisite) REFERENCES Course(Course#),
	CONSTRAINT Course_FK1 FOREIGN KEY (Prerequisite_2) REFERENCES Course(Course#)
);


--CourseBookList Entity
CREATE TABLE CourseBookList(
	ISBN INT NOT NULL,
	CourseBookName VARCHAR(40),
	CourseBookPublisher VARCHAR(30),
	Author VARCHAR(30),
	Edition VARCHAR(10)
	CONSTRAINT CourseBookList_PK PRIMARY KEY (ISBN)
);

-- ClassList Entity
CREATE TABLE ClassList(
	Class# INT NOT NULL,
	Semester VARCHAR(10) NOT NULL,
	Course# VARCHAR(10),
	SectionNo INT,
	InstructorID CHAR(6),
	MeetingDays VARCHAR(10),
	StartsTime TIME,
	EndsTime TIME,
	CourseClassRoom VARCHAR(10),
	CourseBook INT,
	CourseBook_2 INT,
	CONSTRAINT ClassList_PK PRIMARY KEY (Class#, Semester),
	CONSTRAINT ClassList_FK FOREIGN KEY (Course#) REFERENCES Course(Course#),
	CONSTRAINT ClassList_FK1 FOREIGN KEY (InstructorID) REFERENCES Instructor(NetID),
	CONSTRAINT ClassList_FK2 FOREIGN KEY (CourseClassRoom) REFERENCES Location(LocationID),
	CONSTRAINT ClassList_FK3 FOREIGN KEY (CourseBook) REFERENCES CourseBookList(ISBN),
	CONSTRAINT ClassList_FK4 FOREIGN KEY (CourseBook_2) REFERENCES CourseBookList(ISBN)
);

--Enrollment Entity
CREATE TABLE Enrollment(
	StudentID CHAR(6) NOT NULL,
	Class# INT NOT NULL,
	Semester VARCHAR(10) NOT NULL,
	LetterGrade CHAR(2),
	CONSTRAINT Enrollment_PK PRIMARY KEY (StudentID,Class#),
	CONSTRAINT Enrollment_FK FOREIGN KEY (StudentID) REFERENCES Student(NetID),
	CONSTRAINT Enrollment_FK1 FOREIGN KEY (Class#, Semester) REFERENCES ClassList(Class#,Semester)
);

