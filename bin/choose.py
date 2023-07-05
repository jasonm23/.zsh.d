#!/usr/bin/env python3

import tkinter as tk
from tkinter import END
import os
import sys
import re
import argparse

# --- Event Handler functions
def select_handler(w):
    widget = w.widget
    index = int(widget.curselection()[0])
    value = widget.get(index)
    text_entry_str.set(value)
    suggestion_list.delete(0, END)
    text_entry.focus()

def down_handler(w):
    suggestion_list.focus()
    suggestion_list.selection_set(0)

def complete_handler(w):
    print(text_entry.get())
    exit(0)

def exit_handler(w):
    exit(1)

def get_data(*args):
    search_str = text_entry.get()
    suggestion_list.delete(0, END)
    for element in suggestions:
        if (re.match(f".*{search_str}", element, re.IGNORECASE)):
            suggestion_list.insert(tk.END, element)

def focus_text(*args):
    text_entry.focus()

# --- Command line parser
parser = argparse.ArgumentParser(
    prog="choose.py",
    description="Provide a autocomplete selection GUI usable from a script.",
    epilog="By default autocomplete suggestions are read as lines from stdin."
)

parser.add_argument('-i', '--input', help="Suggestions file", type=str)
parser.add_argument('-t', '--title', help="Window title", type=str, default="Select")

args = parser.parse_args()

if args.input:
    print(f"input provided: {args.input}")
    if os.path.exists(args.input):
        with open('file.txt', 'r') as file:
            # Read all lines from the file into an array
            suggestions = file.readlines()
    else:
        print(f"{args.input} does not exist")
        exit(1)
else:
    suggestions = []
    try:
        while True:
            line = input()
            suggestions.append(line)
    except EOFError:
        pass

    if len(suggestions) == 0:
        print("Error: No suggestions input", file=sys.stderr)
        exit(1)

title = args.title

# --- Default config
title_font = ( 'Helvetica Neue',16,"normal" )
text_width = 70
suggestion_rows = 48

# --- Assemble GUI
root = tk.Tk()
root.geometry("595x370")
root.title(title)
root.grid_columnconfigure(0, weight=1)

# --- Text input
text_entry_str = tk.StringVar()
text_entry = tk.Entry(
    root,
    textvariable=text_entry_str,
    font=title_font,
    width=text_width
)

text_entry.pack(
    expand=True,
    fill='x',
    side='top',
    padx=10,
    pady=0
)

text_entry.bind('<Down>', down_handler)
text_entry.bind('<Return>', complete_handler)
text_entry.bind('<Escape>', exit_handler)
text_entry_str.trace('w', get_data)

# --- Autocomplete Suggestions
suggestion_list = tk.Listbox(
    root,
    height=suggestion_rows,
    width=text_width,
    font=title_font
)

suggestion_list.pack(
    expand=True,
    fill=tk.BOTH,
    side='bottom',
    padx=10,
    pady=0
)

suggestion_list.bind('<Right>', select_handler)
suggestion_list.bind('<Return>', select_handler)
suggestion_list.bind('<Escape>', focus_text)

# --- Start up
text_entry.focus()
root.mainloop()
