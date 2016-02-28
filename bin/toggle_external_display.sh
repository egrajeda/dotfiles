#!/bin/sh

# Por cada salida xrandr devuelve una línea como la siguiente:
#
# HDMI1 connected (normal left inverted right x axis y axis)
# ^---^           ^-----^
# display         resolution
#
# O si la salida ha sido activada:
#
# HDMI1 connected 1920x1080+0+0 (normal left inverted right x axis y axis)
# ^---^           ^-----------^
# display          resolution
#
# Usaremos el valor de "resolution" para diferenciar si la salida está activada
# o no.

display=$(xrandr | grep " connected" | grep -v LVDS1 | cut -d " " -f1)
resolution=$(xrandr | grep " connected" | grep -v LVDS1 | cut -d " " -f3)

# La salida NO está activada
if [[ $resolution == \(* ]]; then
    xrandr --output $display --auto --above LVDS1

# La salida SI está activada
else
    xrandr --output $display --off
fi

# Recargamos el fondo de pantalla
feh --bg-scale ~/images/wallpaper.jpg
