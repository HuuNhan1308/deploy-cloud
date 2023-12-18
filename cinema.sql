/*
PostgreSQL Backup
Database: db_cinema/public
Backup Time: 2023-12-18 12:24:27
*/

DROP SEQUENCE IF EXISTS "public"."seat_class_sequence";
DROP SEQUENCE IF EXISTS "public"."the_sequence_name";
DROP TABLE IF EXISTS "public"."customer";
DROP TABLE IF EXISTS "public"."invoice";
DROP TABLE IF EXISTS "public"."movie";
DROP TABLE IF EXISTS "public"."room";
DROP TABLE IF EXISTS "public"."seatclass";
DROP TABLE IF EXISTS "public"."showtime";
DROP TABLE IF EXISTS "public"."ticket";
DROP FUNCTION IF EXISTS "public"."check_showtime()";
CREATE SEQUENCE "seat_class_sequence" 
INCREMENT 50
MINVALUE  1
MAXVALUE 9223372036854775807
START 50
CACHE 1;
CREATE SEQUENCE "the_sequence_name" 
INCREMENT 50
MINVALUE  1
MAXVALUE 9223372036854775807
START 50
CACHE 1;
CREATE TABLE "customer" (
  "customer_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "balance" float8,
  "email" varchar(255) COLLATE "pg_catalog"."default",
  "fullname" varchar(255) COLLATE "pg_catalog"."default",
  "password" varchar(255) COLLATE "pg_catalog"."default",
  "phone_number" varchar(255) COLLATE "pg_catalog"."default",
  "username" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "customer" OWNER TO "admin";
CREATE TABLE "invoice" (
  "invoice_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "boughtdate" date,
  "customer_id" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "invoice" OWNER TO "admin";
CREATE TABLE "movie" (
  "movie_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "description" varchar(255) COLLATE "pg_catalog"."default",
  "director" varchar(255) COLLATE "pg_catalog"."default",
  "duration" time(6),
  "genre" varchar(255) COLLATE "pg_catalog"."default",
  "img" varchar(255) COLLATE "pg_catalog"."default",
  "main_actor" varchar(255) COLLATE "pg_catalog"."default",
  "title" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "movie" OWNER TO "admin";
CREATE TABLE "room" (
  "room_number" int4 NOT NULL,
  "max_seats" int4,
  "screen_quality" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "room" OWNER TO "admin";
CREATE TABLE "seatclass" (
  "id" int4 NOT NULL,
  "category" varchar(255) COLLATE "pg_catalog"."default",
  "factor" float8
)
;
ALTER TABLE "seatclass" OWNER TO "admin";
CREATE TABLE "showtime" (
  "showtime_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "show_date" date,
  "price" int4,
  "start_time" time(6),
  "movie_id" varchar(255) COLLATE "pg_catalog"."default",
  "room_number" int4
)
;
ALTER TABLE "showtime" OWNER TO "admin";
CREATE TABLE "ticket" (
  "ticket_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "seat_number" int4,
  "invoice_id" varchar(255) COLLATE "pg_catalog"."default",
  "seatclass_id" int4,
  "showtime_id" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "ticket" OWNER TO "admin";
CREATE OR REPLACE FUNCTION "check_showtime"()
  RETURNS "pg_catalog"."trigger" AS $BODY$
DECLARE
    len INTERVAL;

BEGIN
    SELECT mv.duration::INTERVAL INTO len
    FROM showtime st inner join movie mv on st.movie_id = mv.movie_id
    WHERE mv.movie_id = NEW.movie_id;
    
    IF EXISTS (
        SELECT 1 
        FROM showtime st inner join movie mv on st.movie_id = mv.movie_id
        WHERE st.show_date = NEW.show_date and st.room_number = NEW.room_number 
        AND ((NEW.start_time < st.start_time + mv.duration::INTERVAL) AND (NEW.start_time + len > st.start_time))
        AND id <> NEW.id
    ) THEN
        RAISE EXCEPTION 'Duplicate showtime';
    END IF;
    RETURN NEW;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "check_showtime"() OWNER TO "admin";
BEGIN;
LOCK TABLE "public"."customer" IN SHARE MODE;
DELETE FROM "public"."customer";
INSERT INTO "public"."customer" ("customer_id","balance","email","fullname","password","phone_number","username") VALUES ('56CC135B-0845-45C2-8178-AC9E4C95444D', 1000000, 'hoanglongvu912@gmail.com', 'Hoàng Long Vũ', '123456', '0912512513', 'longvu912'),('9D3FE92C-2C75-4F7E-A2F2-CDFC42C63453', 868000, 'nhanhohuunhan7398@gmail.com', 'Ho Huu Nhan', '1', '0928317247', 'nhan'),('2ED090E8-9B41-4AB3-B854-759E14609681', 99858000, 'quangtrieudeptraikobaogiosai2703@gmail.com', 'quangtrieudeptraikobaogiosai', '123', '0326565781', 'quangtrieu'),('11CE67FD-45CF-4F86-BA0A-6BC0FDB49FA2', 0, 'giauten28@gmail.com', 'quangtriu', '126a3408-559b-4ed0-aed0-ec5d8843ac4c', '0326565781', 'trieu'),('5E1E1A20-BE6C-4E55-944B-9E3D518AAD55', 244000, 'heavenkillgirls@gmail.com', 'DAtdz', '1', '0156749879', 'Datdz'),('FDCFA224-9B64-4A04-9678-3F505793F875', 5000000, 'levy3443@gmail.com', 'Vy Lê', 'ca1079b9-008b-460a-8b12-f287e28703e2', '0966480829', 'vyle2509'),('E69C0935-0DC7-4FC1-8E8C-DCD1B85D68FC', 1114567, '21110759@student.hcmute.edu.vn', 'Hồ Thanh Duy', '1b12b35a-13d5-4cca-a691-dc80bf3a538e', '0123456789', 'thanhduy'),('D16BD783-99F9-4A18-A5BE-57139FB0DEC4', 3744000, 'haclovo2190@gmail.com', 'Hoàng Long Vũ', '123456', '0981241241', 'longvu')
;
COMMIT;
BEGIN;
LOCK TABLE "public"."invoice" IN SHARE MODE;
DELETE FROM "public"."invoice";
INSERT INTO "public"."invoice" ("invoice_id","boughtdate","customer_id") VALUES ('249577C0-5BDE-4617-9AFB-8EF546617C9F', '2023-11-28', '2ED090E8-9B41-4AB3-B854-759E14609681'),('6B7842F8-9D62-4A0B-A5C7-E6DB80654770', '2023-11-28', 'D16BD783-99F9-4A18-A5BE-57139FB0DEC4'),('86961E21-37BC-4102-83C4-4ACDE34F7532', '2023-11-28', '9D3FE92C-2C75-4F7E-A2F2-CDFC42C63453'),('B09D058F-A65F-49AA-8056-992E944A5965', '2023-11-28', '2ED090E8-9B41-4AB3-B854-759E14609681'),('A26F967A-6C91-4FE1-879E-8B9C9DF911F0', '2023-11-29', 'D16BD783-99F9-4A18-A5BE-57139FB0DEC4'),('B4D5F7E7-1C53-4E13-A486-5357C571EEBD', '2023-11-28', '5E1E1A20-BE6C-4E55-944B-9E3D518AAD55'),('C2B3617D-EA47-49B1-9820-2448E5D82642', '2023-11-29', 'D16BD783-99F9-4A18-A5BE-57139FB0DEC4'),('B4107EA4-C48F-4EEF-96EC-C86A0D658DA8', '2023-11-28', 'E69C0935-0DC7-4FC1-8E8C-DCD1B85D68FC'),('39CDC233-49AF-4B32-AAE8-A62E220384CB', '2023-11-28', 'D16BD783-99F9-4A18-A5BE-57139FB0DEC4'),('F09F2133-3EA1-4B63-B023-B8C1CFAFF81E', '2023-11-29', 'D16BD783-99F9-4A18-A5BE-57139FB0DEC4')
;
COMMIT;
BEGIN;
LOCK TABLE "public"."movie" IN SHARE MODE;
DELETE FROM "public"."movie";
INSERT INTO "public"."movie" ("movie_id","description","director","duration","genre","img","main_actor","title") VALUES ('EAECA91C-85AE-4EE3-977F-34FCB6A8C98E', 'A legendary hitman who comes out of retirement to seek revenge against the men who killed his puppy, a final gift from his recently deceased wife.', 'Derek Kolstad', '02:00:00', 'Action, Tragedy', 'johnwick1.png', 'Keanu Reeves', 'John Wick 1'),('D8430069-7C50-4342-81E3-48E7EEE67391', 'After returning to the criminal underworld to repay a debt, John Wick discovers that a large bounty has been put on his life.', 'Derek Kolstad', '02:00:00', 'Action, Tragedy', 'johnwick2.png', 'Keanu Reeves', 'John Wick 2'),('CDDEACE3-F679-4125-9702-9922EC8954CE', 'Skilled assassin John Wick (Keanu Reeves) returns with a $14 million price tag on his head and an army of bounty-hunting killers on his trail.', 'Derek Kolstad', '02:00:00', 'Action, Tragedy', 'johnwick3.png', 'Keanu Reeves', 'John Wick 3'),('5C6FCEEA-2F25-4929-BF7F-5B2F843088CB', 'John Wick uncovers a path to defeating The High Table. But before he can earn his freedom, Wick must face off against a new enemy with powerful alliances across the globe and forces that turn old friends into foes.', 'Derek Kolstad', '02:00:00', 'Action, Tragedy', 'johnwick4.png', 'Keanu Reeves', 'John Wick 4'),('4B537AD4-4EE0-4DDD-B835-AA6201773CD2', 'It is set in a world where humanity is forced to live in cities surrounded by three enormous walls that protect them from gigantic man-eating humanoids referred to as Titans.', 'Isayama Hajime', '03:00:00', 'Anime, Action, Horror, Tragedy', 'aot.png', 'Eren Yeager', 'Attack on Titan: The final season'),('A7ADE191-985B-451D-ABAA-60337F5F33FB', 'Nội dung “Bến Phà Xác Sống” xoay quanh cuộc chạy trốn của nhóm người của Công (Huỳnh Đông) khỏi sự bùng phát của dịch bệnh và cố gắng chạy đến chuyến phà cuối cùng ở vùng hạ lưu sông Mekong.', 'Nguyễn Thành Nam', '02:30:00', 'Horror, Comedy', 'benphaxacsong.png', 'Huỳnh Đông', 'Bến Phà Xác Sống'),('CC58B3E0-CE47-4DA2-B324-74E4C02A3528', 'Phim nói về hành trình của Công - một thầy thuốc đông y cố gắng đưa cha và con gái thoát khỏi sự truy đuổi của xác sống khi đại dịch bùng nổ. Họ thất lạc nhau trên đường chạy trốn.', 'Nhất Trung', '02:20:00', 'Horror, Comedy', 'culaoxacsong.png', 'Ốc Thanh Vân', 'Cù Lao Xác Sống'),('6C40B1C6-F992-4009-97FC-8FCADFB8E57B', 'A woman, Rose, goes in search for her adopted daughter within the confines of a strange, desolate town called Silent Hill.', 'Christophe Gans', '03:00:00', 'Horror, Tragedy', 'silenthill.png', 'Sean Bean', 'Silent Hill'),('94BE4423-876E-416B-8BD3-A6D98A47E385', 'When a spell goes wrong, dangerous foes from other worlds start to appear, forcing Peter to discover what it truly means to be Spider-Man.', 'Top gun', '03:00:00', 'Action, Adventure, Romance', 'spiderman.png', 'Tom Holland', 'Spider Man: No Way Home'),('05CC596D-7987-49C0-930C-43D33A27A26C', 'The two play characters who are of different social classes. They fall in love after meeting aboard the ship, but it was not good for a rich girl to fall in love with a poor boy in 1912.', 'James Cameron', '02:00:00', 'Comedy, Romance, Tragedy', 'titanic.png', 'Leonardo DiCaprio', 'Titanic'),('C24E3587-B2DA-4518-9755-922DFC94793E', 'An là một cậu bé sinh sống ở đô thành của khu vực Nam Kỳ Lục tỉnh cùng với mẹ của mình vào những năm 1920 – 1930. Ba của An là Hai Thành, một người đi theo cách mạng với mong muốn đánh đuổi thực dân Pháp ra khỏi Việt Nam.', 'Nguyễn Quang Dũng', '02:00:00', 'Document', 'datrungphuongnam.png', 'Trấn Thành', 'Đất Rừng Phương Nam'),('FE40B917-C5FB-485C-9055-8E96F24A0EE5', 'Nhóm của Conan, theo lời mời của Sonoko, cũng đến đảo Hachijo để xem cá voi. Tính mạng Haibara Ai (cựu thành viên Tổ chức với mật danh Sherry) bị đe dọa, rất có thể thân phận của Haibara bị bại lộ trước Gin… ', 'Aoyama Gōshō', '03:00:00', 'Anime, Action, Detective', 'conan26.png', 'Edogawa Conan', 'Conan Movie 26: Tàu Ngầm Sắt Màu Đen'),('99FCE9F2-C692-442C-92A0-A8EC3B985904', 'Nobita được nghe Dekisugi tóm tắt về Utopia của Thomas More kể về vùng đất giả tưởng mà con người sống hạnh phúc, không phải chịu đau khổ và không có xung đột, sau giờ học, cậu nhờ Doraemon tìm giúp vùng đất lý tưởng đó.', 'Fujiko F. Fujio', '03:00:00', 'Anime, Adventure, Action', 'doraemon42.png', 'Nobi Nobita', 'Doraemon Movie 42: Nobita Và Vùng Đất Lý Tưởng Trên Bầu Trời'),('5C2E4B6A-4C12-4AA2-9784-E9A5F437543A', '“Hào quang rực rỡ” (The King) tái hiện cuộc đời đa sắc màu của chính mình, trải dài qua nhiều giai đoạn của nền giải trí, âm nhạc Việt Nam từ thập niên 80-90 cho đến nay.', 'Đàm Vĩnh Hưng', '03:00:00', 'Document', 'haoquangrucro.png', 'Đàm Vĩnh Hưng', 'Hào Quang Rực Rỡ'),('E8DABEC0-BA7E-428D-90CA-2F6DA6C286E7', 'Mắt biếc xoay quanh mối tình đơn phương của Ngạn với Hà Lan, cô bạn gái có cặp mắt hút hồn nhưng cá tính bướng bỉnh. Một chuyện tình nhiều cung bậc, từ ngộ nghĩnh trẻ con, rồi tình yêu thuở học trò trong sáng.', 'Victor Vũ', '03:00:00', 'Romance, Comedy', 'matbiec.png', 'Trần Nghĩa', 'Mắt Biếc')
;
COMMIT;
BEGIN;
LOCK TABLE "public"."room" IN SHARE MODE;
DELETE FROM "public"."room";
INSERT INTO "public"."room" ("room_number","max_seats","screen_quality") VALUES (101, 100, 'Full HD'),(102, 100, '2K'),(103, 100, '4K'),(104, 100, '8K')
;
COMMIT;
BEGIN;
LOCK TABLE "public"."seatclass" IN SHARE MODE;
DELETE FROM "public"."seatclass";
INSERT INTO "public"."seatclass" ("id","category","factor") VALUES (2, 'Standard', 1),(3, 'VIP', 1.2)
;
COMMIT;
BEGIN;
LOCK TABLE "public"."showtime" IN SHARE MODE;
DELETE FROM "public"."showtime";
INSERT INTO "public"."showtime" ("showtime_id","show_date","price","start_time","movie_id","room_number") VALUES ('3AAA72DB-040F-4ECC-B601-1636BE557EC7', '2023-11-29', 60000, '08:00:00', '6C40B1C6-F992-4009-97FC-8FCADFB8E57B', 101),('3505BC73-727D-48DE-8A01-B69D085F129D', '2023-11-28', 70000, '09:00:00', 'EAECA91C-85AE-4EE3-977F-34FCB6A8C98E', 101),('E2BD3441-2F55-4A89-A500-EC25FBDC9665', '2023-11-28', 60000, '22:15:00', 'D8430069-7C50-4342-81E3-48E7EEE67391', 102),('78D16F70-6641-41EC-84FC-A2F72B254435', '2023-11-27', 80000, '20:20:00', 'CDDEACE3-F679-4125-9702-9922EC8954CE', 102),('3453B99A-B925-4373-912F-1B1F1CF8CC3D', '2023-11-29', 80000, '19:00:00', '5C6FCEEA-2F25-4929-BF7F-5B2F843088CB', 103),('8C322CF1-9E60-411C-AD89-1E359CC1600F', '2023-12-01', 80000, '12:30:00', 'CC58B3E0-CE47-4DA2-B324-74E4C02A3528', 101),('03986E7D-109D-4E0B-8CCB-57D4FB4FA96B', '2023-12-02', 70000, '08:30:00', 'A7ADE191-985B-451D-ABAA-60337F5F33FB', 101),('576116BF-8CB7-455A-93B3-CAF355F3ADD2', '2023-12-03', 80000, '10:50:00', '94BE4423-876E-416B-8BD3-A6D98A47E385', 101),('14104FB8-86A3-48C8-8D08-9E1B528748E6', '2023-12-04', 60000, '15:00:00', 'FE40B917-C5FB-485C-9055-8E96F24A0EE5', 103),('F510530E-8C74-46F5-9450-95A0DEEE18CD', '2023-12-04', 80000, '22:30:00', '99FCE9F2-C692-442C-92A0-A8EC3B985904', 104),('4CFEEDE7-079F-4FAF-8E9B-A63A1B18DAAE', '2023-12-02', 60000, '11:30:00', '5C2E4B6A-4C12-4AA2-9784-E9A5F437543A', 104),('39107151-A0D9-4778-91CF-3218396F5878', '2023-12-05', 80000, '12:50:00', 'E8DABEC0-BA7E-428D-90CA-2F6DA6C286E7', 103),('A8447F00-556E-4659-83F2-FB834E7ABB38', '2023-12-02', 50000, '17:50:00', 'CDDEACE3-F679-4125-9702-9922EC8954CE', 104),('7524881C-A653-4A7B-8DA6-CCB20AEC8FE3', '2023-12-06', 60000, '18:00:00', 'E8DABEC0-BA7E-428D-90CA-2F6DA6C286E7', 104),('1AF93AAF-ED6E-4F20-9175-974222BB0FE1', '2023-12-05', 70000, '16:00:00', 'E8DABEC0-BA7E-428D-90CA-2F6DA6C286E7', 104),('08923666-AD0F-455E-83D7-D4D54CC86982', '2023-12-04', 60000, '17:00:00', 'E8DABEC0-BA7E-428D-90CA-2F6DA6C286E7', 101),('EB99B08E-536A-4C2D-80AC-0C3760882B05', '2023-12-05', 70000, '19:10:00', 'E8DABEC0-BA7E-428D-90CA-2F6DA6C286E7', 102),('88D76F11-DCA2-4C15-A6B4-B92E234DF305', '2023-12-03', 70000, '18:00:00', 'E8DABEC0-BA7E-428D-90CA-2F6DA6C286E7', 102),('F07E3824-8BE7-4795-AA4E-0F08885DE9A7', '2023-12-02', 70000, '18:00:00', 'E8DABEC0-BA7E-428D-90CA-2F6DA6C286E7', 101),('59E82F1D-C208-4B6B-BEDC-F3FD70116829', '2023-12-14', 70000, '09:30:00', 'E8DABEC0-BA7E-428D-90CA-2F6DA6C286E7', 102),('CE842DBE-BDF3-4394-9B08-25DADFAAF469', '2023-12-20', 60000, '11:30:00', 'A7ADE191-985B-451D-ABAA-60337F5F33FB', 103)
;
COMMIT;
BEGIN;
LOCK TABLE "public"."ticket" IN SHARE MODE;
DELETE FROM "public"."ticket";
INSERT INTO "public"."ticket" ("ticket_id","seat_number","invoice_id","seatclass_id","showtime_id") VALUES ('27FA45BB-D4EF-4876-8852-4C46DDF91C52', 40, '249577C0-5BDE-4617-9AFB-8EF546617C9F', 3, '3453B99A-B925-4373-912F-1B1F1CF8CC3D'),('459B8249-74B2-47DD-84FD-41D552BC43E1', 60, '249577C0-5BDE-4617-9AFB-8EF546617C9F', 3, '3453B99A-B925-4373-912F-1B1F1CF8CC3D'),('70FF2A16-9A4A-4468-86DB-8E103B1692A7', 50, '249577C0-5BDE-4617-9AFB-8EF546617C9F', 3, '3453B99A-B925-4373-912F-1B1F1CF8CC3D'),('FE73B785-DB4F-42F7-B0E6-C1205AA11225', 56, '6B7842F8-9D62-4A0B-A5C7-E6DB80654770', 3, '3453B99A-B925-4373-912F-1B1F1CF8CC3D'),('DE531398-FFC5-4775-AA8B-31F375BA2FA0', 58, '6B7842F8-9D62-4A0B-A5C7-E6DB80654770', 3, '3453B99A-B925-4373-912F-1B1F1CF8CC3D'),('C0902033-DF2C-4F80-86AE-0DFDEAAEC6BD', 57, '6B7842F8-9D62-4A0B-A5C7-E6DB80654770', 3, '3453B99A-B925-4373-912F-1B1F1CF8CC3D'),('24611764-7CA5-4FE2-8A89-BDC386F199E5', 29, '86961E21-37BC-4102-83C4-4ACDE34F7532', 2, '3AAA72DB-040F-4ECC-B601-1636BE557EC7'),('598CA19A-8F31-497C-93AE-62CED6F20B10', 39, '86961E21-37BC-4102-83C4-4ACDE34F7532', 3, '3AAA72DB-040F-4ECC-B601-1636BE557EC7'),('4364ADE4-E972-4BE7-B4FC-494499192791', 55, 'B09D058F-A65F-49AA-8056-992E944A5965', 3, '3AAA72DB-040F-4ECC-B601-1636BE557EC7'),('27A8DCD6-6009-4C72-BF69-5F911217C87B', 34, 'B09D058F-A65F-49AA-8056-992E944A5965', 3, '3AAA72DB-040F-4ECC-B601-1636BE557EC7'),('0DCEA029-2DDC-457F-8B04-550E56F6E497', 56, 'B09D058F-A65F-49AA-8056-992E944A5965', 3, '3AAA72DB-040F-4ECC-B601-1636BE557EC7'),('929913C9-ABA1-4B6F-B7A1-F62E365C89F2', 54, 'B09D058F-A65F-49AA-8056-992E944A5965', 3, '3AAA72DB-040F-4ECC-B601-1636BE557EC7'),('30FB34C0-AB5E-423B-A509-B6CAE1A7737E', 47, 'B09D058F-A65F-49AA-8056-992E944A5965', 3, '3AAA72DB-040F-4ECC-B601-1636BE557EC7'),('F1642217-5013-4096-97F2-284517E9D269', 44, 'B09D058F-A65F-49AA-8056-992E944A5965', 3, '3AAA72DB-040F-4ECC-B601-1636BE557EC7'),('AD5BAA59-FC93-43F4-918B-C7FF97C4D63A', 46, 'B09D058F-A65F-49AA-8056-992E944A5965', 3, '3AAA72DB-040F-4ECC-B601-1636BE557EC7'),('89934353-2D7B-4BF4-89DF-B36673694227', 57, 'B09D058F-A65F-49AA-8056-992E944A5965', 3, '3AAA72DB-040F-4ECC-B601-1636BE557EC7'),('6FD7A68E-3FCB-4C8C-AC26-8C378BB1E07B', 36, 'B09D058F-A65F-49AA-8056-992E944A5965', 3, '3AAA72DB-040F-4ECC-B601-1636BE557EC7'),('835EFF49-E0CC-4157-A0CE-14C263FC5B87', 45, 'B09D058F-A65F-49AA-8056-992E944A5965', 3, '3AAA72DB-040F-4ECC-B601-1636BE557EC7'),('C39BD8CE-9AA4-4867-B13E-1401A6E7ECD7', 35, 'B09D058F-A65F-49AA-8056-992E944A5965', 3, '3AAA72DB-040F-4ECC-B601-1636BE557EC7'),('8A9F4D6F-855D-49B9-8CE3-3C6AE60D5C66', 37, 'B09D058F-A65F-49AA-8056-992E944A5965', 3, '3AAA72DB-040F-4ECC-B601-1636BE557EC7'),('56EB94FD-5CA3-461A-8126-0A9FDBF6943F', 68, 'A26F967A-6C91-4FE1-879E-8B9C9DF911F0', 2, '3AAA72DB-040F-4ECC-B601-1636BE557EC7'),('5DB95AE8-F5A9-4DF5-99C5-8E9CF61CABFE', 58, 'A26F967A-6C91-4FE1-879E-8B9C9DF911F0', 3, '3AAA72DB-040F-4ECC-B601-1636BE557EC7'),('87A71EEA-8C3C-4E87-A4C9-722C2F0BD649', 69, 'A26F967A-6C91-4FE1-879E-8B9C9DF911F0', 2, '3AAA72DB-040F-4ECC-B601-1636BE557EC7'),('380D2C2D-BFBD-45D9-9C37-55F88E5E5048', 59, 'A26F967A-6C91-4FE1-879E-8B9C9DF911F0', 3, '3AAA72DB-040F-4ECC-B601-1636BE557EC7'),('5A06689C-E317-4EDA-90DD-45AD206A8D57', 69, 'B4D5F7E7-1C53-4E13-A486-5357C571EEBD', 2, '3453B99A-B925-4373-912F-1B1F1CF8CC3D'),('878D70B5-F2BC-458B-952C-4AE787CAF757', 68, 'B4D5F7E7-1C53-4E13-A486-5357C571EEBD', 2, '3453B99A-B925-4373-912F-1B1F1CF8CC3D'),('90348561-1CE0-4829-8747-BB5B5599CA59', 59, 'B4D5F7E7-1C53-4E13-A486-5357C571EEBD', 3, '3453B99A-B925-4373-912F-1B1F1CF8CC3D'),('458F129D-ECC0-401C-B54B-709222DB7E22', 57, 'C2B3617D-EA47-49B1-9820-2448E5D82642', 3, '14104FB8-86A3-48C8-8D08-9E1B528748E6'),('A8C7292D-9B4E-479A-8531-6352C6E3BB23', 47, 'C2B3617D-EA47-49B1-9820-2448E5D82642', 3, '14104FB8-86A3-48C8-8D08-9E1B528748E6'),('F1C7BB60-C6CD-4820-9FCB-1F1060728601', 56, 'C2B3617D-EA47-49B1-9820-2448E5D82642', 3, '14104FB8-86A3-48C8-8D08-9E1B528748E6'),('7EFB701D-5A5B-4FC4-8EA0-83A107E580E5', 46, 'C2B3617D-EA47-49B1-9820-2448E5D82642', 3, '14104FB8-86A3-48C8-8D08-9E1B528748E6'),('039359FD-F941-4BAB-91AD-14F172F3C2FA', 86, 'B4107EA4-C48F-4EEF-96EC-C86A0D658DA8', 2, '3AAA72DB-040F-4ECC-B601-1636BE557EC7'),('DEBA2E78-A9DB-4588-90BC-7C35973414DF', 87, 'B4107EA4-C48F-4EEF-96EC-C86A0D658DA8', 2, '3AAA72DB-040F-4ECC-B601-1636BE557EC7'),('79A32CE4-CC68-442C-B32F-F473AD7CFCE5', 62, '39CDC233-49AF-4B32-AAE8-A62E220384CB', 2, '3453B99A-B925-4373-912F-1B1F1CF8CC3D'),('EA28D8A7-15C7-4791-B0ED-41DF5282D4E6', 51, '39CDC233-49AF-4B32-AAE8-A62E220384CB', 3, '3453B99A-B925-4373-912F-1B1F1CF8CC3D'),('C9872E41-04A8-4C66-AE05-E0EF517CE6EF', 61, '39CDC233-49AF-4B32-AAE8-A62E220384CB', 2, '3453B99A-B925-4373-912F-1B1F1CF8CC3D'),('30255BF0-B831-44BC-8618-DF8A913D0A5D', 52, '39CDC233-49AF-4B32-AAE8-A62E220384CB', 3, '3453B99A-B925-4373-912F-1B1F1CF8CC3D'),('D324BE8A-8F6E-4418-854C-ECA775547DCA', 65, 'F09F2133-3EA1-4B63-B023-B8C1CFAFF81E', 2, '4CFEEDE7-079F-4FAF-8E9B-A63A1B18DAAE'),('2CC17C79-E8FE-4478-ABB3-C2A0FDD433FD', 66, 'F09F2133-3EA1-4B63-B023-B8C1CFAFF81E', 2, '4CFEEDE7-079F-4FAF-8E9B-A63A1B18DAAE'),('A2C380F7-1D61-4938-965E-C6BC64D37190', 55, 'F09F2133-3EA1-4B63-B023-B8C1CFAFF81E', 3, '4CFEEDE7-079F-4FAF-8E9B-A63A1B18DAAE'),('E473D508-F355-47EE-89BF-0C3853545B8E', 56, 'F09F2133-3EA1-4B63-B023-B8C1CFAFF81E', 3, '4CFEEDE7-079F-4FAF-8E9B-A63A1B18DAAE')
;
COMMIT;
ALTER TABLE "customer" ADD CONSTRAINT "customer_pkey" PRIMARY KEY ("customer_id");
ALTER TABLE "invoice" ADD CONSTRAINT "invoice_pkey" PRIMARY KEY ("invoice_id");
ALTER TABLE "movie" ADD CONSTRAINT "movie_pkey" PRIMARY KEY ("movie_id");
ALTER TABLE "room" ADD CONSTRAINT "room_pkey" PRIMARY KEY ("room_number");
ALTER TABLE "seatclass" ADD CONSTRAINT "seatclass_pkey" PRIMARY KEY ("id");
ALTER TABLE "showtime" ADD CONSTRAINT "showtime_pkey" PRIMARY KEY ("showtime_id");
ALTER TABLE "ticket" ADD CONSTRAINT "ticket_pkey" PRIMARY KEY ("ticket_id");
ALTER TABLE "customer" ADD CONSTRAINT "customer_username_key" UNIQUE ("username");
ALTER TABLE "invoice" ADD CONSTRAINT "fk_invoice_customer_id" FOREIGN KEY ("customer_id") REFERENCES "public"."customer" ("customer_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "movie" ADD CONSTRAINT "movie_title_key" UNIQUE ("title");
ALTER TABLE "showtime" ADD CONSTRAINT "fk_showtime_movie_id" FOREIGN KEY ("movie_id") REFERENCES "public"."movie" ("movie_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "showtime" ADD CONSTRAINT "fk_showtime_room_number" FOREIGN KEY ("room_number") REFERENCES "public"."room" ("room_number") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "ticket" ADD CONSTRAINT "fk_ticket_invoice_id" FOREIGN KEY ("invoice_id") REFERENCES "public"."invoice" ("invoice_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "ticket" ADD CONSTRAINT "fk_ticket_seatclass_id" FOREIGN KEY ("seatclass_id") REFERENCES "public"."seatclass" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "ticket" ADD CONSTRAINT "fk_ticket_showtime_id" FOREIGN KEY ("showtime_id") REFERENCES "public"."showtime" ("showtime_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
SELECT setval('"seat_class_sequence"', 15950, true);
ALTER SEQUENCE "seat_class_sequence" OWNER TO "admin";
SELECT setval('"the_sequence_name"', 16000, true);
ALTER SEQUENCE "the_sequence_name" OWNER TO "admin";
