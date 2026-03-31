FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Shanghai
ENV PYTHONUNBUFFERED=1

RUN groupadd -g 1000 nanouser && \
    useradd -u 1000 -g nanouser -m -s /bin/bash nanouser

WORKDIR /app

COPY pyproject.toml README.md LICENSE ./
COPY nanobot/ nanobot/

RUN uv pip install --system --no-cache ".[weixin,wecom]"

RUN chown -R nanouser:nanouser /app

USER nanouser

RUN mkdir -p /home/nanouser/.nanobot

ENTRYPOINT ["nanobot"]
CMD ["gateway"]