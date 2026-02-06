#!/bin/zsh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVICE="Wi-Fi"
PAC_URL="https://tech.stromez.tech/proxy.pac"
CERT_PATH="$SCRIPT_DIR/cert/mitmproxy-ca-cert.pem"

sudo -v || exit 1

sudo xattr -c "$CERT_PATH" 2>/dev/null
sudo chmod 644 "$CERT_PATH"

TEMP_CERT="/tmp/mitm-$(date +%s).pem"
sudo cp "$CERT_PATH" "$TEMP_CERT"

sudo networksetup -setautoproxyurl "$SERVICE" "$PAC_URL" 2>/dev/null
sudo networksetup -setautoproxystate "$SERVICE" on 2>/dev/null

CERT_NAME=$(openssl x509 -noout -subject -in "$TEMP_CERT" 2>/dev/null | sed 's/.*CN=//')
[[ -n "$CERT_NAME" ]] && sudo security delete-certificate -c "$CERT_NAME" /Library/Keychains/System.keychain 2>/dev/null

sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain "$TEMP_CERT" 2>/dev/null
sudo rm -f "$TEMP_CERT"
