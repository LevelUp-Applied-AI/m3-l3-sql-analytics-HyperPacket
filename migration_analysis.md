# Production Migration Analysis: `salary_history`

Adding a new table like `salary_history` and backfilling it from an existing `employees` table requires careful planning in a live production environment.

## Handling the Migration

### 1. Phased Approach
- **Phase 1: Schema Deployment**: Add the `salary_history` table without any constraints that might block existing writes (e.g., initial nullable fields if necessary, though here we can likely go with full schema).
- **Phase 2: Code Update (Dual Write)**: Update the application logic to write to both `employees` (current salary) and `salary_history` (new record) whenever a salary change occurs. This prevents the "history gap" during the migration.
- **Phase 3: Backfill**: Copy existing data from `employees` to `salary_history`.
- **Phase 4: Verification**: Audit the counts and data integrity between the two tables.
- **Phase 5: Cutover**: If the app relies on history for certain features, enable those features once the backfill is complete.

## Risks & Mitigations

### 1. Database Locking
- **Risk**: A large `INSERT INTO ... SELECT` can lock the `employees` table or the `salary_history` table for an extended period, slowing down or blocking other transactions.
- **Mitigation**: Perform the backfill in **batches** (e.g., 1,000 rows at a time) with short pauses to allow other transactions to slip through.

### 2. Data Integrity (The "Race Condition")
- **Risk**: An employee's salary might be updated between the `SELECT` from `employees` and the `INSERT` into `salary_history`.
- **Mitigation**: Use a **transactional approach** or a **database trigger** to handle the initial capture, or perform the backfill during a low-traffic window.

### 3. Storage & Performance
- **Risk**: The `salary_history` table can grow very rapidly if salary changes are frequent.
- **Mitigation**: Ensure proper **indexing** on `employee_id` and `change_date`. Consider **table partitioning** by year if the dataset reaches millions of records.

## Production Checklist
- [ ] Run migration on a **staging environment** with a production clone.
- [ ] Measure the time taken for backfill to estimate production downtime (or impact).
- [ ] Ensure **backups** are taken immediately before the migration.
- [ ] Prepare a **rollback script** (e.g., `DROP TABLE salary_history`).
