import mysql.connector

connection = mysql.connector.connect(
  host="localhost",
  user="root",
  password="rfhfgtn",
  database="lesson_1",
  auth_plugin='mysql_native_password'
)

print(connection)

select_students_query= "SELECT * FROM students"
with connection.cursor() as cursor:
    cursor.execute(select_students_query)
    
    for row in cursor.fetchall():
        print(row)
