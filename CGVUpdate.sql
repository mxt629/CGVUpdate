USE CGV
GO
IF EXISTS (SELECT * FROM sys.databases WHERE name='CGVUpdate')
DROP DATABASE CGVUpdate
GO
CREATE DATABASE CGVUpdate
GO
USE CGVUpdate
GO

CREATE TABLE Customers (
    CusID INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(20),
    Phone VARCHAR(10),
    Address NVARCHAR(30),
    Email VARCHAR(30),
    BOD VARCHAR(20)
)
GO
INSERT INTO Customers(Name,Phone,Address,Email,BOD) VALUES (N'Mai Xuân Tiến','0988362662',N'Đội Nhân,Hà Nội','xuantien.6290@gmail.com','02-06-1990'),
                                                            (N'Nguyễn Bá Quốc','0842252000',N'Đan Phượng,Hà Nội','baquoc@gmail.com','11-12-2000'),
                                                            (N'Nguyễn Đình Hiến','0946299388',N'Trung Kính,Hà Nội','dinhhien@gmail.com','11-09-1995'),
                                                            (N'Tống Minh Dương','0374148897',N'Láng,Hà Nội','minhduong@gmail.com','08-08-1997')


CREATE TABLE Booking(
    BookingID INT IDENTITY(100,1) PRIMARY KEY,
    CusID INT CONSTRAINT FK_C FOREIGN KEY (CusID) REFERENCES Customers(CusID),
    PurchaseDate DATE 
)
GO
INSERT INTO Booking(CusID,PurchaseDate) VALUES (1,'06-15-2022'),
                                                (2,'06-14-2022'),
                                                (3,'06-16-2022'),
                                                (4,'06-15-2022')


CREATE TABLE OrderFood(
    OrderFID INT IDENTITY (50,1) PRIMARY KEY,
    CusID INT CONSTRAINT FK_CUS FOREIGN KEY (CusID) REFERENCES Customers(CusID),
)
GO
INSERT INTO OrderFood(CusID) VALUES (1),(2),(3),(4)



CREATE TABLE Foods(
    FoodID INT IDENTITY(300,1) PRIMARY KEY,
    FoodType INT DEFAULT 0 CHECK (FoodType IN(0,1,2)),   -- Loại đồ ăn: 0:Bỏng , 1: Nước, 2:Combo  --
    Name NVARCHAR(50),
    Size INT DEFAULT 0 CHECK (Size IN (0,1)),   -- Kích cỡ: 0: Cỡ M, 1: Cỡ L --
    Price MONEY
)
GO
INSERT INTO Foods(FoodType,Name,Size,Price) VALUES (0,N'Bỏng thường',0,35000),
                                                    (0,N'Bỏng Phô Mai',0,35000),
                                                    (0,N'Bỏng Chocolate',0,35000),
                                                    (0,N'Bỏng thường',1,45000),
                                                    (0,N'Bỏng Phô Mai',1,45000),
                                                    (0,N'Bỏng Chocolate',1,45000),
                                                    (1,N'Pepsi',0,40000),
                                                    (1,N'Fanta',0,40000),
                                                    (1,N'Milo',0,40000),
                                                    (1,N'Pepsi',1,50000),
                                                    (1,N'Fanta',1,50000),
                                                    (1,N'Milo',1,50000),
                                                    (2,N'Combo Bỏng to Nước nhỏ',0,80000),
                                                    (2,N'Combo Bỏng to Nước to',1,90000)

CREATE TABLE OrderDetails(
    OrderFID INT CONSTRAINT FK_OF FOREIGN KEY (OrderFID) REFERENCES OrderFood(OrderFID),
    FoodID INT CONSTRAINT FK_F FOREIGN KEY (FoodID) REFERENCES Foods(FoodID),
    Unit VARCHAR(10),
    Price MONEY,
    Quantity INT
)
GO

INSERT INTO OrderDetails(OrderFID,FoodID,Unit,Price,Quantity) VALUES    (50,307,N'Cốc',40000,2),
                                                                        (51,305,N'Gói',45000,2),
                                                                        (52,312,N'Combo',80000,1),
                                                                        (53,313,N'Combo',90000,1)

CREATE TABLE Dates(
    DateID INT IDENTITY (400,1) PRIMARY KEY,
    Dates DATE CHECK (Dates >= GETDATE() and Dates < (getdate() + 30))
)
GO
INSERT INTO Dates(Dates) VALUES ('06-25-2022'),
                                ('06-20-2022'),
                                ('06-26-2022'),
                                ('06-24-2022'),
                                ('06-21-2022'),
                                ('07-17-2022')

CREATE TABLE Citys(
    CityID INT IDENTITY (200,1) PRIMARY KEY,
    DateID INT CONSTRAINT FK_D FOREIGN KEY (DateID) REFERENCES Dates(DateID),
    Name NVARCHAR(20) NOT NULL UNIQUE
)
GO

INSERT INTO Citys(DateID,Name) VALUES   (400,N'Nam Định'),
                                        (400,N'Hồ Chí Minh'),
                                        (400,N'Hà Nội'),
                                        (400,N'Đà Nẵng')

CREATE TABLE Cinemas(
    CinemaID INT IDENTITY (500,1) PRIMARY KEY,
    CityID INT CONSTRAINT FK_CI FOREIGN KEY (CityID) REFERENCES Citys(CityID),
    Name NVARCHAR(50) NOT NULL UNIQUE
)
GO
INSERT INTO Cinemas(CityID,Name) VALUES (201,N'CGV Quận 1'),
                                        (201,N'CGV Quận 2'),
                                        (201,N'CGV Quận 3'),
                                        (201,N'CGV Quận 4'),
                                        (202,N'CGV Vincom Royal City'),
                                        (202,N'CGV Vincom Bà Triệu'),
                                        (202,N'CGV Vincom Metropolis'),
                                        (202,N'CGV Vincom Nguyễn Chí Thanh')

CREATE TABLE Rooms(
    RoomID INT IDENTITY (600,1) PRIMARY KEY,
    CinemaID INT CONSTRAINT FK_CMN FOREIGN KEY (CinemaID) REFERENCES Cinemas(CinemaID),
    Types INT DEFAULT 0 CONSTRAINT CHK_RT CHECK(Types IN (0,1,2)),    -- Loại phòng: 0:2D , 1:3D , 2:4DX --
    Name VARCHAR(5) NOT NULL 
)
GO 
INSERT INTO Rooms(CinemaID,Types,Name) VALUES   (505,0,'Room1'),
                                                (505,1,'Room2'),
                                                (505,2,'Room3'),
                                                (506,0,'Room1'),
                                                (506,1,'Room2'),
                                                (506,2,'Room3'),
                                                (507,0,'Room1'),
                                                (507,1,'Room2'),
                                                (507,2,'Room3')


CREATE TABLE Seats(
    SeatID INT IDENTITY (700,1) PRIMARY KEY,
    RoomID INT CONSTRAINT FK_R FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
    Types INT DEFAULT 0 CONSTRAINT CHK_ST CHECK (Types IN (0,1,2)),    -- Loại ghế: 0:Ghế thường, 1: Ghế Vip, 2: SweetBox --
    Name VARCHAR (3) NOT NULL,
    Price Money
)
GO
INSERT INTO Seats(RoomID,Types,Name,Price) VALUES   (601,0,'A1',140000),
                                                    (601,0,'A2',140000),
                                                    (601,1,'B1',200000),
                                                    (601,1,'B2',200000),
                                                    (601,2,'C1',250000),
                                                    (601,2,'C2',250000),
                                                    (602,0,'A1',140000),
                                                    (602,0,'A2',140000),
                                                    (602,1,'B1',200000),
                                                    (602,1,'B2',200000),
                                                    (602,2,'C1',250000),
                                                    (602,2,'C2',250000)


CREATE TABLE Movies(
    MovieID INT IDENTITY (1000,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Formats INT DEFAULT 0 CONSTRAINT CHK_F CHECK (Formats IN (0,1,2) ), -- Định dạng phim: 0: 2D, 1:3D, 2:4DX --
    Types INT DEFAULT 0 CONSTRAINT CHK_T CHECK (Types IN (0,1,2)), -- Thể loại phim: 0: Hài hước, 1:Hành động , 2:Tình cảm --
    Director NVARCHAR (50) NOT NULL,
    Languages NVARCHAR(50) NOT NULL,
    ReleaseDate DATE,
    Duration NVARCHAR(20),
    MPAA INT DEFAULT 0 CONSTRAINT CHK_MPAA CHECK (MPAA IN (0,1,2))   -- Giới hạn độ tuổi: 0: Tất cả mng, 1:Từ 13 tuổi trở lên, 2: Từ 18 tuổi trở lên --
)
GO

INSERT INTO Movies(Name,Formats,Types,Director,Languages,ReleaseDate,Duration,MPAA) 
VALUES (N'Thế Giới Khủng Long: Lãnh Địa',1,1,N'Colin Trevorrow',N'Tiếng Việt','06-10-2022','147 Phút',1),
        (N'Em Và Trịnh',0,2,N'Phan Gia Nhật Linh',N'Tiếng Việt','06-17-2022','136 Phút',1),
        (N'Trịnh Công Sơn',0,2,N'Phan Gia Nhật Linh',N'Tiếng Việt','06-17-2022','95 Phút',1),
        (N'Phi Công Siêu Đẳng ',1,1,N'Joseph Kosinski',N'Tiếng Việt','05-27-2022','130 Phút',1),
        (N'HarryPotter Và Căn Phòng Bí Mật',0,2,N'Chris Columbus',N'Tiếng Việt','06-03-2022','161 Phút',0)

CREATE TABLE Schedule(
    ScheduleID INT IDENTITY (900,1) PRIMARY KEY,
    RoomID INT CONSTRAINT FK_RM FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
    MovieID INT CONSTRAINT FK_M FOREIGN KEY (MovieID)  REFERENCES Movies(MovieID),
    Time TIME
)
GO
INSERT INTO Schedule(RoomID,MovieID,Time) VALUES (601,1000,'14:20:00'),
                                                    (602,1003,'19:00:00')
CREATE TABLE BookingDetails(
    BookingID INT CONSTRAINT FK_B FOREIGN KEY (BookingID) REFERENCES Booking(BookingID),
    ScheduleID INT CONSTRAINT FK_SCH FOREIGN KEY (ScheduleID) REFERENCES Schedule(ScheduleID),
    SeatID INT CONSTRAINT FK_ST FOREIGN KEY (SeatID) REFERENCES Seats(SeatID),
    CONSTRAINT PK PRIMARY KEY (BookingID,ScheduleID,SeatID),
    Price MONEY,
    Quantity INT,
    ExportDate DATE
)
GO
INSERT INTO BookingDetails(BookingID,ScheduleID,SeatID,Price,Quantity,ExportDate) VALUES    (100,900,704,250000,1,'06-19-2022'),
                                                                                            (100,900,705,250000,1,'06-19-2022'),
                                                                                            (101,901,708,200000,1,'06-19-2022'),
                                                                                            (101,901,709,200000,1,'06-19-2022')

