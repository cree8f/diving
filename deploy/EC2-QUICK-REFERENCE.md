# Quick Reference: EC2 Deployment Commands

## 1️⃣ FIRST CHECK: AWS Security Group (if you can't see the app)

**In AWS Console:**
- Go to EC2 → Security Groups → Your Instance's Group
- Edit Inbound Rules
- Add: HTTP (port 80) from 0.0.0.0/0 → SAVE

**Test from your computer:**
```bash
curl http://3.87.174.211
```

---

## 2️⃣ SSH into EC2 and Check Services

```bash
# Connect
ssh -i your-key.pem ubuntu@3.87.174.211

# Check gunicorn
sudo systemctl status gunicorn

# Check nginx
sudo systemctl status nginx

# Run health check script
bash deploy/ec2-health-check.sh
```

---

## 3️⃣ Quick Fixes (if not working)

```bash
# If gunicorn is stopped:
sudo systemctl start gunicorn
sudo systemctl status gunicorn

# If nginx is stopped:
sudo systemctl start nginx
sudo systemctl status nginx

# Restart both:
sudo systemctl restart gunicorn nginx

# Check if ports are listening:
sudo ss -tlnp | grep :3000
sudo ss -tlnp | grep :80
```

---

## 4️⃣ Verify Gunicorn Works Locally

```bash
# On EC2 SSH session:
curl http://127.0.0.1:3000
# Should show your Flask app

# If it doesn't work, check logs:
sudo journalctl -u gunicorn -n 50 -f
```

---

## 5️⃣ Verify Nginx Reverse Proxy Works

```bash
# On EC2 SSH session:
curl http://localhost
# Should show your Flask app (proxied through nginx)
```

---

## 6️⃣ From Your Computer, Access the App

```bash
# Use your EC2 public IP
curl http://3.87.174.211
# Or open in browser: http://3.87.174.211
```

---

## ⚠️ Still Not Working? Troubleshoot:

| Issue | Check | Command |
|-------|-------|---------|
| Connection Timeout | AWS Security Group | Port 80 open? In AWS console. |
| Connection Refused | Nginx status | `sudo systemctl status nginx` |
| 502 Bad Gateway | Gunicorn | `sudo systemctl restart gunicorn` |
| App logs | Gunicorn logs | `sudo journalctl -u gunicorn -n 20` |
| Nginx config | Syntax error | `sudo nginx -t` |

---

## 📋 Essential Commands Reference

```bash
# Service management
sudo systemctl start gunicorn       # Start gunicorn
sudo systemctl stop gunicorn        # Stop gunicorn
sudo systemctl restart gunicorn     # Restart gunicorn
sudo systemctl status gunicorn      # Check status
sudo systemctl enable gunicorn      # Auto-start on reboot

sudo systemctl restart nginx        # Restart nginx
sudo systemctl reload nginx         # Reload (no downtime)

# Logs & monitoring
sudo journalctl -u gunicorn -f      # Follow gunicorn logs
sudo tail -f /var/log/nginx/error.log  # Nginx errors
sudo tail -f /var/log/nginx/access.log # Nginx access

# Port checking
sudo ss -tlnp                       # Show all listening ports
sudo lsof -i :3000                  # Show what's on port 3000
sudo lsof -i :80                    # Show what's on port 80

# Config validation
sudo nginx -t                       # Test nginx config syntax
```

---

## 📌 Key Points for EC2 Setup

✅ **Security Group** must allow port 80 inbound  
✅ **Gunicorn** listens on 127.0.0.1:3000 (internal)  
✅ **Nginx** listens on 0.0.0.0:80 (external)  
✅ **Nginx** reverse proxies requests to gunicorn  
✅ **Systemd** manages both services  

---

## Files in deploy/ folder

| File | Purpose |
|------|---------|
| `gunicorn.service` | Systemd service file for gunicorn |
| `nginx-port3000.conf` | Nginx reverse proxy config |
| `AWS-EC2-DEPLOYMENT.md` | Full deployment guide |
| `ec2-health-check.sh` | Health check script |
