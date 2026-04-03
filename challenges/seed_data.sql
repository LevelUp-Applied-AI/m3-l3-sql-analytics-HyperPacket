-- seed_data.sql — Levant Tech Solutions Sample Data
-- Module 3: SQL Analytics Lab
--
-- Run this file after schema.sql to populate all tables.
-- Usage: psql -h localhost -U postgres -d testdb -f seed_data.sql

-- ============================================================
-- Departments (8 departments, 4 Jordanian cities)
-- ============================================================
INSERT INTO departments (name, location) VALUES
('Engineering',       'Amman'),
('Marketing',         'Irbid'),
('Sales',             'Zarqa'),
('HR',                'Amman'),
('Finance',           'Aqaba'),
('Operations',        'Irbid'),
('Research',          'Amman'),
('Customer Support',  'Zarqa');

-- ============================================================
-- Employees (60 total, across all 8 departments)
-- Data designed so that:
--   - Several departments have total salary > 150,000
--   - Hire dates span 2022-01 through 2025-02
--   - Employees 51-60 are NOT assigned to any project (for Q7)
-- ============================================================

-- Engineering (employees 1-12) — total salary ~880,000
INSERT INTO employees (first_name, last_name, email, title, salary, hire_date, department_id) VALUES
('Layla',   'Haddad',   'layla.haddad@levanttech.com',    'Senior Software Engineer',  95000.00, '2022-01-15', 1),
('Omar',    'Khalil',   'omar.khalil@levanttech.com',     'Software Engineer',         72000.00, '2022-03-01', 1),
('Nour',    'Mansour',  'nour.mansour@levanttech.com',    'Software Engineer',         70000.00, '2022-06-20', 1),
('Tariq',   'Saleh',    'tariq.saleh@levanttech.com',     'DevOps Engineer',           85000.00, '2022-09-10', 1),
('Rania',   'Darwish',  'rania.darwish@levanttech.com',   'Data Engineer',             88000.00, '2023-01-05', 1),
('Fadi',    'Nasser',   'fadi.nasser@levanttech.com',     'Junior Developer',          52000.00, '2023-04-15', 1),
('Hana',    'Issa',     'hana.issa@levanttech.com',       'QA Engineer',               65000.00, '2023-07-22', 1),
('Sami',    'Abed',     'sami.abed@levanttech.com',       'Software Engineer',         74000.00, '2023-11-01', 1),
('Dina',    'Qasem',    'dina.qasem@levanttech.com',      'Senior Software Engineer',  98000.00, '2024-02-14', 1),
('Khaled',  'Hamdan',   'khaled.hamdan@levanttech.com',   'Software Engineer',         71000.00, '2024-06-01', 1),
('Yasmin',  'Taha',     'yasmin.taha@levanttech.com',     'Junior Developer',          48000.00, '2024-09-15', 1),
('Mazen',   'Bishara',  'mazen.bishara@levanttech.com',   'Tech Lead',                120000.00, '2022-01-10', 1);

-- Marketing (employees 13-18) — total salary ~388,000
INSERT INTO employees (first_name, last_name, email, title, salary, hire_date, department_id) VALUES
('Lina',    'Sabbagh',  'lina.sabbagh@levanttech.com',    'Marketing Manager',         82000.00, '2022-02-01', 2),
('Ahmad',   'Khoury',   'ahmad.khoury@levanttech.com',   'Content Strategist',        60000.00, '2022-08-15', 2),
('Sara',    'Awad',     'sara.awad@levanttech.com',       'Digital Marketing Analyst', 58000.00, '2023-03-10', 2),
('Rami',    'Habash',   'rami.habash@levanttech.com',     'SEO Specialist',            55000.00, '2023-09-01', 2),
('Nadia',   'Barakat',  'nadia.barakat@levanttech.com',   'Marketing Coordinator',     45000.00, '2024-01-20', 2),
('Ziad',    'Masri',    'ziad.masri@levanttech.com',      'Senior Marketing Manager',  88000.00, '2022-04-05', 2);

-- Sales (employees 19-25) — total salary ~418,000
INSERT INTO employees (first_name, last_name, email, title, salary, hire_date, department_id) VALUES
('Mona',    'Jarrah',   'mona.jarrah@levanttech.com',    'Sales Director',            95000.00, '2022-01-20', 3),
('Basem',   'Othman',   'basem.othman@levanttech.com',   'Account Executive',         62000.00, '2022-05-10', 3),
('Rana',    'Ghazal',   'rana.ghazal@levanttech.com',    'Sales Representative',      48000.00, '2023-02-15', 3),
('Waleed',  'Najjar',   'waleed.najjar@levanttech.com',  'Sales Representative',      50000.00, '2023-06-20', 3),
('Dalia',   'Halabi',   'dalia.halabi@levanttech.com',   'Account Manager',           68000.00, '2023-10-05', 3),
('Karim',   'Fakhouri', 'karim.fakhouri@levanttech.com', 'Sales Analyst',             55000.00, '2024-03-01', 3),
('Sana',    'Zu''bi',   'sana.zubi@levanttech.com',      'Senior Account Executive',  40000.00, '2024-07-15', 3);

-- HR (employees 26-30) — total salary ~280,000
INSERT INTO employees (first_name, last_name, email, title, salary, hire_date, department_id) VALUES
('Iman',    'Shahwan',  'iman.shahwan@levanttech.com',   'HR Director',               85000.00, '2022-03-01', 4),
('Tamer',   'Obeidat',  'tamer.obeidat@levanttech.com',  'HR Specialist',             52000.00, '2022-10-15', 4),
('Huda',    'Rawashdeh','huda.rawashdeh@levanttech.com',  'Recruiter',                48000.00, '2023-05-20', 4),
('Amjad',   'Batayneh', 'amjad.batayneh@levanttech.com', 'Training Coordinator',      45000.00, '2024-01-10', 4),
('Sawsan',  'Ma''aytah','sawsan.maaitah@levanttech.com',  'HR Generalist',            50000.00, '2024-08-01', 4);

-- Finance (employees 31-36) — total salary ~413,000
INSERT INTO employees (first_name, last_name, email, title, salary, hire_date, department_id) VALUES
('Jamal',   'Khatib',   'jamal.khatib@levanttech.com',   'Finance Director',         105000.00, '2022-02-15', 5),
('Abeer',   'Qudah',    'abeer.qudah@levanttech.com',    'Financial Analyst',         65000.00, '2022-07-01', 5),
('Nabil',   'Shraideh', 'nabil.shraideh@levanttech.com',  'Accountant',               55000.00, '2023-01-20', 5),
('Lubna',   'Tarawneh', 'lubna.tarawneh@levanttech.com',  'Senior Accountant',        72000.00, '2023-06-10', 5),
('Hatem',   'Ababneh',  'hatem.ababneh@levanttech.com',  'Budget Analyst',            58000.00, '2024-02-01', 5),
('Reem',    'Zoubi',    'reem.zoubi@levanttech.com',      'Financial Controller',      58000.00, '2024-05-15', 5);

-- Operations (employees 37-42) — total salary ~333,000
INSERT INTO employees (first_name, last_name, email, title, salary, hire_date, department_id) VALUES
('Samir',   'Bani Ata', 'samir.baniata@levanttech.com',  'Operations Manager',        78000.00, '2022-04-01', 6),
('Ghada',   'Smadi',    'ghada.smadi@levanttech.com',    'Logistics Coordinator',     48000.00, '2022-11-10', 6),
('Maher',   'Dmour',    'maher.dmour@levanttech.com',    'Supply Chain Analyst',      55000.00, '2023-03-25', 6),
('Wafa',    'Momani',   'wafa.momani@levanttech.com',    'Operations Analyst',        52000.00, '2023-08-15', 6),
('Hazem',   'Ajlouni',  'hazem.ajlouni@levanttech.com',  'Facilities Manager',        62000.00, '2024-04-01', 6),
('Nisreen', 'Shobaki',  'nisreen.shobaki@levanttech.com', 'Procurement Specialist',   38000.00, '2025-01-10', 6);

-- Research (employees 43-50) — total salary ~558,000
INSERT INTO employees (first_name, last_name, email, title, salary, hire_date, department_id) VALUES
('Adel',    'Hindawi',  'adel.hindawi@levanttech.com',   'Research Director',        110000.00, '2022-01-25', 7),
('Maha',    'Bdour',    'maha.bdour@levanttech.com',     'Data Scientist',            85000.00, '2022-05-15', 7),
('Faris',   'Jaradat',  'faris.jaradat@levanttech.com',  'Research Analyst',          62000.00, '2022-09-20', 7),
('Suha',    'Kilani',   'suha.kilani@levanttech.com',    'ML Engineer',               90000.00, '2023-02-01', 7),
('Imad',    'Touqan',   'imad.touqan@levanttech.com',    'Data Analyst',              58000.00, '2023-07-10', 7),
('Rasha',   'Nimri',    'rasha.nimri@levanttech.com',    'Research Scientist',        78000.00, '2024-01-15', 7),
('Bilal',   'Hashem',   'bilal.hashem@levanttech.com',   'Junior Data Analyst',       40000.00, '2024-06-20', 7),
('Amal',    'Hammad',   'amal.hammad@levanttech.com',    'NLP Researcher',            35000.00, '2025-02-01', 7);

-- Customer Support (employees 51-60) — these employees are NOT assigned to any project
-- total salary ~464,000
INSERT INTO employees (first_name, last_name, email, title, salary, hire_date, department_id) VALUES
('Tala',    'Erekat',   'tala.erekat@levanttech.com',    'Support Team Lead',         65000.00, '2022-06-01', 8),
('Yousef',  'Muhtaseb', 'yousef.muhtaseb@levanttech.com','Support Specialist',        42000.00, '2022-12-15', 8),
('Manal',   'Safadi',   'manal.safadi@levanttech.com',   'Technical Support Engineer',55000.00, '2023-04-10', 8),
('Rafat',   'Zaghmout', 'rafat.zaghmout@levanttech.com', 'Support Specialist',        40000.00, '2023-08-20', 8),
('Sireen',  'Ashour',   'sireen.ashour@levanttech.com',  'Customer Success Manager',  68000.00, '2023-12-01', 8),
('Wael',    'Jadallah', 'wael.jadallah@levanttech.com',  'Help Desk Analyst',         38000.00, '2024-03-15', 8),
('Haneen',  'Rabadi',   'haneen.rabadi@levanttech.com',  'Support Coordinator',       42000.00, '2024-07-01', 8),
('Munther', 'Bataineh', 'munther.bataineh@levanttech.com','Senior Support Engineer',  60000.00, '2024-10-10', 8),
('Dalal',   'Zu''mot',  'dalal.zumot@levanttech.com',    'QA Support Specialist',    36000.00, '2025-01-05', 8),
('Faisal',  'Ayyash',   'faisal.ayyash@levanttech.com',  'Support Specialist',       18000.00, '2025-02-15', 8);

-- ============================================================
-- Projects (15 total — projects 14 and 15 have 0 assignments)
-- ============================================================
INSERT INTO projects (name, start_date, end_date, budget, department_id) VALUES
('Customer Portal Redesign',       '2023-01-10', '2023-06-30', 250000.00, 1),
('Data Warehouse Migration',       '2023-03-01', '2023-12-15', 400000.00, 7),
('Mobile App Launch',              '2023-06-01', '2024-01-31', 320000.00, 1),
('Marketing Automation Platform',  '2023-09-15', '2024-03-31', 180000.00, 2),
('AI Recommendation Engine',       '2024-01-01', '2024-08-30', 500000.00, 7),
('ERP System Upgrade',             '2024-02-15', '2024-09-30', 350000.00, 5),
('Regional Expansion Analytics',   '2024-04-01', '2024-10-31', 220000.00, 3),
('Cloud Infrastructure Migration', '2024-06-01', '2025-01-31', 450000.00, 1),
('Employee Training Portal',       '2024-08-01', '2025-03-31', 150000.00, 4),
('Supply Chain Optimization',      '2024-09-15', '2025-04-30', 280000.00, 6),
('Cybersecurity Audit',            '2024-11-01', '2025-02-28', 120000.00, 1),
('API Gateway Redesign',           '2025-01-01', '2025-06-30', 190000.00, 1),
('Customer Feedback Analytics',    '2025-01-15', NULL,         160000.00, 7),
('Blockchain Pilot',               '2025-03-01', NULL,         300000.00, 7),
('Quantum Computing Research',     '2025-04-01', NULL,         500000.00, 7);

-- ============================================================
-- Project Assignments (80 total)
-- Employees 1-50 only. Employees 51-60 have NO assignments.
-- Projects 14 and 15 have 0 assignments.
-- ============================================================
INSERT INTO project_assignments (employee_id, project_id, role, hours_allocated) VALUES
-- Project 1: Customer Portal Redesign (7 assignments)
(1,  1, 'Lead Developer',        200),
(2,  1, 'Backend Developer',     160),
(3,  1, 'Frontend Developer',    180),
(7,  1, 'QA Engineer',           120),
(13, 1, 'Marketing Liaison',      80),
(14, 1, 'Content Writer',         60),
(37, 1, 'Operations Coordinator', 40),

-- Project 2: Data Warehouse Migration (8 assignments)
(4,  2, 'DevOps Lead',           220),
(5,  2, 'Data Engineer Lead',    240),
(12, 2, 'Technical Architect',   180),
(44, 2, 'Data Scientist',        160),
(45, 2, 'Research Analyst',      120),
(31, 2, 'Budget Oversight',       60),
(32, 2, 'Financial Analyst',      80),
(37, 2, 'Operations Manager',    100),

-- Project 3: Mobile App Launch (7 assignments)
(1,  3, 'Senior Developer',      140),
(6,  3, 'Junior Developer',      200),
(8,  3, 'Backend Developer',     180),
(9,  3, 'Senior Developer',      160),
(7,  3, 'QA Engineer',           140),
(15, 3, 'Marketing Analyst',      60),
(19, 3, 'Sales Liaison',          40),

-- Project 4: Marketing Automation Platform (6 assignments)
(13, 4, 'Project Lead',          200),
(14, 4, 'Content Lead',          160),
(15, 4, 'Analytics Lead',        180),
(16, 4, 'SEO Lead',              140),
(18, 4, 'Senior Strategist',     120),
(2,  4, 'Developer',             100),

-- Project 5: AI Recommendation Engine (8 assignments)
(43, 5, 'Research Director',     200),
(44, 5, 'Lead Data Scientist',   240),
(46, 5, 'ML Engineer Lead',      260),
(47, 5, 'Data Analyst',          160),
(12, 5, 'Technical Architect',   120),
(9,  5, 'Senior Developer',      180),
(5,  5, 'Data Engineer',         200),
(48, 5, 'Research Scientist',    140),

-- Project 6: ERP System Upgrade (7 assignments)
(4,  6, 'DevOps Engineer',       160),
(10, 6, 'Developer',             200),
(11, 6, 'Junior Developer',      180),
(37, 6, 'Operations Lead',       140),
(38, 6, 'Logistics Coordinator', 100),
(31, 6, 'Finance Lead',          80),
(26, 6, 'HR Liaison',             60),

-- Project 7: Regional Expansion Analytics (6 assignments)
(19, 7, 'Sales Director',        120),
(20, 7, 'Account Executive',     160),
(23, 7, 'Account Manager',       140),
(24, 7, 'Sales Analyst',         180),
(39, 7, 'Supply Chain Analyst',  100),
(33, 7, 'Accountant',             80),

-- Project 8: Cloud Infrastructure Migration (7 assignments)
(4,  8, 'DevOps Lead',           240),
(1,  8, 'Senior Engineer',       160),
(8,  8, 'Developer',             200),
(12, 8, 'Technical Architect',   100),
(10, 8, 'Developer',             180),
(42, 8, 'Facilities Coordinator', 60),
(34, 8, 'Senior Accountant',      40),

-- Project 9: Employee Training Portal (5 assignments)
(26, 9, 'HR Director Lead',      160),
(27, 9, 'HR Specialist',         120),
(28, 9, 'Recruiter',             100),
(29, 9, 'Training Lead',         200),
(6,  9, 'Developer',             180),

-- Project 10: Supply Chain Optimization (6 assignments)
(37, 10, 'Operations Lead',      200),
(38, 10, 'Logistics Lead',       180),
(39, 10, 'Supply Chain Lead',    220),
(40, 10, 'Operations Analyst',   160),
(47, 10, 'Data Analyst',         140),
(35, 10, 'Budget Analyst',       80),

-- Project 11: Cybersecurity Audit (4 assignments)
(4,  11, 'Security Engineer',    100),
(12, 11, 'Technical Lead',        80),
(3,  11, 'Code Reviewer',        120),
(43, 11, 'Research Advisor',      60),

-- Project 12: API Gateway Redesign (5 assignments)
(1,  12, 'Lead Developer',       180),
(2,  12, 'Backend Developer',    200),
(8,  12, 'Developer',            160),
(11, 12, 'Junior Developer',     140),
(7,  12, 'QA Engineer',          100),

-- Project 13: Customer Feedback Analytics (4 assignments)
(44, 13, 'Data Scientist Lead',  160),
(47, 13, 'Data Analyst',         200),
(49, 13, 'Junior Analyst',       180),
(15, 13, 'Marketing Analyst',    120);

-- Projects 14 (Blockchain Pilot) and 15 (Quantum Computing Research)
-- intentionally have 0 assignments — used for Q4 LEFT JOIN exercise.
