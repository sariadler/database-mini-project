# targil0
# מיני פרויקט בבסיסי נתונים - אגף עיצוב וייצור

**מגישות:** שרי אדלר, מיכל גרינבלט וחני כהן  

**קורס:** מיני פרויקט בבסיסי נתונים  
**נושא האגף:** עיצוב וייצור (דגמים, חומרי גלם, מוצרים, ספקים ועובדים)
---
## שלב א – תכנון, עיצוב וייצור בסיס הנתונים
<details>
<summary><b> מבוא וניתוח המערכת</b></summary>

### 1. ניתוח מערכת TOP-DOWN
בשלב זה תוכננו מסכי המערכת הראשוניים בעזרת Google AI Studio. המטרה היא להמחיש את זרימת המידע בין הישויות השונות (מוצרים, חומרי גלם ועיצובים) בממשק המשתמש.

#### סקיצות ממשק (Wireframes):

**לוח בקרה (Dashboard):**
מציג סטטיסטיקות על תהליכי הייצור ומלאי חומרי הגלם.
![Dashboard UI](DBProject/dbFiles/ui_dashboard.png)

**ניהול מוצרים:**
טבלת מעקב אחר מוצרים קיימים והקשר שלהם לדגמי העיצוב.
![Product Management UI](DBProject/dbFiles/ui_products.png)

**טופס הזנת עיצוב חדש:**
ממשק להזנת מפרטים טכניים כולל תמיכה בפורמט JSON.
![New Design Form](DBProject/dbFiles/ui_design_form.png)

**ניהול ספקים:**
מסך לניהול ספקים, כולל צפייה, הוספה ועדכון פרטי ספקים במערכת.
![Supplier Management UI](DBProject/dbFiles/ui_suppliers.png)

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
![ERD Diagram](DBProject/dbFiles/erd_diagram.jpeg)

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
<summary><b> נירמול ותלויות פונקציונליות (BCNF)</b></summary>
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
<summary><b>  מימוש פיזי, מילוי נתונים וגיבוי המערכת </b></summary>
<br>

### מעבר מהתכנון הלוגי למימוש הפיזי

המעבר מהתכנון הלוגי למימוש הפיזי בוצע על בסיס דיאגרמת ה-ERD.  
פקודות CREATE TABLE נכתבו בהתאם למבנה הישויות, התכונות והקשרים שהוגדרו בתכנון, ולאחר מכן הורצו ב-pgAdmin ליצירת הסכמה המלאה.

### DSD - Data Structure Diagram

לאחר בניית הטבלאות ב-PostgreSQL, הופק תרשים ה-DSD (Data Structure Diagram) המשקף את מבנה הנתונים הסופי. התרשים מציג את טיפוסי הנתונים המדויקים, המפתחות הראשיים והקשרים הפיזיים (Foreign Keys) בין הישויות באגף הייצור.

![DSD Diagram](DBProject/dbFiles/dsd_diagram.png)

![DSD Diagram](DBProject/dbFiles/pgadmin_view_data.png)

<details>
<summary><b>שיטת Python</b></summary>
<br>

---

***💻 א. מימוש פיזי בבסיס הנתונים***
בשלב זה הפכנו את המודל הלוגי (ERD) לבסיס נתונים פיזי מתפקד בתוך סביבת המערכת ב-pgAdmin.

**תיאור המימוש:**
באמצעות ממשק ה-pgAdmin, הרצנו סקריפטים של SQL ליצירת הסכימה המלאה הכוללת את כל הטבלאות והקשרים. התמונה להלן מציגה את מבנה הטבלאות כפי שנוצרו:

![Tables View](DBProject/dbFiles/pgadmin_view_data.png)
ניתן לראות כי כל הטבלאות שהוגדרו בתכנון אכן נוצרו בהצלחה בבסיס הנתונים.

* **אימות מימוש**: ניתן לראות כי כל הישויות שהוגדרו בתכנון נוצרו בהצלחה תחת הסכימה הציבורית (public).
* **אילוצים וקשרים**: המימוש כולל הגדרת מפתחות ראשיים (PK) ומפתחות זרים (FK) המבטיחים את שלמות הנתונים.

---

***🐍 ב. מילוי נתונים (Data Population) - אסטרטגיה וביצוע***

כדי לעמוד בדרישה של מעל **500 רשומות** בטבלאות המרכזיות ולשמור על דיוק מקצועי, בחרנו להשתמש באוטומציה של סקריפטים ב-Python. התהליך בוצע בסדר כרונולוגי מחייב כדי למנוע שגיאות של מפתחות זרים.

---

#### 🛠 שלב 1: יצירת תשתית המוצרים (`fill_products.py`)
בשלב הראשון כתבנו קוד Python שמייצר נתונים רנדומליים אך הגיוניים עבור המוצרים שלנו. הקוד יוצר קובץ SQL מוכן להרצה.

![VS Code Script](DBProject/dbFiles/vscode_screenshot.png)

---

#### 🎨 שלב 2: יצירת פקודות ה-Insert
כאן ניתן לראות את קובץ ה-SQL שנוצר (`insert_products.sql`) עם פקודות ה-INSERT המוכנות. כללנו לוגיקה שיוצרת גם ערכי **NULL** באופן רנדומלי כדי לעמוד בדרישות הפרויקט לטיפול בנתונים חסרים.

![Insert Commands](DBProject/dbFiles/insert_commands.png)

---

#### 🚀 שלב 3: ייבוא ואימות ב-pgAdmin
העתקנו את פקודות ה-Insert לתוך ה-Query Tool ב-**pgAdmin** והרצנו אותן כדי למלא את הטבלאות בפועל.

![pgAdmin Execution](DBProject/dbFiles/pgadmin_insert.png)

בסיום התהליך, ביצענו שאילתת **COUNT** על טבלת העיצובים (design) כדי לוודא שכל 500 הרשומות נקלטו בהצלחה בבסיס הנתונים.

![pgAdmin Count](DBProject/dbFiles/pgadmin_count.png)
הנתונים שנוצרו באמצעות סקריפט Python הוזנו בהצלחה לבסיס הנתונים כפי שניתן לראות בתוצאה.

</details>

<details>
<summary><b>שיטת Mockaroo (SQL Export) - טבלת Supplier</b></summary>
<br>

בשיטה זו השתמשנו באתר [Mockaroo](https://www.mockaroo.com/) כדי למלא 500 רשומות לטבלת הספקים. זה עזר לנו לייצר נתונים שנראים אמיתיים בצורה מהירה ומדויקת.

**כך נראה התהליך שעשינו:**

**1. הגדרת הנתונים באתר:**
בצילום המסך אפשר לראות איך התאמנו את סוגי השדות (שם חברה, כתובת, טלפון) למבנה הטבלה שלנו. כדי לעמוד בדרישה של המטלה לערכים חסרים, הגדרנו אחוזי **Blank** (ערכי NULL) בשדות הטלפון והכתובת.

![Mockaroo Settings](DBProject/dbFiles/mockaroo_settings.png)

---

**2. בדיקת הנתונים לפני ההורדה:**
כאן אפשר לראות בתצוגה המקדימה שהאתר אכן ייצר נתונים בפורמט הנכון, כולל שמות חברות באנגלית ונתוני ה-JSON, מה שמוודא שהקובץ יהיה תקין לפני הייבוא.

![Data Preview](DBProject/dbFiles/mockaroo_data_preview.png)

---

**3. שמירה וניהול ב-VS Code:**
הורדנו את הנתונים כקובץ SQL ושמרנו אותו בתיקיית הפרויקט שלנו. בתמונה רואים איך הקוד נראה בתוך ה-**VS Code** – שמירת הקובץ כאן מאפשרת לכל הבנות בצוות למשוך את הקובץ מה-GitHub ולהשתמש בו בבסיס הנתונים המקומי שלהן.

![VS Code SQL View](DBProject/dbFiles/vscode_sql_preview.png)

---

**4. הרצה ב-pgAdmin:**
העתקנו את פקודות ה-Insert מהקובץ והרצנו אותן ב-Query Tool. התמונה מראה את רגע ההרצה בתוך התוכנה והזנת הנתונים למחסן הנתונים הפיזי.

![pgAdmin Execution](DBProject/dbFiles/pgadmin_insert_query.png)

---

**5. התוצאה הסופית:**
בבדיקה בבסיס הנתונים אפשר לראות שהטבלה התמלאה ב-500 שורות. ניתן לראות בבירור את ערכי ה-**NULL** (השדות הריקים) שנוצרו רנדומלית, בדיוק לפי דרישות הפרויקט.

![Final Supplier Table](DBProject/dbFiles/supplier_table_results.png)
ניתן לראות כי חלק מהשדות מכילים ערכי NULL בהתאם לדרישות המטלה.

</details>

</details>

<details>
<summary><b>שיטת Mockaroo (SQL Export) - טבלאות Product ו־Design</b></summary>

כדי למלא 500 רשומות בטבלאות המרכזיות, השתמשנו באתר Mockaroo ליצירת נתונים אקראיים בצורה מהירה ואמינה.

בשלב הראשון הגדרנו את השדות בהתאם למבנה הטבלאות, ולאחר מכן ייצאנו את הנתונים בפורמט SQL.

![Mockaroo Schema](DBProject/dbFiles/mockaroo_product.png)

את קובצי ה־SQL הרצנו ב־pgAdmin, וכך הוזנו הנתונים לטבלאות Product ו־Design.

לאחר ההרצה ביצענו בדיקת COUNT על מנת לוודא שכל הנתונים הוכנסו בהצלחה.

![Schema Create](DBProject/dbFiles/schema_create.png)
![Product Insert](DBProject/dbFiles/product_insert.png)
![Product Count](DBProject/dbFiles/product_count.JPG)
![Design Insert](DBProject/dbFiles/design_insert.png)
![Design Count](DBProject/dbFiles/design_count.png)

</details>

---

<details>
<summary><b>שיטת SQL (Generate Series) - טבלת RawMaterial</b></summary>

בטבלה זו השתמשנו בפקודת SQL מובנית של PostgreSQL בשם generate_series כדי ליצור כמות גדולה של נתונים בצורה אוטומטית.

בתחילה הוכנסו מספר רשומות ידניות לצורך בדיקה, ולאחר מכן בוצעה הכנסת נתונים אוטומטית באמצעות generate_series יחד עם פונקציות random ליצירת מחירים וכמויות.

השיטה אפשרה יצירה מהירה ויעילה של 500 רשומות ללא שימוש בכלים חיצוניים.

לאחר ההרצה ביצענו בדיקת COUNT כדי לוודא שהנתונים הוכנסו בהצלחה.

![RawMaterial Insert](DBProject/dbFiles/rawmaterial_insert.png)
![RawMaterial Count](DBProject/dbFiles/rawmaterial_count.png)

בתמונה הבאה ניתן לראות בדיקה מרוכזת של כמות הרשומות בכל הטבלאות לאחר הכנסת הנתונים:
![Generate Series Query](DBProject/dbFiles/all_tables_count.png)

</details>

<details>
<summary><b>שיטת Excel - טבלת Department</b></summary>
<br>

בשיטה זו השתמשנו בקובץ Excel לצורך יצירת נתונים לטבלת Department.

תחילה נבנה קובץ Excel הכולל את כל העמודות בהתאם למבנה הטבלה במערכת:
DE_id, DE_name, Location, Budget, Manager_Name, E_id, PL_id.

הנתונים נוצרו בצורה אוטומטית באמצעות גרירה (fill) באקסל, כך שנוצרו רשומות רבות בצורה מהירה ויעילה.

![Excel Data](DBProject/dbFiles/excel_department.png)

לאחר מכן שמרנו את הקובץ בפורמט CSV (UTF-8), והשתמשנו ב־pgAdmin כדי לייבא את הנתונים לטבלה באמצעות האפשרות Import.

![Import Settings](DBProject/dbFiles/import_department.png)

![Department Data](DBProject/dbFiles/department_result.png)

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

![Duplicate Key Error](DBProject/dbFiles/duplicate_error.png)
![Foreign Key Error](DBProject/dbFiles/foreign_key_error.png)


</details>

---

<details>
<summary><b>גיבוי בסיס הנתונים (Backup)</b></summary>

לאחר סיום מילוי הנתונים, ביצענו גיבוי מלא של בסיס הנתונים באמצעות pgAdmin.
הגיבוי בוצע באמצעות pgAdmin על ידי לחיצה ימנית על בסיס הנתונים ובחירה באפשרות Backup.  
נבחר פורמט Custom (.backup), המאפשר גיבוי מלא של מבנה הנתונים והתוכן.
הגיבוי כולל גם את מבנה הטבלאות וגם את הנתונים (Schema + Data), ולכן מאפשר שחזור מלא של המערכת.


![Backup](DBProject/dbFiles/backup.png)

בנוסף לגיבוי שבוצע באמצעות pgAdmin, בוצע גיבוי נוסף באמצעות שורת פקודה (pg_dump) מתוך Docker container.
הגיבוי בוצע בהצלחה והקובץ נשמר בתיקיית backup של הפרויקט.

![Backup via Command Line](DBProject/dbFiles/backup_cmd.png)

</details>

---

<details>
<summary><b>שחזור בסיס הנתונים (Restore)</b></summary>

כדי לוודא את תקינות הגיבוי, ביצענו תהליך שחזור.

נוצר בסיס נתונים חדש בשם test_restore, ולאחר מכן בוצע Restore מקובץ הגיבוי.

לאחר השחזור בוצעה בדיקת COUNT על טבלת Product, אשר הראתה כי כל הנתונים שוחזרו בהצלחה.

השחזור בוצע על מנת לוודא שקובץ הגיבוי תקין וניתן להשתמש בו לשחזור מלא של בסיס הנתונים.

![Create Restore DB](DBProject/dbFiles/create_restore_db.png)
![Restore Count](DBProject/dbFiles/restore_count.png)

</details>
---

## שלב ב – שאילתות ואילוצים

<details>
<summary><b>▶ שאילתות SELECT</b></summary>
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



<details>
<summary><b>SELECT 1 – סיכום הזמנות לפי ספק ותאריך</b></summary>
<br>

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

![הרצה](DBProject/dbFiles/select1_run.png)
<*![תוצאה](DBProject/dbFiles/select1_result.png)*>
</details>


<details>
<summary><b>SELECT 2 – מוצרים, עיצובים וכמות חומרי גלם נדרשים</b></summary>
<br>

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

![הרצה](DBProject/dbFiles/select2_run.png)
<*![תוצאה](DBProject/dbFiles/select2_result.png)*>

</details>


<details>
<summary><b>SELECT 3 – חומרי גלם המשמשים בעיצובים ובהזמנות</b></summary>
<br>

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

![הרצה](DBProject/dbFiles/select3_run.png)
<*![תוצאה](DBProject/dbFiles/select3_result.png)*>
</details>


<details>
<summary><b>SELECT 4 – מוצרים שמחירם גבוה מהממוצע</b></summary>
<br>
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


![תוצאה](DBProject/dbFiles/select4_run.png)
<*![תוצאה](DBProject/dbFiles/select4_result.png)*>

</details>


<details>
<summary><b>SELECT 5 – ספקים שיש להם הזמנות (השוואה בין IN ל־EXISTS)</b></summary>
<br>
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

![הרצה](DBProject/dbFiles/select5A_run.png)
<*![תוצאה](DBProject/dbFiles/select5A_result.png)*>

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

![הרצה](DBProject/dbFiles/select5B_run.png)
<*![תוצאה](DBProject/dbFiles/select5B_result.png)*>

## מה יותר יעיל ולמה

השימוש בEXIST בדכ יותר יעיל מהשימוש בIN.

IN מחזיר רשימה של ערכים מתת־השאילתה ומשווה אליה,  
בעוד EXISTS בודק רק אם קיימת שורה מתאימה ועוצר ברגע שמצא אחת.

לכן, בטבלאות גדולות EXISTS לרוב יעיל יותר.  
עם זאת, PostgreSQL יכול לבצע אופטימיזציה ולכן לעיתים ההבדל לא משמעותי.

</details>


<details>
<summary><b>SELECT 6 – מוצרים שיש להם עיצוב (השוואה בין IN ל־JOIN)</b></summary>
<br>

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

![הרצה](DBProject/dbFiles/select6A_run.png)
<*![תוצאה](DBProject/dbFiles/select6A_result.png)*>

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

![הרצה](DBProject/dbFiles/select6B_run.png)
<*![תוצאה](DBProject/dbFiles/select6B_result.png)*>

## הסבר והבדל בין השיטות

שתי השאילתות מחזירות את אותם מוצרים — מוצרים שיש להם לפחות עיצוב אחד בטבלת Design.

בגרסת IN, תת־השאילתה מחזירה רשימה של מזהי מוצרים מטבלת Design,  
והשאילתה הראשית בודקת האם כל מוצר נמצא ברשימה זו.

בגרסת JOIN, מתבצע חיבור ישיר בין הטבלאות Product ו־Design לפי מזהה המוצר (P_id).  
במקרה זה השתמשנו ב־DISTINCT כדי למנוע כפילויות, מאחר שלמוצר יכול להיות יותר מעיצוב אחד.

מבחינת יעילות, JOIN נחשב בדרך כלל ליעיל יותר כאשר מדובר בקשר בין טבלאות,  
מאחר שמערכת ניהול בסיס הנתונים יכולה לבצע אופטימיזציה טובה יותר לחיבור בין הטבלאות.  
לעומת זאת, IN מתאים יותר למצבים של בדיקה מול רשימה של ערכים.

</details>


<details>
<summary><b>SELECT 7 – חומרי גלם המשמשים בעיצובים (השוואה בין EXISTS ל־JOIN)</b></summary>
<br>

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

![הרצה](DBProject/dbFiles/select7A_run.png)
<*![תוצאה](DBProject/dbFiles/select7A_result.png)*>

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
![הרצה](DBProject/dbFiles/select7B_run.png)
<*![תוצאה](DBProject/dbFiles/select7B_result.png)*>

## הסבר והבדל בין השיטות

שתי השאילתות מחזירות את אותם חומרי גלם — כאלה שמופיעים בטבלת Requires.

בגרסת EXISTS מתבצעת בדיקה עבור כל חומר גלם האם קיימת לפחות רשומה אחת מתאימה.  
ברגע שנמצאת התאמה, הבדיקה נעצרת.

בגרסת JOIN מתבצע חיבור בין הטבלאות, ולכן אותו חומר גלם יכול להופיע מספר פעמים, ולכן נדרש שימוש ב־DISTINCT.

מבחינת יעילות, EXISTS בדרך כלל יעיל יותר כאשר רוצים רק לבדוק קיום,  
בעוד JOIN מתאים כאשר רוצים גם לשלוף נתונים מהטבלה המקושרת.
</details>


<details>
<summary><b>SELECT 8 – עובדים שעבדו במשמרות (השוואה בין IN ל־JOIN)</b></summary>
<br>
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


![הרצה](DBProject/dbFiles/select8A_run.png)
<*![תוצאה](DBProject/dbFiles/select8A_result.png)*>
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
![הרצה](DBProject/dbFiles/select8B_run.png)
<*![תוצאה](DBProject/dbFiles/select8B_result.png)*>
</details>


<details>
<summary><b> SELECT 9 – איתור מוצרים מעל 1000 ש"ח שיש להם עיצוב</b></summary>

<br>
## SELECT 9 – איתור מוצרים מעל 1000 ש"ח שיש להם עיצוב

### מטרת השאילתה
למצוא את כל המוצרים שמחירם מעל 1000 ש"ח ושכבר קיים עבורם דגם עיצובי במערכת. זה מאפשר לנו לוודא שלכל המוצרים בסכום זה יש תכנון תקין.



---

## הסבר והבדל בין השיטות

שתי השאילתות מציגות את אותה התוצאה בדרכים שונות:

* **בגרסת ה-IN (בדיקת רשימה):** המחשב עובר על טבלת המוצרים ובודק האם כל מוצר מופיע ברשימת העיצובים. זו דרך פשוטה שמונעת כפילויות באופן אוטומטי.
* **בגרסת ה-JOIN (חיבור טבלאות):** המחשב ממש "מדביק" את שתי הטבלאות זו לזו לפי מספר המוצר. בגלל שחיבור כזה עלול להציג את אותו מוצר כמה פעמים, השתמשנו בפקודת DISTINCT כדי שכל מוצר יופיע רק פעם אחת ברשימה.

---


## גרסה 1 – שימוש ב-IN

### קוד SQL

```sql
SELECT 
    p.P_id AS "Product_ID", 
    p.P_name AS "Product_Name", 
    p.P_price AS "Unit_Price"
FROM Product p
WHERE p.P_price > 1000 
  AND p.P_id IN (
    SELECT d.P_id 
    FROM Design d
);
```

![הרצה](DBProject/dbFiles/Select9ARun.JPG)
![תוצאה](DBProject/dbFiles/Select9AResult.JPG)


## גרסה 2 – שימוש ב-JOIN

### קוד SQL
```sql
SELECT DISTINCT
    p.P_id AS "Product_ID", 
    p.P_name AS "Product_Name", 
    p.P_price AS "Unit_Price"
FROM Product p
JOIN Design d ON p.P_id = d.P_id
WHERE p.P_price > 1000;
```
![הרצה](DBProject/dbFiles/Select9BRun.JPG)
![תוצאה](DBProject/dbFiles/Select9BResult.JPG)
</details>


<details>
<summary><b>SELECT 10 – איתור קווי ייצור המייצרים מעל 5 מוצרים שונים</b></summary>

<br>


### מטרת השאילתה
לזהות קווי ייצור עמוסים במיוחד. השאילתה סופרת כמה מוצרים שונים משויכים לכל קו ייצור ומציגה רק את הקווים שאחראים על יותר מ-5 מוצרים.

### קוד SQL
```sql
SELECT 
    pl.pl_id AS "Line_ID", 
    pl.factory_location AS "Factory_Location", 
    COUNT(p.p_id) AS "Total_Products"
FROM Product_Line pl
JOIN Product p ON pl.pl_id = p.p_id
GROUP BY pl.pl_id, pl.factory_location
HAVING COUNT(p.p_id) > 5
ORDER BY "Total_Products" DESC;
```
![הרצה](DBProject/dbFiles/Select10AResult.JPG)

</details>


<details>
<summary><b> SELECT 11 – ניתוח עומס ייצור לפי מחלקות (GROUP BY & HAVING)</b></summary>
<br>

### מטרת השאילתה
לזהות אילו מחלקות במפעל אחראיות על ייצור של מספר גדול של מוצרים שונים. מידע זה קריטי להקצאת כוח אדם ומשאבים.

### הסבר הלוגיקה
השאילתה מחברת בין טבלת המחלקות לטבלת המוצרים. אנו משתמשים ב-`GROUP BY` כדי לרכז את הנתונים לפי שם המחלקה, וב-`HAVING` כדי להציג רק מחלקות שמשויכים אליהן יותר ממוצר אחד שונה.

### קוד SQL
```sql
SELECT 
    d.de_name AS "Department_Name", 
    COUNT(p.P_id) AS "Total_Products"
FROM Department d
JOIN Product p ON d.e_id = p.p_id
GROUP BY d.de_name
HAVING COUNT(p.p_id) > 0
ORDER BY "Total_Products" DESC;
```
![הרצה](DBProject/dbFiles/Select11AResult.JPG)

</details>

</details>
<details>
<summary><b>▶ UPDATE – שאילתות עדכון נתונים</b></summary>
<br>

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


![update_run](DBProject/dbFiles/update_run.png)
![update_before](DBProject/dbFiles/update_before.png)
![update_after](DBProject/dbFiles/update_after.png)



<*## UPDATE – שאילתות עדכון נתונים*>

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
![update2_run](DBProject/dbFiles/update2_run.png)
![update2_run](DBProject/dbFiles/update2_before.png)
![update2_run](DBProject/dbFiles/update2_after.png)


<*## UPDATE – שאילתות עדכון נתונים*>

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
![update3_run](DBProject/dbFiles/update3_run.png)
![update3_run](DBProject/dbFiles/update3_before.png)
![update3_run](DBProject/dbFiles/update3_after.png)





<details>
<summary><b>UPDATE 4: הוזלת חומרי גלם יקרים (Raw Material)</b></summary>
<br>

**1. לפני השינוי (Before):** מחירי חומרי הגלם המקוריים הגבוהים מ-99:
![update4_before](DBProject/dbFiles/update4_before.JPG)

**2. קוד SQL לביצוע העדכון:**
```sql
-- Purpose: Apply a 10% discount to high-cost materials
UPDATE rawmaterial
SET r_price = r_price * 0.90
WHERE r_price > 99;

COMMIT;
```
**3. אחרי השינוי (After):** מחירי חומרי הגלם לאחר ההוזלה ב-10%:
![update4_after](DBProject/dbFiles/update4_after.JPG)


</details>


<details>
<summary><b>UPDATE 5: שדרוג משלוח להזמנות גדולות (Supply Order)</b></summary>
<br>

**1. לפני השינוי (Before):** איתור הזמנות שסכומן הכולל עולה על 200 ש"ח ושיטת המשלוח שלהן אינה אקספרס:
![update5_before](DBProject/dbFiles/update5_before.JPG)

**2. קוד SQL לביצוע העדכון:**
```sql
-- Purpose: Upgrade shipping to Express for orders over 200
UPDATE supplyorder
SET shipping_method = 'Express'
WHERE total > 200;

COMMIT;
```
**3. אחרי השינוי (After):** מחירי חומרי הגלם לאחר ההוזלה ב-10%:
![update4_after](DBProject/dbFiles/update5_after.JPG)


<details>
<summary><b>UPDATE 6: הגדלת מלאי לעיצובים חדשים (Stock Update)</b></summary>
<br>

**1. לפני השינוי (Before):** בדיקת כמות המלאי הנוכחית של חומרי גלם המשמשים בעיצובים משנת 2025 ואילך:
![update6_before](DBProject/dbFiles/update6_before.JPG)

**2. קוד SQL לביצוע העדכון:**
```sql
-- Purpose: Increase stock by 20% for materials used in designs from 2025 onwards
UPDATE rawmaterial
SET stock_quantity = stock_quantity * 1.20
WHERE r_id IN (
    SELECT r.r_id
    FROM requires r
    JOIN design d ON r.d_id = d.d_id
    WHERE d.d_data >= '2025-01-01'
);

COMMIT;
```
**3. אחרי השינוי (After):** מחירי חומרי הגלם לאחר ההוזלה ב-10%:
![update4_after](DBProject/dbFiles/update6_after.JPG)
</details>


<details>
<summary><b>▶ DELETE – שאילתות מחיקת נתונים</b></summary>
<br>

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
![לפני](DBProject/dbFiles/delete1_before.jpeg)

**צילום הרצה:**  
מציג את הרצת שאילתת ה־DELETE והודעת המערכת על מספר הרשומות שנמחקו.
![הרצה](DBProject/dbFiles/delete1_run.jpeg)

**צילום מצב אחרי ההרצה:**  
מציג את הטבלה לאחר המחיקה, כאשר ניתן לראות שהרשומות המתאימות הוסרו.
![אחרי](DBProject/dbFiles/delete1_after.jpeg)

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
![לפני](DBProject/dbFiles/delete2_before.jpeg)

**צילום הרצה:** 
מציג את הרצת שאילתת ה־DELETE והודעת המערכת על מספר הרשומות שנמחקו.
![הרצה](DBProject/dbFiles/delete2_run.jpeg)

**צילום מצב אחרי ההרצה:**
מציג את הטבלה לאחר המחיקה, כאשר המשמרות ללא עובדים הוסרו.
![אחרי](DBProject/dbFiles/delete2_after.jpeg)


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
![לפני](DBProject/dbFiles/delete3_before.jpeg)

**צילום הרצה:** 
מציג את הרצת שאילתת ה־DELETE והודעת המערכת על מספר הרשומות שנמחקו.
![הרצה](DBProject/dbFiles/delete3_run.jpeg)

**צילום מצב אחרי ההרצה:**
מציג את הטבלה לאחר המחיקה, כאשר חומרי הגלם שאינם בשימוש הוסרו.
![אחרי](DBProject/dbFiles/delete3_after.jpeg)

</details>


<details>
<summary><b>▶ ROLLBACK </b></summary>
<br>
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
![לפני](DBProject/dbFiles/rollback_before.jpeg)

---

**צילום הרצה של העדכון:**  
מציג את ביצוע פעולת ה־UPDATE על הרשומה.  
![הרצה](DBProject/dbFiles/rollback_run.jpeg)

---

**צילום מצב לאחר העדכון:**  
מציג את הערך לאחר שינוי המחיר לפני ביצוע ה־ROLLBACK.  
![אחרי עדכון](DBProject/dbFiles/rollback_after_update.jpeg)

---

**צילום מצב לאחר ROLLBACK:**  
מציג שהערך חזר למצבו המקורי לאחר ביטול השינוי.  
![אחרי](DBProject/dbFiles/rollback_after.jpeg)

</details>

<details>
<summary><b>▶ COMMIT </b></summary>
<br>

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
![לפני](DBProject/dbFiles/commit_before.jpeg)

---
![עדכון](DBProject/dbFiles/commit_update.jpeg)

**צילום מצב לאחר העדכון:**  
מציג את הערך לאחר ביצוע העדכון אך לפני שמירתו לצמיתות.  
![אחרי עדכון](DBProject/dbFiles/commit_update.jpeg)
![הרצה](DBProject/dbFiles/commit_run.jpeg)
---

**צילום מצב לאחר COMMIT:**  
מציג שהשינוי נשמר בבסיס הנתונים ונשאר קבוע.  
![אחרי](DBProject/dbFiles/commit_after.jpeg)

</details>

<details>
<summary><b>▶ Constraints (אילוצים)</b></summary>
<br>

בשלב זה הוספנו אילוצים (Constraints) לבסיס הנתונים במטרה לשמור על תקינות הנתונים ולמנוע הכנסת ערכים לא חוקיים.

---

## 🔸 Constraint 1 – RawMaterial (מחיר חייב להיות חיובי)

**הסבר:**  
אילוץ זה מבטיח שלא ניתן להכניס חומר גלם עם מחיר שלילי או אפס.  
כך נשמרת תקינות עסקית של הנתונים, מאחר ומחיר חייב להיות ערך חיובי.

![אחרי](DBProject/dbFiles/constraints.png)

**בדיקת שגיאה:**  
בוצע ניסיון להכניס חומר גלם עם מחיר שלילי, והמערכת החזירה שגיאה.  
השגיאה מוכיחה שהאילוץ נאכף ולא מאפשר הכנסת נתונים לא תקינים.

![אחרי](DBProject/dbFiles/constraints_error.png)

---

## 🔸 Constraint 2 – SupplyOrder (סטטוס חוקי בלבד)

**הסבר:**  
אילוץ זה מגביל את הערכים האפשריים של סטטוס ההזמנה לרשימה מוגדרת מראש.  
מטרתו למנוע הכנסת ערכים לא תקינים ולשמור על אחידות הנתונים במערכת.
![אחרי](DBProject/dbFiles/constraint2.png)

**בדיקת שגיאה:**  
בוצע ניסיון להכניס סטטוס שאינו קיים ברשימה החוקית, והתקבלה שגיאה.  
השגיאה מוכיחה שהמערכת חוסמת ערכים לא חוקיים.

![אחרי](DBProject/dbFiles/constraint2_error.png)

---

## 🔸 Constraint 3 – Employee (תאריך לא יכול להיות בעתיד)

**הסבר:**  
אילוץ זה מבטיח שלא ניתן להכניס עובד עם תאריך עתידי.  
כך נשמרת אמינות הנתונים, מאחר ואין היגיון בהוספת עובד עם תאריך עתידי.

![אחרי](DBProject/dbFiles/constaint3.png)



**בדיקת שגיאה:**  
בוצע ניסיון להכניס עובד עם תאריך עתידי, והמערכת החזירה שגיאה.  
השגיאה מוכיחה שהאילוץ פועל בצורה תקינה.

![אחרי](DBProject/dbFiles/constaint3_error.png)

</details>

<details>
<summary><b>▶ אינדקסים והשוואת ביצועים</b></summary>
<br>

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
![index1_before](DBProject/dbFiles/index1_before.png)

**צילום אחרי הוספת האינדקס**
מציג את זמן הריצה ותוכנית הביצוע של אותה שאילתה לאחר יצירת האינדקס.
![index1_after](DBProject/dbFiles/index1_after.png)

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
![index1_before](DBProject/dbFiles/index2_before.png)

**אחרי הוספת האינדקס:** 
מציג את זמן הריצה ותוכנית הביצוע של אותה שאילתה לאחר יצירת האינדקס. 
![index1_after](DBProject/dbFiles/index2_after.png)

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
![index1_before](DBProject/dbFiles/index3_before.png)

**אחרי הוספת האינדקס:** 
בתמונה ניתן לראות כי השאילתה משתמשת ב־Index Scan במקום Seq Scan.  
במקרה זה, בסיס הנתונים נעזר באינדקס שנוצר על השדה e_id כדי לגשת ישירות לרשומה המתאימה, מבלי לסרוק את כל הטבלה. 
![index1_after](DBProject/dbFiles/index3_after.png)

**הסבר תוצאה**
לאחר יצירת האינדקס, זמן הריצה של השאילתה השתפר מאחר ובסיס הנתונים כבר לא צריך לבצע סריקה מלאה של הטבלה.

האינדקס יוצר מבנה נתונים שמאפשר גישה ישירה לערכים לפי e_id, ולכן החיפוש הופך למהיר יותר.

במקרה זה השיפור עשוי להיות קטן, מכיוון שמדובר בחיפוש לפי מפתח ייחודי (Primary Key), ולעיתים בסיס הנתונים כבר מבצע אופטימיזציה פנימית.

עם זאת, בטבלאות גדולות יותר או בשדות שאינם מפתחות ראשיים, השימוש באינדקס יכול לשפר בצורה משמעותית את ביצועי השאילתות.
</details>



