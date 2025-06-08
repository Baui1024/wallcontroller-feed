#!/bin/sh

# Define certificate locations
CERT_DIR="/etc/ssl/certs"
KEY_DIR="/etc/ssl/private" 
CERT_FILE="${CERT_DIR}/wallcontroller.crt"
KEY_FILE="${KEY_DIR}/wallcontroller.key"
DOMAIN="wallcontroller.local"

# Ensure directories exist
mkdir -p $CERT_DIR $KEY_DIR

# Check if certificate renewal is needed
needs_new_cert=0
if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
  needs_new_cert=1
else
  # Check expiration (renew if less than 30 days left)
  if which openssl > /dev/null; then
    expiry_date=$(openssl x509 -enddate -noout -in "$CERT_FILE" | cut -d= -f2)
    expiry_epoch=$(date -d "$expiry_date" +%s 2>/dev/null || date -j -f "%b %d %H:%M:%S %Y %Z" "$expiry_date" "+%s")
    current_epoch=$(date +%s)
    days_left=$(( (expiry_epoch - current_epoch) / 86400 ))
    logger -t cert-renew "Certificate expires in $days_left days, not renewing"
    if [ "$days_left" -lt 30 ]; then
      needs_new_cert=1
      logger -t cert-renew "Certificate expires in $days_left days, renewing"
    fi
  fi
fi

# Generate certificate if needed
if [ "$needs_new_cert" -eq 1 ]; then
  logger -t cert-renew "Generating new self-signed SSL certificate"
  openssl req -x509 -newkey rsa:4096 \
    -keyout "$KEY_FILE" -out "$CERT_FILE" \
    -days 730 -nodes \
    -subj "/CN=$DOMAIN"
  
  # Set proper permissions
  chmod 644 "$CERT_FILE" 
  chmod 600 "$KEY_FILE"
  
  # Restart services that use the certificate
  if [ -f /etc/init.d/webserver ]; then
    logger -t cert-renew "Restarting webserver to use new certificate"
    /etc/init.d/webserver restart
    /etc/init.d/gpio-daemon restart
  fi
fi