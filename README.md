# SQL-First Data Engineering Exercise
Incremental ETL - Data Modeling - Data Quality - Repeatability

This exercise evaluates your ability to design and implement SQL-first data transformations, build a simple data warehouse model, and demonstrate incremental, idempotent ETL using Day 1 and Day 2 input files.

You may use any local SQL engine you prefer (SQL Server, Postgres, DuckDB, SQLite, etc.).
You may complete the exercise using plain SQL scripts or a framework such as dbt Core, SQLMesh, or Dataform.

Should you choose to use DBT, access the DBT Files folder here

Your work should reflect production-quality engineering fundamentals: incrementality, clean SQL, clear documentation, testing, and Git version control.

This session will be recorded for internal review. You are encouraged to explain verbally as you go, reasoning as you work etc., especially when making design decisions.

---

## Contents

    /data
       /SalesOrders_Day_One.csv
       /SalesOrders_Day_Two.csv

    /bi
       PowerBI_Template.pbix (optional starter file)

    /candidate
       (put all your SQL, documentation, tests, and notes here)

---

## Overview

You will:

1. Load Day 1 files into a SQL database.
2. Build a small, clear data warehouse model (facts/dims).
3. Implement an incremental, idempotent ELT pipeline using `updated_at` as a watermark.
4. Add data quality tests.
5. Document your model and assumptions.
6. Re-run your process on Day 2 files to validate correctness.
7. Create a Power BI Dashboard (or other BI tool) with a few charts you deem useful.

Your work will be reviewed for correctness, clarity, and real-world engineering thinking.

---

## Deliverables

Place all deliverables inside:

    /candidate

### Required

- SQL DDL scripts for staging tables
- SQL DDL scripts for warehouse tables (fact + dims)
- SQL scripts (or dbt models) implementing incremental and idempotent loads
- At least two data quality tests (SQL assertions or dbt tests)
- A README.md (inside `/candidate`) explaining:
  - Pipeline flow
  - Warehouse model
  - Incremental logic and watermark strategy
  - Assumptions and limitations
- A Power BI file (or other BI tool) with visual representations of the data

## Optional
- Additional tests, documentation, or lineage diagrams

---

## Step 1: Load Day 1 Data into Staging

Use the files from:

    /data/day1/

Create staging tables (for example: `stg_sales_orders`, `stg_customers`, `stg_products`) and load all Day 1 CSVs into your SQL engine.

Deliver:

- DDL scripts for staging tables
- Short notes in your `/candidate/README.md` describing how you imported the CSVs

---

## Step 2: Design a Minimal Warehouse Model

Build a simple star schema suitable for reporting.

Minimum:

- One fact table (for example: `fact_sales` at order-line grain)
- At least one dimension (for example: `dim_customer`)

Optional but encouraged:

- `dim_product`
- `dim_date`

Document primary keys, foreign keys (if supported), and column purposes.

Deliver:

- DDL scripts for fact and dimension tables
- Brief description of grain and keys in `/candidate/README.md`

---

## Step 3: Implement Incremental, Idempotent Loads

Your pipeline must satisfy all of the following:

### A. Filter out cancelled orders

Rows where:

    order_status = 'cancelled'

should not enter the fact table.

### B. Use `updated_at` as a watermark

On each run, process only rows where:

    updated_at > (max updated_at already loaded into the target table)

### C. Handle late-arriving updates

Use the Day 2 data to demonstrate that your logic correctly handles:

- Orders O1001 and O1002 with later `updated_at` timestamps
- Order O1002 changing from `pending` to `completed`
- Order O1003 remaining `cancelled` (and therefore still excluded)
- New orders O1004 and O1005

### D. Be idempotent

Re-running your Day 1 or Day 2 load scripts should:

- Not create duplicate rows
- Properly update changed rows
- Maintain referential integrity between fact and dimension tables

You may use any pattern appropriate to your stack:

- MERGE statements
- INSERT + UPDATE pattern
- dbt incremental models
- Equivalent engine-specific approach

Deliver:

- SQL scripts or dbt models that clearly implement your incremental logic
- Comments in the code explaining your approach

---

## Step 4: Add Data Quality Tests

Provide at least two data quality tests using SQL or dbt.

Recommended tests:

- Assert that `order_id` + `order_line_id` is unique in the fact table
- Assert that `customer_id` is not null in the fact table
- Optionally validate accepted values for `order_status`
- Optionally prevent negative quantities

Deliver:

- SQL scripts with assertions or dbt test files
- Brief notes in `/candidate/README.md` describing what each test ensures

---

## Step 5: Document Your Work

Create a `README.md` inside the `/candidate` folder explaining:

- End-to-end pipeline flow (from staging to warehouse)
- Fact and dimension design, including table grain
- Incremental logic and how you use the watermark
- How late-arriving data is handled
- Why cancelled orders are excluded from the fact table
- Any assumptions or limitations you identified
- Potential improvements if the dataset grew significantly

---

## Step 6: Run Your Process on Day 2 Data

Now use the files from:

    /data/day2/

Re-run your incremental pipeline (do not rebuild from scratch unless your design requires it; the goal is to test incrementality).

### Expected Results

- Orders O1001 and O1002 are updated to reflect the latest `updated_at` and status
- O1002 changes from `pending` to `completed` in the fact table
- O1003 remains excluded because it is `cancelled`
- O1004 is inserted as a new completed order
- O1005 is inserted as a new pending order
- Running the Day 2 load a second time does not create duplicates or change results

Document any observations in `/candidate/README.md`.

---

## Step 7: Create a BI View

Use Power BI (the empty `Sales_Dashboard.pbix`) or another BI tool to create visuals to describe the dashboards.

Example visuals:

- Revenue by month
- Top 5 customers by revenue
- Sales by product category

Place final file in:

    /candidate/bi

---

## Evaluation Criteria

### Technical

- Correct incremental logic and idempotency
- Solid warehouse modeling (facts, dimensions, grain, keys)
- Clear, maintainable SQL
- Appropriate use of keys and relationships
- Data quality mindset (tests and checks)
- Good documentation of approach and assumptions

### Engineering and Consulting Behaviors

- Clarity in explaining design choices
- Practical reasoning and tradeoffs
- Git hygiene (logical commits, useful messages)
- Clean folder and file structure under `/candidate`

---

## Version Control Expectations

All work for this exercise should be version-controlled in Git.

We will look for:

- Logical, incremental commits (for example, "create staging tables", "add incremental load")
- Clear and meaningful commit messages
- A sensible and organized `/candidate` directory


## BI Capabilities

- Working knowledge of importing data and building visuals representing that data.
---

## Time Expectation

Approximate time: 75 minutes, proctored via screen share.

You may reference documentation or syntax examples as needed.

---

## Questions During the Exercise

If anything in the prompt is unclear, ask the proctor for clarification.  
No technical hints will be provided, but we are happy to clarify requirements or constraints.

