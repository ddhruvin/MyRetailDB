# MySQl-Proj
📷 Screenshots of Expected Output
tables

employee: ![Screenshot 2025-02-10 231709](https://github.com/user-attachments/assets/b3896caa-99d9-4c6c-a695-01518b1628d2)
orders: ![Screenshot 2025-02-10 234448](https://github.com/user-attachments/assets/38a3eb85-057a-4353-8a22-28cad41a8d29)
products: ![Screenshot 2025-02-10 235543](https://github.com/user-attachments/assets/c94ae1bd-f8b8-4557-afd3-0fbc8d526b72)

📷 Screenshots of Expected Output after querying
Fetch All Orders with Customer & Product Details
![image](https://github.com/user-attachments/assets/6b8b9673-1962-4a0c-8fe2-c513464274b0)

Calculate total revenue from all completed (Shipped or Delivered) orders
![image](https://github.com/user-attachments/assets/2f429df7-fab9-431e-aed9-0a2fe3a49f86)

Find the Most Purchased Product
![image](https://github.com/user-attachments/assets/cb4471c9-8ecd-406d-949d-38ae0c2bb6ce)

Count Orders by Status
![image](https://github.com/user-attachments/assets/62fb5c13-da56-4059-9d16-81fbdeffae5e)

Find Customers Who Have Ordered More Than Once
![image](https://github.com/user-attachments/assets/3f9abce0-f4e3-4834-84bb-92223fca4c69)

This procedure will insert a new order and automatically update the stock quantity.
![image](https://github.com/user-attachments/assets/71da79d5-99ec-4367-bbcb-e4072b747151)

This trigger prevents a product from going below zero stock.
![image](https://github.com/user-attachments/assets/aaadbf0d-d502-4573-8297-7236773c1239)


# Restore MySQL Database from SQL Dump

This guide explains how to recreate the retail database using the provided .sql file. Follow the steps below to restore the database and verify the data.

📌 Prerequisites

Ensure you have the following installed on your system:

MySQL Server (8.0 or later recommended)

MySQL Workbench (optional, for GUI-based import)

The provided .sql dump file (retail_backup.sql)

🔄 Restoring the Database

Using MySQL Command Line

Open Command Prompt (cmd) or Terminal

Login to MySQL using the following command:

mysql -u root -p

Enter your MySQL root password when prompted.

Create the retail database (if it does not exist):

CREATE DATABASE retail;

Exit MySQL by typing:

exit;

Restore the Database using mysql command:

mysql -u root -p retail < retail_backup.sql

This will import the database structure and data from the SQL file.

Using MySQL Workbench (GUI Method)

Open MySQL Workbench and connect to your MySQL server.

Go to Server → Data Import.

Select Import from Self-Contained File and choose retail_backup.sql.

Choose Target Schema as retail (or create one if needed).

Click Start Import and wait for the process to complete.

Once done, refresh the schema list and verify the tables.

✅ Verifying the Restoration

Once the database is restored, you can verify its contents:

Check Available Tables

SHOW TABLES;

Preview Sample Data

SELECT * FROM orders LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM customers LIMIT 5;

Check Database Size

SELECT table_schema AS "Database",
       ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS "Size (MB)"
FROM information_schema.tables
WHERE table_schema = "retail";



🛠 Troubleshooting

Error: Unknown table 'column_statistics' in information_schema

If you encounter this error while exporting or restoring, try using the --column-statistics=0 flag:

mysqldump -u root -p --column-statistics=0 --databases retail > retail_backup.sql

Error: mysqldump not recognized

Ensure MySQL is added to your system PATH or use the full path:

"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqldump.exe" -u root -p --databases retail > retail_backup.sql

🎯 Conclusion

Following this guide, you can successfully recreate the retail database from the provided .sql file. Ensure the database structure and data match the expected results using the verification steps.

For any issues, refer to the troubleshooting section or check MySQL logs for errors. 🚀

Happy coding! 🚀
