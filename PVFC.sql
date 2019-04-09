
-- two short line is for comment
-- SQL IS NOT CASE-SENSITIVE FOR SOME STATEMENT BUT NOT FOR VALUES
-- EACH TIME TO EXECUTE THAT IT WILL EXECUTE ALL STATEMENT. SO IF WANT TO 
	-- EXECUTE PARTICULAR STATEMENT, CAN JUST HIGHLIGHT IT AND CLICK EXECUTE

--Create dtabse PVFC


CREATE database PVFC;

USE PVFC;

CREATE table PRODUCT_T(
ProductID integer not null,
ProductDescription varchar(50),
ProductFinish varchar(20)
CHECK (ProductFinish in ('CHERRY','NATURAL ASH','WHITE ASH',
'RED OAK','NATURAL OAK','WALNUT')), --THIS CHECK FUNCTION IS TO CHECK THE VALUE OF ProductFinish IN THE FOLLOWING LIST
ProudctStandardPrice decimal (6,2),
ProductLineID integer,
CONSTRAINT Product_PK primary key (PRODUCTID) -- THIS IS HOW TO GIVE COLUMN AS PK
);

CREATE table CUSTOMER_T(
CustomerID integer not null,
CustomerName varchar(25) not null,
CustomerAddress varchar(30),
CustomerCity varchar(20),
CustomerState varchar(2),
CustomerPostcode varchar(9),
CONSTRAINT Cusomer_PK primary key (CustomerID)
);


--Create Oder Table
CREATE table ORDER_T(
OrderID integer not null,
OrderDate date,
CustomerID integer,
CONSTRAINT Order_PK primary key (OrderID),
CONSTRAINT Order_FK foreign key (CustomerID) 
references CUSTOMER_T(CustomerID) 
);

CREATE table ORDERLINE_T(
OrderID integer not null,
ProductID integer not null,
OderedQuantity integer,
CONSTRAINT OrderLine_PK primary key (OrderID, ProductID),
CONSTRAINT OrderLine_FK1 foreign key (OrderID) references ORDER_T(OrderID),
CONSTRAINT OrderLine_FK2 foreign key (ProductID) references PRODUCT_T(ProductID)
);


-- DIFFERENCE BETWEEN DROP AND DELET, DROP IS TO DROP ALL TABLE DELET IS JUST DELET A VALUE FROM TABLE

-- ALTER IS TO CHANGE THE ATTRIBUTE NAME AND THE UPDATE IS CHANGE THE VALUE (IF WANT TO CHANGE PARTICULAR ROW)

-- INSERT VALUE TO CUSTOMER_T
INSERT INTO CUSTOMER_T VALUES
(1,'Contemporary Casuals','1355 S Hines Blvd','Gainesville','FL','326012871'),
(2,'Value Furniture','15145 S.W. 17th St.','Plano','TX','750947743'),
(3,'Home Furnishings','1900 Allard Ave.','Albany','NY','122091125'),
(4,'Eastern Furniture','1925 Beltline Rd.','Carteret','NJ','070083188'),
(5,'Impressions','5585 Westcott Ct.','Sacramento','CA','942064056'),
(6,'Furniture Gallery','325 Flatiron Dr.','Boulder','CO','805144432'),
(7,'Period Furniture','394 Rainbow Dr.','Seattle','WA','979545589'),
(8,'Calfornia Classics','816 Peach Rd.','Santa Clara','CA','969157754'),
(9,'M and H Casual Furniture','3709 First Street','Clearwater','FL','346202314'),
(10,'Seminole Interiors','2400 Rocky Point Dr.','Seminole','FL','346464423'),
(11,'American Euro Lifestyles','2424 Missouri Ave N.','Prospect Park','NJ','075085621'),
(12,'Battle Creek Furniture','345 Capitol Ave. SW','Battle Creek','MI','490153401'),
(13,'Heritage Furnishings','66789 College Ave.','Carlisle','PA','170138834'),
(14,'Kaneohe Homes','112 Kiowai St.','Kaneohe','HI','967442537'),
(15,'Mountain Scenes','4132 Main Street','Ogden','UT','844034432');

insert into PRODUCT_T values
(1,'End Table','Cherry',$175.00,1),
(2,'Coffe Table','Natural Ash',$200.00,2),
(3,'Computer Desk','Natural Ash',$375.00,2),
(4,'Entertainment Center','Natural Oak',$650.00,3),
(5,'Writers Desk','Cherry',$325.00,1),
(6,'8-Drawer Desk','White Ash',$750.00,2),
(7,'Dining Table','Natural Ash',$800.00,2),
(8,'Computer Desk','Walnut',$250.00,3);

insert into ORDER_T values
(1001,'10-21-2008',1),
(1002,'10-21-2008',8),
(1003,'10-22-2008',15),
(1004,'10-22-2008',5),
(1005,'10-24-2008',3),
(1006,'10-24-2008',2),
(1007,'10-27-2008',11),
(1008,'10-30-2008',12),
(1009,'11-5-2008',4),
(1010,'11-5-2008',1);

insert into ORDERLINE_T values
(1001,1,2),
(1001,2,2),
(1001,4,1),
(1002,3,5),
(1003,3,3),
(1004,6,2),
(1004,8,2),
(1005,4,4),
(1006,4,1),
(1006,5,2),
(1006,7,2),
(1007,1,3),
(1007,2,2),
(1008,3,3),
(1008,8,3),
(1009,4,2),
(1009,7,3),
(1010,8,10);

--Insert multiple rows of data from another table
--Step 1. Create CACustmer table with same schema as Customer table.
create table CACUSTOMER_T
(CustomerID integer not null,
CustomerName varchar(25) not null,
CustomerAddress varchar(30),
CustomerCity varchar(20),
CustomerState char(2),
CustomerPostalCode varchar(9),
constraint CACustomer_PK primary key (CustomerID));

--Step 2. Insert customer data who are residing in CA in CACustmer from Customer table
INSERT INTO CACUSTOMER_T 
SELECT * FROM CUSTOMER_T
WHERE CustomerState='CA';

SELECT * FROM CACUSTOMER_T

--Use UPDATE to alter values of a field
UPDATE PRODUCT_T
SET ProudctStandardPrice=ProudctStandardPrice*1.1
WHERE ProductID=8;

SELECT ProudctStandardPrice from PRODUCT_T
WHERE ProductID=8;

--Use comparison operators =, <, >, <=, >=, <>, !=