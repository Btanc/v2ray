# local email=$(((RANDOM << 22)))
# tls ${email}@gmail.com
case $v2ray_transport in
4|33)
	if [[ $is_path ]]; then
		cat >/etc/caddy/Caddyfile <<-EOF
$domain {
    encode gzip
    handle {
        reverse_proxy $proxy_site {
            header_up Host {upstream_hostport}
            header_up X-Forwarded-Host {host}
        }
    }
    handle_path /${path} {
        reverse_proxy 127.0.0.1:${v2ray_port}
    }
}
import sites/*
		EOF
	else
		cat >/etc/caddy/Caddyfile <<-EOF
$domain {
  encode gzip
	reverse_proxy 127.0.0.1:${v2ray_port}
}
import sites/*
		EOF
	fi
	;;
5)
	if [[ $is_path ]]; then
		cat >/etc/caddy/Caddyfile <<-EOF
$domain {
    encode gzip
    handle {
        reverse_proxy $proxy_site {
            header_up Host {upstream_hostport}
            header_up X-Forwarded-Host {host}
        }
    }
    handle_path /${path} {
        reverse_proxy h2c://127.0.0.1:${v2ray_port}
    }
}
import sites/*
		EOF
	else
		cat >/etc/caddy/Caddyfile <<-EOF
$domain {
    encode gzip
    handle_path * {
        reverse_proxy h2c://127.0.0.1:${v2ray_port}
    }
}
import sites/*
		EOF
	fi
	;;

esac
