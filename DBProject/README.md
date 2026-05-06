# targil0
# מיני פרויקט בבסיסי נתונים - אגף עיצוב וייצור

**מגישות:** שרי אדלר, מיכל גרינבלט וחני כהן  

**קורס:** מיני פרויקט בבסיסי נתונים  
**נושא האגף:** עיצוב וייצור (דגמים, חומרי גלם, מוצרים, ספקים ועובדים)
---

<details>
<summary><b> מבוא וניתוח המערכת</b></summary>

### 1. ניתוח מערכת TOP-DOWN
בשלב זה תוכננו מסכי המערכת הראשוניים בעזרת Google AI Studio. המטרה היא להמחיש את זרימת המידע בין הישויות השונות (מוצרים, חומרי גלם ועיצובים) בממשק המשתמש.

#### סקיצות ממשק (Wireframes):

**לוח בקרה (Dashboard):**
מציג סטטיסטיקות על תהליכי הייצור ומלאי חומרי הגלם.
![Dashboard UI](dbFiles/ui_dashboard.png)

**ניהול מוצרים:**
טבלת מעקב אחר מוצרים קיימים והקשר שלהם לדגמי העיצוב.
![Product Management UI](dbFiles/ui_products.png)

**טופס הזנת עיצוב חדש:**
ממשק להזנת מפרטים טכניים כולל תמיכה בפורמט JSON.
![New Design Form](dbFiles/ui_design_form.png)

**ניהול ספקים:**
מסך לניהול ספקים, כולל צפייה, הוספה ועדכון פרטי ספקים במערכת.
![Supplier Management UI](dbFiles/ui_suppliers.png)

### מבוא ותיאור המערכת
פרויקט זה מתמקד ב**אגף עיצוב וייצור** כחלק ממערכת כוללת לניהול רשת חנויות. 
האגף אחראי על ניהול מחזור החיים של המוצר מרמת הרעיון והעיצוב ועד לייצורו בפועל, תוך תיאום עם ספקים לניהול חומרי הגלם ושיבוץ עובדים למשמרות הייצור.

**תחומי אחריות באגף:**
* **אגף מחקר ופיתוח (R&D):** ניהול דגמים (Designs) ומפרטי JSON טכניים.
* **לוגיסטיקה ורכש פנים-אגפי:** מעקב אחר חומרי גלם (Raw Materials) והזמנות רכש מול ספקים.
* **ייצור:** ניהול קווי ייצור (Production Lines) והפיכת דגמים למוצרים (Products) סופיים המוכנים למכירה בחנות.
* **ניהול כוח אדם:** שיוך עובדים (Employees) למחלקות ושיבוצם במשמרות (Work Shifts)..
</details>

<details>
<summary><b>  ERD תכנון לוגי - דיאגרמת </b></summary>
<br>
## 2. תכנון לוגי - דיאגרמת ERD
המערכת מורכבת מ-**9 ישויות מרכזיות**. לכל ישות הוגדרו לפחות 5 תכונות (Attributes) כדי להבטיח פירוט נתונים מרבי ודיוק בתהליכי העבודה.

### דיאגרמת ERD:
![ERD Diagram](dbFiles/erd_diagram.jpeg)

### מאפייני המודל הלוגי

כל ישות במערכת כוללת לפחות 5 תכונות בהתאם לדרישות המטלה.
הוגדרו קשרים בין הישויות עם עוצמות (Cardinality), כגון:
- קשר מסוג 1:N (לדוגמה: Department – Employee, Supplier – SupplyOrder)
- קשר מסוג M:N (לדוגמה: Design – RawMaterial, SupplyOrder – RawMaterial)
נעשה שימוש בסוגי נתונים מגוונים:
- שדות מסוג Date (לדוגמה: P_date, D_date, Order_date, WS_date)
- שדות מסוג JSON (לדוגמה: JSON_Specs, Supplier_Metadata)
קיימים מספר שדות תאריך במערכת, לצורך שימוש בשאילתות בשלבים מתקדמים.

</details>

<details>
<summary><b>📊 נירמול ותלויות פונקציונליות (BCNF)</b></summary>
<br>
## 3. נירמול ותלויות פונקציונליות (Normalization & Functional Dependencies)

כל הטבלאות במערכת תוכננו כך שיעמדו ברמת נירמול **BCNF** (Boyce-Codd Normal Form). להלן פירוט התלויות והנירמול עבור כל סכמה:

### ישויות מרכזיות

* **Product (מוצר):**
    * **תלויות פונקציונליות:** $P\_id \rightarrow P\_name, P\_price, P\_weight, P\_date, D\_id, PL\_id$
    * **רמת נירמול:** BCNF.
    * **הסבר:** המפתח הראשי $P\_id$ הוא המכריע הפונקציונלי היחיד בטבלה. כל שאר השדות תלויים בו באופן מלא ואין תלויות טרנזיטיביות.

* **Employee (עובד):**
    * **תלויות פונקציונליות:** $E\_id \rightarrow E\_name, E\_familyName, E\_date, Role, DE\_id$
    * **רמת נירמול:** BCNF.
    * **הסבר:** כל פרטי העובד והמחלקה אליה הוא שייך נקבעים אך ורק לפי המזהה הייחודי $E\_id$.

* **Department (מחלקה):**
    * **תלויות פונקציונליות:** $DE\_id \rightarrow DE\_name, Location, Budget, Manager\_Name$
    * **רמת נירמול:** BCNF.
    * **הסבר:** אין שדות שאינם מפתחות שקובעים שדות אחרים (למשל, המיקום לא קובע את שם המחלקה).

* **SupplyOrder (הזמנת רכש):**
    * **תלויות פונקציונליות:** $Order\_id \rightarrow Order\_date, Total, Order\_status, Shipping\_Method, S\_id$
    * **רמת נירמול:** BCNF.
    * **הסבר:** למרות ש-$Total$ הוא אטריביוט נגזר, בבסיס הנתונים הפיזי הוא תלוי ב-$Order\_id$ בלבד.

* **Supplier (ספק):**
    * **תלויות פונקציונליות:** $S\_id \rightarrow Company\_Name, Phone, Address, Supplier\_MetaData$
    * **רמת נירמול:** BCNF.

* **Design, RawMaterial, Product_Line, Work_Ship:**
    * כל הטבלאות הללו נמצאות ב-BCNF מכיוון שלכל אחת מפתח ראשי יחיד ($D\_id, R\_id, PL\_id, WS\_id$ בהתאמה) המהווה את המכריע היחיד לכל שאר תכונות הישות.

---

### טבלאות קשר (Many-to-Many)

בטבלאות אלו המפתח מורכב משני שדות (Composite Primary Key).

* **Includes, Requires, Employee_WorkShip:**
    * **רמת נירמול:** BCNF.
    * **הסבר:** בטבלאות אלו אין תכונות נוספות מעבר למפתחות הזרים המרכיבים את המפתח הראשי. לכן, אין תלויות פונקציונליות שאינן טריוויאליות, והן עומדות בהגדרה המחמירה של BCNF.

---

### סיכום רמת הנירמול
המערכת כולה נמצאת ברמת נירמול **BCNF** מהסיבות הבאות:
1.  כל הטבלאות בנרמול ראשון (ערכים אטומיים, כולל שדות JSON המטופלים כאובייקט שלם).
2.  אין תלויות חלקיות (כל השדות תלויים במפתח הראשי במלואו).
3.  אין תלויות טרנזיטיביות (שדה שאינו מפתח לא קובע שדה אחר שאינו מפתח).
4.  לכל תלות פונקציונלית $X \rightarrow Y$, $X$ הוא מפתח-על (Superkey).

</details>

<details>
<summary><b>📥 4. מימוש פיזי, מילוי נתונים וגיבוי המערכת </b></summary>
<br>

### מעבר מהתכנון הלוגי למימוש הפיזי

המעבר מהתכנון הלוגי למימוש הפיזי בוצע על בסיס דיאגרמת ה-ERD.  
פקודות CREATE TABLE נכתבו בהתאם למבנה הישויות, התכונות והקשרים שהוגדרו בתכנון, ולאחר מכן הורצו ב-pgAdmin ליצירת הסכמה המלאה.

### DSD - Data Structure Diagram

לאחר בניית הטבלאות ב-PostgreSQL, הופק תרשים ה-DSD (Data Structure Diagram) המשקף את מבנה הנתונים הסופי. התרשים מציג את טיפוסי הנתונים המדויקים, המפתחות הראשיים והקשרים הפיזיים (Foreign Keys) בין הישויות באגף הייצור.

![DSD Diagram](dsd_diagram.png)

![DSD Diagram](dbFiles/pgadmin_view_data.png)

<details>
<summary><b>שיטת Python</b></summary>
<br>

---

***💻 א. מימוש פיזי בבסיס הנתונים***
בשלב זה הפכנו את המודל הלוגי (ERD) לבסיס נתונים פיזי מתפקד בתוך סביבת המערכת ב-pgAdmin.

**תיאור המימוש:**
באמצעות ממשק ה-pgAdmin, הרצנו סקריפטים של SQL ליצירת הסכימה המלאה הכוללת את כל הטבלאות והקשרים. התמונה להלן מציגה את מבנה הטבלאות כפי שנוצרו:

![Tables View](dbFiles/pgadmin_view_data.png)
ניתן לראות כי כל הטבלאות שהוגדרו בתכנון אכן נוצרו בהצלחה בבסיס הנתונים.

* **אימות מימוש**: ניתן לראות כי כל הישויות שהוגדרו בתכנון נוצרו בהצלחה תחת הסכימה הציבורית (public).
* **אילוצים וקשרים**: המימוש כולל הגדרת מפתחות ראשיים (PK) ומפתחות זרים (FK) המבטיחים את שלמות הנתונים.

---

***🐍 ב. מילוי נתונים (Data Population) - אסטרטגיה וביצוע***

כדי לעמוד בדרישה של מעל **500 רשומות** בטבלאות המרכזיות ולשמור על דיוק מקצועי, בחרנו להשתמש באוטומציה של סקריפטים ב-Python. התהליך בוצע בסדר כרונולוגי מחייב כדי למנוע שגיאות של מפתחות זרים.

---

#### 🛠 שלב 1: יצירת תשתית המוצרים (`fill_products.py`)
בשלב הראשון כתבנו קוד Python שמייצר נתונים רנדומליים אך הגיוניים עבור המוצרים שלנו. הקוד יוצר קובץ SQL מוכן להרצה.

![VS Code Script](dbFiles/vscode_screenshot.png)

---

#### 🎨 שלב 2: יצירת פקודות ה-Insert
כאן ניתן לראות את קובץ ה-SQL שנוצר (`insert_products.sql`) עם פקודות ה-INSERT המוכנות. כללנו לוגיקה שיוצרת גם ערכי **NULL** באופן רנדומלי כדי לעמוד בדרישות הפרויקט לטיפול בנתונים חסרים.

![Insert Commands](dbFiles/insert_commands.png)

---

#### 🚀 שלב 3: ייבוא ואימות ב-pgAdmin
העתקנו את פקודות ה-Insert לתוך ה-Query Tool ב-**pgAdmin** והרצנו אותן כדי למלא את הטבלאות בפועל.

![pgAdmin Execution](dbFiles/pgadmin_insert.png)

בסיום התהליך, ביצענו שאילתת **COUNT** על טבלת העיצובים (design) כדי לוודא שכל 500 הרשומות נקלטו בהצלחה בבסיס הנתונים.

![pgAdmin Count](dbFiles/pgadmin_count.png)
הנתונים שנוצרו באמצעות סקריפט Python הוזנו בהצלחה לבסיס הנתונים כפי שניתן לראות בתוצאה.

</details>

<details>
<summary><b>שיטת Mockaroo (SQL Export) - טבלת Supplier</b></summary>
<br>

בשיטה זו השתמשנו באתר [Mockaroo](https://www.mockaroo.com/) כדי למלא 500 רשומות לטבלת הספקים. זה עזר לנו לייצר נתונים שנראים אמיתיים בצורה מהירה ומדויקת.

**כך נראה התהליך שעשינו:**

**1. הגדרת הנתונים באתר:**
בצילום המסך אפשר לראות איך התאמנו את סוגי השדות (שם חברה, כתובת, טלפון) למבנה הטבלה שלנו. כדי לעמוד בדרישה של המטלה לערכים חסרים, הגדרנו אחוזי **Blank** (ערכי NULL) בשדות הטלפון והכתובת.

![Mockaroo Settings](dbFiles/mockaroo_settings.png)

---

**2. בדיקת הנתונים לפני ההורדה:**
כאן אפשר לראות בתצוגה המקדימה שהאתר אכן ייצר נתונים בפורמט הנכון, כולל שמות חברות באנגלית ונתוני ה-JSON, מה שמוודא שהקובץ יהיה תקין לפני הייבוא.

![Data Preview](dbFiles/mockaroo_data_preview.png)

---

**3. שמירה וניהול ב-VS Code:**
הורדנו את הנתונים כקובץ SQL ושמרנו אותו בתיקיית הפרויקט שלנו. בתמונה רואים איך הקוד נראה בתוך ה-**VS Code** – שמירת הקובץ כאן מאפשרת לכל הבנות בצוות למשוך את הקובץ מה-GitHub ולהשתמש בו בבסיס הנתונים המקומי שלהן.

![VS Code SQL View](dbFiles/vscode_sql_preview.png)

---

**4. הרצה ב-pgAdmin:**
העתקנו את פקודות ה-Insert מהקובץ והרצנו אותן ב-Query Tool. התמונה מראה את רגע ההרצה בתוך התוכנה והזנת הנתונים למחסן הנתונים הפיזי.

![pgAdmin Execution](dbFiles/pgadmin_insert_query.png)

---

**5. התוצאה הסופית:**
בבדיקה בבסיס הנתונים אפשר לראות שהטבלה התמלאה ב-500 שורות. ניתן לראות בבירור את ערכי ה-**NULL** (השדות הריקים) שנוצרו רנדומלית, בדיוק לפי דרישות הפרויקט.

![Final Supplier Table](dbFiles/supplier_table_results.png)
ניתן לראות כי חלק מהשדות מכילים ערכי NULL בהתאם לדרישות המטלה.

</details>

</details>

<details>
<summary><b>שיטת Mockaroo (SQL Export) - טבלאות Product ו־Design</b></summary>

כדי למלא 500 רשומות בטבלאות המרכזיות, השתמשנו באתר Mockaroo ליצירת נתונים אקראיים בצורה מהירה ואמינה.

בשלב הראשון הגדרנו את השדות בהתאם למבנה הטבלאות, ולאחר מכן ייצאנו את הנתונים בפורמט SQL.

![Mockaroo Schema](dbFiles/mockaroo_product.png)

את קובצי ה־SQL הרצנו ב־pgAdmin, וכך הוזנו הנתונים לטבלאות Product ו־Design.

לאחר ההרצה ביצענו בדיקת COUNT על מנת לוודא שכל הנתונים הוכנסו בהצלחה.

![Schema Create](dbFiles/schema_create.png)
![Product Insert](dbFiles/product_insert.png)
![Product Count](dbFiles/product_count.png)
![Design Insert](dbFiles/design_insert.png)
![Design Count](dbFiles/design_count.png)

</details>

---

<details>
<summary><b>שיטת SQL (Generate Series) - טבלת RawMaterial</b></summary>

בטבלה זו השתמשנו בפקודת SQL מובנית של PostgreSQL בשם generate_series כדי ליצור כמות גדולה של נתונים בצורה אוטומטית.

בתחילה הוכנסו מספר רשומות ידניות לצורך בדיקה, ולאחר מכן בוצעה הכנסת נתונים אוטומטית באמצעות generate_series יחד עם פונקציות random ליצירת מחירים וכמויות.

השיטה אפשרה יצירה מהירה ויעילה של 500 רשומות ללא שימוש בכלים חיצוניים.

לאחר ההרצה ביצענו בדיקת COUNT כדי לוודא שהנתונים הוכנסו בהצלחה.

![RawMaterial Insert](dbFiles/rawmaterial_insert.png)
![RawMaterial Count](dbFiles/rawmaterial_count.png)

בתמונה הבאה ניתן לראות בדיקה מרוכזת של כמות הרשומות בכל הטבלאות לאחר הכנסת הנתונים:
![Generate Series Query](dbFiles/all_tables_count.png)

</details>

<details>
<summary><b>שיטת Excel - טבלת Department</b></summary>
<br>

בשיטה זו השתמשנו בקובץ Excel לצורך יצירת נתונים לטבלת Department.

תחילה נבנה קובץ Excel הכולל את כל העמודות בהתאם למבנה הטבלה במערכת:
DE_id, DE_name, Location, Budget, Manager_Name, E_id, PL_id.

הנתונים נוצרו בצורה אוטומטית באמצעות גרירה (fill) באקסל, כך שנוצרו רשומות רבות בצורה מהירה ויעילה.

![Excel Data](dbFiles/excel_department.png)

לאחר מכן שמרנו את הקובץ בפורמט CSV (UTF-8), והשתמשנו ב־pgAdmin כדי לייבא את הנתונים לטבלה באמצעות האפשרות Import.

![Import Settings](dbFiles/import_department.png)

![Department Data](dbFiles/department_result.png)

שיטה זו מאפשרת יצירת נתונים בצורה ידידותית ונוחה למשתמש, תוך הפרדה בין יצירת הנתונים לבין הכנסת הנתונים בפועל למערכת.

</details>

<details>
<summary><b>טיפול בשגיאות (Data Integrity)</b></summary>

במהלך העבודה נתקלנו במספר שגיאות אשר המחישו את חשיבות שלמות הנתונים במערכת.

בין השגיאות:

- Duplicate Key – הכנסת רשומה עם מזהה שכבר קיים
- JSON לא תקין
- NULL בשדה שמוגדר כ־NOT NULL
- Foreign Key Constraint – ניסיון למחוק רשומה שמקושרת לטבלה אחרת

שגיאות אלו סייעו לנו להבין את מגבלות המערכת ואת הקשרים בין הטבלאות.

![Duplicate Key Error](dbFiles/duplicate_error.png)
![Foreign Key Error](dbFiles/foreign_key_error.png)


</details>

---

<details>
<summary><b>גיבוי בסיס הנתונים (Backup)</b></summary>

לאחר סיום מילוי הנתונים, ביצענו גיבוי מלא של בסיס הנתונים באמצעות pgAdmin.
הגיבוי בוצע באמצעות pgAdmin על ידי לחיצה ימנית על בסיס הנתונים ובחירה באפשרות Backup.  
נבחר פורמט Custom (.backup), המאפשר גיבוי מלא של מבנה הנתונים והתוכן.
הגיבוי כולל גם את מבנה הטבלאות וגם את הנתונים (Schema + Data), ולכן מאפשר שחזור מלא של המערכת.


![Backup](dbFiles/backup.png)

בנוסף לגיבוי שבוצע באמצעות pgAdmin, בוצע גיבוי נוסף באמצעות שורת פקודה (pg_dump) מתוך Docker container.
הגיבוי בוצע בהצלחה והקובץ נשמר בתיקיית backup של הפרויקט.

![Backup via Command Line](dbFiles/backup_cmd.png)

</details>

---

<details>
<summary><b>שחזור בסיס הנתונים (Restore)</b></summary>

כדי לוודא את תקינות הגיבוי, ביצענו תהליך שחזור.

נוצר בסיס נתונים חדש בשם test_restore, ולאחר מכן בוצע Restore מקובץ הגיבוי.

לאחר השחזור בוצעה בדיקת COUNT על טבלת Product, אשר הראתה כי כל הנתונים שוחזרו בהצלחה.

השחזור בוצע על מנת לוודא שקובץ הגיבוי תקין וניתן להשתמש בו לשחזור מלא של בסיס הנתונים.

![Create Restore DB](dbFiles/create_restore_db.png)
![Restore Count](dbFiles/restore_count.png)

</details>
---

# שלב ב – שאילתות ואילוצים

<details>
<summary><b>כל השאילתות והאילוצים של שלב ב'</b></summary>
<br>

## הקדמה
בשלב זה ביצענו שאילתות SQL מורכבות על בסיס הנתונים, כולל:
- SELECT מורכבות עם JOIN
- תתי שאילתות
- GROUP BY ו־ORDER BY
- שימוש בשדות תאריכים
- שאילתות UPDATE ו־DELETE
- שימוש ב־ROLLBACK ו־COMMIT
- הוספת אילוצים (Constraints)
- הוספת אינדקסים והשוואת ביצועים

## SELECT 1 – סיכום הזמנות לפי ספק ותאריך

### מטרת השאילתה
השאילתה מציגה עבור כל ספק את מספר ההזמנות ואת הסכום הכולל של ההזמנות,
כאשר הנתונים מחולקים לפי שנה וחודש.  
מטרת השאילתה היא לאפשר ניתוח פעילות הספקים לאורך זמן.

### קוד SQL
```sql
SELECT
    s.S_id,
    s.Company_Name,
    EXTRACT(YEAR FROM so.Order_date) AS order_year,
    EXTRACT(MONTH FROM so.Order_date) AS order_month,
    COUNT(so.Order_id) AS total_orders,
    SUM(so.Total) AS total_amount
FROM Supplier s
JOIN SupplyOrder so ON s.S_id = so.S_id
GROUP BY
    s.S_id,
    s.Company_Name,
    EXTRACT(YEAR FROM so.Order_date),
    EXTRACT(MONTH FROM so.Order_date)
ORDER BY order_year, order_month, total_amount DESC;
```

![הרצה](dbFiles/select1_run.png)
![תוצאה](dbFiles/select1_result.png)

## SELECT 2 – מוצרים, עיצובים וכמות חומרי גלם נדרשים

### מטרת השאילתה
השאילתה מציגה עבור כל מוצר את העיצוב שלו, מספר חומרי הגלם הדרושים לעיצוב, ואת סך כמות המלאי של חומרי הגלם האלו.  
מטרת השאילתה היא לעזור להבין אילו מוצרים דורשים יותר חומרי גלם ומה מצב המלאי עבורם.

### קוד SQL
```sql
SELECT
    p.P_id,
    p.P_name,
    p.P_price,
    d.D_id,
    d.D_name,
    COUNT(r.R_id) AS raw_materials_count,
    SUM(rm.Stock_Quantity) AS total_stock_quantity
FROM Product p
JOIN Design d ON p.P_id = d.P_id
JOIN Requires r ON d.D_id = r.D_id
JOIN RawMaterial rm ON r.R_id = rm.R_id
GROUP BY
    p.P_id,
    p.P_name,
    p.P_price,
    d.D_id,
    d.D_name
ORDER BY raw_materials_count DESC;
```

![הרצה](dbFiles/select2_run.png)
![תוצאה](dbFiles/select2_result.png)

## SELECT 3 – חומרי גלם המשמשים בעיצובים ובהזמנות

### מטרת השאילתה
השאילתה מציגה חומרי גלם שמשמשים בעיצובים, יחד עם מספר העיצובים שבהם הם מופיעים ומספר ההזמנות שבהן הם נכללו.  
מטרת השאילתה היא לזהות חומרי גלם חשובים שחוזרים בהרבה עיצובים והזמנות.

### קוד SQL
```sql
SELECT
    rm.R_id,
    rm.R_name,
    rm.Unit_Measure,
    rm.Stock_Quantity,
    COUNT(DISTINCT r.D_id) AS used_in_designs_count,
    COUNT(DISTINCT i.Order_id) AS included_in_orders_count
FROM RawMaterial rm
LEFT JOIN Requires r ON rm.R_id = r.R_id
LEFT JOIN Includes i ON rm.R_id = i.R_id
GROUP BY
    rm.R_id,
    rm.R_name,
    rm.Unit_Measure,
    rm.Stock_Quantity
HAVING COUNT(DISTINCT r.D_id) > 0
ORDER BY used_in_designs_count DESC, included_in_orders_count DESC;
```

![הרצה](dbFiles/select3_run.png)
![תוצאה](dbFiles/select3_result.png)

## SELECT 4 – מוצרים שמחירם גבוה מהממוצע

### מטרת השאילתה
השאילתה מציגה את כל המוצרים שמחירם גבוה מהממוצע של כלל המוצרים.  
מטרת השאילתה היא לזהות מוצרים יקרים יחסית לשוק המוצרים הקיים.

### קוד SQL
```sql
SELECT
    p.P_id,
    p.P_name,
    p.P_price,
    p.P_weight,
    p.P_data
FROM Product p
WHERE p.P_price > (
    SELECT AVG(P_price)
    FROM Product
)
ORDER BY p.P_price DESC;
```


![תוצאה](dbFiles/select4_run.png)
![תוצאה](dbFiles/select4_result.png)


## SELECT 5 – ספקים שיש להם הזמנות (השוואה בין IN ל־EXISTS)

### מטרת השאילתה
השאילתה מציגה את כל הספקים שיש להם לפחות הזמנה אחת במערכת.  
מטרת השאילתה היא לזהות ספקים פעילים.

---

## גרסה 1 – שימוש ב־IN

### קוד SQL
```sql
SELECT
    s.S_id,
    s.Company_Name,
    s.Phone,
    s.Address
FROM Supplier s
WHERE s.S_id IN (
    SELECT so.S_id
    FROM SupplyOrder so
);
```

![הרצה](dbFiles/select5A_run.png)
![תוצאה](dbFiles/select5A_result.png)

```sql
SELECT
    s.S_id,
    s.Company_Name,
    s.Phone,
    s.Address
FROM Supplier s
WHERE EXISTS (
    SELECT 1
    FROM SupplyOrder so
    WHERE so.S_id = s.S_id
);
```

![הרצה](dbFiles/select5B_run.png)
![תוצאה](dbFiles/select5B_result.png)

## מה יותר יעיל ולמה

השימוש בEXIST בדכ יותר יעיל מהשימוש בIN.

IN מחזיר רשימה של ערכים מתת־השאילתה ומשווה אליה,  
בעוד EXISTS בודק רק אם קיימת שורה מתאימה ועוצר ברגע שמצא אחת.

לכן, בטבלאות גדולות EXISTS לרוב יעיל יותר.  
עם זאת, PostgreSQL יכול לבצע אופטימיזציה ולכן לעיתים ההבדל לא משמעותי.

## SELECT 6 – מוצרים שיש להם עיצוב (השוואה בין IN ל־JOIN)

### מטרת השאילתה
השאילתה מציגה את כל המוצרים שיש להם לפחות עיצוב אחד במערכת.  
מטרת השאילתה היא לזהות מוצרים שעברו שלב תכנון ועיצוב.

---

## גרסה 1 – שימוש ב־IN

### קוד SQL
```sql
SELECT
    p.P_id,
    p.P_name,
    p.P_price,
    p.P_weight,
    p.P_data
FROM Product p
WHERE p.P_id IN (
    SELECT d.P_id
    FROM Design d
);
```

![הרצה](dbFiles/select6A_run.png)
![תוצאה](dbFiles/select6A_result.png)

```sql
SELECT DISTINCT
    p.P_id,
    p.P_name,
    p.P_price,
    p.P_weight,
    p.P_data
FROM Product p
JOIN Design d ON p.P_id = d.P_id;
```

![הרצה](dbFiles/select6B_run.png)
![תוצאה](dbFiles/select6B_result.png)

## הסבר והבדל בין השיטות

שתי השאילתות מחזירות את אותם מוצרים — מוצרים שיש להם לפחות עיצוב אחד בטבלת Design.

בגרסת IN, תת־השאילתה מחזירה רשימה של מזהי מוצרים מטבלת Design,  
והשאילתה הראשית בודקת האם כל מוצר נמצא ברשימה זו.

בגרסת JOIN, מתבצע חיבור ישיר בין הטבלאות Product ו־Design לפי מזהה המוצר (P_id).  
במקרה זה השתמשנו ב־DISTINCT כדי למנוע כפילויות, מאחר שלמוצר יכול להיות יותר מעיצוב אחד.

מבחינת יעילות, JOIN נחשב בדרך כלל ליעיל יותר כאשר מדובר בקשר בין טבלאות,  
מאחר שמערכת ניהול בסיס הנתונים יכולה לבצע אופטימיזציה טובה יותר לחיבור בין הטבלאות.  
לעומת זאת, IN מתאים יותר למצבים של בדיקה מול רשימה של ערכים.

## SELECT 7 – חומרי גלם המשמשים בעיצובים (השוואה בין EXISTS ל־JOIN)

### מטרת השאילתה
השאילתה מציגה את כל חומרי הגלם שנדרשים לפחות עבור עיצוב אחד במערכת.  
מטרת השאילתה היא לזהות חומרי גלם פעילים שמשמשים בתהליך התכנון והייצור.

---

## גרסה 1 – שימוש ב־EXISTS

### קוד SQL
```sql
SELECT
    rm.R_id,
    rm.R_name,
    rm.R_price,
    rm.Unit_Measure,
    rm.Stock_Quantity
FROM RawMaterial rm
WHERE EXISTS (
    SELECT 1
    FROM Requires r
    WHERE r.R_id = rm.R_id
);
```

![הרצה](dbFiles/select7A_run.png)
![תוצאה](dbFiles/select7A_result.png)

```sql
SELECT DISTINCT
    rm.R_id,
    rm.R_name,
    rm.R_price,
    rm.Unit_Measure,
    rm.Stock_Quantity
FROM RawMaterial rm
JOIN Requires r ON rm.R_id = r.R_id;
```
![הרצה](dbFiles/select7B_run.png)
![תוצאה](dbFiles/select7B_result.png)

## הסבר והבדל בין השיטות

שתי השאילתות מחזירות את אותם חומרי גלם — כאלה שמופיעים בטבלת Requires.

בגרסת EXISTS מתבצעת בדיקה עבור כל חומר גלם האם קיימת לפחות רשומה אחת מתאימה.  
ברגע שנמצאת התאמה, הבדיקה נעצרת.

בגרסת JOIN מתבצע חיבור בין הטבלאות, ולכן אותו חומר גלם יכול להופיע מספר פעמים, ולכן נדרש שימוש ב־DISTINCT.

מבחינת יעילות, EXISTS בדרך כלל יעיל יותר כאשר רוצים רק לבדוק קיום,  
בעוד JOIN מתאים כאשר רוצים גם לשלוף נתונים מהטבלה המקושרת.

## SELECT 8 – עובדים שעבדו במשמרות (השוואה בין IN ל־JOIN)

### מטרת השאילתה
השאילתה מציגה את כל העובדים שעבדו לפחות במשמרת אחת.  
מטרת השאילתה היא לזהות עובדים פעילים שביצעו עבודה בפועל במערכת.

---

## גרסה 1 – שימוש ב־IN

### קוד SQL
```sql
SELECT
    e.E_id,
    e.E_name,
    e.E_familyName,
    e.Role,
    e.E_date
FROM Employee e
WHERE e.E_id IN (
    SELECT ews.E_id
    FROM Employee_WorkShip ews
);
```

![הרצה](dbFiles/select8A_run.png)
![תוצאה](dbFiles/select8A_result.png)
```sql
SELECT DISTINCT
    e.E_id,
    e.E_name,
    e.E_familyName,
    e.Role,
    e.E_date
FROM Employee e
JOIN Employee_WorkShip ews ON e.E_id = ews.E_id;
```
![הרצה](dbFiles/select8B_run.png)
![תוצאה](dbFiles/select8B_result.png)
</details>

<details>
<summary>▶ UPDATE – שאילתות עדכון נתונים</summary>

---

## UPDATE 1 – עדכון מחיר מוצרים לפי תאריך עיצוב

### מטרת השאילתה
השאילתה מעדכנת את מחיר המוצרים ומעלה אותו ב־5% עבור מוצרים שיש להם עיצוב מתאריך 2024-01-01 והלאה.

### קוד SQL
```sql
UPDATE Product
SET P_price = P_price * 1.05
WHERE P_id IN (
    SELECT P_id
    FROM Design
    WHERE D_data >= '2024-01-01
);
```


![update_run](dbFiles/update_run.png)
![update_before](dbFiles/update_before.png)
![update_after](dbFiles/update_after.png)



## UPDATE – שאילתות עדכון נתונים

---

## UPDATE 2 – סימון קווי ייצור שדורשים תחזוקה

### מטרת השאילתה
השאילתה מזהה קווי ייצור שלא בוצעה להם תחזוקה במשך יותר משנה,  
ומעדכנת את הסטטוס שלהם ל־"Needs Maintenance".

### קוד SQL
```sql
UPDATE Product_Line
SET Status = 'Needs Maintenance'
WHERE Last_Maintenance < CURRENT_DATE - INTERVAL '1 year';
```
![update2_run](dbFiles/update2_run.png)
![update2_run](dbFiles/update2_before.png)
![update2_run](dbFiles/update2_after.png)


## UPDATE – שאילתות עדכון נתונים

---

## UPDATE 3 – הפחתת תקציב למחלקות עם קווי ייצור לא פעילים

### מטרת השאילתה
השאילתה מפחיתה ב־10% את התקציב של מחלקות שיש להן קווי ייצור במצב "Inactive".  
המטרה היא לשקף ירידה בפעילות ולהתאים את התקציב בהתאם.

### קוד SQL
```sql
UPDATE Department
SET Budget = Budget * 0.90
WHERE PL_id IN (
    SELECT PL_id
    FROM Product_Line
    WHERE Status = 'Inactive'
);
```
![update3_run](dbFiles/update3_run.png)
![update3_run](dbFiles/update3_before.png)
![update3_run](dbFiles/update3_after.png)

</details>

<details>
<summary>▶ DELETE – שאילתות מחיקת נתונים</summary>

---

## DELETE 1 – מחיקת הזמנות ישנות ומבוטלות ללא חומרי גלם

### מטרת השאילתה
השאילתה מוחקת הזמנות מספקים אשר סטטוס ההזמנה שלהן הוא "Cancelled" (מבוטל), תאריך ההזמנה שלהן ישן ביותר משנתיים, ואינן מקושרות לאף חומר גלם בטבלת Includes.

מטרת השאילתה היא לנקות את בסיס הנתונים מהזמנות לא רלוונטיות שאינן פעילות ואינן קשורות לנתונים נוספים במערכת, ובכך לשפר את יעילות ואמינות הנתונים.

### קוד SQL
```sql
DELETE FROM SupplyOrder
WHERE Order_status = 'Cancelled'
  AND Order_date < CURRENT_DATE - INTERVAL '2 years'
  AND Order_id NOT IN (
      SELECT Order_id
      FROM Includes
  );
```
**צילום מצב לפני ההרצה:**  
מציג את הרשומות בטבלה לפני ביצוע פעולת המחיקה, כולל הנתונים שעומדים להימחק.
![לפני](dbFiles/delete1_before.jpeg)

**צילום הרצה:**  
מציג את הרצת שאילתת ה־DELETE והודעת המערכת על מספר הרשומות שנמחקו.
![הרצה](dbFiles/delete1_run.jpeg)

**צילום מצב אחרי ההרצה:**  
מציג את הטבלה לאחר המחיקה, כאשר ניתן לראות שהרשומות המתאימות הוסרו.
![אחרי](dbFiles/delete1_after.jpeg)

## DELETE 2 – מחיקת משמרות ללא עובדים

### מטרת השאילתה
השאילתה מוחקת משמרות בטבלה Work_Ship אשר אינן מקושרות לאף עובד בטבלת Employee_WorkShip.

מטרת השאילתה היא להסיר משמרות שאינן פעילות בפועל (ללא עובדים משויכים), ובכך לשמור על בסיס נתונים נקי ורלוונטי.

### קוד SQL
```sql
DELETE FROM Work_Ship
WHERE WS_id NOT IN (
    SELECT WS_id
    FROM Employee_WorkShip
);
```
**צילום מצב לפני ההרצה:** 
מציג את המשמרות לפני המחיקה, כולל משמרות ללא עובדים.
![לפני](dbFiles/delete2_before.jpeg)

**צילום הרצה:** 
מציג את הרצת שאילתת ה־DELETE והודעת המערכת על מספר הרשומות שנמחקו.
![הרצה](dbFiles/delete2_run.jpeg)

**צילום מצב אחרי ההרצה:**
מציג את הטבלה לאחר המחיקה, כאשר המשמרות ללא עובדים הוסרו.
![אחרי](dbFiles/delete2_after.jpeg)


---

## DELETE 3 – מחיקת חומרי גלם שאינם בשימוש

### מטרת השאילתה
השאילתה מוחקת חומרי גלם מטבלת RawMaterial אשר אינם משויכים לאף עיצוב בטבלת Requires ואינם כלולים באף הזמנה בטבלת Includes.

מטרת השאילתה היא להסיר חומרי גלם שאינם בשימוש במערכת, ובכך לשפר את איכות ויעילות הנתונים.

### קוד SQL
```sql
DELETE FROM RawMaterial
WHERE R_id NOT IN (
    SELECT R_id FROM Requires
)
AND R_id NOT IN (
    SELECT R_id FROM Includes
);
```
**צילום מצב לפני ההרצה:** 
מציג את חומרי הגלם לפני המחיקה, כולל חומרים שאינם בשימוש.
![לפני](dbFiles/delete3_before.jpeg)

**צילום הרצה:** 
מציג את הרצת שאילתת ה־DELETE והודעת המערכת על מספר הרשומות שנמחקו.
![הרצה](dbFiles/delete3_run.jpeg)

**צילום מצב אחרי ההרצה:**
מציג את הטבלה לאחר המחיקה, כאשר חומרי הגלם שאינם בשימוש הוסרו.
![אחרי](dbFiles/delete3_after.jpeg)

</details>


<details>
<summary>▶ ROLLBACK </summary>
## ROLLBACK – ביטול שינוי במחיר חומר גלם

### מטרת השאילתה
השאילתה מדגימה כיצד ניתן לבצע עדכון זמני בבסיס הנתונים באמצעות Transaction, ולאחר מכן לבטל את השינוי באמצעות פקודת ROLLBACK.

במקרה זה, עודכן המחיר של חומר גלם מסוים ולאחר מכן בוטל השינוי כדי להחזיר את הנתונים למצבם המקורי.

### קוד SQL
```sql
BEGIN;

UPDATE rawmaterial
SET r_price = r_price + 11
WHERE r_id = 5002;

SELECT *
FROM rawmaterial
WHERE r_id = 5002;

ROLLBACK;

SELECT *
FROM rawmaterial
WHERE r_id = 5002;
```
### ROLLBACK – תיעוד תהליך

**צילום מצב לפני העדכון:**  
מציג את ערך המחיר המקורי לפני ביצוע השינוי.  
![לפני](dbFiles/rollback_before.jpeg)

---

**צילום הרצה של העדכון:**  
מציג את ביצוע פעולת ה־UPDATE על הרשומה.  
![הרצה](dbFiles/rollback_run.jpeg)

---

**צילום מצב לאחר העדכון:**  
מציג את הערך לאחר שינוי המחיר לפני ביצוע ה־ROLLBACK.  
![אחרי עדכון](dbFiles/rollback_after_update.jpeg)

---

**צילום מצב לאחר ROLLBACK:**  
מציג שהערך חזר למצבו המקורי לאחר ביטול השינוי.  
![אחרי](dbFiles/rollback_after.jpeg)

</details>

<details>
<summary>▶ COMMIT </summary>

## COMMIT – שמירת שינוי בבסיס הנתונים

### מטרת הפעולה
השאילתה מדגימה כיצד ניתן לבצע עדכון בבסיס הנתונים בתוך Transaction, ולאחר מכן לשמור את השינוי באופן קבוע באמצעות פקודת COMMIT.

במקרה זה עודכן התקציב של מחלקה מסוימת, ולאחר מכן בוצע COMMIT כך שהשינוי נשמר בבסיס הנתונים.

---

### קוד SQL
```sql
BEGIN;

UPDATE department
SET budget = budget + 5000
WHERE de_id = 1;

SELECT *
FROM department
WHERE de_id = 1;

COMMIT;

SELECT *
FROM department
WHERE de_id = 1;
```
### COMMIT – תיעוד תהליך

**צילום מצב לפני העדכון:**  
מציג את ערך התקציב לפני ביצוע השינוי.  
![לפני](dbFiles/commit_before.jpeg)

---
![עדכון](dbFiles/commit_update.jpeg)

**צילום מצב לאחר העדכון:**  
מציג את הערך לאחר ביצוע העדכון אך לפני שמירתו לצמיתות.  
![אחרי עדכון](dbFiles/commit_update.jpeg)
![הרצה](dbFiles/commit_run.jpeg)
---

**צילום מצב לאחר COMMIT:**  
מציג שהשינוי נשמר בבסיס הנתונים ונשאר קבוע.  
![אחרי](dbFiles/commit_after.jpeg)

<details>

<details>
<summary>🔹 Constraints (אילוצים)</summary>

בשלב זה הוספנו אילוצים (Constraints) לבסיס הנתונים במטרה לשמור על תקינות הנתונים ולמנוע הכנסת ערכים לא חוקיים.

---

## 🔸 Constraint 1 – RawMaterial (מחיר חייב להיות חיובי)

**הסבר:**  
אילוץ זה מבטיח שלא ניתן להכניס חומר גלם עם מחיר שלילי או אפס.  
כך נשמרת תקינות עסקית של הנתונים, מאחר ומחיר חייב להיות ערך חיובי.

![אחרי](dbFiles/constraints.png)

**בדיקת שגיאה:**  
בוצע ניסיון להכניס חומר גלם עם מחיר שלילי, והמערכת החזירה שגיאה.  
השגיאה מוכיחה שהאילוץ נאכף ולא מאפשר הכנסת נתונים לא תקינים.

![אחרי](dbFiles/constraints_error.png)

---

## 🔸 Constraint 2 – SupplyOrder (סטטוס חוקי בלבד)

**הסבר:**  
אילוץ זה מגביל את הערכים האפשריים של סטטוס ההזמנה לרשימה מוגדרת מראש.  
מטרתו למנוע הכנסת ערכים לא תקינים ולשמור על אחידות הנתונים במערכת.
![אחרי](dbFiles/constraint2.png)

**בדיקת שגיאה:**  
בוצע ניסיון להכניס סטטוס שאינו קיים ברשימה החוקית, והתקבלה שגיאה.  
השגיאה מוכיחה שהמערכת חוסמת ערכים לא חוקיים.

![אחרי](dbFiles/constraint2_error.png)

---

## 🔸 Constraint 3 – Employee (תאריך לא יכול להיות בעתיד)

**הסבר:**  
אילוץ זה מבטיח שלא ניתן להכניס עובד עם תאריך עתידי.  
כך נשמרת אמינות הנתונים, מאחר ואין היגיון בהוספת עובד עם תאריך עתידי.

![אחרי](dbFiles/constaint3.png)



**בדיקת שגיאה:**  
בוצע ניסיון להכניס עובד עם תאריך עתידי, והמערכת החזירה שגיאה.  
השגיאה מוכיחה שהאילוץ פועל בצורה תקינה.

![אחרי](dbFiles/constaint3_error.png)

---
</details>

<details>
<summary>▶ אינדקסים והשוואת ביצועים</summary>

---

## INDEX 1 – אינדקס לפי תאריך הזמנה

### מטרת האינדקס
האינדקס נוצר על השדה `order_date` בטבלת `SupplyOrder`, כדי לשפר ביצועים של שאילתות שמחפשות הזמנות לפי טווח תאריכים וממיינות לפי תאריך.

### קוד SQL
```sql
EXPLAIN ANALYZE
SELECT
    order_id,
    order_date,
    total,
    order_status,
    s_id
FROM SupplyOrder
WHERE order_date BETWEEN '2024-01-01' AND '2024-03-31'
ORDER BY order_date;

CREATE INDEX idx_supplyorder_order_date
ON SupplyOrder(order_date);

EXPLAIN ANALYZE
SELECT
    order_id,
    order_date,
    total,
    order_status,
    s_id
FROM SupplyOrder
WHERE order_date BETWEEN '2024-01-01' AND '2024-03-31'
ORDER BY order_date;
```

**צילום לפני הוספת האינדקס**
מציג את זמן הריצה ותוכנית הביצוע של השאילתה לפני יצירת האינדקס.
![index1_before](dbFiles/index1_before.png)

**צילום אחרי הוספת האינדקס**
מציג את זמן הריצה ותוכנית הביצוע של אותה שאילתה לאחר יצירת האינדקס.
![index1_after](dbFiles/index1_after.png)

**הסבר התוצאה**
לאחר הוספת האינדקס, בסיס הנתונים יכול לאתר הזמנות לפי order_date בצורה יעילה יותר, במקום לסרוק את כל הטבלה.

## INDEX 2 – אינדקס לפי מחיר מוצר

### מטרת האינדקס
האינדקס נוצר על השדה `p_price` בטבלת `Product`, כדי לשפר ביצועים של שאילתות שמחפשות מוצרים לפי מחיר וממיינות לפי מחיר.

---

### קוד SQL
```sql
EXPLAIN ANALYZE
SELECT
    p_id,
    p_name,
    p_price,
    p_weight,
    p_data
FROM Product
WHERE p_price > 1000
ORDER BY p_price DESC;

CREATE INDEX idx_product_price
ON Product(p_price);

EXPLAIN ANALYZE
SELECT
    p_id,
    p_name,
    p_price,
    p_weight,
    p_data
FROM Product
WHERE p_price > 1000
ORDER BY p_price DESC;
```
**לפני הוספת האינדקס:**  
מציג את זמן הריצה ותוכנית הביצוע של השאילתה לפני יצירת האינדקס.
![index1_before](dbFiles/index2_before.png)

**אחרי הוספת האינדקס:** 
מציג את זמן הריצה ותוכנית הביצוע של אותה שאילתה לאחר יצירת האינדקס. 
![index1_after](dbFiles/index2_after.png)

**הסבר תוצאה**
האינדקס מאפשר חיפוש ומיון מהירים יותר לפי מחיר, במיוחד כאשר מספר הרשומות גדול.


### אינדקס 3: ייעול חיפוש עובד לפי מזהה (Employee ID)

**1. מוטיבציה ותועלת:**
במערכת לניהול דגמים וייצור, השליפה של פרטי עובד לפי המזהה הייחודי שלו (`e_id`) היא אחת הפעולות הנפוצות ביותר (למשל: בכניסה למערכת, בשיוך עובד להזמנה, או בעדכון פרטי שכר). ללא אינדקס, ככל שנתוני העובדים בטבלה יגדלו, מסד הנתונים ייאלץ לסרוק את כל הטבלה כדי למצוא רשומה אחת. הוספת האינדקס מאפשרת גישה ישירה (O(log n) במקום O(n)), מה שמשפר את חווית המשתמש ומוריד עומס מהשרת.

**2. שאילתת הבדיקה (Query):**
### קוד SQL
```sql
EXPLAIN ANALYZE
SELECT
    e_id,
    e_name,
    e_familyname,
    role,
    e_id
FROM Employee
WHERE e_id = 1;

CREATE INDEX idx_employee_department
ON Employee(e_id);

EXPLAIN ANALYZE
SELECT
    e_id,
    e_name,
    e_familyname,
    role,
    e_id
FROM Employee
WHERE e_id = 1;
```

**לפני הוספת האינדקס:**  
בתמונה ניתן לראות כי השאילתה מבוצעת באמצעות Seq Scan (סריקה מלאה של הטבלה).  
כלומר, בסיס הנתונים עובר על כל הרשומות בטבלת Employee כדי למצוא את העובד עם e_id = 1, דבר שעלול להיות איטי כאשר הטבלה גדולה.
![index1_before](dbFiles/index3_before.png)

**אחרי הוספת האינדקס:** 
בתמונה ניתן לראות כי השאילתה משתמשת ב־Index Scan במקום Seq Scan.  
במקרה זה, בסיס הנתונים נעזר באינדקס שנוצר על השדה e_id כדי לגשת ישירות לרשומה המתאימה, מבלי לסרוק את כל הטבלה. 
![index1_after](dbFiles/index3_after.png)

**הסבר תוצאה**
לאחר יצירת האינדקס, זמן הריצה של השאילתה השתפר מאחר ובסיס הנתונים כבר לא צריך לבצע סריקה מלאה של הטבלה.

האינדקס יוצר מבנה נתונים שמאפשר גישה ישירה לערכים לפי e_id, ולכן החיפוש הופך למהיר יותר.

במקרה זה השיפור עשוי להיות קטן, מכיוון שמדובר בחיפוש לפי מפתח ייחודי (Primary Key), ולעיתים בסיס הנתונים כבר מבצע אופטימיזציה פנימית.

עם זאת, בטבלאות גדולות יותר או בשדות שאינם מפתחות ראשיים, השימוש באינדקס יכול לשפר בצורה משמעותית את ביצועי השאילתות.


