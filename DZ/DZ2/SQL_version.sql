DROP database product;
CREATE database product;
use product;
CREATE TABLE sales(
      id INT AUTO_INCREMENT PRIMARY KEY,
      order_date date not null,
      count_product int default 0
);
INSERT INTO sales(order_date, count_product)
values ('2022-01-01', 156),
      ('2022-01-02', 180),
      ('2020-01-03', 21),
      ('2022-01-04', 124),
      ('2020-01-05', 341);
SELECT id AS 'id заказа',
CASE
            WHEN count_product < 100 THEN 'Маленький заказ'
            WHEN count_product BETWEEN 100 AND 300 THEN 'Средний заказ'
            WHEN count_product > 300 THEN 'Большой заказ'
            ELSE 'Не определено'
      END AS 'Тип заказа'
FROM sales;
CREATE TABLE orders(
      id INT AUTO_INCREMENT PRIMARY KEY,
      employee_id varchar(10) not null,
      amount decimal(10, 2),
      order_status varchar(9)
);
INSERT INTO orders(employee_id, amount, order_status)
values ('e03', 15.00, 'OPEN'),
      ('e01', 25.50, 'OPEN'),
      ('e05', 100.70, 'CLOSED'),
      ('e02', 22.18, 'OPEN'),
      ('e04', 9.50, 'CANCELLED');
SELECT id AS 'id заказа',
      employee_id AS 'Employee',
CASE
            WHEN order_status = 'OPEN' THEN 'Order is in open state'
            WHEN order_status = 'CLOSED' THEN 'Order is closed'
            WHEN order_status = 'CANCELLED' THEN 'Order is cancelled'
            ELSE 'Не определено'
      END AS 'full_order_status'
FROM orders;