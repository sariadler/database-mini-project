import tkinter as tk
from tkinter import ttk, messagebox
from psycopg2 import sql
from db import get_connection


BG_COLOR = "#EEF3F7"
CARD_COLOR = "#FFFFFF"
PRIMARY_COLOR = "#2F5D8C"
SECONDARY_COLOR = "#4F6F8F"
TEXT_COLOR = "#1F2933"


TABLES = [
    "employee",
    "department",
    "product",
    "product_line",
    "supplier",
    "supplyorder",
    "rawmaterial",
    "collection",
    "model",
    "required_m",
    "supplied_by",
    "works_on",
    "design",
    "includes",
    "requires",
    "work_ship",
    "employee_workship",
    "supply_order_status_log",
    "product_price_history"
]


def get_foreign_keys(table_name):
    """
    Returns all foreign keys of a table.
    Each result contains:
    column_name, foreign_table_name, foreign_column_name
    """
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        SELECT
            kcu.column_name,
            ccu.table_name AS foreign_table_name,
            ccu.column_name AS foreign_column_name
        FROM information_schema.table_constraints AS tc
        JOIN information_schema.key_column_usage AS kcu
          ON tc.constraint_name = kcu.constraint_name
         AND tc.table_schema = kcu.table_schema
        JOIN information_schema.constraint_column_usage AS ccu
          ON ccu.constraint_name = tc.constraint_name
         AND ccu.table_schema = tc.table_schema
        WHERE tc.constraint_type = 'FOREIGN KEY'
          AND tc.table_schema = 'public'
          AND tc.table_name = %s;
    """, (table_name,))

    foreign_keys = cursor.fetchall()

    cursor.close()
    conn.close()

    return foreign_keys


def choose_display_column(foreign_table, foreign_key_column):
    """
    Chooses a readable column from the referenced table.
    Prefer text/varchar columns that are not ID columns.
    """
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        SELECT column_name, data_type
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name = %s
        ORDER BY ordinal_position;
    """, (foreign_table,))

    columns = cursor.fetchall()

    cursor.close()
    conn.close()

    # Prefer columns that look like names/descriptions
    preferred_names = [
        "name",
        "model_name",
        "collection_name",
        "company_name",
        "de_name",
        "e_name",
        "color",
        "role"
    ]

    for preferred in preferred_names:
        for column_name, data_type in columns:
            if column_name == preferred:
                return column_name

    # Otherwise choose the first textual column that is not the foreign key
    for column_name, data_type in columns:
        if column_name != foreign_key_column and data_type in [
            "character varying",
            "text",
            "char",
            "character"
        ]:
            return column_name

    # Fallback: choose any column that is not the foreign key
    for column_name, data_type in columns:
        if column_name != foreign_key_column:
            return column_name

    # Last fallback
    return foreign_key_column


def fetch_table_data(table_name):
    """
    Fetches table data.
    If the table has foreign keys, it replaces foreign key IDs with readable values
    using LEFT JOIN.
    """
    conn = get_connection()
    cursor = conn.cursor()

    foreign_keys = get_foreign_keys(table_name)
    fk_columns = [fk[0] for fk in foreign_keys]

    # Get all table columns
    cursor.execute("""
        SELECT column_name
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name = %s
        ORDER BY ordinal_position;
    """, (table_name,))

    all_columns = [row[0] for row in cursor.fetchall()]

    select_parts = []
    join_parts = []

    # Add regular columns, but skip foreign key ID columns
    for column_name in all_columns:
        if column_name not in fk_columns:
            select_parts.append(
                sql.SQL("main.{}").format(sql.Identifier(column_name))
            )

    # Add readable values instead of foreign key IDs
    for index, (fk_column, foreign_table, foreign_column) in enumerate(foreign_keys):
        alias = f"fk{index}"
        display_column = choose_display_column(foreign_table, foreign_column)

        select_parts.append(
            sql.SQL("{}.{} AS {}").format(
                sql.Identifier(alias),
                sql.Identifier(display_column),
                sql.Identifier(f"{fk_column}_display")
            )
        )

        join_parts.append(
            sql.SQL("LEFT JOIN public.{} AS {} ON main.{} = {}.{}").format(
                sql.Identifier(foreign_table),
                sql.Identifier(alias),
                sql.Identifier(fk_column),
                sql.Identifier(alias),
                sql.Identifier(foreign_column)
            )
        )

    query = sql.SQL("SELECT {fields} FROM public.{table} AS main {joins} LIMIT 100;").format(
        fields=sql.SQL(", ").join(select_parts),
        table=sql.Identifier(table_name),
        joins=sql.SQL(" ").join(join_parts)
    )

    cursor.execute(query)

    rows = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]

    cursor.close()
    conn.close()

    return columns, rows

def get_insert_columns(table_name):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        SELECT column_name, is_nullable, data_type, column_default
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name = %s
        ORDER BY ordinal_position;
    """, (table_name,))

    columns = cursor.fetchall()

    cursor.close()
    conn.close()

    insert_columns = []

    for column_name, is_nullable, data_type, column_default in columns:
        if column_default is not None and "nextval" in column_default:
            continue

        insert_columns.append({
            "name": column_name,
            "nullable": is_nullable,
            "type": data_type
        })

    return insert_columns


def get_primary_key_columns(table_name):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        SELECT kcu.column_name
        FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu
          ON tc.constraint_name = kcu.constraint_name
         AND tc.table_schema = kcu.table_schema
        WHERE tc.constraint_type = 'PRIMARY KEY'
          AND tc.table_schema = 'public'
          AND tc.table_name = %s
        ORDER BY kcu.ordinal_position;
    """, (table_name,))

    pk_columns = [row[0] for row in cursor.fetchall()]

    cursor.close()
    conn.close()

    return pk_columns


def get_table_columns(table_name):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        SELECT column_name, data_type
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name = %s
        ORDER BY ordinal_position;
    """, (table_name,))

    columns = cursor.fetchall()

    cursor.close()
    conn.close()

    return columns


def fetch_row_by_primary_key(table_name, pk_columns, pk_values):
    conn = get_connection()
    cursor = conn.cursor()

    where_clause = sql.SQL(" AND ").join(
        sql.SQL("{} = {}").format(
            sql.Identifier(pk_col),
            sql.Placeholder()
        )
        for pk_col in pk_columns
    )

    query = sql.SQL("SELECT * FROM public.{table} WHERE {where_clause};").format(
        table=sql.Identifier(table_name),
        where_clause=where_clause
    )

    cursor.execute(query, pk_values)
    row = cursor.fetchone()
    columns = [desc[0] for desc in cursor.description]

    cursor.close()
    conn.close()

    return columns, row


def open_insert_window(parent, table_name, refresh_callback):
    if table_name not in TABLES:
        messagebox.showerror("Error", "Invalid table selected")
        return

    insert_window = tk.Toplevel(parent)
    insert_window.title(f"Insert into {table_name}")
    insert_window.geometry("520x650")
    insert_window.configure(bg=BG_COLOR)

    card = tk.Frame(insert_window, bg=CARD_COLOR)
    card.pack(fill=tk.BOTH, expand=True, padx=25, pady=25)

    title = tk.Label(
        card,
        text=f"Insert New Row Into {table_name}",
        font=("Arial", 16, "bold"),
        bg=CARD_COLOR,
        fg=TEXT_COLOR
    )
    title.pack(pady=(20, 10))

    subtitle = tk.Label(
        card,
        text="Fill the relevant fields and click Insert",
        font=("Arial", 10),
        bg=CARD_COLOR,
        fg="#52616B"
    )
    subtitle.pack(pady=(0, 15))

    fields_frame = tk.Frame(card, bg=CARD_COLOR)
    fields_frame.pack(fill=tk.BOTH, expand=True, padx=20)

    try:
        columns = get_insert_columns(table_name)
    except Exception as e:
        messagebox.showerror("Error", str(e))
        return

    entries = {}

    for i, col in enumerate(columns):
        label_text = col["name"]

        if col["nullable"] == "NO":
            label_text += " *"

        label_text += f" ({col['type']})"

        label = tk.Label(
            fields_frame,
            text=label_text,
            font=("Arial", 10),
            bg=CARD_COLOR,
            fg=TEXT_COLOR,
            anchor="w"
        )
        label.grid(row=i, column=0, sticky="w", pady=5, padx=5)

        entry = ttk.Entry(fields_frame, width=32)
        entry.grid(row=i, column=1, sticky="w", pady=5, padx=5)

        entries[col["name"]] = entry

    def insert_row():
        insert_cols = []
        values = []

        for col_name, entry in entries.items():
            value = entry.get().strip()

            if value != "":
                insert_cols.append(col_name)
                values.append(value)

        if not insert_cols:
            messagebox.showwarning("Missing Data", "Please fill at least one field.")
            return

        try:
            conn = get_connection()
            cursor = conn.cursor()

            query = sql.SQL("INSERT INTO public.{table} ({fields}) VALUES ({placeholders})").format(
                table=sql.Identifier(table_name),
                fields=sql.SQL(", ").join(map(sql.Identifier, insert_cols)),
                placeholders=sql.SQL(", ").join(sql.Placeholder() * len(values))
            )

            cursor.execute(query, values)
            conn.commit()

            cursor.close()
            conn.close()

            messagebox.showinfo("Success", f"Row inserted successfully into {table_name}")
            insert_window.destroy()
            refresh_callback()

        except Exception as e:
            messagebox.showerror("Insert Error", str(e))

    buttons_frame = tk.Frame(card, bg=CARD_COLOR)
    buttons_frame.pack(pady=20)

    ttk.Button(
        buttons_frame,
        text="Insert",
        command=insert_row,
        width=18
    ).pack(side=tk.LEFT, padx=8)

    ttk.Button(
        buttons_frame,
        text="Cancel",
        command=insert_window.destroy,
        width=18
    ).pack(side=tk.LEFT, padx=8)


def open_update_window(parent, table_name, refresh_callback):
    if table_name not in TABLES:
        messagebox.showerror("Error", "Invalid table selected")
        return

    try:
        pk_columns = get_primary_key_columns(table_name)
        all_columns = get_table_columns(table_name)
    except Exception as e:
        messagebox.showerror("Error", str(e))
        return

    if not pk_columns:
        messagebox.showerror("Error", f"Table {table_name} has no primary key.")
        return

    update_window = tk.Toplevel(parent)
    update_window.title(f"Update row in {table_name}")
    update_window.geometry("600x760")
    update_window.configure(bg=BG_COLOR)

    card = tk.Frame(update_window, bg=CARD_COLOR)
    card.pack(fill=tk.BOTH, expand=True, padx=25, pady=25)

    title = tk.Label(
        card,
        text=f"Update Row In {table_name}",
        font=("Arial", 16, "bold"),
        bg=CARD_COLOR,
        fg=TEXT_COLOR
    )
    title.pack(pady=(20, 5))

    subtitle = tk.Label(
        card,
        text="Enter the primary key, load the row, then update the fields",
        font=("Arial", 10),
        bg=CARD_COLOR,
        fg="#52616B"
    )
    subtitle.pack(pady=(0, 15))

    pk_frame = tk.LabelFrame(
        card,
        text="Primary Key",
        font=("Arial", 10, "bold"),
        bg=CARD_COLOR,
        fg=TEXT_COLOR,
        padx=10,
        pady=10
    )
    pk_frame.pack(fill=tk.X, padx=20, pady=10)

    pk_entries = {}

    for i, pk_col in enumerate(pk_columns):
        tk.Label(
            pk_frame,
            text=pk_col,
            font=("Arial", 10),
            bg=CARD_COLOR,
            fg=TEXT_COLOR
        ).grid(row=i, column=0, sticky="w", pady=5, padx=5)

        entry = ttk.Entry(pk_frame, width=30)
        entry.grid(row=i, column=1, sticky="w", pady=5, padx=5)

        pk_entries[pk_col] = entry

    fields_frame = tk.LabelFrame(
        card,
        text="Row Fields",
        font=("Arial", 10, "bold"),
        bg=CARD_COLOR,
        fg=TEXT_COLOR,
        padx=10,
        pady=10
    )
    fields_frame.pack(fill=tk.BOTH, expand=True, padx=20, pady=10)

    field_entries = {}

    for i, (col_name, data_type) in enumerate(all_columns):
        label = tk.Label(
            fields_frame,
            text=f"{col_name} ({data_type})",
            font=("Arial", 10),
            bg=CARD_COLOR,
            fg=TEXT_COLOR,
            anchor="w"
        )
        label.grid(row=i, column=0, sticky="w", pady=4, padx=5)

        entry = ttk.Entry(fields_frame, width=32)
        entry.grid(row=i, column=1, sticky="w", pady=4, padx=5)

        if col_name in pk_columns:
            entry.configure(state="readonly")

        field_entries[col_name] = entry

    def load_row():
        pk_values = []

        for pk_col in pk_columns:
            value = pk_entries[pk_col].get().strip()
            if value == "":
                messagebox.showwarning("Missing Key", f"Please enter value for {pk_col}")
                return
            pk_values.append(value)

        try:
            columns, row = fetch_row_by_primary_key(table_name, pk_columns, pk_values)

            if row is None:
                messagebox.showerror("Not Found", "No row found with this primary key.")
                return

            for col_name, value in zip(columns, row):
                entry = field_entries[col_name]
                entry.configure(state="normal")
                entry.delete(0, tk.END)
                entry.insert(0, "" if value is None else str(value))

                if col_name in pk_columns:
                    entry.configure(state="readonly")

            messagebox.showinfo("Success", "Row loaded successfully. You can now update it.")

        except Exception as e:
            messagebox.showerror("Load Error", str(e))

    def update_row():
        pk_values = []

        for pk_col in pk_columns:
            value = pk_entries[pk_col].get().strip()
            if value == "":
                messagebox.showwarning("Missing Key", f"Please enter value for {pk_col}")
                return
            pk_values.append(value)

        update_columns = []
        update_values = []

        for col_name, entry in field_entries.items():
            if col_name in pk_columns:
                continue

            value = entry.get().strip()
            update_columns.append(col_name)

            if value == "":
                update_values.append(None)
            else:
                update_values.append(value)

        if not update_columns:
            messagebox.showwarning("No Fields", "There are no fields to update.")
            return

        try:
            conn = get_connection()
            cursor = conn.cursor()

            set_clause = sql.SQL(", ").join(
                sql.SQL("{} = {}").format(
                    sql.Identifier(col),
                    sql.Placeholder()
                )
                for col in update_columns
            )

            where_clause = sql.SQL(" AND ").join(
                sql.SQL("{} = {}").format(
                    sql.Identifier(pk_col),
                    sql.Placeholder()
                )
                for pk_col in pk_columns
            )

            query = sql.SQL("UPDATE public.{table} SET {set_clause} WHERE {where_clause};").format(
                table=sql.Identifier(table_name),
                set_clause=set_clause,
                where_clause=where_clause
            )

            cursor.execute(query, update_values + pk_values)
            conn.commit()

            updated_rows = cursor.rowcount

            cursor.close()
            conn.close()

            if updated_rows == 0:
                messagebox.showwarning("Not Updated", "No row was updated.")
            else:
                messagebox.showinfo("Success", "Row updated successfully.")
                update_window.destroy()
                refresh_callback()

        except Exception as e:
            messagebox.showerror("Update Error", str(e))

    buttons_frame = tk.Frame(card, bg=CARD_COLOR)
    buttons_frame.pack(pady=15)

    ttk.Button(
        buttons_frame,
        text="Load Row",
        command=load_row,
        width=16
    ).pack(side=tk.LEFT, padx=8)

    ttk.Button(
        buttons_frame,
        text="Update",
        command=update_row,
        width=16
    ).pack(side=tk.LEFT, padx=8)

    ttk.Button(
        buttons_frame,
        text="Cancel",
        command=update_window.destroy,
        width=16
    ).pack(side=tk.LEFT, padx=8)

def open_delete_window(parent, table_name, refresh_callback):
    if table_name not in TABLES:
        messagebox.showerror("Error", "Invalid table selected")
        return

    try:
        pk_columns = get_primary_key_columns(table_name)
    except Exception as e:
        messagebox.showerror("Error", str(e))
        return

    if not pk_columns:
        messagebox.showerror("Error", f"Table {table_name} has no primary key.")
        return

    delete_window = tk.Toplevel(parent)
    delete_window.title(f"Delete row from {table_name}")
    delete_window.geometry("520x360")
    delete_window.configure(bg=BG_COLOR)

    card = tk.Frame(delete_window, bg=CARD_COLOR)
    card.pack(fill=tk.BOTH, expand=True, padx=25, pady=25)

    title = tk.Label(
        card,
        text=f"Delete Row From {table_name}",
        font=("Arial", 16, "bold"),
        bg=CARD_COLOR,
        fg=TEXT_COLOR
    )
    title.pack(pady=(20, 5))

    subtitle = tk.Label(
        card,
        text="Enter the primary key of the row you want to delete",
        font=("Arial", 10),
        bg=CARD_COLOR,
        fg="#52616B"
    )
    subtitle.pack(pady=(0, 15))

    pk_frame = tk.LabelFrame(
        card,
        text="Primary Key",
        font=("Arial", 10, "bold"),
        bg=CARD_COLOR,
        fg=TEXT_COLOR,
        padx=10,
        pady=10
    )
    pk_frame.pack(fill=tk.X, padx=20, pady=10)

    pk_entries = {}

    for i, pk_col in enumerate(pk_columns):
        tk.Label(
            pk_frame,
            text=pk_col,
            font=("Arial", 10),
            bg=CARD_COLOR,
            fg=TEXT_COLOR
        ).grid(row=i, column=0, sticky="w", pady=5, padx=5)

        entry = ttk.Entry(pk_frame, width=30)
        entry.grid(row=i, column=1, sticky="w", pady=5, padx=5)

        pk_entries[pk_col] = entry

    def delete_row():
        pk_values = []

        for pk_col in pk_columns:
            value = pk_entries[pk_col].get().strip()
            if value == "":
                messagebox.showwarning("Missing Key", f"Please enter value for {pk_col}")
                return
            pk_values.append(value)

        confirm = messagebox.askyesno(
            "Confirm Delete",
            f"Are you sure you want to delete this row from {table_name}?"
        )

        if not confirm:
            return

        try:
            conn = get_connection()
            cursor = conn.cursor()

            where_clause = sql.SQL(" AND ").join(
                sql.SQL("{} = {}").format(
                    sql.Identifier(pk_col),
                    sql.Placeholder()
                )
                for pk_col in pk_columns
            )

            query = sql.SQL("DELETE FROM public.{table} WHERE {where_clause};").format(
                table=sql.Identifier(table_name),
                where_clause=where_clause
            )

            cursor.execute(query, pk_values)
            conn.commit()

            deleted_rows = cursor.rowcount

            cursor.close()
            conn.close()

            if deleted_rows == 0:
                messagebox.showwarning("Not Found", "No row was deleted. Check the primary key.")
            else:
                messagebox.showinfo("Success", "Row deleted successfully.")
                delete_window.destroy()
                refresh_callback()

        except Exception as e:
            messagebox.showerror("Delete Error", str(e))

    buttons_frame = tk.Frame(card, bg=CARD_COLOR)
    buttons_frame.pack(pady=20)

    ttk.Button(
        buttons_frame,
        text="Delete",
        command=delete_row,
        width=16
    ).pack(side=tk.LEFT, padx=8)

    ttk.Button(
        buttons_frame,
        text="Cancel",
        command=delete_window.destroy,
        width=16
    ).pack(side=tk.LEFT, padx=8)

def open_tables_screen():
    window = tk.Toplevel()
    window.title("Manage Tables - CRUD")
    window.geometry("1250x760")
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
        "Action.TButton",
        font=("Arial", 11),
        padding=8,
        background="#D9DEE3",
        foreground=TEXT_COLOR
    )

    style.configure(
        "Custom.TCombobox",
        padding=6
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
    card.place(relx=0.5, rely=0.5, anchor="center", width=1180, height=680)

    title = tk.Label(
        card,
        text="PROD-SYS Database Management",
        font=("Arial", 22, "bold"),
        bg=CARD_COLOR,
        fg=TEXT_COLOR
    )
    title.pack(pady=(25, 10))

    subtitle = tk.Label(
        card,
        text="Manage products, raw materials, suppliers, production lines and all database tables",
        font=("Arial", 11),
        bg=CARD_COLOR,
        fg="#52616B"
    )
    subtitle.pack(pady=(0, 20))

    top_frame = tk.Frame(card, bg=CARD_COLOR)
    top_frame.pack(pady=10)

    tk.Label(
        top_frame,
        text="Choose table:",
        font=("Arial", 12, "bold"),
        bg=CARD_COLOR,
        fg=TEXT_COLOR
    ).pack(side=tk.LEFT, padx=8)

    table_combo = ttk.Combobox(
        top_frame,
        values=TABLES,
        state="readonly",
        width=28,
        style="Custom.TCombobox"
    )
    table_combo.pack(side=tk.LEFT, padx=8)
    table_combo.set(TABLES[0])

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

    def load_data():
        selected_table = table_combo.get()

        try:
            columns, rows = fetch_table_data(selected_table)

            tree.delete(*tree.get_children())
            tree["columns"] = columns
            tree["show"] = "headings"

            for col in columns:
                tree.heading(col, text=col)
                tree.column(col, width=150, anchor="center")

            for row in rows:
                tree.insert("", tk.END, values=row)

        except Exception as e:
            messagebox.showerror("Error", str(e))

    ttk.Button(
        top_frame,
        text="Load Data",
        command=load_data,
        style="Custom.TButton",
        width=16
    ).pack(side=tk.LEFT, padx=8)

    buttons_frame = tk.Frame(card, bg=CARD_COLOR)
    buttons_frame.pack(pady=(5, 20))

    ttk.Button(
        buttons_frame,
        text="Insert",
        width=14,
        style="Action.TButton",
        command=lambda: open_insert_window(window, table_combo.get(), load_data)
    ).pack(side=tk.LEFT, padx=8)

    ttk.Button(
        buttons_frame,
        text="Update",
        width=14,
        style="Action.TButton",
        command=lambda: open_update_window(window, table_combo.get(), load_data)
    ).pack(side=tk.LEFT, padx=8)

    ttk.Button(
        buttons_frame,
        text="Delete",
        width=14,
        style="Action.TButton",
        command=lambda: open_delete_window(window, table_combo.get(), load_data)
    ).pack(side=tk.LEFT, padx=8)

    ttk.Button(
        buttons_frame,
        text="Refresh",
        width=14,
        style="Action.TButton",
        command=load_data
    ).pack(side=tk.LEFT, padx=8)

    load_data()