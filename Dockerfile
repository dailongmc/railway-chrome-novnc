FROM ubuntu:24.04

# Cập nhật và install các gói cần thiết + deps Chrome + noVNC tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common wget curl gnupg ca-certificates \
    xfce4 xfce4-goodies xfce4-terminal \
    tigervnc-standalone-server tigervnc-common \
    novnc websockify \
    git unzip supervisor \
    fonts-liberation libappindicator3-1 libasound2t64 libatk-bridge2.0-0 \
    libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgbm1 \
    libgcc-s1 libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 \
    libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 \
    libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 lsb-release \
    xdg-utils \
    && wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y ./google-chrome-stable_current_amd64.deb \
    && rm google-chrome-stable_current_amd64.deb \
    && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Tạo user non-root
RUN useradd -m -s /bin/bash chromeuser && \
    mkdir -p /home/chromeuser/.vnc && \
    chown -R chromeuser:chromeuser /home/chromeuser

USER chromeuser
WORKDIR /home/chromeuser

# Cấu hình VNC xstartup (khởi động XFCE)
RUN echo '#!/bin/sh' > ~/.vnc/xstartup && \
    echo 'unset SESSION_MANAGER' >> ~/.vnc/xstartup && \
    echo 'unset DBUS_SESSION_BUS_ADDRESS' >> ~/.vnc/xstartup && \
    echo 'exec /etc/X11/Xsession' >> ~/.vnc/xstartup && \
    echo 'startxfce4 &' >> ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup

# Expose port noVNC (Railway sẽ map PORT env nếu cần)
EXPOSE 8080

# Copy script khởi động
COPY start.sh /home/chromeuser/start.sh
RUN chmod +x /home/chromeuser/start.sh

# CMD chạy script
CMD ["/home/chromeuser/start.sh"]
