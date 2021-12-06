CREATE TABLE IF NOT EXIST "Student" (
    "Sno"             CHAR(8)     PRIMARY KEY NOT NULL,
    "Sname"           VARCHAR(10) NOT NULL,
    "Sex"             CHAR(2)     DEFAULT '男' CHECK ("Sex" = '男' OR "Sex" = '女'),
    "Age"             SMALLINT    DEFAULT  20  CHECK ("Age" <= 30 AND "Age" >= 15),  
    "PhoneNumber"     CHAR(12)    UNIQUE,
    "Sdept"           VARCHAR(20) NOT NULL
);


CREATE TABLE IF NOT EXIST "Course" (
    "Cno"         CHAR(10)      PRIMARY KEY                                     NOT NULL,
    "Cname"       VARCHAR(20)   UNIQUE                                          NOT NULL,
    "TotalPerior" SMALLINT      DEFAULT 64 CHECK("TotalPerior" <= 108 AND "TotalPerior" >= 32),
    "WeekPerior"  SMALLINT      DEFAULT 4  CHECK("WeekPerior" <= 7 AND "WeekPerior" >= 2),
    "credit"      SMALLINT      DEFAULT 4  CHECK(credit <= 7 AND credit >= 1)   NOT NULL,
    "Pcno"        CHAR(10) 
);

CREATE TABLE IF NOT EXIST "SC" (
    "Sno"     CHAR(10) REFERENCES "Student"("Sno"),
    "Cno"     CHAR(10) REFERENCES "Course"("Cno"),
    PRIMARY KEY("Sno", "Cno"),
    "Grade"   SMALLSERIAL CHECK("Grade" <= 100 AND "Grade" >= 0)
);

CREATE TABLE IF NOT EXIST "Customers" (
    "CustomerID" INT            PRIMARY KEY,
    "CName"      VARCHAR(8)     NOT NULL,
    "Address"    VARCHAR(50),
    "City"       VARCHAR(10),
    "Tel"        VARCHAR(20)    UNIQUE,
    "Company"    VARCHAR(20),
    "Birthday"   DATE,
    "Type"       SMALLINT DEFAULT 1,
);

CREATE TABLE IF NOT EXIST "Goods" (
     "GoodsID"      INT  CONSTRAINT  C1 PRIMARY  KEY ,
     "GoodsName"    VARCHAR(20)  NOT  NULL,
     "Price"        MONEY,
     "Description"  VARCHAR(200),
     "Storage"      INT,
     "Provider"     VARCHAR(50),
     "Status"       SMALLINT DEFAULT 1,
);

CREATE TABLE IF NOT EXIST "Orders" (
    "OrderID"    INT            PRIMARY KEY,
    "GoodsID"    INT            NOT NULL REFERENCES "Goods"("GoodsID") ON DELETE CASCADE,
    "CustomerID" INT            NOT NULL FOREIGN KEY("CustomerID") REFERENCES "Customers"("CustomerID") ON UPDATE CASCADE ON DELETE CASCADE,
    "Quantity"   INT            NOT NULL CHECK("Quantity" > 0),
    "OrderSum"   MONEY          NOT NULL,
    "OrderDate"  DATE           DEFAULT today,
);

CREATE TABLE IF NOT EXIST "Book" (
    "BookName"     VARCHAR(120)     PRIMARY KEY,
    "BookID"       INT              PRIMARY KEY,
    "Kind"         INT              NOT NULL DEFAULT 1,
    "Press"        VARCHAR(120)     NOT NULL,
    "Author"       VARCHAR(120)     NOT NULL,
    "Price"        MONEY            NOT NULL,
    "Date"         DATE             NOT NULL,
);

CREATE TABLE IF NOT EXIST "Reader" (
    "ID"           VARCHAR(120) PRIMARY KEY,
    "Name"         VARCHAR(120) PRIMARY KEY,
    "Inc"          VARCHAR(120),
    "Sex"          ENUM ("Male", "Female") NOT NULL,
    "Address"      VARCHAR(240)     NOT NULL,
    "Tel"          VARCHAR(13)      NOT NULL,
);

CREATE TABLE IF NOT EXIST "Borrow" (
    "BookID"        INT REFERENCES "Book"("BookID") PRIMARY KEY,
    "ID"            VARCHAR(120) REFERENCES "Reader"("ID") PRIMARY KEY,
    "Date"          DATE DEFAULT today NOT NULL,
);

