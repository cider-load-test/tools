#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# run.py - simple launch/run program written in Python
# by Ricardo Martins <ricardo at scarybox dot net>
#
# A big thanks to nightm4re (dave foster <daf at minuslab.net>), since my history
# code was inspired in his screen launch script for OB3 (screenscript.pl).
#
# Licensed under the BSD License
#
# TODO:
#   - Cleanup and optimize the code

import os, gtk

program = ""
command_id = 0

# location of the command history
history_file = os.environ.get('HOME')+"/.rprhist"

# get our command history
history = open(history_file, "a+").readlines()
# add a last blank command and reverse the list
history.append("")
history.reverse()

# add used commands to history
def history_add(program):
  # the program is NOT in history
  if (program+"\n") not in history:
    history.append(program+"\n")
    open(history_file, "w+").writelines(history)
  # the program IS in the history
  else:
    pass # Goggles -- Turn: Do nothing

# go back in history
def history_back():
  global command_id
  if command_id < len(history)-1:
    command_id += 1
    entry.set_text(history[command_id].strip("\n"))
  else:
    pass # there's no older command in history
  
# advance in history
def history_next():
  global command_id
  if command_id > 0:
    command_id -= 1
    # here we set the entry text to the next command. stripping "\n"
    # is necessary, otherwise the selected program won't run
    entry.set_text(history[command_id].strip("\n"))
  else:
    pass # there's no newer command in history

# Properties of the window
window = gtk.Window()
window.set_title("Run program")
window.set_decorated(False)
window.set_border_width(0)
window.move(0,0)

# launch the program
def on_entry_activated(entry):
  program = entry.get_text()
  if program != "":
    history_add(program)
    #os.spawnlp(os.P_NOWAIT, program)
    # Ugly hack here. There must be a cleaner way to do this.
    os.execlp(program, ">/dev/null 2>&1 &")
  gtk.main_quit()

# what to do if keys are pressed
def key_press_impl(win,event):
  if event.keyval == gtk.keysyms.Escape:
    gtk.main_quit()
  elif event.keyval == gtk.keysyms.Up:
    history_back()
  elif event.keyval == gtk.keysyms.Down:
    history_next()
  elif event.keyval == gtk.keysyms.Tab:
    pass ## will use this for tab-completion

# exit if the entry get unfocused
def focus_out(object,event):
  gtk.main_quit()

# Create the windows
vbox = gtk.VBox(False, 0)
window.add(vbox)
vbox.show()
entry = gtk.Entry()
entry.set_max_length(50)
entry.connect("activate", on_entry_activated)
entry.connect("key-press-event", key_press_impl)
entry.connect("focus_out_event", focus_out)
entry.set_text("")
vbox.pack_start(entry, True, True, 0)
entry.show()
window.show_all()
gtk.main()
