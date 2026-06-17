import tkinter as tk
from tkinter import ttk

from tables_screen import open_tables_screen
from queries_screen import open_queries_screen
from programs_screen import open_programs_screen

'''
===================================================================
📌 הקוד המקורי של חברה שלך (שמור כהערה - לא נוגעות בו):
===================================================================
def main():
    root = tk.Tk()
    root.title("Database Project - Stage E")
    root.geometry("820x560")
    root.configure(bg="#F0F4F8")

    style = ttk.Style()
    style.theme_use("clam")

    style.configure("Main.TButton", font=("Arial", 12, "bold"), padding=10, foreground="white")
    style.configure("Exit.TButton", font=("Arial", 12, "bold"), padding=10, background="#D32F2F", foreground="white")
    style.map("Exit.TButton", background=[("active", "#B71C1C")])

    container = tk.Frame(root, bg="#FFFFFF", highlightbackground="#D9E2EC", highlightthickness=1)
    container.place(relx=0.5, rely=0.5, anchor="center", width=620, height=460)

    title = tk.Label(container, text="PROD-SYS v1.0", font=("Arial", 26, "bold"), bg="#FFFFFF", fg="#102A43")
    title.pack(pady=(35, 10))

    subtitle = tk.Label(container, text="Design & Production Departmant Database System", font=("Arial", 13, "italic"), bg="#FFFFFF", fg="#486581")
    subtitle.pack(pady=(0, 30))

    btn_crud = ttk.Button(container, text="Manage Database Tables - CRUD", command=open_tables_screen, style="Crud.TButton", width=38)
    style.configure("Crud.TButton", parent="Main.TButton", background="#1976D2")
    style.map("Crud.TButton", background=[("active", "#1565C0")])
    btn_crud.pack(pady=10)

    btn_queries = ttk.Button(container, text="Run Stage B Reports / Queries", command=open_queries_screen, style="Queries.TButton", width=38)
    style.configure("Queries.TButton", parent="Main.TButton", background="#1976D2")
    style.map("Queries.TButton", background=[("active", "#1565C0")])
    btn_queries.pack(pady=10)

    btn_programs = ttk.Button(container, text="Run Stage D Functions / Procedurs", command=open_programs_screen, style="Programs.TButton", width=38)
    style.configure("Programs.TButton", parent="Main.TButton", background="#1976D2")
    style.map("Programs.TButton", background=[("active", "#1565C0")])
    btn_programs.pack(pady=10)

    ttk.Button(container, text="Exit", command=root.destroy, style="Exit.TButton", width=38)
    btn_programs.pack(pady=10)
    container.winfo_children()[-1].pack(pady=(25, 0))

    root.mainloop()
===================================================================
'''

# ===================================================================
# 🚀 העיצוב המתוקן (בטוח להרצה)
# ===================================================================

BG_COLOR = "#243B55"          
TEXT_MAIN = "#FFFFFF"         
TEXT_SUB = "#E2E8F0"          
COLOR_CRUD = "#2B6CB0"        
COLOR_QUERIES = "#2F855A"     
COLOR_STAGED = "#D69E2E"      
COLOR_EXIT = "#C53030"        
HOVER_CRUD = "#2A4365"
HOVER_QUERIES = "#22543D"
HOVER_STAGED = "#975A16"
HOVER_EXIT = "#9B2C2C"

def main():
    root = tk.Tk()
    root.title("מערכת ניהול - תפריט ראשי")
    root.geometry("920x720")  
    root.configure(bg=BG_COLOR)

    title = tk.Label(
        root,
        text="מערכת ניהול בסיס נתונים\nDatabase Management System",
        font=("Arial", 24, "bold"), # הוחלף מ-Segoe UI ל-Arial בטוח
        bg=BG_COLOR,
        fg=TEXT_MAIN,
        justify="center"
    )
    title.pack(pady=(40, 5))

    subtitle = tk.Label(
        root,
        text="מערכת מידע וניהול עבור רשת הנעליים | Shoes Enterprise System",
        font=("Arial", 12), # הוסר ה-"italic" שעלול היה לגרום לבעיות
        bg=BG_COLOR,
        fg=TEXT_SUB
    )
    subtitle.pack(pady=(0, 35))

    grid_container = tk.Frame(root, bg=BG_COLOR)
    grid_container.pack(expand=True, fill="both", padx=60, pady=10)

    def create_menu_box(parent, row, col, title_text, desc_text, command, bg_color, hover_color):
        box = tk.Button(
            parent, command=command, bg=bg_color, activebackground=hover_color,
            bd=0, relief="flat", cursor="hand2", padx=15, pady=20
        )
        
        lbl_title = tk.Label(
            box, text=title_text, font=("Arial", 14, "bold"),
            bg=bg_color, fg="white", justify="center", wraplength=260
        )
        lbl_title.pack(pady=(15, 5))
        
        lbl_desc = tk.Label(
            box, text=desc_text, font=("Arial", 10),
            bg=bg_color, fg="#E2E8F0", justify="center", wraplength=260
        )
        lbl_desc.pack(pady=(0, 15))

        lbl_title.bind("<Button-1>", lambda e: box.invoke())
        lbl_desc.bind("<Button-1>", lambda e: box.invoke())

        def on_enter(e):
            box.config(bg=hover_color)
            lbl_title.config(bg=hover_color)
            lbl_desc.config(bg=hover_color)
        def on_leave(e):
            box.config(bg=bg_color)
            lbl_title.config(bg=bg_color)
            lbl_desc.config(bg=bg_color)

        box.bind("<Enter>", on_enter); box.bind("<Leave>", on_leave)
        lbl_title.bind("<Enter>", on_enter); lbl_title.bind("<Leave>", on_leave)
        lbl_desc.bind("<Enter>", on_enter); lbl_desc.bind("<Leave>", on_leave)

        box.grid(row=row, column=col, padx=20, pady=20, sticky="nsew")
        return box

    grid_container.grid_columnconfigure(0, weight=1)
    grid_container.grid_columnconfigure(1, weight=1)
    grid_container.grid_rowconfigure(0, weight=1)
    grid_container.grid_rowconfigure(1, weight=1)

    create_menu_box(grid_container, 0, 0, "⚙️  ניהול טבלאות", "CRUD Tables", open_tables_screen, COLOR_CRUD, HOVER_CRUD)
    create_menu_box(grid_container, 0, 1, "📊  שאילתות ודוחות", "Queries & Reports", open_queries_screen, COLOR_QUERIES, HOVER_QUERIES)
    create_menu_box(grid_container, 1, 0, "⚡  פרוצדורות", "Stored Programs", open_programs_screen, COLOR_STAGED, HOVER_STAGED)
    create_menu_box(grid_container, 1, 1, "❌  יציאה", "Exit System", root.destroy, COLOR_EXIT, HOVER_EXIT)

    root.mainloop()

if __name__ == "__main__":
    main()