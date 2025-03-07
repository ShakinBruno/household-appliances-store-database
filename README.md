# Household Appliances Store Database

## Project Overview
This repository contains the PostgreSQL implementation of a relational database for a Household Appliances Store. The project aims to streamline the store's operations by efficiently managing inventory, customer orders, suppliers, and employees. The database structure ensures data consistency, reduces redundancy, and improves overall operational efficiency.

## Database Design
The database is designed using a structured relational model that includes:
- **Customers**: Stores customer details.
- **Employees**: Manages employee information.
- **Brands & Models**: Defines appliance brands and their specific models.
- **Appliances**: Maintains details of available appliances.
- **Categories**: Classifies appliances into different categories.
- **Suppliers**: Tracks suppliers providing products to the store.
- **Orders**: Records customer purchases and their statuses.
- **Order Items**: Defines products included in each order.
- **Stock & Supply**: Manages supplier stock levels and pricing.

## Entity-Relationship Model
The database follows a structured ER model, ensuring:
- **One-to-Many Relationships**: Customers placing multiple orders, employees processing multiple orders.
- **Many-to-Many Relationships**: Suppliers providing multiple appliances, orders containing multiple appliances.
- **Constraints & Validations**: Ensuring data integrity through primary keys, foreign keys, and data validation rules.

### Conceptual Schema
The conceptual schema provides a high-level overview of the database structure, illustrating major entities and their relationships.

![Conceptual Schema](https://github.com/user-attachments/assets/130c17a3-01e0-4f9e-8520-7cfbeb61c8ad)

### Logical Schema
The logical schema details the attributes, relationships, and constraints between entities, reflecting how data is structured in the database.

![Logical Schema](https://github.com/user-attachments/assets/c96246d4-5031-42ea-9adc-6ffbba107d19)

## Repository Structure
- **`household_appliances_DDL.sql`**: Contains the SQL script for database schema creation.
- **`household_appliances_DML.sql`**: Contains SQL statements for inserting sample data.

## 🛠️ Setup & Installation
To set up the database on your local system:
1. Install PostgreSQL.
2. Execute the DDL script to create the database schema:
   ```sql
   psql -U your_username -d household_appliances -f household_appliances_DDL.sql
   ```
3. Load sample data using the DML script:
   ```sql
   psql -U your_username -d household_appliances -f household_appliances_DML.sql
   ```
4. Verify the database by running queries:
   ```sql
   SELECT * FROM MANAGEMENT.CUSTOMERS;
   SELECT * FROM MANAGEMENT.APPLIANCES;
   ```
