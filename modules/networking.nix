{ ... }:

{
  networking.hosts = {
    "127.0.0.1" = [ "cenitly.local" ];
  };
  networking.nftables = {
    enable = true;
    tables = {
      nat = {
        family = "ip";
        content = ''
          chain prerouting {
            type nat hook prerouting priority dstnat
            policy accept
            ip daddr 127.0.0.1 tcp dport 443 dnat to 127.0.0.1:7443
          }
          chain output {
            type nat hook output priority dstnat
            policy accept
            ip daddr 127.0.0.1 tcp dport 443 dnat to 127.0.0.1:7443
          }
          chain postrouting {
            type nat hook postrouting priority srcnat
            policy accept
          }
        '';
      };
    };
  };
}
