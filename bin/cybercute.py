import sys
import os
import sqlite3
from pathlib import Path


def get_xdg_data_home():
    """
    Returns the XDG_DATA_HOME path, respecting the environment variable
    or falling back to the default ~/.local/share.
    """
    xdg_data_home_env = os.environ.get("XDG_DATA_HOME")
    if xdg_data_home_env:
        return Path(xdg_data_home_env).expanduser()
    else:
        return Path.home() / ".local" / "share"


db_path = get_xdg_data_home() / "cybercute" / "word_pairs.db"
dark_list = get_xdg_data_home() / "cybercute" / "dark.txt"
cute_list = get_xdg_data_home() / "cybercute" / "cute.txt"
db_path.parent.mkdir(parents=True, exist_ok=True)


# --- Database Initialization and Population ---
def setup_database():
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS dark_words (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word TEXT UNIQUE NOT NULL
        )
    """)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS kawaii_words (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word TEXT UNIQUE NOT NULL
        )
    """)

    for word_list_file, table in [
            (dark_list, "dark_words"),
            (cute_list, "kawaii_words"),
    ]:
        wordlist = filter(
            None,
            map(lambda w: w.strip(), list(open(word_list_file, 'r'))))

        for word in wordlist:
            if word:
                try:
                    cursor.execute(
                        f"INSERT INTO {table} (word) VALUES (?)",
                        (word,)
                    )
                except sqlite3.IntegrityError:
                    pass

    conn.commit()
    conn.close()


# --- Generate Single Pair from DB ---
def generate_pairs_from_db(limit: int = 1):
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    cursor.execute(
        "SELECT word FROM dark_words ORDER BY RANDOM() LIMIT ?",
        (limit,)
    )
    dark_word = cursor.fetchall()

    cursor.execute(
        "SELECT word FROM kawaii_words ORDER BY RANDOM() LIMIT ?",
        (limit,)
    )
    kawaii_word = cursor.fetchall()

    conn.close()
    return dark_word, kawaii_word


def generate_codename_strings(list1, list2):
    codename_strings = []
    for item1, item2 in zip(list1, list2):
        codename_strings.append(f"{str(item1[0])}-{str(item2[0])}")
        codename_strings.append(f"{str(item2[0])}-{str(item1[0])}")
    return codename_strings


if __name__ == "__main__":
    setup_database()  # Ensure the database and tables are ready and populated

    limit = 1
    if len(sys.argv) > 1:
        try:
            limit = int(sys.argv[1])
        except ValueError:
            print("Invalid input. Please provide a valid integer.")
            sys.exit(1)

    a, b = generate_pairs_from_db(limit)
    for codename in generate_codename_strings(a,b):
        print(codename)
