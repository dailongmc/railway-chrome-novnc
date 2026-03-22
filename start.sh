#!/bin/bash

# Set VNC password từ env var (Railway Variables)
VNC_PASS=${VNC_PASSWORD:-"railway123"}
echo -e "${VNC_PASS}\n${VNC_PASS}" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Start VNC server (display :1)
vncserver :1 -geometry 1280x800 -depth 24 -SecurityTypes VncAuth &

sleep 5  # Wait for VNC to start

# Start noVNC proxy (VNC 5901 -> HTTP 8080)
websockify --web=/usr/share/novnc/ 8080 localhost:5901 &

# Start multiple Chrome windows/tabs (thay URL bằng cái bạn cần, ví dụ farm tab)
google-chrome-stable \
  --no-sandbox --disable-dev-shm-usage --disable-gpu --no-first-run \
  --user-data-dir=/tmp/chrome-profile1 \
  --start-maximized https://example.com https://google.com https://youtube.com &

google-chrome-stable \
  --no-sandbox --disable-dev-shm-usage --disable-gpu --no-first-run \
  --user-data-dir=/tmp/chrome-profile2 \
  --new-window https://facebook.com https://twitter.com &

# Thêm bao nhiêu profile tùy ý để giống dãy tab/icon lặp lại

# Keep container running
tail -f /dev/null
