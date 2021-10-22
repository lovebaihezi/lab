CREATE TABLE "Student" (
    "Sno"             CHAR(8)     PRIMARY KEY NOT NULL,
    "Sname"           VARCHAR(10) NOT NULL,
    "Sex"             CHAR(2)     DEFAULT '男' CHECK ("Sex" = '男' OR "Sex" = '女'),
    "Age"             SMALLINT    DEFAULT  20  CHECK ("Age" <= 30 AND "Age" >= 15),  
    "PhoneNumber"     CHAR(12)    UNIQUE,
    "Sdept"           VARCHAR(20) NOT NULL
);


CREATE TABLE "Course" (
    "Cno"         CHAR(10)      PRIMARY KEY                                     NOT NULL,
    "Cname"       VARCHAR(20)   UNIQUE                                          NOT NULL,
    "TotalPerior" SMALLINT      DEFAULT 64 CHECK("TotalPerior" <= 108 AND "TotalPerior" >= 32),
    "WeekPerior"  SMALLINT      DEFAULT 4  CHECK("WeekPerior" <= 7 AND "WeekPerior" >= 2),
    "credit"      SMALLINT      DEFAULT 4  CHECK(credit <= 7 AND credit >= 1)   NOT NULL,
    "Pcno"        CHAR(10) 
);

CREATE TABLE "SC" (
    "Sno"     CHAR(10) REFERENCES "Student"("Sno"),
    "Cno"     CHAR(10) REFERENCES "Course"("Cno"),
    PRIMARY KEY("Sno", "Cno"),
    "Grade"   SMALLSERIAL CHECK("Grade" <= 100 AND "Grade" >= 0)
);

