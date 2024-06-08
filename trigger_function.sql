DELIMITER $$

CREATE TRIGGER check_student_gender_before_insert
BEFORE INSERT ON Student
FOR EACH ROW
BEGIN
    -- Check if the gender is valid
    IF NEW.Student_Gender NOT IN ('M', 'F') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid gender. Must be M or F';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER check_staff_gender_before_insert
BEFORE INSERT ON Staff
FOR EACH ROW
BEGIN
    -- Check if the gender is valid
    IF NEW.Staff_Gender NOT IN ('M', 'F') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid gender. Must be M or F';
    END IF;
END$$

DELIMITER ;


DELIMITER //

CREATE TRIGGER check_occupancy_before_insert
BEFORE INSERT ON Room
FOR EACH ROW
BEGIN
    IF NEW.Current_Occupancy > NEW.Number_Of_Bed THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Current occupancy cannot be greater than the number of beds';
    END IF;
END //

CREATE TRIGGER check_occupancy_before_update
BEFORE UPDATE ON Room
FOR EACH ROW
BEGIN
    IF NEW.Current_Occupancy > NEW.Number_Of_Bed THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Current occupancy cannot be greater than the number of beds';
    END IF;
END //

DELIMITER ;

DELIMITER //
CREATE TRIGGER update_occupancy_on_renting
AFTER INSERT ON Renting
FOR EACH ROW
BEGIN
  DECLARE available_beds INT;
  DECLARE End_Date Date;

  SELECT Number_Of_Bed - Current_Occupancy INTO available_beds
  FROM Room
  WHERE Room.Room_ID = NEW.Room_ID;
  
  SELECT Renting_End_Date INTO End_Date
	FROM Renting
  WHERE Renting.Room_ID = NEW.Room_ID AND Renting.Student_ID = NEW.Student_ID ;
  IF available_beds > 0  THEN
	IF NOW() < End_Date THEN
    -- Cập nhật Current_Occupancy
    UPDATE Room
    SET Current_Occupancy = Current_Occupancy + 1
    WHERE Room.Room_ID = NEW.Room_ID;
    END IF;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot rent room, maximum capacity reached.';
  END IF;
END; //
DELIMITER ;


Drop trigger update_occupancy_on_renting
DELIMITER $$

CREATE TRIGGER Renting_Gender_check
BEFORE INSERT ON Renting
FOR EACH ROW
BEGIN
  DECLARE room_type VARCHAR(10);
  DECLARE student_gender CHAR(1);

  -- Lấy giới tính của sinh viên từ bảng Student
  SELECT Student.Student_Gender INTO student_gender
  FROM Student
  WHERE Student.Student_ID = NEW.Student_ID;

  -- Lấy loại phòng từ bảng Room
  SELECT Room.Room_Type INTO room_type
  FROM Room
  WHERE Room.Room_ID = NEW.Room_ID;

  -- So sánh giới tính và loại phòng
  IF (room_type = 'Female' AND student_gender <> 'F') OR (room_type = 'Male' AND student_gender <> 'M') THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Giới tính của sinh viên không phù hợp với loại phòng.';
  END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER Calculate_Total_Amount_Monthly
AFTER INSERT ON Service_Registration
FOR EACH ROW
BEGIN
  DECLARE total_amount DECIMAL(10, 2);
  DECLARE service_month INT;  -- Use INT for whole months
  DECLARE month_service_price DECIMAL(10,2);

  SELECT Service.Service_Price INTO month_service_price
  FROM Service
  WHERE Service.Service_ID = NEW.Service_ID;

  SET service_month = CEIL(DATEDIFF(NEW.Service_End_Date,NEW.Service_Start_Date) / 30.44);

  SET total_amount = service_month * month_service_price;

 INSERT INTO Service_Price 
  SET Service_Price.Service_total = total_amount,
		Service_Price.Service_Registration_ID = NEW.Service_Registration_ID;
END $$

DELIMITER ;
DROP Trigger Calculate_Total_Amount_Monthly