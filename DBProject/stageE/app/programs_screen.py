import tkinter as tk
from tkinter import ttk, messagebox
from db import get_connection


BG_COLOR = "#EEF3F7"
CARD_COLOR = "#FFFFFF"
PRIMARY_COLOR = "#2F5D8C"
SECONDARY_COLOR = "#4F6F8F"
TEXT_COLOR = "#1F2933"


def run_fetch_query(query, params):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute(query, params)
    rows = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]

    cursor.close()
    conn.close()

    return columns, rows


def run_procedure(query, params):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute(query, params)
    conn.commit()

    cursor.close()
    conn.close()


def open_programs_screen():
    window = tk.Toplevel()
    window.title("Stage D Functions / Procedures")
    window.geometry("1150x720")
    window.configure(bg=BG_COLOR)

    style = ttk.Style()
    style.theme_use("clam")

    style.configure(
        "Custom.TButton",
        font=("Arial", 11),
        padding=8,
        background=PRIMARY_COLOR,
        foreground="white"
    )

    style.map(
        "Custom.TButton",
        background=[("active", SECONDARY_COLOR)]
    )

    style.configure(
        "Treeview.Heading",
        font=("Arial", 10, "bold")
    )

    style.configure(
        "Treeview",
        font=("Arial", 10),
        rowheight=26
    )

    card = tk.Frame(window, bg=CARD_COLOR)
    card.place(relx=0.5, rely=0.5, anchor="center", width=1080, height=640)

    title = tk.Label(
        card,
        text="Stage D Functions / Procedures",
        font=("Arial", 22, "bold"),
        bg=CARD_COLOR,
        fg=TEXT_COLOR
    )
    title.pack(pady=(25, 10))

    subtitle = tk.Label(
        card,
        text="Run functions and procedures created in Stage D",
        font=("Arial", 11),
        bg=CARD_COLOR,
        fg="#52616B"
    )
    subtitle.pack(pady=(0, 20))

    # Input area
    input_frame = tk.Frame(card, bg=CARD_COLOR)
    input_frame.pack(pady=10)

    tk.Label(
        input_frame,
        text="Employee ID:",
        font=("Arial", 11, "bold"),
        bg=CARD_COLOR,
        fg=TEXT_COLOR
    ).grid(row=0, column=0, padx=8, pady=6, sticky="w")

    employee_id_entry = ttk.Entry(input_frame, width=18)
    employee_id_entry.grid(row=0, column=1, padx=8, pady=6)
    employee_id_entry.insert(0, "1")

    tk.Label(
        input_frame,
        text="Model ID:",
        font=("Arial", 11, "bold"),
        bg=CARD_COLOR,
        fg=TEXT_COLOR
    ).grid(row=0, column=2, padx=8, pady=6, sticky="w")

    model_id_entry = ttk.Entry(input_frame, width=18)
    model_id_entry.grid(row=0, column=3, padx=8, pady=6)
    model_id_entry.insert(0, "1")

    tk.Label(
        input_frame,
        text="Order ID:",
        font=("Arial", 11, "bold"),
        bg=CARD_COLOR,
        fg=TEXT_COLOR
    ).grid(row=1, column=0, padx=8, pady=6, sticky="w")

    order_id_entry = ttk.Entry(input_frame, width=18)
    order_id_entry.grid(row=1, column=1, padx=8, pady=6)
    order_id_entry.insert(0, "1")

    tk.Label(
        input_frame,
        text="New Status:",
        font=("Arial", 11, "bold"),
        bg=CARD_COLOR,
        fg=TEXT_COLOR
    ).grid(row=1, column=2, padx=8, pady=6, sticky="w")

    status_entry = ttk.Entry(input_frame, width=18)
    status_entry.grid(row=1, column=3, padx=8, pady=6)
    status_entry.insert(0, "Delivered")

    # Buttons
    buttons_frame = tk.Frame(card, bg=CARD_COLOR)
    buttons_frame.pack(pady=15)

    # Results table
    table_outer_frame = tk.Frame(card, bg=CARD_COLOR)
    table_outer_frame.pack(fill=tk.BOTH, expand=True, padx=25, pady=15)

    table_frame = tk.Frame(table_outer_frame, bg=CARD_COLOR)
    table_frame.pack(fill=tk.BOTH, expand=True)

    tree = ttk.Treeview(table_frame)
    tree.grid(row=0, column=0, sticky="nsew")

    y_scroll = ttk.Scrollbar(table_frame, orient=tk.VERTICAL, command=tree.yview)
    y_scroll.grid(row=0, column=1, sticky="ns")

    x_scroll = ttk.Scrollbar(table_frame, orient=tk.HORIZONTAL, command=tree.xview)
    x_scroll.grid(row=1, column=0, sticky="ew")

    tree.configure(yscrollcommand=y_scroll.set, xscrollcommand=x_scroll.set)

    table_frame.rowconfigure(0, weight=1)
    table_frame.columnconfigure(0, weight=1)

    def show_results(columns, rows):
        tree.delete(*tree.get_children())
        tree["columns"] = columns
        tree["show"] = "headings"

        for col in columns:
            tree.heading(col, text=col)
            tree.column(col, width=180, anchor="center")

        for row in rows:
            tree.insert("", tk.END, values=row)

    def run_employee_rank():
        employee_id = employee_id_entry.get().strip()

        if employee_id == "":
            messagebox.showwarning("Missing Data", "Please enter Employee ID")
            return

        try:
            columns, rows = run_fetch_query(
                """
                SELECT 
                    %s AS employee_id,
                    get_employee_experience_rank(%s) AS experience_rank;
                """,
                (employee_id, employee_id)
            )

            show_results(columns, rows)

        except Exception as e:
            messagebox.showerror("Function Error", str(e))

    def run_model_cost():
        model_id = model_id_entry.get().strip()

        if model_id == "":
            messagebox.showwarning("Missing Data", "Please enter Model ID")
            return

        try:
            columns, rows = run_fetch_query(
                """
                SELECT 
                    %s AS model_id,
                    calculate_model_material_cost(%s) AS total_material_cost;
                """,
                (model_id, model_id)
            )

            show_results(columns, rows)

        except Exception as e:
            messagebox.showerror("Function Error", str(e))

    def run_update_order_status():
        order_id = order_id_entry.get().strip()
        new_status = status_entry.get().strip()

        if order_id == "" or new_status == "":
            messagebox.showwarning("Missing Data", "Please enter Order ID and New Status")
            return

        try:
            run_procedure(
                "CALL update_supply_order_status(%s, %s);",
                (order_id, new_status)
            )

            columns, rows = run_fetch_query(
                """
                SELECT order_id, order_status, updated_at
                FROM supplyorder
                WHERE order_id = %s;
                """,
                (order_id,)
            )

            show_results(columns, rows)

            messagebox.showinfo("Success", "Procedure executed successfully.")

        except Exception as e:
            messagebox.showerror("Procedure Error", str(e))

    ttk.Button(
        buttons_frame,
        text="Run Employee Rank Function",
        command=run_employee_rank,
        style="Custom.TButton",
        width=28
    ).pack(side=tk.LEFT, padx=8)

    ttk.Button(
        buttons_frame,
        text="Run Model Cost Function",
        command=run_model_cost,
        style="Custom.TButton",
        width=28
    ).pack(side=tk.LEFT, padx=8)

    ttk.Button(
        buttons_frame,
        text="Run Update Order Status Procedure",
        command=run_update_order_status,
        style="Custom.TButton",
        width=32
    ).pack(side=tk.LEFT, padx=8)