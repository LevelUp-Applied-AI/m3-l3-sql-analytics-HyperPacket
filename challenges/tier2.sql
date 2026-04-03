-- Tier 2 — Dynamic Reporting with Views and Functions

-- 1. Department summary view
CREATE OR REPLACE VIEW department_summary AS
SELECT 
    d.department_id,
    d.name AS department_name,
    COUNT(e.employee_id) AS employee_count,
    COALESCE(SUM(e.salary), 0) AS total_salary
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.name;


-- 2. Project status view
CREATE OR REPLACE VIEW project_status AS
SELECT 
    p.project_id,
    p.name AS project_name,
    p.department_id,
    d.name AS department_name,
    p.budget,
    COALESCE(SUM(pa.hours_allocated), 0) AS total_allocated_hours,
    CASE 
        WHEN COALESCE(SUM(pa.hours_allocated), 0) > p.budget THEN 'Over Budget'
        WHEN COALESCE(SUM(pa.hours_allocated), 0) > p.budget * 0.8 THEN 'At Risk'
        ELSE 'On Track'
    END AS status
FROM projects p
JOIN departments d ON p.department_id = d.department_id
LEFT JOIN project_assignments pa ON p.project_id = pa.project_id
GROUP BY p.project_id, p.name, p.department_id, d.name, p.budget;


-- Explore materialized views
-- Difference: A standard VIEW is a saved query that executes every time it is referenced.
-- A MATERIALIZED VIEW executes the query once and physically stores the data (like a table).
-- This significantly speeds up read times for complex reports, but the data becomes stale 
-- and must be manually refreshed using `REFRESH MATERIALIZED VIEW`.
CREATE MATERIALIZED VIEW project_status_mat AS
SELECT * FROM project_status;

-- Refresh command to update materialized data:
-- REFRESH MATERIALIZED VIEW project_status_mat;


-- 3. PostgreSQL function (PL/pgSQL) returning JSON
CREATE OR REPLACE FUNCTION get_department_stats(dept_name VARCHAR) 
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_build_object(
        'employee_count', ds.employee_count,
        'total_salary', ds.total_salary,
        'active_projects', (
            SELECT COUNT(*) 
            FROM projects p
            JOIN departments d ON p.department_id = d.department_id
            WHERE d.name = dept_name
            AND (p.end_date IS NULL OR p.end_date >= CURRENT_DATE)
        )
    )
    INTO result
    FROM department_summary ds
    WHERE ds.department_name = dept_name;

    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- 4. Call scenarios:

-- Call the function from psql:
-- SELECT get_department_stats('Engineering');

-- Call the function from Python (using psycopg2):
/*
import psycopg2
import json

def fetch_dept_stats(department_name):
    try:
        conn = psycopg2.connect("dbname=testdb user=postgres password=mysecret host=localhost")
        cur = conn.cursor()
        
        # Execute the function
        cur.execute("SELECT get_department_stats(%s);", (department_name,))
        stats = cur.fetchone()[0] # The function returns a single JSON object
        
        print(f"Stats for {department_name}:")
        print(json.dumps(stats, indent=2))
        
        cur.close()
        conn.close()
    except Exception as e:
        print(f"Database error: {e}")

# Example usage:
# fetch_dept_stats('Engineering')
*/
