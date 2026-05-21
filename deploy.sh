#!/usr/bin/env bash
# ============================================================
# PrestaShop Deployment Script
# Ubuntu 26.04 LTS + PHP 8.5 + Apache 2
# ============================================================
set -e

PS_VERSION="8.1.7"   # <-- update to your target version
WEBROOT="/var/www/html"

echo "==> [1/6] Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "==> [2/6] Installing Apache, PHP 8.5, and required extensions..."
sudo apt install -y apache2 php libapache2-mod-php php-mysql \
  php-curl php-gd php-intl php-mbstring php-xml php-zip php-bcmath unzip wget

echo "==> [3/6] Enabling mod_rewrite..."
sudo a2enmod rewrite
sudo systemctl restart apache2

echo "==> [4/6] Applying PHP 8.5 compatibility overrides..."
PHP_INI="/etc/php/8.5/apache2/php.ini"
sudo sed -i 's/^;*pcre.jit\s*=.*/pcre.jit = 0/'         "$PHP_INI"
sudo sed -i 's/^display_errors\s*=.*/display_errors = Off/' "$PHP_INI"
sudo sed -i 's/^;*log_errors\s*=.*/log_errors = On/'      "$PHP_INI"
# Append error_reporting override
echo "error_reporting = E_ALL & ~E_NOTICE & ~E_STRICT & ~E_DEPRECATED" \
  | sudo tee -a "$PHP_INI" > /dev/null

echo "==> [5/6] Downloading and deploying official PrestaShop release..."
cd /tmp
wget -q "https://github.com/PrestaShop/PrestaShop/releases/download/${PS_VERSION}/prestashop_${PS_VERSION}.zip"
sudo unzip -q "prestashop_${PS_VERSION}.zip" -d "$WEBROOT"

echo "==> [6/6] Setting file permissions..."
sudo chown -R www-data:www-data "$WEBROOT"
sudo find "$WEBROOT" -type d -exec chmod 755 {} \;
sudo find "$WEBROOT" -type f -exec chmod 644 {} \;

sudo systemctl restart apache2

echo ""
echo "✅ Done! Navigate to http://<EC2-Public-IP>/install to complete setup."
echo "   After install, run: sudo rm -rf ${WEBROOT}/install"
