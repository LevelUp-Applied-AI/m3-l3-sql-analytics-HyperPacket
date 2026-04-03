-- schema.sql — Levant Tech Solutions Database Schema
-- Module 3: SQL Analytics Lab
--
-- Run this file first to create all tables.
-- Usage: psql -h localhost -U postgres -d testdb -f schema.sql

DROP TABLE IF EXISTS project_assignments CASCADE;
DROP TABLE IF EXISTS projects CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

-- ============================================================
-- Table: departments
-- ============================================================
CREATE TABLE departments (
    department_id   SERIAL PRIMARY KEY,
    name            VARCHAR(100) NOT NULL UNIQUE,
    location        VARCHAR(100) NOT NULL
);

-- ============================================================
-- Table: employees
-- ============================================================
CREATE TABLE employees (
    employee_id     SERIAL PRIMARY KEY,
    first_name      VARCHAR(50)  NOT NULL,
    last_name       VARCHAR(50)  NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    title           VARCHAR(100) NOT NULL,
    salary          NUMERIC(10,2) NOT NULL CHECK (salary > 0),
    hire_date       DATE         NOT NULL,
    department_id   INTEGER      NOT NULL REFERENCES departments(department_id)
);

-- ============================================================
-- Table: projects
-- ============================================================
CREATE TABLE projects (
    project_id      SERIAL PRIMARY KEY,
    name            VARCHAR(150) NOT NULL,
    start_date      DATE         NOT NULL,
    end_date        DATE,
    budget          NUMERIC(12,2) NOT NULL CHECK (budget >= 0),
    department_id   INTEGER      NOT NULL REFERENCES departments(department_id)
);

-- ============================================================
-- Table: project_assignments
-- ============================================================
CREATE TABLE project_assignments (
    assignment_id   SERIAL PRIMARY KEY,
    employee_id     INTEGER NOT NULL REFERENCES employees(employee_id),
    project_id      INTEGER NOT NULL REFERENCES projects(project_id),
    role            VARCHAR(100) NOT NULL,
    hours_allocated INTEGER NOT NULL CHECK (hours_allocated > 0)
);
