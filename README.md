# Sales & Customer Analytics | SQL Case Study

## Project Overview

This project analyzes sales, customers, products, employees, and regional performance using SQL Server.

The objective is to generate actionable business insights by analyzing sales performance, profitability, customer behavior, product categories, employee performance, and monthly sales trends.

---

## Business Problem

The company needs to understand:

- Which customers generate the highest revenue?
- Which products and categories perform best?
- Which customer segments generate the highest Net Sales?
- Which states and sales employees perform best?
- How do sales change month over month?
- Which areas generate the highest profit?

---

## Dataset

The project uses four datasets:

### Customers
Contains customer demographic and segmentation information.

### Products
Contains product, category, brand, price, and cost information.

### Orders
Contains order transactions, quantities, discounts, payment methods, and order status.

### Sales Employees
Contains sales employee and regional information.

---

## Project Structure

```text
Sales-Customer-Analytics/
│
├── dataset/
│   ├── Customers.csv
│   ├── Products.csv
│   ├── Orders.csv
│   └── Sales_Employees.csv
│
├── sql/
│   ├── 01_Create_Database_and_Tables.sql
│   ├── 02_Data_Validation.sql
│   ├── 03_Basic_Analysis.sql
│   ├── 04_Business_Analysis.sql
│   └── 05_Advanced_Analysis.sql
│
├── insights/
│   └── business_insights.md
│
└── README.md