#!/usr/bin/env python3
import gi
gi.require_version('Gtk', '3.0')
gi.require_version('WebKit2', '4.1')
from gi.repository import Gtk, WebKit2

class WhatsApp(Gtk.Window):
    def __init__(self):
        super().__init__(title="WhatsApp")
        self.set_default_size(1100, 720)

        view = WebKit2.WebView()
        view.load_uri("https://web.whatsapp.com/")

        scrolled = Gtk.ScrolledWindow()
        scrolled.add(view)

        self.add(scrolled)
        self.connect("destroy", Gtk.main_quit)

win = WhatsApp()
win.show_all()
Gtk.main()
