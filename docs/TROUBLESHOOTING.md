# Troubleshooting Guide — PHP 8.5 + PrestaShop on Ubuntu 26.04

## Error: `Allocation of JIT memory failed`

**File to edit:** `/etc/php/8.5/apache2/php.ini`

```ini
pcre.jit = 0
```

Restart Apache after saving:
```bash
sudo systemctl restart apache2
```

---

## Broken storefront / back office layout (missing CSS, displaced blocks)

**File to edit:** `/etc/php/8.5/apache2/php.ini`

```ini
error_reporting = E_ALL & ~E_NOTICE & ~E_STRICT & ~E_DEPRECATED
display_errors  = Off
log_errors      = On
error_log       = /var/log/php_errors.log
```

Restart Apache after saving:
```bash
sudo systemctl restart apache2
```

---

## `/install` returns 404

You cloned the GitHub source repo. It does not contain compiled build artifacts.

Download the official release instead:
```bash
wget https://github.com/PrestaShop/PrestaShop/releases/download/<version>/prestashop_<version>.zip
```

---

## SSH connection times out

Your current public IP may not match the `/32` rule in the EC2 Security Group.

Check your current IP:
```bash
curl ifconfig.me
```

Update the SSH inbound rule in the AWS Console → EC2 → Security Groups to match.

---

## After installation — store not accessible

Ensure the `/install` directory has been removed:
```bash
sudo rm -rf /var/www/html/install
```
