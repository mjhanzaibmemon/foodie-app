#!/bin/bash
set -e

CONF_FILE="/usr/local/lsws/conf/httpd_config.conf"

# Backup config once (only first run)
if [ ! -f "${CONF_FILE}.bak" ]; then
  cp "$CONF_FILE" "${CONF_FILE}.bak"
fi

# Ensure LSAPI inherits environment variables
if ! grep -q "envInherit on" "$CONF_FILE"; then
  echo "Adding envInherit on to LSAPI config..."
  sed -i "/extProcessor lsphp {/a\ \ \ \ envInherit on" "$CONF_FILE"
fi

# Inject all current environment variables into LSAPI config
echo "Injecting environment variables into LSAPI..."
while IFS='=' read -r name value; do
  # Skip system variables and empty names
  case "$name" in
    HOSTNAME|PWD|HOME|TERM|SHLVL|PATH|_|LS_COLORS) continue ;;
  esac

  # Escape any special chars in the value
  safe_value=$(printf '%s\n' "$value" | sed 's/\\/\\\\/g; s/&/\\&/g')

  # Only inject if not already present
  if ! grep -q "env ${name}=" "$CONF_FILE"; then
    sed -i "/extProcessor lsphp {/a\ \ \ \ env ${name}=\$${name}" "$CONF_FILE"
  fi
done < <(env)

# Start OpenLiteSpeed
/usr/local/lsws/bin/lswsctrl start

# Keep container running
tail -f /usr/local/lsws/logs/error.log