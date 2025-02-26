# docker-ionic-capacitor

🐳 Docker image for building Ionic apps with Capacitor.

- Java openjdk
- Android Tools
- Gradle
- node.js
- Ionic CLI
- Capacitor CLI
- Linux Goodies: curl, git, unzip, build-essentials, ...
- Ruby (rake + bundler)
- Python

# Usage

Pull from Docker Registry:
`docker pull level51/docker-ionic-capacitor`

---

See `makefile` for building and pushing to Docker Registry.

Available build arguments:  

- JAVA_VERSION
- NODEJS_VERSION
- ANDROID_SDK_VERSION
- ANDROID_BUILD_TOOLS_VERSION
- ANDROID_PLATFORMS_VERSION
- GRADLE_VERSION
- IONIC_VERSION
- CAPACITOR_VERSION

---

Run the image:
```
docker run -it level51/docker-ionic-capacitor bash
```

# Version Table

| Image Version | Java | node.js | Android SDK | Android Build Tools | Android Platforms | Gradle | Ionic | Capacitor |
|---------------|------|---------|-------------|---------------------|-------------------|--------|-------|-----------|
| 1             | 21   | 22      | 11076708    | 35.0.0              | 35                | 8.11.1 | 7.2.0 | 7.0.1     |

# Caveats

If build fail on mac m1/m2 with qemu x84_64 error add '"runArgs": ["--platform=linux/amd64"]' to devcontainer.json in vscode.

# Kudos

...to Robin Genz for coming up with the initial version ✨
