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
  logger -t cert-renew "Certificate or key file missing, creating new one"
else
  # Check expiration (renew if less than 30 days left)
  if which openssl > /dev/null; then
    # Get certificate expiration date in a more directly usable format
    expiry_sec=$(openssl x509 -enddate -noout -in "$CERT_FILE" | 
                cut -d= -f2 | 
                xargs -I{} date -d "{}" +%s 2>/dev/null)
    
    # If date conversion failed, try an alternative approach
    if [ $? -ne 0 ]; then
      # Get raw expiry date
      expiry_date=$(openssl x509 -enddate -noout -in "$CERT_FILE" | cut -d= -f2)
      logger -t cert-renew "Parsing date: $expiry_date"
      
      # Try manual parsing (BusyBox date has limited format support)
      month=$(echo "$expiry_date" | awk '{print $1}')
      day=$(echo "$expiry_date" | awk '{print $2}')
      year=$(echo "$expiry_date" | awk '{print $4}')
      
      # Convert month to number (approximate)
      case "$month" in
        Jan*) month_num="01";;
        Feb*) month_num="02";;
        Mar*) month_num="03";;
        Apr*) month_num="04";;
        May*) month_num="05";;
        Jun*) month_num="06";;
        Jul*) month_num="07";;
        Aug*) month_num="08";;
        Sep*) month_num="09";;
        Oct*) month_num="10";;
        Nov*) month_num="11";;
        Dec*) month_num="12";;
        *) month_num="01";;
      esac
      
      # Try a more compatible date format
      expiry_sec=$(date -d "$year-$month_num-$day" +%s 2>/dev/null)
      
      # If still failing, renew to be safe
      if [ $? -ne 0 ]; then
        logger -t cert-renew "Failed to parse certificate date, renewing to be safe"
        needs_new_cert=1
      fi
    fi
    
    # If we got a valid timestamp, calculate days remaining
    if [ "$needs_new_cert" -eq 0 ] && [ -n "$expiry_sec" ]; then
      current_sec=$(date +%s)
      seconds_left=$((expiry_sec - current_sec))
      days_left=$((seconds_left / 86400))
      
      logger -t cert-renew "Certificate expires in $days_left days"
      
      # Sanity check - if days_left is negative or unreasonably large, something is wrong
      if [ "$days_left" -lt 0 ] || [ "$days_left" -gt 3650 ]; then
        logger -t cert-renew "Invalid expiration calculation ($days_left days), renewing certificate"
        needs_new_cert=1
      elif [ "$days_left" -lt 30 ]; then
        needs_new_cert=1
        logger -t cert-renew "Certificate expires in $days_left days, renewing"
      fi
    fi
  else
    # If openssl isn't available, create a new certificate to be safe
    needs_new_cert=1
    logger -t cert-renew "OpenSSL not found, renewing certificate to be safe"
  fi
fi

# Generate certificate if needed
if [ "$needs_new_cert" -eq 1 ]; then
  logger -t cert-renew "Generating new self-signed SSL certificate"
  # Use a smaller key size (2048 bit instead of 4096) for better performance
  # and use the faster sha256 algorithm
  openssl req -x509 -newkey rsa:2048 \
    -keyout "$KEY_FILE" -out "$CERT_FILE" \
    -days 730 -nodes -sha256 \
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