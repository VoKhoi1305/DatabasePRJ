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


CREATE TRIGGER CalculateServiceTotalAmount
ON Service_Registration
AFTER INSERT
AS
BEGIN
    UPDATE sr
    SET sr.Service_Total_Amount = DATEDIFF(DAY, sr.Service_Start_Date, sr.Service_End_Date) / 30.0 * s.Monthly_Rate
    FROM Service_Registration sr
    INNER JOIN inserted i ON sr.Service_ID = i.Service_ID AND sr.Student_ID = i.Student_ID
    INNER JOIN Service s ON sr.Service_ID = s.Service_ID;
END;