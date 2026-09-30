#!/bin/sh
# Creates and renews the self-signed TLS certificate that nginx serves for the
# web UI (443) and the gpio-daemon websocket (8765).
# Only certificates created here (marked with .self-signed) are ever replaced;
# an uploaded certificate is left alone and only reported when it expires.

TLS_DIR=/etc/wallcontroller/tls
CERT="$TLS_DIR/server.crt"
KEY="$TLS_DIR/server.key"
MARKER="$TLS_DIR/.self-signed"
RENEW_BEFORE=$((30 * 86400))

mkdir -p "$TLS_DIR"

if [ -f "$CERT" ] && [ -f "$KEY" ]; then
	openssl x509 -checkend "$RENEW_BEFORE" -noout -in "$CERT" >/dev/null && exit 0

	if [ ! -f "$MARKER" ]; then
		logger -t cert-renew "uploaded certificate expires within 30 days, not replacing it"
		exit 0
	fi
	logger -t cert-renew "self-signed certificate expires within 30 days, renewing"
else
	logger -t cert-renew "no certificate found, creating self-signed certificate"
fi

host="$(uci -q get system.@system[0].hostname)"
host="${host:-wallcontroller}"

# 825 days is the longest validity Apple clients accept
if ! openssl req -x509 -newkey rsa:2048 -nodes -sha256 -days 825 \
	-keyout "$KEY.new" -out "$CERT.new" \
	-subj "/CN=$host.local" \
	-addext "subjectAltName=DNS:$host.local,DNS:$host" 2>/dev/null; then
	logger -t cert-renew "certificate generation failed"
	rm -f "$KEY.new" "$CERT.new"
	exit 1
fi

chmod 600 "$KEY.new"
chmod 644 "$CERT.new"
mv "$KEY.new" "$KEY"
mv "$CERT.new" "$CERT"
touch "$MARKER"

# nginx picks up the new certificate on reload; open connections stay up
/etc/init.d/nginx running && /etc/init.d/nginx reload
exit 0
