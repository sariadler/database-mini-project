import random
import json
from datetime import datetime, timedelta

def generate_design_data(num_records=500):
    # שמות דגמים יוקרתיים ברוח מותגי על (Luxury Footwear)
    shoe_styles = [
        "מגף Heritage Calfskin", 
        "סנדל Amalfi Silk", 
        "נעלי ריצה Quantum-Tech", 
        "נעלי ערב Royal Velvet", 
        "סניקרס Urban Canvas Limited",
        "מוקסין Midnight Suede",
        "נעלי עקב Starlight Satin",
        "מגף רכיבה Windsor Leather",
        "סנדל גלדיאטור Aurora",
        "נעלי אוקספורד Maestro"
    ]

    # תיאורי עיצוב מקצועיים לאגף הייצור
    descriptions = [
        "מהדורה מוגבלת בעבודת יד", 
        "עור איטלקי בעיבוד טבעי", 
        "סוליה בולמת זעזועים מתקדמת", 
        "גימור פרימיום עמיד במים",
        "עיצוב ארכיטקטוני בהשראת פריז",
        "תפירה כפולה לחוזק מקסימלי",
        "בטנת משי רכה לנוחות מירבית",
        "טקסטורת נחש במראה יוקרתי"
    ]

    sql_commands = []
    
    for i in range(1, num_records + 1):
        d_id = i
        # בחירת שם דגם עם מספר סידורי רנדומלי
        d_name = f"'{random.choice(shoe_styles)} {random.randint(100, 999)}'"
        
        # דרישת המרצה: חלק מהשדות יקבלו ערך NULL באופן רנדומלי (כאן 15% מהמקרים)
        if random.random() > 0.15:
            d_description = f"'{random.choice(descriptions)}'"
        else:
            d_description = "NULL"
        
        # d_data (שדה תאריך) - תאריכים סביב תחילת 2025
        random_days = random.randint(0, 365)
        d_data = f"'{ (datetime(2025, 1, 1) + timedelta(days=random_days)).date() }'"
        
        # json_specs (שדה JSON - לפחות 2 בפרויקט)
        specs = {
            "material": random.choice(["Leather", "Rubber", "Fabric", "Silk"]),
            "designer": random.choice(["Michal", "Chani", "Sari", "International Studio"]),
            "season": random.choice(["Spring-Summer 2026", "Winter-Autumn 2025"]),
            "quality_check": random.choice(["Passed", "Pending", "Top Priority"])
        }
        json_specs = f"'{json.dumps(specs)}'"
        
        # p_id (מפתח זר לטבלת מוצרים - מניח שקיימים מוצרים עם מזהים 1-10)
        p_id = random.randint(1, 10)

        # בניית פקודת ה-SQL לפי העמודות שראינו ב-pgAdmin שלך
        sql = (f"INSERT INTO public.design (d_id, d_name, d_description, d_data, json_specs, p_id) "
               f"VALUES ({d_id}, {d_name}, {d_description}, {d_data}, {json_specs}, {p_id});")
        
        sql_commands.append(sql)
    
    return sql_commands

# יצירת הקובץ
commands = generate_design_data(500)
with open('insert_designs.sql', 'w', encoding='utf-8') as f:
    for cmd in commands:
        f.write(cmd + "\n")

print("-" * 30)
print("הצלחה! הקובץ 'insert_designs.sql' נוצר בתיקייה שלך.")
print("כעת פתחי אותו, העתיקי את תוכנו והדביקי ב-pgAdmin.")
print("-" * 30)