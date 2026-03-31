
-- Task 1: At-risk projects
-- Projects where total allocated hours exceed 80% of the project budget.
-- Treat budget as available hours for simplicity.

SELECT 
    p.name AS project_name,
    p.budget AS total_budget_hours,
    SUM(pa.hours_allocated) AS total_hours_allocated,
    ROUND((SUM(pa.hours_allocated)::numeric / p.budget) * 100, 2) AS utilization_percentage
FROM projects p
JOIN project_assignments pa ON p.project_id = pa.project_id
GROUP BY p.project_id, p.name, p.budget
HAVING SUM(pa.hours_allocated) > 0.8 * p.budget
ORDER BY utilization_percentage DESC;

-- Task 2: Cross-department analysis setup
-- First, add dept_id to projects to allow department-level project ownership.

ALTER TABLE projects ADD COLUMN dept_id INTEGER REFERENCES departments(department_id);

-- Assign projects to departments logically
UPDATE projects SET dept_id = 1 WHERE project_id IN (1, 2, 3, 8, 12); -- Engineering
UPDATE projects SET dept_id = 2 WHERE project_id IN (4);             -- Marketing
UPDATE projects SET dept_id = 7 WHERE project_id IN (5, 11, 13, 14, 15); -- Research
UPDATE projects SET dept_id = 6 WHERE project_id IN (6, 10);         -- Operations
UPDATE projects SET dept_id = 3 WHERE project_id IN (7);             -- Sales
UPDATE projects SET dept_id = 4 WHERE project_id IN (9);             -- HR

-- Task 2: Cross-department analysis query
-- Find employees assigned to projects in departments other than their own.

SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    d_emp.name AS employee_dept,
    p.name AS project_name,
    d_proj.name AS project_dept
FROM employees e
JOIN departments d_emp ON e.department_id = d_emp.department_id
JOIN project_assignments pa ON e.employee_id = pa.employee_id
JOIN projects p ON pa.project_id = p.project_id
JOIN departments d_proj ON p.dept_id = d_proj.department_id
WHERE e.department_id != p.dept_id
ORDER BY employee_name;


-- 2
-- Task 1: Department summary view
-- Includes employee count, total salary, and average salary.

CREATE OR REPLACE VIEW department_summary AS
SELECT 
    d.name AS department_name,
    COUNT(e.employee_id) AS employee_count,
    SUM(e.salary) AS total_salary,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.name;

-- Task 2: Project status view
-- Shows total hours, budget usage, and status based on allocation.

CREATE OR REPLACE VIEW project_status AS
SELECT 
    p.name AS project_name,
    p.budget AS budget_hours,
    COALESCE(SUM(pa.hours_allocated), 0) AS total_hours_allocated,
    CASE 
        WHEN COALESCE(SUM(pa.hours_allocated), 0) = 0 THEN 'Unstaffed'
        WHEN SUM(pa.hours_allocated) < 0.5 * p.budget THEN 'Healthy'
        WHEN SUM(pa.hours_allocated) <= 0.8 * p.budget THEN 'Warning'
        ELSE 'At-Risk'
    END AS status,
    ROUND((COALESCE(SUM(pa.hours_allocated), 0)::numeric / NULLIF(p.budget, 0)) * 100, 2) AS budget_utilization
FROM projects p
LEFT JOIN project_assignments pa ON p.project_id = pa.project_id
GROUP BY p.project_id, p.name, p.budget;

-- Task 3: Materialized View exploration
-- Materialized views are useful for complex analytics that don't need real-time data.

DROP MATERIALIZED VIEW IF EXISTS mv_department_stats;
CREATE MATERIALIZED VIEW mv_department_stats AS
SELECT 
    d.name AS department_name,
    COUNT(e.employee_id) AS headcount,
    SUM(e.salary) AS salary_pool,
    COUNT(DISTINCT pa.project_id) AS active_project_count
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
LEFT JOIN project_assignments pa ON e.employee_id = pa.employee_id
GROUP BY d.department_id, d.name;

-- Note: Materialized views must be manually refreshed.
-- REFRESH MATERIALIZED VIEW mv_department_stats;

-- Task 4: PL/pgSQL Function
-- Accepts department name, returns JSON with stats.

CREATE OR REPLACE FUNCTION get_department_stats(dept_name TEXT)
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_build_object(
        'department', d.name,
        'employee_count', COUNT(e.employee_id),
        'total_salary', SUM(e.salary),
        'active_projects', (
            SELECT COUNT(DISTINCT pa.project_id)
            FROM projects p
            JOIN project_assignments pa ON p.project_id = pa.project_id
            WHERE p.dept_id = d.department_id
        )
    ) INTO result
    FROM departments d
    LEFT JOIN employees e ON d.department_id = e.department_id
    WHERE d.name = dept_name
    GROUP BY d.department_id, d.name;

    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Example calls:
-- SELECT get_department_stats('Engineering');
-- SELECT get_department_stats('Research');


-- 3

-- Task 1: Design salary_history table
-- Tracks salary changes over time.

CREATE TABLE IF NOT EXISTS salary_history (
    history_id      SERIAL PRIMARY KEY,
    employee_id     INTEGER NOT NULL REFERENCES employees(employee_id),
    salary          NUMERIC(10,2) NOT NULL,
    change_date     DATE NOT NULL,
    reason          VARCHAR(255),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Task 2: Write a migration script that populates salary_history from the existing employees table
-- One initial record per employee at their current salary.

INSERT INTO salary_history (employee_id, salary, change_date, reason)
SELECT employee_id, salary, hire_date, 'Initial Salary'
FROM employees
ON CONFLICT DO NOTHING;

-- Task 3: Seed historical data (simulating 2-3 changes over 3 years)
-- For demonstration, increment salaries by 5-10% for some employees.

INSERT INTO salary_history (employee_id, salary, change_date, reason)
SELECT 
    employee_id, 
    salary * 1.10, 
    hire_date + INTERVAL '1 year', 
    'Annual Performance Review'
FROM employees
WHERE hire_date < CURRENT_DATE - INTERVAL '1 year';

INSERT INTO salary_history (employee_id, salary, change_date, reason)
SELECT 
    employee_id, 
    salary * 1.21, 
    hire_date + INTERVAL '2 years', 
    'Promotion'
FROM employees
WHERE hire_date < CURRENT_DATE - INTERVAL '2 years';

-- Task 4: Write queries against the new schema

-- A. Salary growth rate by department over time
-- Using window functions to calculate growth from the first record.

WITH dept_history AS (
    SELECT 
        d.name AS department_name,
        sh.change_date,
        sh.salary,
        FIRST_VALUE(sh.salary) OVER (PARTITION BY sh.employee_id ORDER BY sh.change_date) AS starting_salary
    FROM salary_history sh
    JOIN employees e ON sh.employee_id = e.employee_id
    JOIN departments d ON e.department_id = d.department_id
)
SELECT 
    department_name,
    EXTRACT(YEAR FROM change_date) AS year,
    ROUND(AVG(salary), 2) AS current_avg_salary,
    ROUND(AVG(starting_salary), 2) AS starting_avg_salary,
    ROUND(((AVG(salary) - AVG(starting_salary)) / NULLIF(AVG(starting_salary), 0)) * 100, 2) AS growth_percentage
FROM dept_history
GROUP BY department_name, year
ORDER BY department_name, year;

-- B. Employees due for salary review (no change in 12+ months)

SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    e.title,
    d.name AS department_name,
    MAX(sh.change_date) AS last_review_date
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN salary_history sh ON e.employee_id = sh.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.title, d.name
HAVING MAX(sh.change_date) < CURRENT_DATE - INTERVAL '12 months'
ORDER BY last_review_date;
