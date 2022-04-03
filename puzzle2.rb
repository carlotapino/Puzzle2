require 'gtk3'
require 'thread'
require_relative 'puzzle1.rb'

@rf = Rfid.new
@uid=""

#Creo la finestra 
window = Gtk::Window.new("Rfid Window")
window.set_size_request(600,150)
window.set_border_width(5)    
window.set_window_position(:CENTER)

#Per utilitzar colors, necessito incialitzar-los:
@blue = Gdk::RGBA::new(0,0,1.0,1.0)
@white = Gdk::RGBA::new(1.0,1.0,1.0,1.0)
@turquesa = Gdk::RGBA::new(0,1.0,1.0,1.0)
@purple = Gdk::RGBA::new(1.0,0,1.0,1.0)

#Creo el label i el botó

@label1 = Gtk::Label.new("Si us plau, apropeu la targeta")
@label1.override_background_color(:normal, @blue)
@label1.override_color(:normal, @white)
@button = Gtk::Button.new(:@label => "Clear")
@button.set_size_request(540,40)

fixed = Gtk::Fixed.new

@label1.set_size_request(540,100)
fixed.put(@label1, 30,0)
fixed.put(@button, 30,110)
window.add(fixed)
window.show_all


#Quan polsem CLEAR la pantalla demanara la targeta i entrara al thread (Si abans s'ha passat una targeta, sino no fara res)
@button.signal_connect ("clicked") do 
if @uid!=""  
  @label1.override_background_color(:normal, @blue)
  @label1.set_text("Si us plau, apropeu la targeta")
  @uid=""
  threads
end
end
 
#el thread llegeix i quan acaba de llegir finalitza el thread
def threads
  t = Thread.new{
    lectura
    puts "FI DEL THREAD"
    t.exit
  }
end
 
#lectura: guarda el numero que llegeix 
def lectura
  puts "Passi la targeta"
  @uid = @rf.read_uid
  GLib::Idle.add{gestio_UI}
end

def gestio_UI
  if @uid!=""
    @label1.set_label(@uid)
    @label1.override_background_color(:normal, @purple)
  end
end
threads

Gtk.main

