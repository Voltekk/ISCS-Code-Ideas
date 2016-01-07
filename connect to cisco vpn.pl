use strict;
use warnings;

system('sudo openvpn --mktun --dev tun1');
system('sudo ifconfig tun1 up');
system('sudo openconnect <insert here> --interface=tun1');

exit();
