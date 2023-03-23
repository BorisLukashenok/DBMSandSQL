from mysql.connector import connect, Error
from getpass import getpass

def head(data):
    return [i[0] for i in data]

def print_table(data, head, indent=1):

    # расчёт макимальной ширины колонок таблицы
    width = [max([len(el) for el in map(str, col)]) + 2 *
             indent for col in zip(*data, head)]
    width_table = sum(width) + len(head) + 1
    # печать шапки таблицы
    print('-' * width_table)
    for i, col in enumerate(head):
        print(f'|{col:^{width[i]}}', end='')
    print('|')
    print('-' * width_table)
    # печать тела таблицы
    for el in data:
        for i, col in enumerate(el):
            print(f'|{col:>{width[i] - indent}}{" " * indent}', end='')
        print('|')
    print('-' * width_table)


user = input(
    "Подключение к серверу.\nВведите имя пользователя(root по умолчанию): ")
if not user:
    user = 'root'
password = getpass("Введите пароль: ")

# Добавить ручной ввод навание базы и запрос на удаление если существует
base_name = 'product'


# Подключение к серверу и создание базы
try:
    with connect(
        host="localhost",
        user=user,
        password=password
    ) as connection:
        show_db_query = "SHOW DATABASES"
        with connection.cursor() as cursor:
            cursor.execute(show_db_query)
            answer = cursor.fetchall()
            if (base_name,) in answer:
                cursor.execute(f'DROP database {base_name}')
                connection.commit()
            cursor.execute(f'CREATE database {base_name}')
            cursor.execute(f'USE {base_name}')
            cursor.execute('''
                            CREATE TABLE sales(
                            id INT AUTO_INCREMENT PRIMARY KEY,
                            order_date date not null,
                            count_product int default 0)
                            '''
                           )
            cursor.execute('''
                            INSERT INTO sales(order_date, count_product)
                            values ('2022-01-01', 156),
                                ('2022-01-02', 180),
                                ('2020-01-03', 21),
                                ('2022-01-04', 124),
                                ('2020-01-05', 341)
                            '''
                           )
            cursor.execute('''
                            SELECT id AS 'id заказа',
                            CASE
                                WHEN count_product < 100 THEN 'Маленький заказ'
                                WHEN count_product BETWEEN 100 AND 300 THEN 'Средний заказ'
                                WHEN count_product > 300 THEN 'Большой заказ'
                                ELSE 'Не определено'
                                END AS 'Тип заказа'
                            FROM sales
                            '''
                           )
            
            print_table(cursor.fetchall(), head(cursor.description))
            cursor.execute('''
                            CREATE TABLE orders(
                                id INT AUTO_INCREMENT PRIMARY KEY,
                                employee_id varchar(10) not null,
                                amount decimal(10, 2),
                                order_status varchar(9)
                           )
                            '''
                           )            
            cursor.execute('''
                            INSERT INTO orders(employee_id, amount, order_status)
                            values ('e03', 15.00, 'OPEN'),
                                ('e01', 25.50, 'OPEN'),
                                ('e05', 100.70, 'CLOSED'),
                                ('e02', 22.18, 'OPEN'),
                                ('e04', 9.50, 'CANCELLED')
                            '''
                           )            
            cursor.execute('''
                            SELECT id AS 'id заказа',
                                employee_id AS 'Employee',
                            CASE
                                        WHEN order_status = 'OPEN' THEN 'Order is in open state'
                                        WHEN order_status = 'CLOSED' THEN 'Order is closed'
                                        WHEN order_status = 'CANCELLED' THEN 'Order is cancelled'
                                        ELSE 'Не определено'
                                END AS 'full_order_status'
                            FROM orders
                            '''
                           )
            print_table(cursor.fetchall(), head(cursor.description))

except Error as e:
    print(e)
