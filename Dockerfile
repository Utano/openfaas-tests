FROM debian
# 1. Use any image as your base image, or "scratch"
# 2. Add fwatchdog binary via https://github.com/openfaas/faas/releases/
# 3. Then set fprocess to the process you want to invoke per request - i.e. "cat" or "my_binary"

COPY img2ascii /usr/bin/
RUN apt-get -qq update \
    && apt-get -qq install curl imagemagick jp2a \
    && echo "Pulling watchdog binary from Github." \
    && curl -sSL https://github.com/openfaas/faas/releases/download/0.7.3/fwatchdog > /usr/bin/fwatchdog \
    && chmod +x /usr/bin/fwatchdog \
    && chmod +x /usr/bin/img2ascii

# Populate example here - i.e. "cat", "sha512sum" or "node index.js"
ENV fprocess="img2ascii"

# Set to true to see request in function logs
ENV write_debug="false"

HEALTHCHECK --interval=5s CMD [ -e /tmp/.lock ] || exit 1
CMD [ "fwatchdog" ]