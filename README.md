# OpenWRT Wall Controller Feed

This custom OpenWRT feed provides:
- `webserver`: for device IP configuration
- `gpio-daemon`: for handling GPIO buttons and RGB LEDs with WebSocket support

## How to Use
In your OpenWRT source tree:

1. Add to `feeds.conf`:
   ```
   src-git wallcontroller https://github.com/youruser/openwrt-wallcontroller-feed.git
   ```

2. Update and install:
   ```bash
   ./scripts/feeds update wallcontroller
   ./scripts/feeds install -a -p wallcontroller
   ```

3. Select and build packages:
   ```bash
   make menuconfig  # Choose webserver and gpio-daemon
   make package/webserver/compile
   make package/gpio-daemon/compile
   ```
