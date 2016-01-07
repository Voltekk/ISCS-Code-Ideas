use strict;
use warnings;

system('sudo ifconfig tun1 down');
system('sudo openvpn --rmtun --dev tun1');

exit();
