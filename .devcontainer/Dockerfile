FROM ruby:3.4.9-slim

# Create a non-root user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Install base packages
RUN apt-get update -qq && apt-get install -yq --no-install-recommends \
    curl \
    git \
    gnupg2 \
    build-essential \
    postgresql-client \
    zlib1g-dev \
    liblzma-dev \
    patch \
    libpq-dev \
    openssh-client \
    sudo \
    vim \
    less \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log

# Install Node.js and npm for Tailwind CSS
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Create workspace directory
RUN mkdir -p /workspace && chown $USERNAME:$USERNAME /workspace

# Switch to the non-root user
USER $USERNAME

# Set working directory
WORKDIR /workspace

# Set environment variables
ENV BUNDLE_PATH=/usr/local/bundle
ENV BUNDLE_BIN=/usr/local/bundle/bin
ENV GEM_HOME=/usr/local/bundle
ENV PATH $BUNDLE_BIN:$PATH

# Install bundler
RUN gem install bundler

# Default command
CMD ["sleep", "infinity"]