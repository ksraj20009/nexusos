#!/bin/bash
# Vajra OS — Smart Download Manager
# Every download/install shows: app info, pros, cons, then asks user.
# Nothing installs without explicit user confirmation.

APP_DB="/opt/vajra/download-manager/app-info.db"
mkdir -p /opt/vajra/download-manager

# Initialize app database if not exists
if [ ! -f "$APP_DB" ]; then
    cat > "$APP_DB" << 'DBEOF'
# Format: package|name|description|pros|cons|size|category|permissions
firefox-esr|Firefox ESR Browser|Privacy-focused web browser, Extended Support Release|Privacy hardened;Open source;Customizable;Vast extension library;Built-in tracking protection|Can be heavy on RAM (~500MB);Some sites break with strict tracking protection;~350MB installed|350MB|Web Browser|Network access;File system read/write
thunderbird|Thunderbird Mail|Email client with calendar, RSS, and chat|Open source;Excellent privacy;Built-in encryption;Vast addon support;Multi-account support|UI feels dated;Heavy on RAM (~300MB);Setup can be complex for new users|250MB|Email Client|Network access;Contacts read;File system read/write
vlc|VLC Media Player|Plays any video or audio format|Plays literally everything;Lightweight (~100MB);No ads;Free and open source;Streaming support;Subtitle support;Screen recording|Minimal UI;Some advanced features hidden;Cannot edit video|100MB|Media Player|File system read;Network access (for streaming)
libreoffice|LibreOffice Suite|Word processor, spreadsheet, presentations|Full office suite;Free and open source;Opens Microsoft formats;Lightweight;No telemetry;Powerful macros|UI not as polished as MS Office;Some complex Excel formulas don't convert perfectly;~500MB|600MB|Office Suite|File system read/write;Printer access
gimp|GIMP Image Editor|Professional photo and image editing|Powerful editing;Free and open source;Supports layers, masks, filters;Plugin ecosystem;Handles PSD files|Steep learning curve;UI different from Photoshop;Some pro features missing (CMYK);~300MB|300MB|Image Editor|File system read/write
obs-studio|OBS Studio|Screen recording and live streaming|Professional quality;Free and open source;Multi-scene support;Streaming to YouTube/Twitch;No watermarks;Plugin support|Complex setup;Can be CPU intensive;~250MB|250MB|Screen Recorder|Screen capture;Audio capture;Network access (for streaming)
blender|Blender 3D|3D modeling, animation, rendering|Professional 3D suite;Free and open source;Video editing built-in;Huge community;GPU rendering;Game engine|Very steep learning curve;Requires good GPU;~500MB;Can be overwhelming|500MB|3D Editor|File system read/write;GPU access
audacity|Audacity Audio Editor|Record and edit audio|Simple and powerful;Free and open source;Multi-track editing;Noise reduction;Podcast friendly;Export to MP3/WAV/FLAC|UI is basic;No native MIDI support;Real-time effects limited;~100MB|100MB|Audio Editor|Audio capture;File system read/write
code|Visual Studio Code|Code editor with extensions|Lightweight;Huge extension marketplace;Integrated terminal;Git integration;Debugging;AI assistance (Copilot)|Microsoft telemetry (can be disabled);Some extensions are heavy;Electron-based (RAM usage)|200MB|Code Editor|File system read/write;Network access;Terminal access
git|Git Version Control|Track changes in code and files|Industry standard;Fast and reliable;Branching and merging;Offline capable;Free and open source|Command line can be confusing;Large repos are slow;Learning curve for advanced features|50MB|Developer Tool|File system read/write
docker.io|Docker Container Engine|Run apps in isolated containers|App isolation;Consistent environments;Easy deployment;Huge image registry;Microservices friendly|Uses significant RAM (~1GB idle);Large images;Security considerations;~500MB|500MB|Developer Tool|Network access;File system access;Root privileges
torbrowser-launcher|Tor Browser|Anonymous web browsing|Maximum anonymity;Access .onion sites;Bypasses censorship;No tracking;Free|Slow browsing (5-10x);Many sites block Tor;Streaming doesn't work;CAPTCHAs frequent;~200MB|200MB|Web Browser|Network access (Tor)
gnome-terminal|GNOME Terminal|Default terminal emulator|Reliable;Customizable;Tabbed interface;Integrated with GNOME;Free|Basic features;No split panes by default;~10MB|10MB|Terminal|Terminal access
htop|System Monitor (htop)|Real-time system resource monitor|Lightweight;Colorful and clear;Kill processes;Tree view;Free|Read-only;No disk monitoring;~2MB|2MB|System Tool|Process list read
neovim|Neovim Text Editor|Modern Vim-based text editor|Fast;Highly customizable;Lua scripting;LSP support;Git integration|Learning curve (Vim keys);Not for beginners;~30MB|30MB|Text Editor|File system read/write
inkscape|Inkscape Vector Editor|SVG and vector graphics editing|Professional vector editor;Free and open source;Opens SVG/AI/EPS;Layers and paths;Good for logos|Complex UI;Performance with large files;~250MB|250MB|Image Editor|File system read/write
kdenlive|Kdenlive Video Editor|Non-linear video editing|Professional features;Free and open source;Multi-track;Effects and transitions;4K support|Can crash on complex projects;Rendering is slow;~300MB|300MB|Video Editor|File system read/write;GPU access
qbittorrent|qBittorrent|BitTorrent client|No ads;Free and open source;Built-in search;RSS support;Bandwidth scheduling|Legal risks if downloading copyrighted material;ISP may throttle;~50MB|50MB|Download Tool|Network access;File system read/write
steam|Steam Gaming|Game store and launcher|Huge game library;Cloud saves;Auto-updates;Proton for Linux gaming|DRM (you don't own games);Heavy on RAM (~500MB);Store has tracking;~1GB|1000MB|Gaming|Network access;File system read/write;GPU access
spotify|Spotify Music|Music streaming|Huge library;Discovery features;Playlists;Podcasts;Offline mode|Ads in free version;Telemetry/tracking;Requires account;~200MB|200MB|Music|Network access;Audio playback;Usage tracking
discord|Discord Chat|Voice and text chat|Great for communities;Screen sharing;Free voice chat;Bot support|Telemetry/tracking;Electron (RAM ~300MB);Requires account;~200MB|200MB|Communication|Network access;Audio capture;Usage tracking
DBEOF
fi

show_app_info() {
    local pkg="$1"
    echo ""
    echo "  ============================================"
    echo "   APP INFORMATION"
    echo "  ============================================"
    echo "  Package: $pkg"

    local line=$(grep -i "^${pkg}|" "$APP_DB" 2>/dev/null | head -1)
    if [ -z "$line" ]; then
        echo "  Status:   Not in Vajra database"
        echo "  Info:     Unknown - check the web for details"
        echo "  Size:     Unknown"
        echo "  Pros:     Unknown (no data available)"
        echo "  Cons:     Unknown (no data available)"
        echo "  Permissions: Unknown - proceed with caution"
        echo ""
        echo "  WARNING: This app is not in Vajra's database."
        echo "  We cannot show pros/cons for it."
        echo "  Only install if you trust the source."
    else
        IFS='|' read -r pname desc pros cons size category perms <<< "$line"
        echo "  Name:     $pname"
        echo "  Category: $category"
        echo "  Description: $desc"
        echo "  Download Size: $size"
        echo ""
        echo "  PROS:"
        echo "$pros" | tr ';' '\n' | while read -r p; do [ -n "$p" ] && echo "    + $p"; done
        echo ""
        echo "  CONS:"
        echo "$cons" | tr ';' '\n' | while read -r c; do [ -n "$c" ] && echo "    - $c"; done
        echo ""
        echo "  PERMISSIONS REQUIRED:"
        echo "$perms" | tr ';' '\n' | while read -r perm; do [ -n "$perm" ] && echo "    * $perm"; done
    fi
    echo ""
}

ask_install_confirmation() {
    local pkg="$1"
    echo "  Do you want to download and install $pkg?"
    echo ""
    echo "    [1] YES - Install it now"
    echo "    [2] NO  - Cancel"
    echo "    [3] INFO - Show more information first"
    echo "    [4] ALT - Search for alternatives"
    echo ""
    read -p "  Your choice (1/2/3/4): " choice
    case "$choice" in
        1)
            echo "  Starting download of $pkg..."
            sudo apt-get install -y "$pkg" 2>/dev/null
            if [ $? -eq 0 ]; then echo "  SUCCESS: $pkg installed!"; else echo "  FAILED: Installation of $pkg failed."; fi
            ;;
        2) echo "  Cancelled. $pkg was NOT installed." ;;
        3) apt-cache show "$pkg" 2>/dev/null | head -30; read -p "  Install now? (yes/no): " confirm; [ "$confirm" = "yes" ] && sudo apt-get install -y "$pkg" 2>/dev/null ;;
        4) apt-cache search "$pkg" 2>/dev/null | head -10; read -p "  Install which? " alt; [ -n "$alt" ] && vajra-download install "$alt" ;;
        *) echo "  Invalid choice. Cancelled." ;;
    esac
}

show_remove_confirmation() {
    local pkg="$1"
    echo ""
    echo "  WARNING: UNINSTALL $pkg"
    echo "  This will remove the application and free up disk space."
    echo "  Your personal files will NOT be deleted, but settings will be lost."
    echo ""
    read -p "  Remove $pkg? (yes/no): " confirm
    if [ "$confirm" = "yes" ] || [ "$confirm" = "y" ]; then
        read -p "  Also remove config files? (yes/no): " purge
        if [ "$purge" = "yes" ]; then sudo apt-get purge -y "$pkg" 2>/dev/null; echo "  Removed $pkg (with config)."
        else sudo apt-get remove -y "$pkg" 2>/dev/null; echo "  Removed $pkg (config kept)."; fi
    else echo "  Cancelled."; fi
}

case "${1:-help}" in
    install|get)
        PKG="$2"; [ -z "$PKG" ] && echo "  Usage: vajra-download install <package>" && exit 1
        show_app_info "$PKG"; ask_install_confirmation "$PKG"
        ;;
    remove|uninstall)
        PKG="$2"; [ -z "$PKG" ] && echo "  Usage: vajra-download remove <package>" && exit 1
        show_remove_confirmation "$PKG"
        ;;
    info)
        PKG="$2"; [ -z "$PKG" ] && echo "  Usage: vajra-download info <package>" && exit 1
        show_app_info "$PKG"
        ;;
    search)
        QUERY="$2"; [ -z "$QUERY" ] && echo "  Usage: vajra-download search <keyword>" && exit 1
        echo "  Searching for: $QUERY"; apt-cache search "$QUERY" 2>/dev/null | head -20
        ;;
    list)
        echo "  Apps in Vajra database:"
        grep -v "^#" "$APP_DB" | while IFS='|' read -r pkg name desc pros cons size cat perms; do echo "    $pkg - $name ($size)"; done
        ;;
    update)
        echo "  This will update ALL installed packages."
        echo "  Pros: Security fixes, bug fixes, new features, better performance"
        echo "  Cons: May break working setup (rare), uses bandwidth, some apps change UI"
        echo ""
        read -p "  Run system update now? (yes/no): " confirm
        [ "$confirm" = "yes" ] && sudo apt-get update && sudo apt-get upgrade -y || echo "  Cancelled."
        ;;
    browse)
        echo "  Vajra App Browser - Categories:"
        echo "    1.Web Browsers  2.Email  3.Media Players  4.Office  5.Image Editors"
        echo "    6.Video Editors  7.Audio  8.Code Editors  9.Dev Tools  10.Gaming"
        echo "    11.Communication  12.System Tools"
        read -p "  Choose category (1-12): " cat
        case "$cat" in
            1) vajra-download info firefox-esr ;; 2) vajra-download info thunderbird ;;
            3) vajra-download info vlc ;; 4) vajra-download info libreoffice ;;
            5) vajra-download info gimp ;; 6) vajra-download info kdenlive ;;
            7) vajra-download info audacity ;; 8) vajra-download info code ;;
            9) vajra-download info git ;; 10) vajra-download info steam ;;
            11) vajra-download info discord ;; 12) vajra-download info htop ;;
        esac
        ;;
    help|*)
        echo "  Vajra OS - Smart Download Manager"
        echo "  Commands:"
        echo "    vajra-download install <pkg>  - Show info + pros/cons + ask before install"
        echo "    vajra-download remove <pkg>  - Show warning + ask before uninstall"
        echo "    vajra-download info <pkg>    - Show app info, pros, cons, permissions"
        echo "    vajra-download search <term> - Search for packages"
        echo "    vajra-download list         - List all apps in Vajra database"
        echo "    vajra-download browse       - Browse apps by category"
        echo "    vajra-download update       - Show update pros/cons + ask before updating"
        echo ""
        echo "  Every action asks for your confirmation first."
        ;;
esac
