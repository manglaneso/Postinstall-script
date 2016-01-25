#!/usr/bin/env python3

import subprocess
import time
import getpass

no_show = ['rhythmbox', 'vlc', 'clementine', 'spotify', 'banshee', 'lollypop', 'audacious'] # add names here, to set apps not to show
cleanup_interval = 10 # cleanup interval (in seconds)

curruser = getpass.getuser()

def createlist_runningprocs():
    processesb = subprocess.Popen(
        ["ps", "-u", curruser],
        stdout=subprocess.PIPE)
    process_listb = (processesb.communicate()[0].decode("utf-8")).split("\n")
    return process_listb

def read_soundmenu():
    # read the current launcher contents
    get_menuitems = subprocess.Popen([
        "gsettings", "get",
        "com.canonical.indicator.sound",
        "interested-media-players"
        ], stdout=subprocess.PIPE)
    try:
        return eval(get_menuitems.communicate()[0].decode("utf-8"))
    except SyntaxError:
        return []

def set_soundmenu(new_list):
    # set the launcher contents
    subprocess.Popen([
        "gsettings", "set",
        "com.canonical.indicator.sound",
        "interested-media-players",
        str(new_list)])

def check_ifactionneeded():
    snd_items = read_soundmenu()
    procs = createlist_runningprocs()
    remove = [item+".desktop" for item in no_show if not item in str(procs)]
    if len(remove) != 0:
        for item in remove:
            try:
                snd_items.remove(item)
            except ValueError:
                pass
        return snd_items
    else:
        pass

while 1 != 0:
    new_list = check_ifactionneeded()
    if new_list != None:
        set_soundmenu(new_list)
    time.sleep(cleanup_interval)
