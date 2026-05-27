-- =========================================================
-- Stage C - Integration
-- Existing tables are not recreated.
-- Only missing tables, columns and relationships are added.
-- =========================================================


-- 1. תיקון מבני (שלב קריטי):
-- בגיבוי של המרצה הטבלה נקראת 'material' והעמודה המזהה נקראת 'material_id'.
-- אנחנו משנים אותן לשמות שסיכמתן עליהן ('rawmaterial' ו-'r_id') כדי שכל הקוד יתחבר.
DO $$ 
BEGIN
    -- שינוי שם הטבלה
    IF EXISTS (SELECT FROM pg_tables WHERE tablename = 'material') THEN
        ALTER TABLE public.material RENAME TO rawmaterial;
    END IF;

    -- שינוי שם העמודה המזהה בתוך הטבלה
    IF EXISTS (SELECT 1 FROM information_schema.columns 
               WHERE table_name='rawmaterial' AND column_name='material_id') THEN
        ALTER TABLE public.rawmaterial RENAME COLUMN material_id TO r_id;
    END IF;
END $$;

-- =========================================================
-- 1. Add Collection table
-- =========================================================
CREATE TABLE IF NOT EXISTS collection (
    collection_id INTEGER PRIMARY KEY,
    collection_name VARCHAR(100),
    season VARCHAR(50),
    year INTEGER,
    release_date DATE
);


-- =========================================================
-- 2. Add Model table
-- =========================================================
CREATE TABLE IF NOT EXISTS model (
    model_id INTEGER PRIMARY KEY,
    model_name VARCHAR(100),
    work_time DOUBLE PRECISION,
    clothing_type VARCHAR(50),
    description_json JSON,
    collection_id INTEGER
);


ALTER TABLE model
DROP CONSTRAINT IF EXISTS fk_model_collection;

ALTER TABLE model
ADD CONSTRAINT fk_model_collection
FOREIGN KEY (collection_id)
REFERENCES collection(collection_id);


-- =========================================================
-- 3. Connect Product to Model
-- =========================================================
ALTER TABLE product
ADD COLUMN IF NOT EXISTS model_id INTEGER;

ALTER TABLE product
DROP CONSTRAINT IF EXISTS fk_product_model;

ALTER TABLE product
ADD CONSTRAINT fk_product_model
FOREIGN KEY (model_id)
REFERENCES model(model_id);


-- =========================================================
-- 4. Add columns to Product
-- =========================================================
ALTER TABLE product
ADD COLUMN IF NOT EXISTS size VARCHAR(10);

ALTER TABLE product
ADD COLUMN IF NOT EXISTS quality_score INTEGER;


-- =========================================================
-- 5. Add columns to RawMaterial
-- =========================================================
ALTER TABLE rawmaterial
ADD COLUMN IF NOT EXISTS color VARCHAR(50);

ALTER TABLE rawmaterial
ADD COLUMN IF NOT EXISTS properties_json JSON;


-- =========================================================
-- 6. Add columns to Employee
-- =========================================================
ALTER TABLE employee
ADD COLUMN IF NOT EXISTS employee_phone VARCHAR(20);

ALTER TABLE employee
ADD COLUMN IF NOT EXISTS salary DOUBLE PRECISION;


-- =========================================================
-- 7. Add column to Supplier
-- =========================================================
ALTER TABLE supplier
ADD COLUMN IF NOT EXISTS rating INTEGER;


-- =========================================================
-- 8. Add Required_M table
-- Model uses raw materials
-- =========================================================
CREATE TABLE IF NOT EXISTS required_m (
    model_id INTEGER,
    r_id INTEGER,
    amount DOUBLE PRECISION,

    PRIMARY KEY (model_id, r_id),

    CONSTRAINT fk_required_m_model
        FOREIGN KEY (model_id)
        REFERENCES model(model_id),

    CONSTRAINT fk_required_m_rawmaterial
        FOREIGN KEY (r_id)
        REFERENCES rawmaterial(r_id)
);


-- =========================================================
-- 9. Add Works_On table
-- Employee works on Model
-- =========================================================
CREATE TABLE IF NOT EXISTS works_on (
    e_id INTEGER,
    model_id INTEGER,
    hour DOUBLE PRECISION,

    PRIMARY KEY (e_id, model_id),

    CONSTRAINT fk_works_on_employee
        FOREIGN KEY (e_id)
        REFERENCES employee(e_id),

    CONSTRAINT fk_works_on_model
        FOREIGN KEY (model_id)
        REFERENCES model(model_id)
);


-- =========================================================
-- 10. Add Supplied_By table
-- Supplier supplies RawMaterial
-- =========================================================
CREATE TABLE IF NOT EXISTS supplied_by (
    supplier_id INTEGER,
    r_id INTEGER,
    unit_price DOUBLE PRECISION,

    PRIMARY KEY (supplier_id, r_id),

    CONSTRAINT fk_supplied_by_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES supplier(s_id),

    CONSTRAINT fk_supplied_by_rawmaterial
        FOREIGN KEY (r_id)
        REFERENCES rawmaterial(r_id)
);