import tkinter as tk
from tkinter import ttk, messagebox
from db import get_connection


BG_COLOR = "#EEF3F7"
CARD_COLOR = "#FFFFFF"
PRIMARY_COLOR = "#2F5D8C"
SECONDARY_COLOR = "#4F6F8F"
TEXT_COLOR = "#1F2933"


QUERIES = {
    "Products Count By Department": """
        SELECT 
            d.de_name AS department_name,
            COUNT(p.p_id) AS total_products
        FROM department d
        JOIN product_line pl ON d.pl_id = pl.pl_id
        JOIN product p ON pl.p_id = p.p_id
        GROUP BY d.de_name
        ORDER BY total_products DESC;
    """,

    "Models Count By Collection": """
        SELECT
            collection_name,
            season,
            year,
            COUNT(model_id) AS total_models
        FROM view_models_collections
        GROUP BY collection_name, season, year
        ORDER BY year DESC, total_models DESC;
    """
}


def run_query(query_text):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute(query_text)

    rows = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]

    cursor.close()
    conn.close()

    return columns, rows


def open_queries_screen():
    window = tk.Toplevel()
    window.title("Stage B Reports / Queries")
    window.geometry("1150x700")
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
    card.place(relx=0.5, rely=0.5, anchor="center", width=1080, height=620)

    title = tk.Label(
        card,
        text="Stage B Reports / Queries",
        font=("Arial", 22, "bold"),
        bg=CARD_COLOR,
        fg=TEXT_COLOR
    )
    title.pack(pady=(25, 10))

    subtitle = tk.Label(
        card,
        text="Run predefined queries from Stage B and view the results",
        font=("Arial", 11),
        bg=CARD_COLOR,
        fg="#52616B"
    )
    subtitle.pack(pady=(0, 20))

    top_frame = tk.Frame(card, bg=CARD_COLOR)
    top_frame.pack(pady=10)

    tk.Label(
        top_frame,
        text="Choose query:",
        font=("Arial", 12, "bold"),
        bg=CARD_COLOR,
        fg=TEXT_COLOR
    ).pack(side=tk.LEFT, padx=8)

    query_combo = ttk.Combobox(
        top_frame,
        values=list(QUERIES.keys()),
        state="readonly",
        width=35
    )
    query_combo.pack(side=tk.LEFT, padx=8)
    query_combo.set(list(QUERIES.keys())[0])

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

    def execute_selected_query():
        selected_query_name = query_combo.get()
        query_text = QUERIES[selected_query_name]

        try:
            columns, rows = run_query(query_text)

            tree.delete(*tree.get_children())
            tree["columns"] = columns
            tree["show"] = "headings"

            for col in columns:
                tree.heading(col, text=col)
                tree.column(col, width=180, anchor="center")

            for row in rows:
                tree.insert("", tk.END, values=row)

        except Exception as e:
            messagebox.showerror("Query Error", str(e))

    ttk.Button(
        top_frame,
        text="Run Query",
        command=execute_selected_query,
        style="Custom.TButton",
        width=16
    ).pack(side=tk.LEFT, padx=8)

    execute_selected_query()