#!/bin/bash

# Set password VNC (từ env var, mặc định nếu không set)
VNC_PASS=${VNC_PASSWORD:-"railway123"}

# Khởi động VNC server
vncserver :1 -geometry 1280x800 -depth 24 -SecurityTypes None &  # None để dễ, hoặc dùng password

# Đợi VNC ready
sleep 5

# Khởi động noVNC (websockify proxy từ VNC port 5901 -> HTTP 8080)
websockify --web=/usr/share/novnc/ 8080 localhost:5901 &

# Mở nhiều tab/cửa sổ Chrome (thay URL bằng cái bạn cần, ví dụ farm tab)
google-chrome-stable \
  --no-sandbox --disable-gpu --user-data-dir=/tmp/chrome1 \
  --start-maximized "https://example.com" "https://google.com" &

google-chrome-stable \
  --no-sandbox --disable-gpu --user-data-dir=/tmp/chrome2 \
  --new-window "https://youtube.com" "https://facebook.com" &

# Giữ container chạy
tail -f /dev/null
