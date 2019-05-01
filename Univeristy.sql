-- Database creation and Use
CREATE DATABASE SCHEDULE;
USE SCHEDULE;

--Location Entity
CREATE TABLE Location (
	LocationID VARCHAR(10),
	BuildingName VARCHAR(20) NOT NULL,
	RoomNumber INT NOT NULL,
	Floor INT NOT NULL,
	Campus VARCHAR(20) CHECK (Campus in ('Hayward','Concord','Online')) NOT NULL,
	CONSTRAINT Location_PK PRIMARY KEY (LocationID)
);
				   

--PersonType Entity is to implement inheritance 
CREATE TABLE PersonType (
	TypeID CHAR(1) CHECK (TypeID in ('S','I')),
	PersonType CHAR(10) CHECK (PersonType in ('Student','Instructor')) NOT NULL,
	CONSTRAINT PersonType_PK PRIMARY KEY (TypeID)
);

-- SuperType: People Entity
CREATE TABLE People (
	NetID CHAR(6) CHECK (NetID LIKE '[a-z][a-z][1-9][0-9][0-9][0-9]'),
	TypeID CHAR(1) NOT NULL,
	PFirstName VARCHAR(30) NOT NULL,
	PLastName VARCHAR(20) NOT NULL,
	Email VARCHAR(40) NOT NULL,
	Gender CHAR(1) CHECK (Gender IN ('M','F','O')) NOT NULL,
	CONSTRAINT People_PK PRIMARY KEY (NetID,TypeID),
	CONSTRAINT People_FK1 FOREIGN KEY (TypeID) REFERENCES PersonType(TypeID)
);

-- Subtype: Student Entity
CREATE TABLE Student (
	NetID CHAR(6), 
	TypeID CHAR(1) DEFAULT 'S' CHECK (TypeID IN ('S')) NOT NULL,
	Major VARCHAR(20) NOT NULL,
	GraducationSemester VARCHAR(10) CHECK (GraducationSemester in ('Spring','Summer','Fall','Winter')) NOT NULL,
	GraducationYear INT CHECK (GraducationYear BETWEEN 2000 AND 2030) NOT NULL,					  
	CONSTRAINT Student_PK PRIMARY KEY (NetID),
	CONSTRAINT Student_FK1 FOREIGN KEY (NetID,TypeID) REFERENCES People(NetID,TypeID)
);

-- Subtype: Instructor Entity
CREATE TABLE Instructor (
	NetID CHAR(6), 
	TypeID CHAR(1) DEFAULT 'I' CHECK (TypeID in ('I')) NOT NULL,
	InstructorOffice VARCHAR(10) NOT NULL,
	CONSTRAINT Instructor_PK PRIMARY KEY (NetID),
	CONSTRAINT Instructor_FK1 FOREIGN KEY (InstructorOffice) REFERENCES Location(LocationID),
	CONSTRAINT Instructor_FK2 FOREIGN KEY (NetID,TypeID) REFERENCES People(NetID,TypeID)
);

-- Course Entity with Unary relationship
CREATE TABLE Course (
	Course# VARCHAR(10), 
	CourseName VARCHAR(40) NOT NULL,
	CreditHours REAL CHECK (CreditHours IN (0.5,1,1.5,2,2.5,3,3.5,4,4.5,5,5.5,6)) NOT NULL,
	Desciption TEXT, 
	PreRequisite_1 VARCHAR(10),
	PreRequisite_2 VARCHAR(10),
	CONSTRAINT Course_PK PRIMARY KEY (Course#),
	CONSTRAINT Course_FK1 FOREIGN KEY (PreRequisite_1) REFERENCES Course(Course#),
	CONSTRAINT Course_FK2 FOREIGN KEY (PreRequisite_2) REFERENCES Course(Course#)
);

--Publisher Entity
CREATE TABLE Publisher (
	PublisherID INT CHECK (PublisherID BETWEEN 10000 AND 99999),
	PublisherName VARCHAR(30) NOT NULL,
	PublisherCity VARCHAR(20),
	PublisherState VARCHAR(15), 
	PublisherCountry VARCHAR(20) NOT NULL,
	CONSTRAINT Publisher_PK PRIMARY KEY (PublisherID)
);

--Author Entity
CREATE TABLE Author (
	AuthorID INT CHECK (AuthorID BETWEEN 100000 AND 999999),
	AuthorFirstName VARCHAR(30) NOT NULL,
	AuthorLastName VARCHAR(20), 
	AuthorGender CHAR(1) CHECK (AuthorGender in ('M','F','O')) NOT NULL,
	AuthorCountry VARCHAR(20) NOT NULL,
	CONSTRAINT Author_PK PRIMARY KEY (AuthorID)
);
				       
--Book Entity
CREATE TABLE Book (
	ISBN INT,
	BookName VARCHAR(100) NOT NULL,
	Edition INT NOT NULL,
	EditionYear INT CHECK (EditionYear BETWEEN 1950 AND 2030) NOT NULL,
	AuthorID_1 INT NOT NULL,
	AuthorID_2 INT,
	AuthorID_3 INT,
	AuthorID_4 INT,
	PublisherID INT NOT NULL,
	CONSTRAINT Book_PK PRIMARY KEY (ISBN),
	CONSTRAINT Book_FK1 FOREIGN KEY (AuthorID_1) REFERENCES Author(AuthorID),
	CONSTRAINT Book_FK2 FOREIGN KEY (AuthorID_2) REFERENCES Author(AuthorID),
	CONSTRAINT Book_FK3 FOREIGN KEY (AuthorID_3) REFERENCES Author(AuthorID),
	CONSTRAINT Book_FK4 FOREIGN KEY (AuthorID_4) REFERENCES Author(AuthorID),
	CONSTRAINT Book_FK5 FOREIGN KEY (PublisherID) REFERENCES Publisher(PublisherID)
);
				     
-- Class Entity
CREATE TABLE Class (
	Class# INT CHECK (Class# BETWEEN 1000 and 9999), 
	ClassSemester VARCHAR(10) CHECK (ClassSemester in ('Spring','Summer','Fall','Winter')) NOT NULL,
	ClassYear INT CHECK (ClassYear BETWEEN 2000 AND 2030) NOT NULL, 
	Course# VARCHAR(10) NOT NULL,
	SectionNo INT CHECK (SectionNo BETWEEN 1 AND 5) DEFAULT 1,
	InstructorID CHAR(6) NOT NULL,
	MeetingDay1 VARCHAR(3) CHECK (MeetingDay1 in ('M','Tu','W','Th','F','Sa','Su','TBA')) NOT NULL,
	StartTime1 TIME,
	EndTime1 TIME,
	CourseClassRoom1 VARCHAR(10) NOT NULL,					       
	MeetingDay2 VARCHAR(3) CHECK (MeetingDay2 in ('M','Tu','W','Th','F','Sa','Su','TBA')),
	StartTime2 TIME,
	EndTime2 TIME,
	CourseClassRoom2 VARCHAR(10),
	MeetingDay3 VARCHAR(3) CHECK (MeetingDay3 in ('M','Tu','W','Th','F','Sa','Su','TBA')),
	StartTime3 TIME,
	EndTime3 TIME,
	CourseClassRoom3 VARCHAR(10),
	MeetingDay4 VARCHAR(3) CHECK (MeetingDay4 in ('M','Tu','W','Th','F','Sa','Su','TBA')),
	StartTime4 TIME,
	EndTime4 TIME,
	CourseClassRoom4 VARCHAR(10),
	CourseBook_1 INT,
	CourseBook_2 INT,
	CONSTRAINT Class_PK PRIMARY KEY (Class#),
	CONSTRAINT Class_Alt_PK UNIQUE (ClassSemester,ClassYear,Course#,SectionNo),
	CONSTRAINT Class_FK1 FOREIGN KEY (Course#) REFERENCES Course(Course#),
	CONSTRAINT Class_FK2 FOREIGN KEY (InstructorID) REFERENCES Instructor(NetID),
	CONSTRAINT Class_FK3 FOREIGN KEY (CourseClassRoom1) REFERENCES Location(LocationID),
	CONSTRAINT Class_FK4 FOREIGN KEY (CourseClassRoom2) REFERENCES Location(LocationID),
	CONSTRAINT Class_FK5 FOREIGN KEY (CourseClassRoom3) REFERENCES Location(LocationID),
	CONSTRAINT Class_FK6 FOREIGN KEY (CourseClassRoom4) REFERENCES Location(LocationID),
	CONSTRAINT Class_FK7 FOREIGN KEY (CourseBook_1) REFERENCES Book(ISBN),
	CONSTRAINT Class_FK8 FOREIGN KEY (CourseBook_2) REFERENCES Book(ISBN)
);

--Enrollment Entity
CREATE TABLE Enrollment (
	StudentID CHAR(6) NOT NULL,
	Class# INT NOT NULL,
	ResultGrade VARCHAR(2) CHECK (ResultGrade IN ('A','A-','B','B-','C','C-','D','F','IP')) DEFAULT 'IP' NOT NULL,
	CONSTRAINT Enrollment_PK PRIMARY KEY (StudentID,Class#),
	CONSTRAINT Enrollment_FK1 FOREIGN KEY (StudentID) REFERENCES Student(NetID),
	CONSTRAINT Enrollment_FK2 FOREIGN KEY (Class#) REFERENCES Class(Class#)
);
