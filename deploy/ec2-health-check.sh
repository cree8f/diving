#!/bin/bash
# EC2 Deployment & Troubleshooting Script
# Run this on your EC2 instance to check the deployment status

echo "🔍 DivinG_BAZ EC2 Deployment Health Check"
echo "=========================================="
echo ""

# Check if running on EC2 Linux
if ! command -v systemctl &> /dev/null; then
    echo "❌ This script requires systemd (Linux/EC2 only)"
    exit 1
fi

# Check Gunicorn
echo "📦 Gunicorn Status:"
if sudo systemctl is-active --quiet gunicorn; then
    echo "   ✅ Gunicorn is RUNNING"
    sudo systemctl status gunicorn --no-pager | tail -3
else
    echo "   ❌ Gunicorn is NOT RUNNING"
    echo "   Fix: sudo systemctl start gunicorn"
fi
echo ""

# Check Nginx
echo "🌐 Nginx Status:"
if sudo systemctl is-active --quiet nginx; then
    echo "   ✅ Nginx is RUNNING"
    sudo systemctl status nginx --no-pager | tail -3
else
    echo "   ❌ Nginx is NOT RUNNING"
    echo "   Fix: sudo systemctl start nginx"
fi
echo ""

# Check if Gunicorn is listening on port 3000
echo "🔌 Port 3000 (Gunicorn):"
if sudo ss -tlnp | grep -q ":3000"; then
    echo "   ✅ Gunicorn listening on port 3000"
else
    echo "   ❌ Nothing listening on port 3000"
    echo "   Fix: sudo systemctl restart gunicorn"
fi
echo ""

# Check if Nginx is listening on port 80
echo "🔌 Port 80 (Nginx):"
if sudo ss -tlnp | grep -q ":80"; then
    echo "   ✅ Nginx listening on port 80"
else
    echo "   ❌ Nothing listening on port 80"
    echo "   Fix: sudo systemctl restart nginx"
fi
echo ""

# Check if app responds on localhost
echo "🧪 Local App Response (127.0.0.1:3000):"
if curl -s http://127.0.0.1:3000 > /dev/null 2>&1; then
    echo "   ✅ App responds on localhost"
else
    echo "   ❌ App not responding on localhost"
    echo "   Fix: Check gunicorn logs: sudo journalctl -u gunicorn -n 20"
fi
echo ""

# Check recent gunicorn errors
echo "📋 Recent Gunicorn Logs:"
sudo journalctl -u gunicorn -n 5 --no-pager | tail -5
echo ""

# Check recent nginx errors
echo "📋 Nginx Error Log (last 3 lines):"
sudo tail -3 /var/log/nginx/error.log 2>/dev/null || echo "   No errors"
echo ""

# Security Group check
echo "🔒 Security Group Check:"
echo "   Port 80 must be open in AWS Security Group"
echo "   To test from outside: curl http://<YOUR_EC2_IP>"
echo ""

# Summary
echo "=========================================="
echo "✅ If all items above are green, your app should be accessible!"
echo "❌ If any are red, use the 'Fix' commands above"
