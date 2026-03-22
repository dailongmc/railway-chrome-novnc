FROM ubuntu:24.04

# Cài đặt deps cần thiết + tải + install Chrome .deb (tự resolve deps)
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl gnupg ca-certificates \
    xfce4 xfce4-goodies \
    tigervnc-standalone-server tigervnc-common \
    novnc websockify \
    git unzip \
    fonts-liberation libasound2t64 libatk-bridge2.0-0 libatk1.0-0 libc6 \
    libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgbm1 libgcc-s1 \
    libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 \
    libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 \
    libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 lsb-release \
    xdg-utils \
    && wget -q -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y /tmp/google-chrome.deb \
    && rm -f /tmp/google-chrome.deb \
    && apt-get autoremove -y && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* /tmp/*

# Phần còn lại của Dockerfile (user, xstartup, expose, COPY start.sh, CMD) giữ nguyên như bản trước
RUN useradd -m -s /bin/bash chromeuser
USER chromeuser
WORKDIR /home/chromeuser

RUN mkdir -p ~/.vnc && \
    echo "xfce4-session" > ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup

EXPOSE 8080

COPY start.sh /home/chromeuser/start.sh
RUN chmod +x /home/chromeuser/start.sh

CMD ["/home/chromeuser/start.sh"]
