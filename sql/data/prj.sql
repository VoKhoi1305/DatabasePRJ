
-- 2. hiện thông tin của tất cả sinh viên ở thành phố
DELIMITER $$
create procedure tt_sv1(thanh_pho varchar(150))
begin
   select Student_ID, Student_First_Name, Student_Last_Name, Student_Birthday, Student_Gender, Student_Email, Student_Phone_Number, Student_Address, Student_City, Major
   from student 
   where Student_City=thanh_pho;
   end $$
DELIMITER;
   call tt_sv1('New John');
-- 3. hiện thông tin sinh viên có mã ngành học "Nature conservation officer"
DELIMITER $$
create procedure tt_sv(ma_ng varchar(150))
begin
   select Student_ID, Student_First_Name, Student_Last_Name, Student_Birthday, Student_Gender, Student_Email, Student_Phone_Number, Student_Address, Student_City, Major
   from student 
   where Major=ma_ng;
   end $$
   DELIMITER;
   call tt_sv('Training and development officer');
-- 4 hiện thông tin những sinh viên sinh năm được nhập
DELIMITER $$
create procedure tt_sv2(nam_sinh varchar(150))
begin
   select Student_ID, Student_First_Name, Student_Last_Name, Student_Birthday, Student_Gender, Student_Email, Student_Phone_Number, Student_Address, Student_City, Major
   from student 
   where year(Student_Birthday)=nam_sinh;
   end $$
   DELIMITER;
   call tt_sv2(2004);
-- 6.thông tin những sinh viên ở mã phòng "RM010816"
delimiter $$
create procedure tt_sv_maphong(id_p varchar(50))
begin
select Student_ID, Student_First_Name, Student_Last_Name, Student_Birthday, Student_Gender, Student_Email, Student_Phone_Number, Student_Address, Student_City, Major
from student
where 	Student_ID in
(select Student_ID
from renting
where Room_ID = id_p
);
end $$
delimiter;
call tt_sv_maphong('RM010816');

-- 8.Danh sách sv đã đăng kí dịch vụ
delimiter $$
create procedure tt_sv_da_dkdv()
begin
select s.Student_ID, s.Student_First_Name, s.Student_Last_Name, s.Student_Birthday, s.Student_Gender, s.Student_Email, s.Student_Phone_Number, s.Student_Address, s.Student_City, s.Major
from student s
join service_registration on service_registration.Student_ID=s.Student_ID;
end $$
delimiter;
call tt_sv_da_dkdv();



 -- 17. Tổng số sv,nv,phòng cho mỗi ktx
 delimiter $$
create procedure tong_nv_sv_phong_moi_toa()
begin
SELECT d.Dorm_Name,
     (SELECT COUNT(*) FROM Student s JOIN Renting r ON s.Student_ID = r.Student_ID WHERE r.Room_ID IN (SELECT Room_ID FROM Room WHERE Dorm_ID = d.Dorm_ID)) AS Total_Students,
     (SELECT COUNT(*) FROM Room WHERE Dorm_ID = d.Dorm_ID) AS Total_Rooms,
     (SELECT COUNT(*) FROM Staff WHERE Dorm_ID = d.Dorm_ID) AS Total_Staff
FROM Dorm as d
LIMIT 0, 1000;
end $$
delimiter;
call tong_nv_sv_phong_moi_toa();
-- 18 những sinh viên vi phạm kỉ luật và thông tin hành vi của sv
delimiter $$
create procedure tt_sv_vp_ky_luat()
begin
SELECT s.Student_ID, s.Student_First_Name, s.Student_Last_Name, d.Violation_Date, d.Violation_Information, d.Penalty
FROM Student s
JOIN Discipline d ON s.Student_ID = d.Student_ID;
end $$
delimiter;
call tt_sv_vp_ky_luat();
-- 19.tổng doanh thu đăng kí dịch vụ của sv
delimiter $$
create procedure tong_doanh_thu_dk_dv_cua_sv()
begin
SELECT s.Student_ID, s.Student_First_Name, s.Student_Last_Name, SUM(sp.Service_total) AS Total_Service_Revenue
FROM Student s
JOIN Service_Registration sr ON s.Student_ID = sr.Student_ID
JOIN Service_price sp ON sr.Service_Registration_ID = sp.Service_Registration_ID
GROUP BY s.Student_ID, s.Student_First_Name, s.Student_Last_Name;
end $$
delimiter;
call tong_doanh_thu_dk_dv_cua_sv();
-- 20.thông tin các phòng có sự cố và chi tiết sự cố
delimiter $$
create procedure tt_phong_co_su_co_va_chi_tiet_su_co()
begin
SELECT r.Room_ID, i.Incident_ID, i.Incident_Status, i.Report_Date, i.Incident_Description
FROM room r
JOIN incident i ON r.Room_ID = i.Room_ID;
end $$
delimiter;
call tt_phong_co_su_co_va_chi_tiet_su_co();
-- 22.Thông tin dịch vụ đang dùng và tổng doanh thu dịch vụ tương ứng
delimiter $$
create procedure tt_dv_va_tong_doanh_thu_tuong_ung()
begin
SELECT p.Provider_Name,s.Service_Name,SUM(sp.Service_total) AS Total_Revenue
FROM provider p
JOIN service s ON p.Provider_ID = s.Provider_ID
LEFT JOIN service_registration sr ON s.Service_ID = sr.Service_ID
LEFT JOIN service_price sp ON sr.Service_Registration_ID = sp.Service_Registration_ID
GROUP BY p.Provider_Name, s.Service_Name;
end $$
delimiter;
call tt_dv_va_tong_doanh_thu_tuong_ung();

-- 24.thông tin sv đã kết thúc hợp đồng
delimiter $$
create procedure tt_sv_da_het_hd()
begin
SELECT 
    s.Student_ID,
    s.Student_First_Name,
    s.Student_Last_Name,
    r.Room_ID,
    r.Room_Type,
    r.Rent_Price,
    re.Renting_Start_Date,
    re.Renting_End_Date
FROM Student s
JOIN Renting re ON s.Student_ID = re.Student_ID
JOIN Room r ON re.Room_ID = r.Room_ID
WHERE re.Renting_End_Date < CURRENT_DATE;
end $$
delimiter;
call tt_sv_da_het_hd();
-- 25 top 3 dịch vụ phổ biến nhẩt
delimiter $$
create procedure top_dv_pho_bien_nhat()
begin
SELECT s.Service_Name, COUNT(sr.Service_ID) AS Registration_Count
FROM Service s
INNER JOIN Service_Registration sr ON s.Service_ID = sr.Service_ID
GROUP BY s.Service_Name
ORDER BY Registration_Count DESC
LIMIT 3;
end $$
delimiter;
call top_dv_pho_bien_nhat();
