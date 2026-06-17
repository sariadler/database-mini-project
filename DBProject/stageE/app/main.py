import customtkinter as ctk

from tables_screen import open_tables_screen
from queries_screen import open_queries_screen
from programs_screen import open_programs_screen


ctk.set_appearance_mode("light")
ctk.set_default_color_theme("blue")


BG = "#DDEBFF"
MAIN_CARD = "#F8FAFC"

TEXT_MAIN = "#0F172A"
TEXT_SUB = "#64748B"

BLUE = "#2563EB"
BLUE_HOVER = "#1D4ED8"

GREEN = "#059669"
GREEN_HOVER = "#047857"

PURPLE = "#7C3AED"
PURPLE_HOVER = "#6D28D9"

RED = "#DC2626"
RED_HOVER = "#B91C1C"


def main():
    root = ctk.CTk()
    root.title("PROD-SYS Dashboard - Stage E")
    root.geometry("1120x760")
    root.minsize(1000, 680)
    root.configure(fg_color=BG)

    main_card = ctk.CTkFrame(
        root,
        fg_color=MAIN_CARD,
        corner_radius=35,
        border_width=1,
        border_color="#C7D2FE"
    )
    main_card.pack(expand=True, fill="both", padx=35, pady=30)

    # =========================
    # Header
    # =========================
    header = ctk.CTkFrame(main_card, fg_color="transparent")
    header.pack(pady=(35, 10))

    title = ctk.CTkLabel(
        header,
        text="📊  PROD-SYS Dashboard",
        font=("Arial", 38, "bold"),
        text_color=TEXT_MAIN
    )
    title.pack()

    subtitle = ctk.CTkLabel(
        header,
        text="Shoes Enterprise Database Management System",
        font=("Arial", 16),
        text_color=TEXT_SUB
    )
    subtitle.pack(pady=(8, 0))

    line = ctk.CTkFrame(
        main_card,
        fg_color="#2563EB",
        height=3,
        width=180,
        corner_radius=10
    )
    line.pack(pady=(12, 28))

    # =========================
    # Menu
    # =========================
    menu = ctk.CTkFrame(main_card, fg_color="transparent")
    menu.pack(expand=True, fill="both", padx=45, pady=10)

    menu.grid_columnconfigure(0, weight=1)
    menu.grid_columnconfigure(1, weight=1)
    menu.grid_rowconfigure(0, weight=1)
    menu.grid_rowconfigure(1, weight=1)

    def create_dashboard_card(row, col, icon, title_text, desc_text, color, hover_color, command):
        shadow = ctk.CTkFrame(
            menu,
            fg_color="#CBD5E1",
            corner_radius=30
        )
        shadow.grid(row=row, column=col, padx=18, pady=18, sticky="nsew")

        card = ctk.CTkFrame(
            shadow,
            fg_color=color,
            corner_radius=30
        )
        card.pack(expand=True, fill="both", padx=(0, 0), pady=(0, 6))

        content = ctk.CTkFrame(card, fg_color="transparent")
        content.pack(expand=True, fill="both", padx=28, pady=26)

        icon_box = ctk.CTkFrame(
            content,
            fg_color=hover_color,
            corner_radius=22,
            width=105,
            height=105
        )
        icon_box.pack(side="left", padx=(0, 28))
        icon_box.pack_propagate(False)

        icon_label = ctk.CTkLabel(
            icon_box,
            text=icon,
            font=("Arial", 45, "bold"),
            text_color="white"
        )
        icon_label.pack(expand=True)

        text_frame = ctk.CTkFrame(content, fg_color="transparent")
        text_frame.pack(side="left", expand=True, fill="both")

        title_label = ctk.CTkLabel(
            text_frame,
            text=title_text,
            font=("Arial", 24, "bold"),
            text_color="white",
            anchor="w"
        )
        title_label.pack(anchor="w", pady=(18, 8))

        desc_label = ctk.CTkLabel(
            text_frame,
            text=desc_text,
            font=("Arial", 15),
            text_color="#E2E8F0",
            anchor="w",
            justify="left",
            wraplength=380
        )
        desc_label.pack(anchor="w")

        arrow = ctk.CTkLabel(
            content,
            text="›",
            font=("Arial", 46, "bold"),
            text_color="#E2E8F0"
        )
        arrow.pack(side="right", padx=(15, 0))

        def on_enter(event=None):
            card.configure(fg_color=hover_color)
            icon_box.configure(fg_color=color)
            shadow.configure(fg_color="#94A3B8")
            arrow.configure(text_color="white")
            root.configure(cursor="hand2")

        def on_leave(event=None):
            card.configure(fg_color=color)
            icon_box.configure(fg_color=hover_color)
            shadow.configure(fg_color="#CBD5E1")
            arrow.configure(text_color="#E2E8F0")
            root.configure(cursor="")

        def on_click(event=None):
            command()

        widgets = [
            shadow, card, content, icon_box, icon_label,
            text_frame, title_label, desc_label, arrow
        ]

        for widget in widgets:
            widget.bind("<Enter>", on_enter)
            widget.bind("<Leave>", on_leave)
            widget.bind("<Button-1>", on_click)

    create_dashboard_card(
        0, 0,
        "⚙️",
        "Manage Tables",
        "Insert, update, delete and view database tables",
        BLUE,
        BLUE_HOVER,
        open_tables_screen
    )

    create_dashboard_card(
        0, 1,
        "📊",
        "Reports & Queries",
        "Run predefined Stage B reports and view results",
        GREEN,
        GREEN_HOVER,
        open_queries_screen
    )

    create_dashboard_card(
        1, 0,
        "⚡",
        "Stored Programs",
        "Run Stage D functions and procedures",
        PURPLE,
        PURPLE_HOVER,
        open_programs_screen
    )

    create_dashboard_card(
        1, 1,
        "✖",
        "Exit System",
        "Close the application safely",
        RED,
        RED_HOVER,
        root.destroy
    )

    footer_line = ctk.CTkFrame(
        main_card,
        fg_color="#CBD5E1",
        height=1
    )
    footer_line.pack(fill="x", padx=55, pady=(10, 12))

    footer = ctk.CTkLabel(
        main_card,
        text="PROD-SYS v1.0  |  Stage E  |  Database GUI Application",
        font=("Arial", 12),
        text_color=TEXT_SUB
    )
    footer.pack(pady=(0, 18))

    root.mainloop()


if __name__ == "__main__":
    main()