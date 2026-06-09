 (
    log_id SERIAL PRIMARY KEY,
    r_id INT NOT NULL,
    old_quantity INT,
    new_quantity INT,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_rawmaterial_stock_update()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.stock_quantity IS DISTINCT FROM NEW.stock_quantity THEN
        INSERT INTO rawmaterial_stock_log (
            r_id,
            old_quantity,
            new_quantity,
            change_date
        )
        VALUES (
            OLD.r_id,
            OLD.stock_quantity,
            NEW.stock_quantity,
            CURRENT_TIMESTAMP
        );
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_log_rawmaterial_stock_update
AFTER UPDATE OF stock_quantity
ON rawmaterial
FOR EACH ROW
EXECUTE FUNCTION log_rawmaterial_stock_update();