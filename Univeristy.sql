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
	,Campus VARCHAR(20) CHECK (Campus in ('Hayward','Concord','Online')) NOT NULL
	,CONSTRAINT Location_PK PRIMARY KEY (LocationID)
);

--PersonType Entity is to implement inheritance 
CREATE TABLE PersonType (
	TypeID INT CHECK (TypeID in ('S','I') 
	,PersonType CHAR(7) (PersonType in ('Student','Instructor') NOT NULL
	,CONSTRAINT PersonType_PK PRIMARY KEY (TypeID)
);

-- SuperType: People Entity
CREATE TABLE People (
	NetID CHAR(6)
	,TypeID CHAR(1) NOT NULL
	,PFirstName VARCHAR(30) NOT NULL
	,PLastName VARCHAR(20) NOT NULL
	,Email VARCHAR(40) NOT NULL
	,Gender CHAR(1) CHECK (Gender IN ('M','F','O')) NOT NULL
	,CONSTRAINT People_PK PRIMARY KEY (NetID)
	,CONSTRAINT People_FK FOREIGN KEY (TypeID) REFERENCES PersonType(TypeID)
--	,CONSTRAINT People_AltPK UNIQUE (NetID, TypeID)
);

-- Subtype: Student Entity
CREATE TABLE Student (
	NetID CHAR(6) 
	,TypeID INT DEFAULT 'S' CHECK (TypeID in ('S')) NOT NULL
	,Major VARCHAR(20) NOT NULL
	,GraducationSemester VARCHAR(10) CHECK (GraducationSemester in ('Spring','Summer','Fall','Winter')) NOT NULL
	,GraducationYear INT NOT NULL					  
	,CONSTRAINT Student_PK PRIMARY KEY (NetID)
--	,CONSTRAINT Student_FK FOREIGN KEY (NetID, TypeID) REFERENCES People(NetID, TypeID)
);

-- Subtype: Instructor Entity
CREATE TABLE Instructor (
	NetID CHAR(6) 
	,TypeID INT DEFAULT 'I' CHECK (TypeID in ('I')) NOT NULL
	,InstructorOffice VARCHAR(10) NOT NULL
	,CONSTRAINT Instructor_PK PRIMARY KEY (NetID) 
	,CONSTRAINT Instructor_FK FOREIGN KEY (InstructorOffice) REFERENCES Location(LocationID)
--	,CONSTRAINT Instructor_FK1 FOREIGN KEY (NetID, TypeID) REFERENCES People(NetID, TypeID)
);

-- Course Entity with Unary relationship
CREATE TABLE Course (
	Course# VARCHAR(10) 
	,CourseName VARCHAR(40) NOT NULL
	,CreditHours REAL NOT NULL
	,Desciption TEXT 
	,PreRequisite_1 VARCHAR(10)
	,PreRequisite_2 VARCHAR(10)
	,CONSTRAINT Course_PK PRIMARY KEY (Course#)
	,CONSTRAINT Course_FK1 FOREIGN KEY (PreRequisite_1) REFERENCES Course(Course#)
	,CONSTRAINT Course_FK2 FOREIGN KEY (PreRequisite_2) REFERENCES Course(Course#)
);


--Publisher Entity
CREATE TABLE Publisher (
	PublisherID INT
	,PublisherName VARCHAR(30) NOT NULL
	,PublisherCity VARCHAR(20) 
	,PublisherState VARCHAR(15) 
	,PublisherCountry VARCHAR(20) NOT NULL
	,CONSTRAINT Publisher_PK PRIMARY KEY (PublisherID)
);
				       
--Author Entity
CREATE TABLE Author (
	AuthorID INT
	,AuthorFirstName VARCHAR(30) NOT NULL
	,AuthorLastName VARCHAR(20) 
	,AuthorGender CHAR(1) CHECK (AuthorGender in ('M','F','O')) NOT NULL
	,AuthorCountry VARCHAR(20) NOT NULL
	,CONSTRAINT Author_PK PRIMARY KEY (AuthorID)
);
				       
				       
--Book Entity
CREATE TABLE Book (
	ISBN INT
	,BookName VARCHAR(100) NOT NULL
	,Edition VARCHAR(2) NOT NULL
	,EditionYear INT NOT NULL
	,AuthorID_1 VARCHAR(30) NOT NULL
	,AuthorID_2 VARCHAR(30) 
	,AuthorID_3 VARCHAR(30) 
	,AuthorID_4 VARCHAR(30) 
	,PublisherID INT NOT NULL
	,CONSTRAINT Book_PK PRIMARY KEY (ISBN)
	,CONSTRAINT Book_FK1 FOREIGN KEY (AuthorID_1) REFERENCES Author(AuthorID)
	,CONSTRAINT Book_FK2 FOREIGN KEY (AuthorID_2) REFERENCES Author(AuthorID)
	,CONSTRAINT Book_FK3 FOREIGN KEY (AuthorID_3) REFERENCES Author(AuthorID)
	,CONSTRAINT Book_FK4 FOREIGN KEY (AuthorID_4) REFERENCES Author(AuthorID)
	,CONSTRAINT Book_FK5 FOREIGN KEY (PublisherID) REFERENCES Publisher(PublisherID)
);
       

-- ClassList Entity
CREATE TABLE ClassList (
	ClassID INT NOT NULL
	,ClassSemester VARCHAR(10) CHECK (ClassSemester in ('Spring','Summer','Fall','Winter')) NOT NULL
	,ClassYear INT NOT NULL
	,Course# VARCHAR(10) NOT NULL
	,SectionNo INT NOT NULL
	,InstructorID CHAR(6) NOT NULL
	,MeetingDay1 VARCHAR(10) NOT NULL
	,StartTime1 TIME NOT NULL
	,EndTime1 TIME NOT NULL
	,MeetingDay2 VARCHAR(10)
	,StartTime2 TIME
	,EndTime2 TIME
	,MeetingDay3 VARCHAR(10)
	,StartTime3 TIME
	,EndTime3 TIME
	,MeetingDay4 VARCHAR(10)
	,StartTime4 TIME
	,EndTime4 TIME
	,CourseClassRoom VARCHAR(10) NOT NULL
	,CourseBook_1 INT  
	,CourseBook_2 INT
	,CONSTRAINT ClassList_PK PRIMARY KEY (ClassID)
	,CONSTRAINT ClassList_FK1 FOREIGN KEY (Course#) REFERENCES Course(Course#)
	,CONSTRAINT ClassList_FK2 FOREIGN KEY (InstructorID) REFERENCES Instructor(NetID)
	,CONSTRAINT ClassList_FK3 FOREIGN KEY (CourseClassRoom) REFERENCES Location(LocationID)
	,CONSTRAINT ClassList_FK4 FOREIGN KEY (CourseBook_1) REFERENCES Book(ISBN)
	,CONSTRAINT ClassList_FK5 FOREIGN KEY (CourseBook_2) REFERENCES Book(ISBN)
);

--Grade Entity
CREATE TABLE Grade (
	ResultGrade VARCHAR(2) 
	,MaxPercent INT UNIQUE CHECK (MaxPercent BETWEEN 0 AND 100)
	,MinPercent INT UNIQUE CHECK (MinPercent BETWEEN 0 AND 100)
	,CONSTRAINT Grade_PK PRIMARY KEY (ResultGrade)
	,CONSTRAINT Grade_Check1 CHECK (MaxPercent > MinPercent)
);					  
					  
--Enrollment Entity
CREATE TABLE Enrollment (
	StudentID CHAR(6) NOT NULL
	,ClassID INT NOT NULL
	,ResultGrade CHAR(2)
	,CONSTRAINT Enrollment_PK PRIMARY KEY (StudentID,ClassID)
	,CONSTRAINT Enrollment_FK FOREIGN KEY (StudentID) REFERENCES Student(NetID)
	,CONSTRAINT Enrollment_FK1 FOREIGN KEY (ClassID) REFERENCES ClassList(ClassID)
	,CONSTRAINT Enrollment_FK2 FOREIGN KEY (ResultGrade) REFERENCES Grade(ResultGrade)	
);

