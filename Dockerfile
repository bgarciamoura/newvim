FROM debian:bookworm-slim AS builder

# Evitar interações durante instalações
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo

# Instalar dependências de compilação
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl ca-certificates build-essential cmake pkg-config \
    gettext ninja-build \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Clonar e compilar Neovim
RUN git clone --depth=1 https://github.com/neovim/neovim.git /tmp/neovim && \
    cd /tmp/neovim && \
    make CMAKE_BUILD_TYPE=Release && \
    make install && \
    rm -rf /tmp/neovim

# Estágio final com imagem mínima
FROM debian:bookworm-slim

# Evitar interações durante instalações
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo

# Argumento para definir o repositório GitHub
ARG GITHUB_REPO=bgarciamoura/newvim
ARG GITHUB_BRANCH=main

# Adicionar aliases para terminais
RUN echo 'alias ls="ls --color=auto"' >> /root/.bashrc && \
    echo 'alias ll="ls -alF"' >> /root/.bashrc

# Instalar apenas o necessário para execução
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl ca-certificates python3 python3-venv python3-pip \
    nodejs npm ripgrep fd-find locales procps \
    libxext6 libxrender1 libxtst6 libxi6 xclip \
    libtinfo-dev unzip build-essential \
    && npm install -g n && n lts \
    && hash -r \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /root/.config/nvim

# Configurar ambiente Python isolado para pacotes
RUN mkdir -p /opt/python-env && \
    python3 -m venv /opt/python-env && \
    /opt/python-env/bin/pip install --no-cache-dir basedpyright && \
    ln -s /opt/python-env/bin/basedpyright /usr/local/bin/basedpyright

# Configuração de locale para UTF-8
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Copiar o Neovim do estágio de compilação
COPY --from=builder /usr/local /usr/local

# Instalar ferramentas com menos camadas
RUN npm cache clean --force

# Instalar lua-language-server (pré-compilado)
RUN mkdir -p /tmp/lua-ls && cd /tmp/lua-ls && \
    curl -L https://github.com/LuaLS/lua-language-server/releases/download/3.7.3/lua-language-server-3.7.3-linux-x64.tar.gz | \
    tar xz -C /usr/local && \
    chmod +x /usr/local/bin/lua-language-server && \
    rm -rf /tmp/lua-ls

# Instalar o lazygit
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*') && \
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
    tar xf lazygit.tar.gz lazygit && \
    install lazygit -D -t /usr/local/bin/ && \
    git config --global --add safe.directory /workspace

# Clonar e configurar o Neovim a partir do GitHub
RUN git clone --filter=blob:none --depth 1 -b ${GITHUB_BRANCH} https://github.com/${GITHUB_REPO}.git /tmp/nvim-config && \
    cp -r /tmp/nvim-config/lua /root/.config/nvim/ && \
    cp /tmp/nvim-config/init.lua /root/.config/nvim/ && \
    if [ -f /tmp/nvim-config/.stylua.toml ]; then cp /tmp/nvim-config/.stylua.toml /root/.config/nvim/; fi && \
    rm -rf /tmp/nvim-config

# Configurar volumes persistentes para caches
VOLUME ["/root/.local/share/nvim", "/root/.cache/nvim"]
WORKDIR /workspace
VOLUME ["/workspace"]

# Configurar PATH e comando padrão
ENV PATH="/usr/local/bin:${PATH}"
ENTRYPOINT ["nvim"]
