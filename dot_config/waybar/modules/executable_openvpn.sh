if [[ $1 == "print" ]];then
	server_name=$(cat /tmp/vpn_server)
	if [[ -z $(pgrep openvpn) ]];then
		echo "{\"text\":\"\",\"alt\":\"Recording\",\"tooltip\":\"tooltip\",\"class\":\"disconnected\"}"
		exit 0
	fi
	# {"text": "$text", "alt": "$alt", "tooltip": "$tooltip", "class": "$class", "percentage": $percentage }
	echo "{\"text\":\" <span font='FluentUI-Filed-Monochrome 14'  color='#ff0000'></span> <span  rise='3000'>"${server_name} " </span>\",\"alt\":\"Recording\",\"tooltip\":\"tooltip\",\"class\":\"record\"}"
	exit 0

elif [[ $1 == "connect" ]];then
    echo "connected" > /tmp/vpn_server
    sleep 2
    pkill -RTMIN+8 waybar
    openvpn --config /home/invisiblecat/.config/vpn/config.ovpn & disown
elif [[ $1 == "disconnect" ]];then
    killall -9 openvpn
    while [ ! -z $(pgrep -x openvpn) ]; do wait; done
    pkill -RTMIN+8 waybar
fi