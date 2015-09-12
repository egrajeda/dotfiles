#!/bin/zsh

BACKGROUND_COLOR="#44000000"
FOREGROUND_COLOR="#FFFFFFFF"
FONT1="Consolas:size=10"
FONT2="FontAwesome:size=10"

PADDING="   "

RED="#FFDC322F"

ICON_VOLUME_UP="\uf028"
ICON_VOLUME_DOWN="\uf027"
ICON_VOLUME_OFF="\uf026"
ICON_WIFI="\uf1eb"

DEFAULT_REFRESH_RATE=1

Clock() {
    echo $(date "+%A %b %d %H:%M")
}

Volume() {
    state=$(amixer get Master | grep "Mono" | grep -o "\[on\]")
    if [ $state ]; then
        volume=$(amixer get Master | grep "Mono" | grep -o "...%" | sed "s/\[//" | sed "s/%//")
        if [ $volume -ge 50 ]; then
            icon=$ICON_VOLUME_UP
        elif [ $volume -eq 0 ]; then
            icon=$ICON_VOLUME_OFF
        else
            icon=$ICON_VOLUME_DOWN
        fi
    else
        volume=0
        icon=$ICON_VOLUME_OFF
    fi
    if [ $volume -eq 0 ]; then
        echo "%{F$RED}$icon     %{F-}"
    else
        printf "$icon %-3s" $volume
    fi
}

Network() {
    printf "$ICON_WIFI "
}

NETWORK_PING_REFRESH_RATE=10
NetworkPing() {
    ping=$(ping -c 1 www.google.com | grep -o "time=.*" | sed "s/time=//" | sed "s/ //")
    printf "%-6s" $ping
}


ticks=0
while true; do
    if [ $(( $ticks % $DEFAULT_REFRESH_RATE )) -eq 0 ]; then
        clock=$(Clock)
        volume=$(Volume)
        network=$(Network)
    fi
    if [ $(( $ticks % $NETWORK_PING_REFRESH_RATE )) -eq 0 ]; then
        network_ping=$(NetworkPing)
    fi

    echo "%{r}${network}${network_ping}$PADDING${volume}$PADDING${clock}  "

    sleep 1;

    ticks=$(( $ticks+1 ))
    if [ $ticks -ge 60 ]; then
        ticks=0
    fi
done | lemonbar \
    -B $BACKGROUND_COLOR \
    -F $FOREGROUND_COLOR \
    -f $FONT1 -f $FONT2 \
    -g x22+0+0 \
    -o 1
