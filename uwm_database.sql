CREATE DATABASE IF NOT EXISTS uwm;
USE uwm;

-- STEP 1: DEPARTMENTS

CREATE TABLE IF NOT EXISTS Departments (
    DepartmentID INT NOT NULL AUTO_INCREMENT,
    DepartmentName VARCHAR(100),
    DepartmentCode VARCHAR(10),
    PRIMARY KEY (DepartmentID)
);

INSERT INTO Departments
(DepartmentID, DepartmentName, DepartmentCode)
VALUES
(1, 'Information Studies', 'INFOST'),
(2, 'Computer Science', 'COMPSCI'),
(3, 'Mathematical Sciences', 'MATH')
ON DUPLICATE KEY UPDATE
DepartmentName = VALUES(DepartmentName),
DepartmentCode = VALUES(DepartmentCode);


-- STEP 2: COURSES

CREATE TABLE IF NOT EXISTS Courses (
    CourseID INT NOT NULL AUTO_INCREMENT,
    CourseNumber VARCHAR(20),
    CourseTitle VARCHAR(150),
    Credits INT,
    DepartmentID INT NOT NULL,
    PRIMARY KEY (CourseID),
    FOREIGN KEY (DepartmentID)
        REFERENCES Departments(DepartmentID)
);

INSERT INTO Courses
(CourseID, CourseNumber, CourseTitle, Credits, DepartmentID)
VALUES
(1, 'INFOST 110', 'Introduction to Information Science and Technology', 3, 1),
(2, 'INFOST 120', 'Information Technology Ethics', 3, 1),
(3, 'INFOST 240', 'Web Design I', 3, 1),
(4, 'INFOST 270', 'Generative AI Literacy', 3, 1),
(5, 'INFOST 410', 'Database Information Retrieval Systems', 3, 1),
(6, 'COMPSCI 250', 'Introductory Computer Programming', 3, 2),
(7, 'MATH 231', 'Calculus and Analytic Geometry I', 4, 3)
ON DUPLICATE KEY UPDATE
CourseNumber = VALUES(CourseNumber),
CourseTitle = VALUES(CourseTitle),
Credits = VALUES(Credits),
DepartmentID = VALUES(DepartmentID);


-- STEP 3: TERMS

CREATE TABLE IF NOT EXISTS Terms (
    TermID INT NOT NULL AUTO_INCREMENT,
    TermName VARCHAR(20),
    PRIMARY KEY (TermID)
);

INSERT INTO Terms (TermID, TermName)
VALUES
(1, 'Spring 2026'),
(2, 'Fall 2026')
ON DUPLICATE KEY UPDATE
TermName = VALUES(TermName);


-- STEP 4: MAJORS

CREATE TABLE IF NOT EXISTS Majors (
    MajorID INT NOT NULL AUTO_INCREMENT,
    MajorName VARCHAR(100),
    DepartmentID INT NOT NULL,
    PRIMARY KEY (MajorID),
    FOREIGN KEY (DepartmentID)
        REFERENCES Departments(DepartmentID)
);

INSERT INTO Majors
(MajorID, MajorName, DepartmentID)
VALUES
(1, 'Information Science and Technology', 1),
(2, 'Computer Science', 2),
(3, 'Mathematics', 3),
(4, 'Actuarial Science', 3)
ON DUPLICATE KEY UPDATE
MajorName = VALUES(MajorName),
DepartmentID = VALUES(DepartmentID);


-- STEP 5: INSTRUCTORS

CREATE TABLE IF NOT EXISTS Instructors (
    InstructorID INT NOT NULL AUTO_INCREMENT,
    FirstName VARCHAR(45),
    LastName VARCHAR(45),
    DepartmentID INT NOT NULL,
    PRIMARY KEY (InstructorID),
    FOREIGN KEY (DepartmentID)
        REFERENCES Departments(DepartmentID)
);

INSERT INTO Instructors
(InstructorID, FirstName, LastName, DepartmentID)
VALUES
(1, 'Edgar', 'Codd', 1),
(2, 'Grace', 'Hopper', 2),
(3, 'Emmy', 'Noether', 3),
(4, 'Alan', 'Turing', 2)
ON DUPLICATE KEY UPDATE
FirstName = VALUES(FirstName),
LastName = VALUES(LastName),
DepartmentID = VALUES(DepartmentID);


-- STEP 6: STUDENTS

CREATE TABLE IF NOT EXISTS Students (
    StudentID INT NOT NULL AUTO_INCREMENT,
    FirstName VARCHAR(45),
    LastName VARCHAR(45),
    MajorID INT NOT NULL,
    PRIMARY KEY (StudentID),
    FOREIGN KEY (MajorID)
        REFERENCES Majors(MajorID)
);

INSERT INTO Students
(StudentID, FirstName, LastName, MajorID)
VALUES
(1, 'Jay', 'Rivera', 1),
(2, 'Max', 'Nguyen', 1),
(3, 'Miranda', 'Okafor', 2),
(4, 'Bill', 'Kowalski', 3),
(5, 'Ana', 'Lopez', 4),
(6, 'Lee', 'Park', 1)
ON DUPLICATE KEY UPDATE
FirstName = VALUES(FirstName),
LastName = VALUES(LastName),
MajorID = VALUES(MajorID);


-- STEP 7: SECTIONS

CREATE TABLE IF NOT EXISTS Sections (
    SectionID INT NOT NULL AUTO_INCREMENT,
    SectionNumber VARCHAR(10),
    CourseID INT NOT NULL,
    TermID INT NOT NULL,
    InstructorID INT NOT NULL,
    PRIMARY KEY (SectionID),
    FOREIGN KEY (CourseID)
        REFERENCES Courses(CourseID),
    FOREIGN KEY (TermID)
        REFERENCES Terms(TermID),
    FOREIGN KEY (InstructorID)
        REFERENCES Instructors(InstructorID)
);

INSERT INTO Sections
(SectionID, SectionNumber, CourseID, TermID, InstructorID)
VALUES
(1, '202', 5, 1, 1),
(2, '201', 6, 1, 4),
(3, '401', 7, 1, 3),
(4, '202', 5, 2, 1),
(5, '201', 3, 2, 1),
(6, '201', 6, 2, 2),
(7, '401', 7, 2, 3)
ON DUPLICATE KEY UPDATE
SectionNumber = VALUES(SectionNumber),
CourseID = VALUES(CourseID),
TermID = VALUES(TermID),
InstructorID = VALUES(InstructorID);


-- STEP 8: ENROLLMENTS

CREATE TABLE IF NOT EXISTS Enrollments (
    EnrollmentID INT NOT NULL AUTO_INCREMENT,
    StudentID INT NOT NULL,
    SectionID INT NOT NULL,
    Grade VARCHAR(2),
    PRIMARY KEY (EnrollmentID),
    FOREIGN KEY (StudentID)
        REFERENCES Students(StudentID),
    FOREIGN KEY (SectionID)
        REFERENCES Sections(SectionID)
);

INSERT INTO Enrollments
(EnrollmentID, StudentID, SectionID, Grade)
VALUES
(1, 1, 1, 'A'),
(2, 2, 1, 'B'),
(3, 3, 2, 'A'),
(4, 4, 3, 'B'),
(5, 1, 3, 'C'),
(6, 1, 4, NULL),
(7, 2, 4, NULL),
(8, 6, 4, NULL),
(9, 5, 7, NULL),
(10, 3, 6, NULL),
(11, 4, 7, NULL),
(12, 2, 5, NULL),
(13, 6, 5, NULL)
ON DUPLICATE KEY UPDATE
StudentID = VALUES(StudentID),
SectionID = VALUES(SectionID),
Grade = VALUES(Grade);


-- STEP 9: CREATE CLASSLISTS VIEW

CREATE OR REPLACE VIEW ClassLists AS

SELECT
    Enrollments.EnrollmentID,
    Terms.TermName,
    Courses.CourseNumber,
    Sections.SectionNumber,
    Students.StudentID,
    Students.FirstName,
    Students.LastName,
    Enrollments.Grade

FROM Enrollments

JOIN Students
ON Enrollments.StudentID = Students.StudentID

JOIN Sections
ON Enrollments.SectionID = Sections.SectionID

JOIN Courses
ON Sections.CourseID = Courses.CourseID

JOIN Terms
ON Sections.TermID = Terms.TermID;


-- STEP 10: VERIFY THE DATABASE

SHOW TABLES;

SELECT * FROM Departments;
SELECT * FROM Courses;
SELECT * FROM Terms;
SELECT * FROM Majors;
SELECT * FROM Instructors;
SELECT * FROM Students;
SELECT * FROM Sections;
SELECT * FROM Enrollments;


-- CHECK INFOST 410 STUDENTS

SELECT *
FROM ClassLists
WHERE CourseNumber = 'INFOST 410'
AND SectionNumber = '202'
AND TermName = 'Fall 2026';


-- CHECK MATH 231 STUDENTS

SELECT *
FROM ClassLists
WHERE CourseNumber = 'MATH 231'
AND TermName = 'Fall 2026';


-- CHECK CREDITS PER INSTRUCTOR

SELECT
    Instructors.InstructorID,
    Instructors.LastName,
    SUM(Courses.Credits) AS TotalCredits

FROM Sections

JOIN Instructors
ON Sections.InstructorID = Instructors.InstructorID

JOIN Courses
ON Sections.CourseID = Courses.CourseID

JOIN Terms
ON Sections.TermID = Terms.TermID

WHERE Terms.TermName = 'Fall 2026'

GROUP BY
    Instructors.InstructorID,
    Instructors.LastName

ORDER BY TotalCredits DESC;
