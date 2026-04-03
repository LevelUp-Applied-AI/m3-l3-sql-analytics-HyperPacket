-- Tier 1 — Complex Analytics Queries

-- 1. Identify "at-risk" projects: 
-- Projects where total allocated hours exceed 80% of the project budget (treat budget as available hours).
SELECT 
    p.project_id,
    p.name AS project_name,
    p.budget AS available_hours,
    SUM(pa.hours_allocated) AS total_allocated_hours
FROM projects p
JOIN project_assignments pa ON p.project_id = pa.project_id
GROUP BY p.project_id, p.name, p.budget
HAVING SUM(pa.hours_allocated) > (p.budget * 0.80);


-- 2. Cross-department analysis: 
-- Find employees who are assigned to projects in departments other than their own.
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    d_emp.name AS employee_department,
    p.name AS project_name,
    d_proj.name AS project_department
FROM employees e
JOIN departments d_emp ON e.department_id = d_emp.department_id
JOIN project_assignments pa ON e.employee_id = pa.employee_id
JOIN projects p ON pa.project_id = p.project_id
JOIN departments d_proj ON p.department_id = d_proj.department_id
WHERE e.department_id != p.department_id;
