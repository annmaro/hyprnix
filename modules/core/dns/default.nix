{ ... }:
{
  networking.firewall = {
    allowedTCPPorts = [
      53
    ];
    allowedUDPPorts = [
      53
    ];
  };
  # Disable systemd dns resolver
  services.resolved = {
    enable = false;
    settings = {
      Resolve = {
        Domains = [ "~." ];
        FallbackDNS = [ ]; # Empty to prevent bypass
        DNSOverTLS = "true";

        # github.com/systemd/systemd/issues/10579
        # dnssec = "allow-downgrade";
        DNSSEC = "false";
      };
    };
  };
  systemd.services = {
    unbound.stopIfChanged = false;
  };
  services = {
    unbound = {
      enable = true;
      settings = {
        remote-control.control-enable = true;
        server = {
          # When only using Unbound as DNS, make sure to replace 127.0.0.1 with your ip address
          # When using Unbound in combination with pi-hole or Adguard, leave 127.0.0.1, and point Adguard to 127.0.0.1:PORT
          interface = [ "127.0.0.1" ]; # "::1"
          port = 53;
          access-control = [
            "127.0.0.1 allow"
            "192.168.0.0/24 allow"
          ];
          # Based on recommended settings in https://docs.pi-hole.net/guides/dns/unbound/#configure-unbound
          harden-glue = true;
          harden-dnssec-stripped = true;
          use-caps-for-id = false;
          prefetch = true;
          edns-buffer-size = 1232;
          hide-identity = true;
          hide-version = true;
        };
        forward-zone = [
          {
            name = ".";
            forward-tls-upstream = "yes";
            forward-addr = [
              "1.1.1.1@853#cloudflare-dns.com"
              "1.0.0.1@853#cloudflare-dns.com"

              # "9.9.9.9#dns.quad9.net"
              # "149.112.112.112#dns.quad9.net"
            ];
          }
        ];
      };
    };
  };
  /*
    services.stubby = {
      enable = true;
      settings = {
        # ::1 cause error, use 0::1 instead
        listen_addresses = [
          "127.0.0.1@5300"
          "0::1@5300"
        ];
        resolution_type = "GETDNS_RESOLUTION_STUB";
        dns_transport_list = [ "GETDNS_TRANSPORT_TLS" ];
        tls_authentication = "GETDNS_AUTHENTICATION_REQUIRED";
        tls_query_padding_blocksize = 128;
        idle_timeout = 10000;
        round_robin_upstreams = 1;
        tls_min_version = "GETDNS_TLS1_3";
        dnssec = "GETDNS_EXTENSION_TRUE";
        upstream_recursive_servers = [
          {
            address_data = "1.0.0.2";
            tls_auth_name = "cloudflare-dns.com";
          }
          {
            address_data = "9.9.9.9";
            tls_auth_name = "dns.quad9.net";
          }
        ];
      };
    };
  */
}