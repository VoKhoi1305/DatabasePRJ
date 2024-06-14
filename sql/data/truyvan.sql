-- 1. xóa mọi thông tin liên quan đến sinh viên có ID nhập vào 
DELIMITER $$
CREATE PROCEDURE delete_student(
    IN student_id VARCHAR(10)
)
BEGIN
    START TRANSACTION;
    
    DELETE FROM Renting WHERE Student_ID = student_id;
    DELETE FROM Service_Registration WHERE Student_ID = student_id;
    DELETE FROM Student WHERE Student_ID = student_id;
    
    COMMIT;
END $$
DELIMITER ;

-- 2.Truy vấn nhân viên theo mã tòa
DELIMITER $$
CREATE PROCEDURE get_staff_info(IN dorm_id VARCHAR(150))
BEGIN
    SELECT 
        Staff.Staff_ID, 
        Staff.Staff_First_Name, 
        Staff.Staff_Last_Name, 
        Working.Dorm_ID
    FROM  Staff
    JOIN   Working ON Staff.Staff_ID = Working.Staff_ID
    WHERE   Working.Dorm_ID = dorm_id
    ORDER BY  Working.Dorm_ID;
END $$
DELIMITER ;

-- 3. Sắp xếp các phòng theo số lượng người 
DELIMITER $$
CREATE PROCEDURE get_rooms_by_occupancy()
BEGIN
     SELECT * FROM Room ORDER BY Current_Occupancy DESC;
end $$
   DELIMITER;

-- 3. Thêm dịch vụ mới vào bảng Service
DELIMITER $$
CREATE PROCEDURE add_new_service(
    IN p_service_id VARCHAR(10),
    IN p_provider_id VARCHAR(10),
    IN p_service_name VARCHAR(50),
    IN p_service_price DECIMAL(10,2),
    IN p_service_description VARCHAR(200)
)
BEGIN
    INSERT INTO Service (
        Service_ID, 
        Provider_ID, 
        Service_Name, 
        Service_Price, 
        Service_Description
    )
    VALUES (
        p_service_id,
        p_provider_id, 
        p_service_name,
        p_service_price,
        p_service_description
    );
END $$
DELIMITER ;
call get_rooms_by_occupancy();
-- 4.Hiển thị tất cả sinh viên theo giới tính
DELIMITER $$
CREATE PROCEDURE get_sexual_students(IN sexual VARCHAR (10))
BEGIN 
 SELECT * FROM Student WHERE Student.Gender = sexual ;
END $$
DELIMITER ;

-- 5.Tính toán tỷ lệ lấp đầy kí túc xá
DELIMITER $$
CREATE PROCEDURE get_dorm_occupancy_rates()
BEGIN
   SELECT Dorm.Dorm_Name,
       SUM(Room.Current_Occupancy) / SUM(Room.Number_Of_Bed) * 100 AS Occupancy_Rate
  FROM Dorm
  JOIN Room ON Dorm.Dorm_ID = Room.Dorm_ID
GROUP BY Dorm.Dorm_Name;
END $$
DELIMITER ;
call get_dorm_occupancy_rates()
-- 6.Hiển thị tất cả thông tin của 1 sinh viên 
DELIMITER $$
CREATE PROCEDURE get_student_by_name(
    IN first_name VARCHAR(50),
    IN last_name VARCHAR(50)
)
BEGIN
    SELECT * 
    FROM Student
    WHERE Student_First_Name = first_name AND Student_Last_Name = last_name;
END $$
DELIMITER ;

-- 7. Kiểm tra các sự cố xảy ra vào ngày tháng nhập vào
DELIMITER $$
CREATE PROCEDURE get_incidents_by_month_year(
    IN report_year INT,
    IN report_month INT
)
BEGIN
    SELECT *
    FROM Incident
    WHERE YEAR(Incident.Report_Date) = report_year
      AND MONTH(Incident.Report_Date) = report_month;
END $$
DELIMITER ;

-- 9. tăng lương cho 1 nhân viên cụ thể lên x lần
DELIMITER $$
CREATE PROCEDURE update_staff_salary(
    IN staff_id VARCHAR(20),
    IN salary_increase DECIMAL(10,2)
)
BEGIN
    UPDATE Staff
    SET Staff_Salary = Staff_Salary * (1 + salary_increase)
    WHERE Staff_ID = staff_id;
END $$
DELIMITER ;

-- 10. Thông tin chi tiết về các nhà cung cấp và dịch vụ của họ
DELIMITER $$
CREATE PROCEDURE get_provider_service_info()
BEGIN
    SELECT 
        Provider.Provider_Name,
        Provider.Provider_Address,
        Provider.Provider_Phone_Number,
        Service.Service_Name,
        Service.Service_Price
    FROM Provider
    JOIN Service ON Provider.Provider_ID = Service.Provider_ID;
END $$
DELIMITER ;

-- 11. Danh sách sinh viên chưa thanh toán tiền thuê phòng
DELIMITER $$
CREATE PROCEDURE get_unpaid_renting_contracts()
BEGIN
    SELECT 
        Student.Student_ID,
        Student.Student_First_Name,
        Student.Student_Last_Name,
        Renting.Renting_Contract_ID,
        Renting.Renting_Status
    FROM Student
    JOIN Renting ON Student.Student_ID = Renting.Student_ID
    WHERE Renting.Renting_Status = 'not paid';
END $$
DELIMITER ;

-- 12. Thông tin chi tiết về thiết bị trong từng ký túc xá
DELIMITER $$
CREATE PROCEDURE get_dorm_equipment_usage()
BEGIN
    SELECT 
        Dorm.Dorm_Name,
        Equipment.Equipment_Name,
        SUM(Equipment_Usage.Using_Quantity) AS Total_Quantity
    FROM Dorm
    JOIN Room ON Dorm.Dorm_ID = Room.Dorm_ID
    JOIN Equipment_Usage ON Room.Room_ID = Equipment_Usage.Room_ID
    JOIN Equipment ON Equipment_Usage.Equipment_ID = Equipment.Equipment_ID
    GROUP BY Dorm.Dorm_Name, Equipment.Equipment_Name;
END $$
DELIMITER ;
call get_dorm_equipment_usage()dorm

-- 14. Thông tin thiết bị trong từng phòng
DELIMITER $$
CREATE PROCEDURE get_room_equipment_usage()
BEGIN
    SELECT 
        Room.Room_ID,
        Room.Room_Type,
        Equipment.Equipment_Name,
        Equipment_Usage.Using_Quantity,
        Equipment_Usage.Equipment_Start_Date,
        Equipment_Usage.Equipment_End_Date
    FROM Room
    JOIN Equipment_Usage ON Room.Room_ID = Equipment_Usage.Room_ID
    JOIN Equipment ON Equipment_Usage.Equipment_ID = Equipment.Equipment_ID ORDER BY Room.Room_ID;
END $$
DELIMITER ;


-- 18. Thống kê số lượng sinh viên theo ngành học
DELIMITER $$
CREATE PROCEDURE get_student_major_counts()
BEGIN
    SELECT 
        Major,
        COUNT(Student_ID) AS Total_Students
    FROM Student
    GROUP BY Major
    ORDER BY Total_Students DESC;
END $$
DELIMITER ;

-- 19. Các phòng có số người ở tối đa và cần mở rộng
DELIMITER $$
CREATE PROCEDURE get_full_rooms()
BEGIN
    SELECT 
        Room.Room_ID,
        Room.Room_Type,
        Room.Number_Of_Bed,
        Room.Current_Occupancy
    FROM Room
    WHERE Room.Current_Occupancy = Room.Number_Of_Bed;
END $$
DELIMITER ;

-- 20. Chi tiết lịch sử thuê phòng của từng sinh viên
DELIMITER $$
CREATE PROCEDURE get_student_renting_details()
BEGIN
    SELECT 
        Student.Student_ID,
        Student.Student_First_Name,
        Student.Student_Last_Name,
        Room.Room_ID,
        Room.Room_Type,
        Renting.Renting_Start_Date,
        Renting.Renting_End_Date,
        Renting.Renting_Status
    FROM Student
    JOIN Renting ON Student.Student_ID = Renting.Student_ID
    JOIN Room ON Renting.Room_ID = Room.Room_ID
    ORDER BY Student.Student_ID, Renting.Renting_Start_Date;
END $$
DELIMITER ;

-- 22. Danh sách sinh viên có hợp đồng thuê sắp hết hạn trong tháng này
DELIMITER $$
CREATE PROCEDURE get_students_returning_equipment_this_month()
BEGIN
    SELECT 
        Student.Student_ID, 
        Student.Student_First_Name, 
        Student.Student_Last_Name,
        Renting.Renting_End_Date
    FROM Student
    JOIN Renting ON Student.Student_ID = Renting.Student_ID
    WHERE MONTH(Renting.Renting_End_Date) = MONTH(CURDATE()) 
        AND YEAR(Renting.Renting_End_Date) = YEAR(CURDATE());
END $$
DELIMITER ;
call get_students_returning_equipment_this_month()


-- 25.Danh sách các sinh viên đã hoàn thành tất cả các khoản thanh toán
DELIMITER $$
CREATE PROCEDURE get_students_with_no_unpaid_items()
BEGIN
    SELECT 
        Student.Student_ID, 
        Student.Student_First_Name, 
        Student.Student_Last_Name
    FROM Student
    WHERE Student.Student_ID NOT IN (
        SELECT Student_ID
        FROM Renting
        WHERE Renting_Status = 'not paid'
    )
    AND Student.Student_ID NOT IN (
        SELECT Student_ID
        FROM Service_Registration
        WHERE Service_Status = 'not paid'
    );
END $$
DELIMITER ;


