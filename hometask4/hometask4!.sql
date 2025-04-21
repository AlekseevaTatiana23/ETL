
/*Задание 1: Создайте таблицу movies с полями movies_type, director, year_of_issue, length_in_minutes, rate.*/

DROP TABLE IF EXISTS movies CASCADE;

CREATE TABLE IF NOT EXISTS movies (
movies_id BIGINT NOT NULL PRIMARY KEY,
name CHARACTER VARYING NOT NULL,
movies_type CHARACTER VARYING NOT NULL,
director CHARACTER VARYING NOT NULL,
year_of_issue INT NOT NULL,
length_in_minutes INT NOT NULL,
rate REAL NOT NULL
);

/*2. Сделайте таблицы для горизонтального партицирования по году выпуска (до 1990, 1990 -2000, 2000- 2010, 2010-2020, после 2020). 
 * Создайте правила добавления данных для каждой таблицы.*/

CREATE TABLE IF NOT EXISTS year_before_1990 (
CHECK (year_of_issue<1990)) INHERITS (movies);

CREATE TABLE IF NOT EXISTS year_1990_2000 (
CHECK (year_of_issue>=1990 AND year_of_issue<2000)) INHERITS (movies);

CREATE TABLE IF NOT EXISTS year_2000_2010 (
CHECK (year_of_issue>=2000 AND year_of_issue<2010)) INHERITS (movies);

CREATE TABLE IF NOT EXISTS year_2010_2020 (
CHECK (year_of_issue>=2010 AND year_of_issue<2020)) INHERITS (movies);

CREATE TABLE IF NOT EXISTS year_after_2020 (
CHECK (year_of_issue>=2020)) INHERITS (movies);

CREATE RULE insert_into_year_before_1990
AS ON INSERT TO movies
WHERE (year_of_issue<1990)
DO INSTEAD INSERT INTO year_before_1990
VALUES (new.*);

CREATE RULE insert_into_year_1990_2000
AS ON INSERT TO movies
WHERE (year_of_issue>=1990 AND year_of_issue<2000)
DO INSTEAD INSERT INTO year_1990_2000
VALUES (new.*);

CREATE RULE insert_into_year_2000_2010
AS ON INSERT TO movies
WHERE (year_of_issue>=2000 AND year_of_issue<2010)
DO INSTEAD INSERT INTO year_2000_2010
VALUES (new.*);

CREATE RULE insert_into_year_2010_2020
AS ON INSERT TO movies
WHERE (year_of_issue>=2010 AND year_of_issue<2020)
DO INSTEAD INSERT INTO year_2010_2020
VALUES (new.*);

CREATE RULE insert_into_year_after_2020
AS ON INSERT TO movies
WHERE (year_of_issue>=2020)
DO INSTEAD INSERT INTO year_after_2020
VALUES (new.*);


/*3. Сделайте таблицы для горизонтального партицирования по длине фильма 
 * (до 40 минута, от 40 до 90 минут, от 90 до 130 минут, более 130 минут).
 * Создайте правила добавления данных для каждой таблицы.*/

CREATE TABLE IF NOT EXISTS length_less_than_40 (
CHECK (length_in_minutes<40)) INHERITS (movies);

CREATE TABLE IF NOT EXISTS length_40_90 (
CHECK (length_in_minutes>=40 AND length_in_minutes<90)) INHERITS (movies);

CREATE TABLE IF NOT EXISTS length_90_130 (
CHECK (length_in_minutes>=90 AND length_in_minutes<130)) INHERITS (movies);

CREATE TABLE IF NOT EXISTS length_more_than_130 (
CHECK (length_in_minutes>=130)) INHERITS (movies);

CREATE RULE insert_into_length_less_than_40
AS ON INSERT TO movies
WHERE (length_in_minutes<40)
DO INSTEAD INSERT INTO length_less_than_40
VALUES(new.*);

CREATE RULE insert_into_length_40_90
AS ON INSERT TO movies
WHERE (length_in_minutes>=40 AND length_in_minutes<90)
DO INSTEAD INSERT INTO length_40_90
VALUES(new.*);

CREATE RULE insert_into_length_90_130
AS ON INSERT TO movies
WHERE (length_in_minutes>=90 AND length_in_minutes<130)
DO INSTEAD INSERT INTO length_90_130
VALUES(new.*);

CREATE RULE insert_into_length_more_than_130
AS ON INSERT TO movies
WHERE (length_in_minutes>=130)
DO INSTEAD INSERT INTO length_more_than_130
VALUES(new.*);

/*4. Сделайте таблицы для горизонтального партицирования по рейтингу фильма (ниже 5, от 5 до 8, от 8 до 10).
5. Создайте правила добавления данных для каждой таблицы.*/

CREATE TABLE IF NOT EXISTS rate_less_than_5 (
CHECK (rate <5)) INHERITS (movies);

CREATE TABLE IF NOT EXISTS rate_5_8 (
CHECK (rate>=5 AND rate<8)) INHERITS (movies);

CREATE TABLE IF NOT EXISTS rate_8_10 (
CHECK (rate>=8 AND rate<=10)) INHERITS (movies);

CREATE RULE insert_to_rate_less_than_5
AS ON INSERT TO movies
WHERE (rate <5)
DO INSTEAD INSERT INTO rate_less_than_5
VALUES(new.*);

CREATE RULE insert_to_rate_upto_8
AS ON INSERT TO movies
WHERE (rate>=5 AND rate<8)
DO INSTEAD INSERT INTO rate_5_8
VALUES(new.*);

CREATE RULE insert_to_rate_upto_10
AS ON INSERT TO movies
WHERE (rate>=8 AND rate<=10)
DO INSTEAD INSERT INTO rate_8_10
VALUES(new.*);


/* 6.Добавьте фильмы так, чтобы в каждой таблице было не менее 3 фильмов.
 * 7. Добавьте пару фильмов с рейтингом выше 10.
 * 8. Сделайте выбор из всех таблиц, в том числе из основной.*/

INSERT INTO movies (movies_id, name, movies_type, director, year_of_issue, length_in_minutes, rate)
VALUES (1, 'Comedy', 'This Is Spinal Tap', 'Rob Reiner', 1984, 86, 6.9),
(2, 'Comedy', 'Groundhog Day', 'Harold Ramis', 1993, 132, 10),
(3, 'Animation', 'Team America: World Police', 'Trey Parker, Matt Stone', 2004, 98, 4.3),
(4, 'Horror', 'Corazón', 'John Hillcoat', 2018, 49, 7.2),
(5, 'Animation', 'The Spider Within: A Spider-Verse Story', 'Jarelle Dampier', 2023, 7, 7.1),
(6, 'Biography', 'Taylor Swift: All Too Well', 'Taylor Swift', 2021, 15, 8.4),
(7, 'Drama', 'The Wire', 'David Simon', 2002, 113, 11.2),
(8, 'Fantasy', 'Harry Potter and the Sorcerers Stone', 'Chris Columbus', 2001, 152, 14),
(9, 'Comedy', 'Samogonshiki', 'Leonid Gaidai', 1962, 19, 8.3);

SELECT * FROM movies;

SELECT * FROM year_before_1990;

SELECT * FROM year_1990_2000;

SELECT * FROM year_2000_2010;

SELECT * FROM year_2010_2020;

SELECT * FROM year_after_2020;

SELECT * FROM length_less_than_40;

SELECT * FROM length_40_90;

SELECT * FROM length_90_130;

SELECT * FROM length_more_than_130;

SELECT * FROM rate_less_than_5;

SELECT * FROM rate_5_8;

SELECT * FROM rate_8_10;

/*9. Сделайте выбор только из основной таблицы.*/

SELECT * FROM ONLY movies;


