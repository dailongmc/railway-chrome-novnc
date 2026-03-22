#!/bin/bash

# Password VNC (từ env, fallback mặc định)
VNC_PASS=${VNC_PASSWORD:-"railway123"}
echo -e "${VNC_PASS}\n${VNC_PASS}" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Khởi động VNC server (display :1, no password auth nếu muốn, nhưng dùng password an toàn hơn)
vncserver :1 -geometry 1280x800 -depth 24 -SecurityTypes VncAuth &

sleep 5  # Đợi VNC ready

# Khởi động noVNC (websockify proxy VNC 5901 -> HTTP 8080)
websockify --web=/usr/share/novnc/ 8080 localhost:5901 &

# Mở 4 cửa sổ Chrome riêng (profile riêng, nhiều tab mỗi cái - thay URL bằng cái bạn cần farm)
# Cửa sổ 1: nhiều tab chính
google-chrome-stable \
  --no-sandbox --disable-gpu --disable-dev-shm-usage --user-data-dir=/tmp/chrome1 \
  --start-maximized https://example.com https://google.com https://youtube.com &

# Cửa sổ 2: tab khác
google-chrome-stable \
  --no-sandbox --disable-gpu --disable-dev-shm-usage --user-data-dir=/tmp/chrome2 \
  --new-window https://facebook.com https://twitter.com &

# Cửa sổ 3: thêm nữa
google-chrome-stable \
  --no-sandbox --disable-gpu --disable-dev-shm-usage --user-data-dir=/tmp/chrome3 \
  --new-window https://site3.com https://site4.com &

# Cửa sổ 4: lặp lại kiểu dãy icon nếu muốn
google-chrome-stable \
  --no-sandbox --disable-gpu --disable-dev-shm-usage --user-data-dir=/tmp/chrome4 \
  --new-window https://another-site.com &

# Giữ container sống (tail logs hoặc sleep infinity)
tail -f /dev/null
