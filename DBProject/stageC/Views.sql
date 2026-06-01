-- =========================================================
-- שלב ג' - יצירת מבטים (Views) ושאילתות
-- =========================================================

-- 1. מבט עבור אגף עיצוב וייצור שלנו (האגף המקורי):
-- במבט זה אנחנו מציגות את דגמי הנעליים שאנחנו מעצבות ואת חומרי הגלם הנדרשים לכל דגם,
-- כדי שנוכל לנהל את מפרטי הייצור שלנו בצורה מדויקת וריכוזית.
CREATE OR REPLACE VIEW view_design_production_status AS
SELECT 
    m.model_name, 
    m.clothing_type,
    r.r_id,
    r.color,
    rm.amount
FROM model m
JOIN required_m rm ON m.model_id = rm.model_id
JOIN rawmaterial r ON rm.r_id = r.r_id;

-- שאילתה 1: בדיקת רשימת חומרי הגלם עבור דגם שאנחנו מעצבות במחלקת העיצוב שלנו
SELECT * 
FROM view_design_production_status 
WHERE model_name = 'Silk Flow Dress';

-- שאילתה 2: שליפת דגמים שדורשים כמויות גבוהות של חומר גלם, כדי שנוכל לתכנן מלאי מראש עבור הייצור שלנו
SELECT model_name, amount 
FROM view_design_production_status 
WHERE amount > 5;


-- 2. מבט עבור אגף סחר ורכש (האגף שקיבלנו):
-- המבט מאפשר לנו לקשר בין ספקים לחומרי הגלם שהם מספקים והעלויות שלהם,
-- לצורך ניהול רכש חכם וחיסכון בעלויות עבור הארגון שלנו.
CREATE OR REPLACE VIEW view_procurement_suppliers AS
SELECT
    s.company_name,
    s.rating,
    r.r_id,
    sb.unit_price
FROM supplier s
JOIN supplied_by sb ON s.s_id = sb.supplier_id
JOIN rawmaterial r ON sb.r_id = r.r_id; -- התיקון: שימוש ב-material_id

-- שאילתה 1: איתור ספקים איכותיים (דירוג מעל 4) שמציעים עלויות משתלמות עבורנו
SELECT company_name, unit_price
FROM view_procurement_suppliers
WHERE rating > 4
AND unit_price < 20;

-- שאילתה 2: השוואת מחירי חומרי גלם בין כלל הספקים כדי למצוא עבור הארגון שלנו את העסקה הטובה ביותר
SELECT r_id, MIN(unit_price) AS min_price
FROM view_procurement_suppliers 
GROUP BY r_id;


-- 3. מבט עבור ניהול דגמים וקולקציות:
-- המבט מציג את הדגמים שלנו יחד עם הקולקציה שאליה כל דגם שייך.
-- כך ניתן לעקוב אחרי הדגמים לפי עונה, שנה וקולקציה,
-- ולהבין אילו פריטים מתוכננים לכל קו עיצובי בארגון.
CREATE OR REPLACE VIEW view_models_collections AS
SELECT
    m.model_id,
    m.model_name,
    m.clothing_type,
    m.work_time,
    c.collection_id,
    c.collection_name,
    c.season,
    c.year,
    c.release_date
FROM model m
JOIN collection c ON m.collection_id = c.collection_id;


-- שאילתה 1: הצגת כל הדגמים ששייכים לקולקציה מסוימת
SELECT
    model_name,
    clothing_type,
    collection_name,
    season,
    year
FROM view_models_collections
WHERE collection_name = 'Summer Breeze';


-- שאילתה 2: חישוב מספר הדגמים בכל קולקציה
SELECT
    collection_name,
    season,
    year,
    COUNT(model_id) AS total_models
FROM view_models_collections
GROUP BY collection_name, season, year
ORDER BY year DESC, total_models DESC;