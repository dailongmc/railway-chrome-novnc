FROM ubuntu:24.04

# Cài đặt cơ bản + XFCE nhẹ + noVNC + Chrome
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies \
    tigervnc-standalone-server tigervnc-common \
    novnc websockify \
    wget curl git unzip \
    google-chrome-stable \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Tạo user để chạy (tránh root)
RUN useradd -m -s /bin/bash chromeuser
USER chromeuser
WORKDIR /home/chromeuser

# Cấu hình VNC + noVNC
RUN mkdir -p ~/.vnc && \
    echo "xfce4-session" > ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup

# Expose port cho noVNC (thường 6080 hoặc 80/8080 cho Railway)
EXPOSE 8080

# Script khởi động: VNC + noVNC + mở nhiều Chrome tab
COPY start.sh /home/chromeuser/start.sh
RUN chmod +x /home/chromeuser/start.sh

CMD ["/home/chromeuser/start.sh"]
