CREATE TABLE 'Employee' (
    'ID' INT,
    name VARCHAR(120),
    level SMALLINT NOT NULL,
    gender VARCHAR(1) NOT NULL CHECK ( gender = 'male' OR gender = 'female' ),
    age SMALLINT NOT NULL CHECK ( age > 0 ),
    edu VARCHAR(120) NOT NULL,
    rewardDate DATE,
    FOREIGN KEY(salary) REFERENCES 'Salary'('ID'),
    FOREIGN KEY(position) REFERENCES 'Position'('ID'),
    FOREIGN KEY(department) REFERENCES 'Department'('ID'),
    PRIMARY KEY('ID', name,salary,
    rewardDate,
    salary,
    position,
    department),
);

CREATE TABLE IF NOT EXISTS 'Course' (
    'ID' INT,
    name VARCHAR(120),
    books VARCHAR(120),
    'timeSlot' SMALLINT,
    score INT NOT NULL CHECK ( score >= 0 ),
    FOREIGN KEY(employee) REFERENCES 'Employee'('ID'),
    PRIMARY KEY('ID', name, employee),
);

CREATE TABLE IF NOT EXISTS 'Skill' (
    'ID' INT,
    name VARCHAR(120),
    level SMALLINT,
    PRIMARY KEY('ID', name)
);

CREATE TABLE IF NOT EXISTS 'Position' (
    'ID' INT,
    name VARCHAR(120),
    FOREIGN KEY(employee) REFERENCES 'Employee'('ID'),
    PRIMARY KEY('ID', name, employee),
);

CREATE TABLE IF NOT EXISTS 'Salary' (
    'ID' INT,
    basic REAL NOT NULL CHECK ( basic >= .0 ),
    level SMALLINT NOT NULL CHECK ( level >= 0 ),
    'Pensions' REAL NOT NULL CHECK ( 'Pensions' >= .0 ),
    'UnemploymentBenefit' REAL NOT NULL CHECK ( 'UnemploymentBenefit' >= .0 ),
    'CPF' REAL NOT NULL CHECK ( 'CPF' >= .0 ),
    tax REAL NOT NULL CHECK ( tax >= .0 ),
    FOREIGN KEY(employee) REFERENCES 'Employee'('ID'),
    PRIMARY KEY('ID', employee),
);

CREATE TABLE IF NOT EXISTS 'Reward' (
    'ID' INT,
    flag SMALLINT NOT NULL CHECK ( flat == 0 OR flag == 1 ),
    FOREIGN KEY(employee) REFERENCES 'Employee'('ID'),
    project VARCHAR(120) NOT NULL,
    amount REAL NOT NULL CHECK ( amount >= .0 ),
    PRIMARY KEY('ID', flag, employee)
);

CREATE TABLE IF NOT EXISTS 'Department' (
    'ID' INT,
    name VARCHAR(120),
    'Functions' VARCHAR(120) NOT NULL,
    FOREIGN KEY(position) REFERENCES 'Position'('ID'),
    PRIMARY KEY('ID', name, position),
);

INSERT INTO 'Employee' (
    name,level,gender,age,edu,
    salary,position,department
) VALUES (
    '??????', 0, 'male', 25, '??????????????????',
    0,
    (SELECT 'ID' FROM 'Position' WHERE name = '??????????????????'),
    (SELECT 'ID' FROM 'Department' WHERE name = '???????????????')
)

INSERT INTO 'Employee' (
    name,level,gender,age,edu,
    salary,position,department
) VALUES (
    '??????', 1, 'female', 23, '??????????????????',
    0,
    (SELECT 'ID' FROM 'Position' WHERE name = '??????????????????'),
    (SELECT 'ID' FROM 'Department' WHERE name = '????????????')
)

INSERT INTO 'Course' (
    name, level, books, 'timeSlot', employee, score
) VALUES (
    '?????????????????????', 3, '?????????', 120, 0, 60
)

INSERT INTO 'Course' (
    name, level, books, 'timeSlot', employee
) VALUES (
    '???????????????', 2, '????????????', 120, 0, 60
)

INSERT INTO 'Skill' (
    name, level
) VALUES (
    '??????????????????', 0
)

INSERT INTO 'Skill' (
    name, level
) VALUES (
    '???????????????', 0
)

INSERT INTO 'Skill' (
    name, level
) VALUES (
    '????????????', 0
)

INSERT INTO 'Course' VALUES (
    '??????????????????', '??????????????????', 0, 85,
    (SELECT 'ID' FROM 'Employee' WHERE name = '??????')
)

INSERT INTO 'Skill' VALUES (
    'Office??????', 1, (SELECT 'ID' FROM 'Employee' WHERE name = '??????')
)

DELETE FROM 'Salary' WHERE employee = (SELECT 'ID' FROM 'Employee' WHERE name = '??????')
DELETE FROM 'Course' WHERE employee = (SELECT 'ID' FROM 'Employee' WHERE name = '??????')
DELETE FROM 'Position' WHERE employee = (SELECT 'ID' FROM 'Employee' WHERE name = '??????')
DELETE FROM 'Skill' WHERE employee = (SELECT 'ID' FROM 'Employee' WHERE name = '??????')
DELETE FROM 'Employee' WHERE name = '??????'

UPDATE 'Course'
SET score = score + 5
WHERE name = '??????????????????' AND 'employee' IN
(
    SELECT 'employee'
    FROM 'Position'
    WHERE name = '?????????'
)

SELECT 'Employee'.'ID', name, 'Position'
FROM 'Employee' as E, 'Position' as P, 'Skill' as S
WHERE E.'ID' == P.employee AND NOT E.'ID' IN  S

CREATE PROCEDURE find(IN name INT, IN class INT, OUT score REAL)
AS
BEGIN
    SELECT score
    FROM 'Employee' as E, 'Course' as C
    WHERE E.name = name AND C.employee = E.'ID' AND C.name = class
END
GO

CALL find('??????', '??????????????????')

CREATE PROCEDURE insert(IN name,IN level,IN gender,IN age,IN edu,IN salary,IN position,IN department)
AS
BEGIN
INSERT INTO 'Employee' (
    name,level,gender,age,edu,
    salary,position,department
) VALUES (
    name,level,gender,age,edu,
    salary,position,department
)
END
GO

CALL insert(
               '??????', 1, 'female', 23, '??????????????????',
               0,
               (SELECT 'ID' FROM 'Position' WHERE name = '??????????????????'),
               (SELECT 'ID' FROM 'Department' WHERE name = '????????????')
           )

CREATE PROCEDURE basic(IN name VARCHAR(120) = '*')
AS
BEGIN
SELECT *
FROM 'Employee' as E
WHERE E.name = name
END
GO

CREATE PROCEDURE count(IN name VARCHAR(120))
AS
BEGIN
SELECT COUNT(*)
FROM 'Employee' as E, 'Course' as C
WHERE E.'ID' = C.employee AND C.name = name
END
GO

CREATE PROCEDURE info(IN id INT, out info)
AS
BEGIN
SELECT * as info
FROM 'Course' as C
WHERE C.'ID' = id
END
GO

ALTER TRIGGER show ON
'Employee'
UPDATE
AS
SELECT * FROM 'Employee'
GO

ALTER TRIGGER check ON 'Reward' UPDATE AS
IF ((SELECT COUNT(*) FROM 'Employee' WHERE 'Employee'.'ID' = 'Reward'.employee) != 0)

END;
GO
