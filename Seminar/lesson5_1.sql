DROP DATABASE IF EXISTS lesson_5;
CREATE DATABASE lesson_5;
USE lesson_5;

-- Персонал
DROP TABLE IF EXISTS staff;
CREATE TABLE staff (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	firstname VARCHAR(45),
	lastname VARCHAR(45),
	post VARCHAR(100),
	seniority INT, 
	salary INT, 
	age INT
);

-- Наполнение данными
INSERT INTO staff (firstname, lastname, post, seniority, salary, age)
VALUES
('Вася', 'Петров', 'Начальник', '40', 100000, 60),
('Петр', 'Власов', 'Начальник', '8', 70000, 30),
('Катя', 'Катина', 'Инженер', '2', 70000, 25),
('Саша', 'Сасин', 'Инженер', '12', 50000, 35),
('Ольга', 'Васютина', 'Инженер', '2', 70000, 25),
('Петр', 'Некрасов', 'Уборщик', '36', 16000, 59),
('Саша', 'Петров', 'Инженер', '12', 50000, 49),
('Иван', 'Сидоров', 'Рабочий', '40', 50000, 59),
('Петр', 'Петров', 'Рабочий', '20', 25000, 40),
('Сидр', 'Сидоров', 'Рабочий', '10', 20000, 35),
('Антон', 'Антонов', 'Рабочий', '8', 19000, 28),
('Юрий', 'Юрков', 'Рабочий', '5', 15000, 25),
('Максим', 'Максимов', 'Рабочий', '2', 11000, 22),
('Юрий', 'Галкин', 'Рабочий', '3', 12000, 24),
('Людмила', 'Маркина', 'Уборщик', '10', 10000, 49),
('Юрий', 'Онегин', 'Начальник', '8', 100000, 39);

-- ОКОННЫЕ ФУНКЦИИ

-- Ранжирование 
-- Вывести список всех сотрудников и указать место в рейтинге по зарплатам

SELECT 
	DENSE_RANK() OVER(ORDER BY salary DESC) AS rank_salary, 
	CONCAT(firstname, ' ', lastname),
	post, 
	salary
FROM staff;

-- Вывести список всех сотрудников и указать место в рейтинге по зарплатам, но по каждой должности
SELECT 
	DENSE_RANK() OVER(PARTITION BY post ORDER BY salary DESC) AS rank_salary, 
	CONCAT(firstname, ' ', lastname),
	post, 
	salary
FROM staff;

-- Найти самых высокооплачиваемых сотрудников по каждой должности

SELECT rank_salary, 
	staff,
	post, 
	salary
FROM 	
(SELECT 
	DENSE_RANK() OVER(PARTITION BY post ORDER BY salary DESC) AS rank_salary, 
	CONCAT(firstname, ' ', lastname) AS staff,
	post, 
	salary
FROM staff) AS list
WHERE rank_salary=1
ORDER BY salary DESC;
	
-- Сравнение со смещением 

-- Вывести список всех сотрудников, отсортировав по зарплатам в порядке убывания и 
-- указать на сколько процентов ЗП меньше, чем у сотрудника со следующей (по значению) зарплатой

SELECT 
	id,
	CONCAT(firstname, ' ', lastname) AS staff,
	post, 
	salary,
	LEAD(salary, 1, 0) OVER(ORDER BY salary DESC) AS last_salary, 
	ROUND((salary-LEAD(salary, 1, 0) OVER(ORDER BY salary DESC))*100/salary) AS diff_percent
FROM staff;


--  Агрегация

-- Вывести всех сотрудников, отсортировав по зарплатам в рамках каждой должности и рассчитать:
-- общую сумму зарплат для каждой должности
-- процентное соотношение каждой зарплаты от общей суммы по должности
-- среднюю зарплату по каждой должности 
-- процентное соотношение каждой зарплаты к средней зарплате по должности

SELECT 
	id,
	CONCAT(firstname, ' ', lastname) AS staff,
	post, 
	salary,
	SUM(salary) OVER w AS sum_salary,
	ROUND(salary*100/SUM(salary) OVER w) AS percent_sum, 
	AVG(salary) OVER w AS avg_salary,
	ROUND(salary*100/AVG(salary) OVER w) AS percent_avg
FROM staff
WINDOW w AS (PARTITION BY post);  

-- примеры использования оконных функций
SELECT 
	id, firstname, lastname, salary,
	ROW_NUMBER() OVER(ORDER BY salary DESC) AS 'ROW_NUMBER', 
	RANK() OVER(ORDER BY salary DESC) AS 'RANK',
 	DENSE_RANK() OVER(ORDER BY salary DESC) AS 'DENSE_RANK',
 	NTILE(3) OVER(ORDER BY salary DESC) AS 'NTILE'
FROM staff;



-- Оценки учеников
DROP TABLE IF EXISTS academic_record;
CREATE TABLE academic_record (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	name VARCHAR(45),
	quartal  VARCHAR(45),
    subject VARCHAR(45),
	grade INT
);

INSERT INTO academic_record (name, quartal, subject, grade)
values
	('Александр','1 четверть', 'математика', 4),
	('Александр','2 четверть', 'русский', 4),
	('Александр', '3 четверть','физика', 5),
	('Александр', '4 четверть','история', 4),
	('Антон', '1 четверть','математика', 4),
	('Антон', '2 четверть','русский', 3),
	('Антон', '3 четверть','физика', 5),
	('Антон', '4 четверть','история', 3),
    ('Петя', '1 четверть', 'физика', 4),
	('Петя', '2 четверть', 'физика', 3),
	('Петя', '3 четверть', 'физика', 4),
	('Петя', '2 четверть', 'математика', 3),
	('Петя', '3 четверть', 'математика', 4),
	('Петя', '4 четверть', 'физика', 5);


/*  Получить с помощью оконных функции:
- средний балл ученика 
- наименьшую оценку ученика
- наибольшую оценку ученика
- сумму всех оценок ученика
- количество всех оценок*/


-- с использованием псевдонима

/* Получить информацию об оценках Пети по четвертям: 
- текущая успеваемость по физике
- оценка по физике в следующей четверти
- оценка по физике в предыдущей четверти
 */

