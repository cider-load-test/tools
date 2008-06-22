#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
run.py - a very small (< 4 KB) launch/run program written in Python
by Ricardo Martins <ricardo at scarybox dot net>

Licensed under the MIT/X11 License

TODO:
  - Cleanup and optimize the code

"""

import os
import gtk

"""Location of the command history."""
HISTORY_FILE = os.environ.get('HOME')+"/.rprhist"

"""Get the command history."""
history = []
file = open(HISTORY_FILE, "a+")
try:
    while True:
        line = file.readline()
        if line == "": break
        history.append(line.strip())
    history.append("")
    history.reverse()
finally:
    file.close()

program = ""
command_id = 0

class RunPy:


    def __init__(self):
        """Window properties"""
        self.window = gtk.Window()
        self.window.set_title("Run program")
        self.window.set_decorated(False)
        self.window.set_border_width(0)
        self.window.move(0,0)

        """Create the window."""
        self.vbox = gtk.VBox(False, 0)
        self.window.add(self.vbox)
        self.vbox.show()

        """Create the entry."""
        self.entry = gtk.Entry()
        self.entry.set_max_length(50)
        self.entry.connect("activate", self.on_entry_activated)
        self.entry.connect("key-press-event", self.key_press_impl)
        self.entry.connect("focus_out_event", self.focus_out)
        self.entry.set_text("")

        """Tie everything up."""
        self.vbox.pack_start(self.entry, True, True, 0)
        self.entry.show()
        self.window.show_all()

    def main(self):
        gtk.main()

    def history_add(self, program):
        """Add used commands to history."""
        if (program) not in history:
            history.append(program)
            file = open(HISTORY_FILE, "w+")
            try:
                for line in history:
                    if line != "": file.write(line + "\n")
            finally:
                file.close()

    def history_back(self):
        """ Go back in history."""
        global command_id
        if command_id < len(history)-1:
            command_id += 1
            self.entry.set_text(history[command_id])

    def history_next(self):
        """Advance in history."""
        global command_id
        if command_id > 0:
            command_id -= 1
            self.entry.set_text(history[command_id])

    def on_entry_activated(self, entry):
        """Launch the program."""
        program = entry.get_text()
        if len(program) > 0:
            self.history_add(program)
            # FIXME: Ugly hack here.
            os.execlp(program, ">/dev/null 2>&1 &")
        gtk.main_quit()

    def key_press_impl(self, win, event):
        """Handle keypresses."""
        if event.keyval == gtk.keysyms.Escape:
            gtk.main_quit()
        elif event.keyval == gtk.keysyms.Up:
            self.history_back()
        elif event.keyval == gtk.keysyms.Down:
            self.history_next()
        elif event.keyval == gtk.keysyms.Tab:
            pass ## will use this for tab-completion

    def focus_out(self, object, event):
        """Exit if the entry becomes unfocused."""
        gtk.main_quit()


runpy = RunPy()
runpy.main()
