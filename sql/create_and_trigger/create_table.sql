	create database DatabaseLabPRJ;
	use DatabaseLabPRJ;

CREATE TABLE Dorm (
    Dorm_ID CHAR(8) NOT NULL UNIQUE PRIMARY KEY,
    Dorm_Name VARCHAR(10) ,
    Number_Of_Rooms INT ,
    Number_Of_Floors INT CHECK (Number_Of_Floors > 0)
);


INSERT INTO Dorm (Dorm_ID, Dorm_Name, Number_Of_Rooms, Number_Of_Floors) VALUES
('DORM0001', 'Dorm A', 200, 9),
('DORM0002', 'Dorm B', 200, 9),
('DORM0003', 'Dorm C', 200, 9),
('DORM0004', 'Dorm D', 200, 9);

select * from Dorm

	CREATE TABLE Room (
		Room_ID CHAR(8) NOT NULL UNIQUE PRIMARY KEY,
		Room_Type VARCHAR(10),
		Number_Of_Bed INT,
		Current_Occupancy INT,
		Rent_Price DECIMAL(10, 2),
		Dorm_ID CHAR(8) NOT NULL ,
		FOREIGN KEY (Dorm_ID) REFERENCES Dorm(Dorm_ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	);

	CREATE TABLE Student (
		Student_ID CHAR(8) NOT NULL UNIQUE PRIMARY KEY,
		Student_First_Name VARCHAR(30) NOT NULL,
		Student_Last_Name VARCHAR(10) NOT NULL,
		Student_Birthday DATE NOT NULL,
		Student_Gender CHAR(1) NOT NULL,
		Student_Email VARCHAR(50) NOT NULL,
		Student_Phone_Number VARCHAR(20) NOT NULL,
		Student_Address VARCHAR(255) ,
		Major VARCHAR(50) NOT NULL 
	);

	CREATE TABLE Staff (
		Staff_ID VARCHAR(8) NOT NULL UNIQUE PRIMARY KEY,
		Staff_First_Name VARCHAR(30) NOT NULL,
		Staff_Last_Name VARCHAR(10) NOT NULL,
		Staff_Gender CHAR(1) NOT NULL,
		Staff_Position VARCHAR(50) NOT NULL ,
		Staff_Phone_Number CHAR(10) NOT NULL,
		Staff_Address VARCHAR(100),
		Salary DECIMAL(10, 2)
	);

	CREATE TABLE Equipment (
		Equipment_ID CHAR(8) NOT NULL UNIQUE PRIMARY KEY,
		Equipment_Name VARCHAR(50) NOT NULL,
		Equipment_Quantity INT CHECK (Equipment_Quantity >0),
		Equipment_Status VARCHAR(255) -- dang co bao nhieu cai bi hong-- 
	);

	-- Tạo bảng Dịch Vụ (Service)
	CREATE TABLE Service (
		Service_ID CHAR(8) NOT NULL UNIQUE PRIMARY KEY,
		Provider_ID CHAR(8) NOT NULL,
		Service_Name VARCHAR(20)  NOT NULL,
		Service_Price DECIMAL(10, 2),
		Service_Description TEXT,
		fOREIGN KEY (Provider_ID) references Provider(Provider_ID)
		   ON DELETE CASCADE
		ON UPDATE CASCADE
	);

	-- Tạo bảng Hồ sơ kỷ luật (Discipline)
	CREATE TABLE Discipline (
		Discipline_ID CHAR(8) NOT NULL PRIMARY KEY,
		Student_ID CHAR(8) NOT NULL,
		Violation_Date DATE DEFAULT (GETDATE()),
		Violation_Information TEXT,
		Penalty TEXT,
		FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	);

	-- Tạo bảng Sự cố (Incident)
	CREATE TABLE Incident (
		Incident_ID CHAR(8) NOT NULL PRIMARY KEY,
		Incident_Status VARCHAR(20) DEFAULT 'fixing',
		Room_ID CHAR(8) NOT NULL,
		Report_Date DATE DEFAULT (GETDATE()),
		Incident_Description TEXT,
		FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	);

	-- Tạo bảng thuê phòng (Renting)
	CREATE TABLE Renting (
		Renting_Contract_ID CHAR(8) NOT NULL UNIQUE PRIMARY KEY,
		Room_ID CHAR(8) NOT NULL,
		Student_ID CHAR(8) NOT NULL,
		Renting_Payment_Date DATE DEFAULT (GETDATE()) ,
		Renting_Start_Date DATE DEFAULT (GETDATE()),
		Renting_End_Date DATE DEFAULT (GETDATE()),
		Renting_Status VARCHAR(50) DEFAULT 'not paid', 
		FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID),
		FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	);

	CREATE TABLE Provider (
		Provider_ID CHAR(8) NOT NULL UNIQUE PRIMARY KEY,
		Provider_Name VARCHAR(50),
		Provider_Address VARCHAR(100),
		Provider_Phone_Number VARCHAR(20),
		Provider_Email VARCHAR(30)
	);

	-- Tạo bảng đăng ký dịch vụ (Service_Registration)
	CREATE TABLE Service_Registration (
		Service_ID CHAR(8) NOT NULL ,
		Student_ID CHAR(8) NOT NULL,
		Service_Start_Date DATE DEFAULT (GETDATE()),
		Service_End_Date DATE DEFAULT (GETDATE()),
		Service_Payment_Date DATE DEFAULT (GETDATE()),
		Service_Total_Amount DECIMAL(10, 2),
		Service_Status VARCHAR(50),
		PRIMARY KEY (Service_ID, Student_ID),
		FOREIGN KEY (Service_ID) REFERENCES Service(Service_ID),
		FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID)
	);

	-- Tạo bảng sử dụng thiết bị (Equipment_Usage)
	CREATE TABLE Equipment_Usage (
		Room_ID CHAR(8) NOT NULL,
		Equipment_ID CHAR(8) NOT NULL,
		Equipment_Start_Date DATE DEFAULT (GETDATE()),
		Equipment_End_Date DATE DEFAULT (GETDATE()),
		Using_Quantity INT CHECK (Using_Quantity >0),
		PRIMARY KEY (Room_ID, Equipment_ID),
		FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID),
		FOREIGN KEY (Equipment_ID) REFERENCES Equipment(Equipment_ID)
	);

	-- Tạo bảng làm việc (Working)
	CREATE TABLE Working (
		Staff_ID CHAR(8) NOT NULL,
		Dorm_ID CHAR(8) NOT NULL,
		PRIMARY KEY (Staff_ID, Dorm_ID),
		FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID),
		FOREIGN KEY (Dorm_ID) REFERENCES Dorm(Dorm_ID)
	);
	DROP TABLE IF EXISTS Equipment_Usage;
	DROP TABLE IF EXISTS Service_Registration;
	DROP TABLE IF EXISTS Supply;
	DROP TABLE IF EXISTS Renting;
	DROP TABLE IF EXISTS Incident;
	DROP TABLE IF EXISTS Discipline;
	DROP TABLE IF EXISTS Provider;
	DROP TABLE IF EXISTS Service;
	DROP TABLE IF EXISTS Equipment;
	DROP TABLE IF EXISTS Staff;
	DROP TABLE IF EXISTS Student;
	DROP TABLE IF EXISTS Room;
	DROP TABLE IF EXISTS Dorm;
    