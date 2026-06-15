import tkinter as tk
from tkinter import ttk

from tables_screen import open_tables_screen
from queries_screen import open_queries_screen
from programs_screen import open_programs_screen


BG_COLOR = "#EEF3F7"
CARD_COLOR = "#FFFFFF"
PRIMARY_COLOR = "#2F5D8C"
SECONDARY_COLOR = "#4F6F8F"
TEXT_COLOR = "#1F2933"


def main():
    root = tk.Tk()
    root.title("Database Project - Stage E")
    root.geometry("820x560")
    root.configure(bg=BG_COLOR)

    style = ttk.Style()
    style.theme_use("clam")

    style.configure(
        "Main.TButton",
        font=("Arial", 13),
        padding=12,
        background=PRIMARY_COLOR,
        foreground="white"
    )

    style.map(
        "Main.TButton",
        background=[("active", SECONDARY_COLOR)]
    )

    style.configure(
        "Exit.TButton",
        font=("Arial", 13),
        padding=12,
        background="#D9DEE3",
        foreground=TEXT_COLOR
    )

    container = tk.Frame(root, bg=CARD_COLOR)
    container.place(relx=0.5, rely=0.5, anchor="center", width=600, height=440)

    title = tk.Label(
        container,
        text="PROD-SYS v1.0",
        font=("Arial", 22, "bold"),
        bg=CARD_COLOR,
        fg=TEXT_COLOR
    )
    title.pack(pady=(35, 10))

    subtitle = tk.Label(
        container,
        text="Design & Production Department Database System",
        font=("Arial", 12),
        bg=CARD_COLOR,
        fg="#52616B"
    )
    subtitle.pack(pady=(0, 25))

    ttk.Button(
        container,
        text="Manage Database Tables - CRUD",
        command=open_tables_screen,
        style="Main.TButton",
        width=35
    ).pack(pady=8)

    ttk.Button(
        container,
        text="Run Stage B Reports / Queries",
        command=open_queries_screen,
        style="Main.TButton",
        width=35
    ).pack(pady=8)

    ttk.Button(
        container,
        text="Run Stage D Functions / Procedures",
        command=open_programs_screen,
        style="Main.TButton",
        width=35
    ).pack(pady=8)

    ttk.Button(
        container,
        text="Exit",
        command=root.destroy,
        style="Exit.TButton",
        width=35
    ).pack(pady=(25, 0))

    root.mainloop()


if __name__ == "__main__":
    main()