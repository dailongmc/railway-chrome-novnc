FROM ubuntu:24.04

# Install deps + download & install Chrome .deb (tự fix deps)
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl ca-certificates gnupg \
    xfce4 xfce4-goodies xfce4-terminal \
    tigervnc-standalone-server tigervnc-common \
    novnc websockify \
    git unzip \
    fonts-liberation libasound2t64 libatk-bridge2.0-0 libatk1.0-0 libc6 \
    libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgbm1 libgcc-s1 \
    libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 \
    libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 \
    libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 lsb-release \
    xdg-utils \
    && wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb \
    && apt-get install -y /tmp/chrome.deb \
    && rm -f /tmp/chrome.deb \
    && apt-get autoremove -y && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/*

# Tạo user non-root (an toàn cho container)
RUN useradd -m -s /bin/bash chromeuser && \
    mkdir -p /home/chromeuser/.vnc && \
    chown -R chromeuser:chromeuser /home/chromeuser

USER chromeuser
WORKDIR /home/chromeuser

# Cấu hình VNC xstartup cho XFCE
RUN echo '#!/bin/sh' > ~/.vnc/xstartup && \
    echo 'xrdb $HOME/.Xresources' >> ~/.vnc/xstartup && \
    echo 'startxfce4 &' >> ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup

EXPOSE 8080

COPY start.sh /home/chromeuser/start.sh
RUN chmod +x start.sh

CMD ["./start.sh"]
