-- Tính tổng thu nhập từ tiền thuê phòng của một ký túc xá
DELIMITER $$

CREATE FUNCTION TotalRentIncome (Dorm_ID CHAR(8))
RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE total_income DECIMAL(10, 2);

    SELECT SUM(rm.Rent_Price * r.Current_Occupancy) INTO total_income
    FROM Room rm
    JOIN Renting r ON rm.Room_ID = r.Room_ID
    WHERE rm.Dorm_ID = Dorm_ID;

    RETURN total_income;
END $$

DELIMITER ;

SELECT TotalRentIncome('DORM0001');

-- Tính trung bình giá thuê phòng của một ký túc xá
DELIMITER $$

CREATE FUNCTION AverageRentPrice (Dorm_ID CHAR(8))
RETURNS DECIMAL(5, 2)
BEGIN
    DECLARE avg_rent_price DECIMAL(5, 2);

    SELECT AVG(rm.Rent_Price) INTO avg_rent_price
    FROM Room rm
    WHERE rm.Dorm_ID = Dorm_ID;

    RETURN avg_rent_price;
END $$

DELIMITER ;

SELECT AverageRentPrice('DORM0001');

-- Tạo báo cáo tổng thu nhập dịch vụ cho một nhà cung cấp
DELIMITER $$

CREATE PROCEDURE ServiceIncomeReport (Provider_ID CHAR(8))
BEGIN
    SELECT 
        s.Service_Name,
        SUM(sr.Service_total) AS Total_Income
    FROM 
        Service s
    JOIN 
        Service_Registration sr ON s.Service_ID = sr.Service_ID
    WHERE 
        s.Provider_ID = Provider_ID
    GROUP BY 
        s.Service_Name;
END $$

DELIMITER ;

CALL ServiceIncomeReport('PROV001');

-- Tính tổng số phòng trong một ký túc xá
DELIMITER $$

CREATE FUNCTION TotalRoomsInDorm (Dorm_ID CHAR(8))
RETURNS INT
BEGIN
    DECLARE total_rooms INT;

    SELECT COUNT(*)
    INTO total_rooms
    FROM Room
    WHERE Dorm_ID = Dorm_ID;

    RETURN total_rooms;
END $$

DELIMITER ;

SELECT TotalRoomsInDorm('DORM0001');

-- Báo cáo tổng số sinh viên trong một ký túc xá
DELIMITER $$

CREATE PROCEDURE StudentCountReport (Dorm_ID CHAR(8))
BEGIN
    SELECT 
        COUNT(s.Student_ID) AS Total_Students
    FROM 
        Student s
    JOIN 
        Room r ON s.Room_ID = r.Room_ID
    WHERE 
        r.Dorm_ID = Dorm_ID;
END $$

DELIMITER ;

CALL StudentCountReport('DORM0001');

-- Tạo báo cáo sự cố theo ký túc xá
DELIMITER $$

CREATE PROCEDURE DormIncidentReport (Dorm_ID CHAR(8))
BEGIN
    SELECT 
        i.Incident_ID,
        i.Incident_Status,
        i.Report_Date,
        i.Incident_Description
    FROM 
        Incident i
    JOIN 
        Room r ON i.Room_ID = r.Room_ID
    WHERE 
        r.Dorm_ID = Dorm_ID;
END $$

DELIMITER ;

CALL DormIncidentReport('DORM0001');

-- Tính tổng số lượng thiết bị còn lại trong kho của một nhà cung cấp
DELIMITER $$

-- Hàm để tính tổng số lượng thiết bị còn lại trong kho của một nhà cung cấp
CREATE FUNCTION TotalAvailableEquipmentForProvider (Provider_ID CHAR(8))
RETURNS INT
BEGIN
    DECLARE total_available_equipment INT;

    SELECT SUM(Equipment_Quantity) INTO total_available_equipment
    FROM Equipment
    WHERE Provider_ID = Provider_ID;

    RETURN total_available_equipment;
END $$

DELIMITER ;

SELECT TotalAvailableEquipmentForProvider('PROV001');

-- Tổng thu nhập từ tiền thuê phòng của một ký túc xá
DELIMITER $$

CREATE FUNCTION TotalRentIncome (Dorm_ID CHAR(8))
RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE total_income DECIMAL(10, 2);

    SELECT SUM(rm.Rent_Price * r.Current_Occupancy) INTO total_income
    FROM Room rm
    JOIN Renting r ON rm.Room_ID = r.Room_ID
    WHERE rm.Dorm_ID = Dorm_ID;

    RETURN total_income;
END $$

DELIMITER ;

SELECT TotalRentIncome('DORM0001');

--  Tổng số lượng thiết bị đã sử dụng trong một phòng
DELIMITER $$

-- Hàm để tính tổng số lượng thiết bị đã sử dụng trong một phòng
CREATE FUNCTION TotalUsedEquipmentInRoom (Room_ID CHAR(8))
RETURNS INT
BEGIN
    DECLARE total_used_equipment INT;

    SELECT SUM(Using_Quantity) INTO total_used_equipment
    FROM Equipment_Usage
    WHERE Room_ID = Room_ID;

    RETURN total_used_equipment;
END $$

DELIMITER ;

SELECT TotalUsedEquipmentInRoom('ROOM001');

-- thống kê số lượng sinh viên theo giới tính
DELIMITER $$

-- Thủ tục để tạo thống kê số lượng sinh viên theo giới tính

CREATE PROCEDURE StudentGenderStatistics ()
BEGIN
    SELECT 
        Student_Gender,
        COUNT(*) AS Total_Students
    FROM 
        Student
    GROUP BY 
        Student_Gender;
END $$

DELIMITER ;

CALL StudentGenderStatistics();

