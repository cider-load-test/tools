#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# run.py - simple launch/run program written in Python
# by Ricardo Martins <meqif@scarybox.net>
#
# Why did I write this? For 3 reasons:
# 1. I was sick of having to have xfce4 installed just because of xfrun4,
# since I run Openbox
# 2. My Python skills were getting rusty
# 3. I wanted to learn a bit more
#
# It is rather minimalist because I wanted it to look like ion3 launch:
# simple and nice. Minimalistic stuff.
#
# A big thanks to nightm4re (dave foster <daf@minuslab.net>), since my history
# code was inspired in his screen launch script for OB3 (screenscript.pl).
#
# I know the code isn't perfect nor efficient, but it gets the job done.
# I'm open to suggestions, criticisms, improvements...
#
# Licensed under the BSD License
#
# 0.0.1 - 19/12/2005 - Initial release
#
# 0.0.2 - 20/12/2005 - The window opens always at the top left corner of
# the screen, kde-based programs now launch, quits if loses focus (useful in
# case you lose the window :P) -- All of these were [Knuckles]'s
# suggestions. Thanks pal!
#
# 0.0.3 - 22/12/2005 - Cleaned up most debug prints
#
# 0.0.4 - 23/12/2005 - Some more cleaning, replacing pointless prints
# with pass where no action is needed
#
#
## TODO:
#	- Cleanup and optimize the code
#	- Fix inability to launch kde programs -- os.system(program) works
# but doesn't spawn a new process, while os.spawn(program) _does_ spawn
# but has this problem. os.execlp(program, ">/dev/null 2>&1 &") does the
# trick but is an ugly hack. I could use some help here.

import os, gtk

program = ""
command_id = 0

## location of the command history
history_file = os.environ.get('HOME')+"/.rprhist"

## get our command history
history = open(history_file, "a+").readlines()
## add a last blank command and reverse the list
history.append("")
history.reverse()

## add used commands to history
def history_add(program):
	## the program is NOT in history
	if (program+"\n") not in history:
		history.append(program+"\n")
		open(history_file, "w+").writelines(history)
	## the program IS in the history
	else:
		pass # Goggles -- Turn: Do nothing

## go back in history
def history_back():
	global command_id
	if command_id < len(history)-1:
		command_id += 1
		entry.set_text(history[command_id].strip("\n"))
	else:
		pass # there's no older command in history
	
## advance in history
def history_next():
	global command_id
	if command_id > 0:
		command_id -= 1
		## here we set the entry text to the next command. stripping "\n"
		## is necessary, otherwise the selected program won't run
		entry.set_text(history[command_id].strip("\n"))
	else:
		pass # there's no newer command in history

## Properties of the window
window = gtk.Window()
window.set_title("Run program")
window.set_decorated(False)
window.set_border_width(0)
window.move(0,0)

## launch the program
def on_entry_activated(entry):
	program = entry.get_text()
	history_add(program)
	#os.spawnlp(os.P_NOWAIT, program)
	## ARGH. Ugly hack here, because KDE-based programs
	## screw up when launched through os.spawn*:
	## ERROR: KUniqueApplication: Registering failed!
	## ERROR: Communication problem with k3b, it probably crashed.
	os.execlp(program, ">/dev/null 2>&1 &")
	gtk.main_quit()

## what to do if keys are pressed
def key_press_impl(win,event):
	if event.keyval == gtk.keysyms.Escape:
		gtk.main_quit()
	elif event.keyval == gtk.keysyms.Up:
		history_back()
	elif event.keyval == gtk.keysyms.Down:
		history_next()
	elif event.keyval == gtk.keysyms.Tab:
		pass ## will use this for tab-completion

## exit if the entry get unfocused
## handy if people lose the window or something
def focus_out(object,event):
	gtk.main_quit()

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

## And now, the hardest part! :P
window.show_all()
gtk.main()
