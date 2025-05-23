FROM ubuntu:24.04

# Fork of https://github.com/robingenz/docker-ionic-capacitor - thanks Robin!
LABEL MAINTAINER="Juian Scheuchenzuber <js@lvl51.de>"

ARG JAVA_VERSION=21
ARG NODEJS_VERSION=20

# See https://developer.android.com/studio/index.html#command-tools
ARG ANDROID_SDK_VERSION=11076708

# See https://developer.android.com/tools/releases/build-tools
ARG ANDROID_BUILD_TOOLS_VERSION=35.0.0

# See https://developer.android.com/studio/releases/platforms
ARG ANDROID_PLATFORMS_VERSION=35

# See https://gradle.org/releases/
ARG GRADLE_VERSION=8.11.1

# See https://www.npmjs.com/package/@ionic/cli
ARG IONIC_VERSION=7.2.1

# See https://www.npmjs.com/package/@capacitor/cli
ARG CAPACITOR_VERSION=7.2.0

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

WORKDIR /tmp

RUN apt-get update -q

# General packages
RUN apt-get install -qy \
    apt-utils \
    locales \
    gnupg2 \
    build-essential \
    curl \
    usbutils \
    git \
    unzip \
    p7zip p7zip-full \
    python3 \
    ruby-full \
    openjdk-${JAVA_VERSION}-jre \
    openjdk-${JAVA_VERSION}-jdk

# Set locale
RUN locale-gen en_US.UTF-8 && update-locale

# Install Gradle
RUN mkdir -p /opt/gradle \
    && curl -fsSL https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip -o gradle.zip \
    && unzip -d /opt/gradle/ gradle.zip \
    && mv gradle.zip /opt/gradle/gradle-${GRADLE_VERSION}-all.zip

# Ensure Gradle is executable
ENV GRADLE_HOME=/opt/gradle/gradle-${GRADLE_VERSION}
RUN chmod +x ${GRADLE_HOME}/bin/gradle

# Verify installation
ENV PATH=$PATH:$GRADLE_HOME/bin
RUN gradle --version

# Install Android SDK tools
ENV ANDROID_HOME=/opt/android-sdk
RUN curl -sL https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip -o commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip \
    && unzip commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip \
    && mkdir $ANDROID_HOME && mv cmdline-tools $ANDROID_HOME \
    && yes | $ANDROID_HOME/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME --licenses \
    && $ANDROID_HOME/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME "platform-tools" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" "platforms;android-${ANDROID_PLATFORMS_VERSION}"
ENV PATH=$PATH:${ANDROID_HOME}/cmdline-tools:${ANDROID_HOME}/platform-tools

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | bash - \
    && apt-get update -q && apt-get install -qy nodejs
ENV NPM_CONFIG_PREFIX=${HOME}/.npm-global
ENV PATH=$PATH:${HOME}/.npm-global/bin

# Install Ionic CLI and Capacitor CLI
RUN npm install -g @ionic/cli@${IONIC_VERSION} \
    && npm install -g @capacitor/cli@${CAPACITOR_VERSION}Y

# Install gems for fastlane usage
RUN gem install rake && \
    gem install bundler

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

WORKDIR /workdir
