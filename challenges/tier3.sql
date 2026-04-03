-- Tier 3 — Schema Evolution and Migration

-- 1. Design a salary_history table
CREATE TABLE IF NOT EXISTS salary_history (
    history_id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL REFERENCES employees(employee_id),
    old_salary NUMERIC(10,2), -- NULL means it was their starting salary
    new_salary NUMERIC(10,2) NOT NULL CHECK (new_salary > 0),
    effective_date DATE NOT NULL,
    change_reason VARCHAR(200)
);

-- 2. Migration script
-- Backfill the table with one initial record per employee representing their current salary state
INSERT INTO salary_history (employee_id, old_salary, new_salary, effective_date, change_reason)
SELECT 
    employee_id,
    NULL, -- No known previous salary system prior to this
    salary,
    hire_date, -- We will assume their current salary has been in effect since their hire date for initial records
    'System Migration - Base Record'
FROM employees;

-- Seed historical realistic data (for testing the queries)
-- Let's give Employee 1 and Employee 2 some older salaries
INSERT INTO salary_history (employee_id, old_salary, new_salary, effective_date, change_reason) VALUES
(1, 75000.00, 80000.00, '2022-01-15', 'Initial Hire'),
(1, 80000.00, 88000.00, '2023-01-15', 'Annual Merit Increase'),
(2, 60000.00, 65000.00, '2022-03-01', 'Initial Hire'),
(2, 65000.00, 72000.00, '2023-03-01', 'Promotion');
-- Here, the record we inserted in the migration (95000 and 72000 acting as the latest)
-- will be considered the most recent increment.


-- 3. Queries against the new schema

-- Query A: Salary growth rate by department over time
-- Comparing average starting salaries vs average current salaries per department.
WITH initial_salaries AS (
    SELECT 
        e.department_id,
        AVG(sh.new_salary) AS avg_starting_salary
    FROM salary_history sh
    JOIN employees e ON sh.employee_id = e.employee_id
    WHERE sh.old_salary IS NULL OR sh.change_reason = 'Initial Hire'
    GROUP BY e.department_id
),
current_salaries AS (
    SELECT 
        department_id,
        AVG(salary) AS avg_current_salary
    FROM employees
    GROUP BY department_id
)
SELECT 
    d.name AS department_name,
    ROUND(i.avg_starting_salary, 2) AS avg_starting_salary,
    ROUND(c.avg_current_salary, 2) AS avg_current_salary,
    ROUND(((c.avg_current_salary - i.avg_starting_salary) / i.avg_starting_salary) * 100, 2) AS growth_percentage
FROM current_salaries c
JOIN initial_salaries i ON c.department_id = i.department_id
JOIN departments d ON c.department_id = d.department_id
ORDER BY growth_percentage DESC;


-- Query B: Employees due for salary review (no change in 12+ months)
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    d.name AS department_name,
    e.salary AS current_salary,
    MAX(sh.effective_date) AS last_salary_change
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN salary_history sh ON e.employee_id = sh.employee_id
GROUP BY e.employee_id, employee_name, department_name, e.salary
HAVING MAX(sh.effective_date) <= CURRENT_DATE - INTERVAL '1 year'
ORDER BY last_salary_change ASC;


-- 4. Brief Analysis (Production Migration Considerations)
/*
======================================================================
Production Migration Analysis:
======================================================================
1. Deployment Strategy: 
   In a live production environment, this migration needs to be done in phases.
   Phase 1: Create the new `salary_history` table (DDL only).
   Phase 2: Update the application code so that any new employee inserts or 
            salary updates write to BOTH `employees` and `salary_history`.
   Phase 3: Run the backfilling script to insert historical records for 
            existing employees. We can use bulk inserts or batching if the 
            table is large to avoid locking up the database.
   
2. Risks of Backfilling:
   - Performance: Doing a massive `INSERT INTO ... SELECT` on a live DB 
     might lock the `employees` table or slow down read queries.
   - Race Conditions: If a salary is updated exactly while the backfill script 
     is running, you might miss a record or insert a duplicate. To prevent this, 
     we should ensure Phase 2 (dual-writing) is fully deployed and stable before 
     starting the backfill.
   - Data Integrity: Deciding what to use for `effective_date`. In the script 
     above, we assumed `hire_date` as the starting point, but realistically 
     employees might have had multiple changes since being hired. Without prior 
     history, the base assumption will be slightly inaccurate.
======================================================================
*/
