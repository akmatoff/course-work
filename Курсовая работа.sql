
-- ===================================================== СОЗДАНИЕ ТАБЛИЦ =======================================================================================

-- Таблица "Части"
CREATE TABLE Units(
	UnitID int IDENTITY(1,1),
	UnitName varchar(80),
	DislocationPlaceID int,
	TroopsTypeID int,
	CONSTRAINT PK_Unit
	PRIMARY KEY (UnitID)
);

-- Таблица "Виды Войск"
CREATE TABLE TroopsTypes (
	TroopsTypeID int IDENTITY(1,1),
	TroopsTypeName varchar(80)
	CONSTRAINT PK_TroopsTypes
	PRIMARY KEY (TroopsTypeID)
);

-- Таблица "Места дислокации"
CREATE TABLE DislocationPlaces (
	DislocationPlaceID int IDENTITY(1,1),
	Country varchar(80),
	City varchar(80),
	Street varchar(80),
	Area int
	CONSTRAINT PK_DislocationPlaces
	PRIMARY KEY (DislocationPlaceID)
);

-- Таблица "Роты"
CREATE TABLE Companies (
	CompanyID int IDENTITY(1,1),
	CompanyName varchar(60),
	UnitID int, -- Добавил внешний ключ к части
	CONSTRAINT PK_Companies
	PRIMARY KEY (CompanyID)
);

-- Таблица "Личный состав"
CREATE TABLE Personnel (
	SoldierID int IDENTITY(1,1),
	Surname varchar(80),
	CompanyID int,
	SoldierRank varchar(60),
	BirthYear int,
	JoinYear int,
	Awards varchar(100),
	TakesPartInMilitaryEvents varchar(10)
	CONSTRAINT PK_Personnel
	PRIMARY KEY (SoldierID)
);


-- =================================================== ИЗМЕНЕНИЕ ТАБЛИЦ ============================================================================


-- Назначение внешнего ключа "Вид Войск"
ALTER TABLE Units
ADD CONSTRAINT FK_Units_TroopsTypes
FOREIGN KEY (TroopsTypeID) REFERENCES TroopsTypes(TroopsTypeID)
ON DELETE CASCADE;

-- Назначение внешнего ключа "Место дислокации"
ALTER TABLE Units
ADD CONSTRAINT FK_Units_DislocationPlaces
FOREIGN KEY (DislocationPlaceID) REFERENCES DislocationPlaces(DislocationPlaceID)
ON DELETE CASCADE;

-- Назначение внешнего ключа "Рота"
ALTER TABLE Personnel 
ADD CONSTRAINT FK_Peronnel_Companies
FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
ON DELETE CASCADE;

-- Назначение внешнего ключа "Часть"
ALTER TABLE Companies
ADD CONSTRAINT FK_Companies_Units
FOREIGN KEY (UnitID) REFERENCES Units(UnitID)
ON DELETE CASCADE;

-- Ограничение таблицы "Личный состав"
-- Добавление CHECK на поле "Участие в военных мероприятиях"
ALTER TABLE Personnel
ADD CONSTRAINT CK_TakesPartInMilitaryEvents
CHECK (TakesPartInMilitaryEvents LIKE 'Yes' OR TakesPartInMilitaryEvents LIKE 'No');

-- ================================================== ВНЕСЕНИЕ ДАННЫХ ==============================================================================


-- Внесение данных в таблицу "Места дислокации"
INSERT INTO DislocationPlaces(Country, City, Street, Area)
VALUES ('USA', 'Washington', 'Waterville', '820'),
('USA', 'Carson City', 'Emerson Dr', '550'),
('UK', 'Lincoln', 'Monks Rd', '512'),
('UK', 'Boston', 'Alfred St', '625'),
('Germany', 'Freienhagen', 'Anger', '812');

-- Внесение данных в таблицу "Виды войск"Ф
INSERT INTO TroopsTypes(TroopsTypeName) 
VALUES ('Air Force'),
('Ground Force'),
('Navy');

-- Внесение данных в таблицу "Части"
INSERT INTO Units(UnitName, DislocationPlaceID, TroopsTypeID) 
VALUES ('Wash It Now', 1, 2),
('Carson Military Unit', 2, 1),
('Lincoln Troops', 3, 3),
('Boston Military Unit', 4, 1),
('MEINEFREUND', 5, 2);

-- Внесение данных в таблицу "Роты"
INSERT INTO Companies(CompanyName, UnitID)
VALUES ('Blackbeard', 1),
('Flying Spaghetti Monster', 2),
('Crownheads', 3),
('Hot Tea', 4),
('Goose', 5),
('Whitebeard', 1),
('Brownbeard', 1)

-- Внесение данных в таблицу "Личный состав"
INSERT INTO Personnel(Surname, CompanyID, SoldierRank, BirthYear, JoinYear, Awards, TakesPartInMilitaryEvents)
VALUES 
('Smith', 1, 'Captain', '1985', '2005', '10 years of service', 'Yes'),
('Cookie', 1, 'Private', '2001', '2020', '', 'No'),
('Second Cookie', 1, 'Private', '2000', '2020', '', 'No'),
('Walker', 1, 'Lieutenant', '1993', '2013', '', 'Yes'),
('Talker', 1, 'Staff Sergeant', '1995', '2015', '', 'Yes'),
('Spaghetti', 1, 'Master Sergeant', '1994', '2014', '', 'Yes'),
('Stevenson', 2, 'Private', '2000', '2020', '', 'No'),
('Braley', 2, 'Lieutenant', '1993', '2013', 'Saved a soldier life', 'Yes'),
('Wilkinson', 2, 'Staff Sergeant', '1995', '2015', '', 'Yes'),
('Rock', 2, 'Captain', '1988', '2008', '', 'Yes'),
('Drew', 3, 'Staff Sergeant', '1995', '2015', '', 'Yes'),
('Tomato', 3, 'Private', '2000', '2020', '', 'No'),
('Raw Tomato', 3, 'Private', '2000', '2020', '', 'No'),
('Green Tomato', 3, 'First Sergeant', '1998', '2018', '', 'Yes'),
('Parker', 3, 'First Lieutenant', '1994', '2014', '', 'Yes'),
('Davis', 4, 'Master Sergeant', '1992', '2012', '', 'Yes'),
('Daniels', 4, 'First Lieutenant', '1994', '2014', '', 'Yes'),
('Winston', 4, 'Major', '1980', '2000', '', 'No'),
('Hudson', 5, 'Colonel', '1975', '1995', 'Best colonel', 'No'),
('Reining', 5, 'Staff Sergeant', '1995', '2015', '', 'Yes'),
('Yohunson', 6, 'Private', '2000', '2020', '', 'No'),
('Stevenson', 6, 'Captain', '1990', '2010', '', 'Yes'),
('Mayson', 6, 'Lieutenant', '1993', '2013', '', 'Yes'),
('Foy', 7, 'Master Sergeant', '1992', '2012', '', 'Yes'),
('Groot', 7, 'Private', '2000', '2020', '', 'No'),
('Hulk', 7, 'Staff Sergeabt', '1995', '2015', '', 'Yes');

-- ========================================================== ЗАПРОСЫ ============================================================================================


-- Выводим данные о роте, и считаем количество служащих
SELECT *, (
	SELECT COUNT(SoldierID)
	FROM Personnel 
	WHERE Personnel.CompanyID = Companies.CompanyID 
	) AS SoldiersCount FROM Companies

-- Выводим данные о частях и считаем количество рот
SELECT *, (
	SELECT COUNT(CompanyID) 
	FROM Companies
	WHERE Units.UnitID = Companies.UnitID
) AS CompanyCount FROM Units

-- Выводим данные о служащих вместе с информацией о длительности службы (в годах)
SELECT *, (2020 - JoinYear) AS ServiceLength FROM Personnel;

-- Выводим фамилию, звание и название роты, в которых состоит служащий
SELECT p.Surname, p.SoldierRank, c.CompanyName 
FROM Personnel p
JOIN Companies c
ON p.CompanyID = c.CompanyID

-- Выводим данные о военных частях с названием роты и количеством служащих 
SELECT c.UnitID, u.UnitName, c.CompanyName, (
	SELECT COUNT(SoldierID)
	FROM Personnel
	WHERE Personnel.CompanyID = c.CompanyID
) AS SoldiersCount
FROM Companies c
JOIN Units u
ON c.UnitID = u.UnitID

SELECT * FROM Personnel
SELECT * FROM DislocationPlaces
SELECT * FROM Companies
SELECT * FROM TroopsTypes

-- Объединяем BirthYear и JoinYear и выводим в одной колонке
SELECT BirthYear FROM Personnel
UNION
SELECT JoinYear FROM Personnel

-- Выводим BirthYear, которых нет в JoinYear
SELECT BirthYear FROM Personnel
EXCEPT
SELECT JoinYear FROM Personnel

-- Выводим годы, которые были в обеих колонках
SELECT BirthYear FROM Personnel
INTERSECT
SELECT JoinYear FROM Personnel

-- Выводим роту где 6 служащих
SELECT * FROM Companies
WHERE (
	SELECT COUNT(SoldierID) FROM Personnel
	WHERE Personnel.CompanyID = Companies.CompanyID
) = '6'

-- Вывод данных о служащих, не участвующих в военных мероприятиях
SELECT p.Surname, p.BirthYear, p.SoldierRank, c.CompanyName 
FROM Personnel p
JOIN Companies c
ON c.CompanyID = p.CompanyID
WHERE TakesPartInMilitaryEvents = 'No'

-- Вывод мест дислокаций в Соединенных Королевствах
SELECT * FROM DislocationPlaces
WHERE Country = 'UK'

