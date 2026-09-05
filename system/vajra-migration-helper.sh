#!/bin/bash
# Vajra OS — Migration Helper
case "${1:-menu}" in
    menu)
        echo "  Vajra OS - Migration Helper"
        echo "  [1] Windows app equivalents [2] Mac app equivalents"
        echo "  [3] Transfer from Windows [4] Transfer from Mac"
        echo "  [5] Import bookmarks [6] Import email"
        echo "  [7] Keyboard shortcuts [8] Terminal vs CMD/PowerShell"
        read -p "  Choose (1-8): " c
        case "$c" in 1) vajra-migration-helper windows ;; 2) vajra-migration-helper mac ;; 3) vajra-migration-helper transfer-win ;; 4) vajra-migration-helper transfer-mac ;; 5) vajra-migration-helper bookmarks ;; 6) vajra-migration-helper email ;; 7) vajra-migration-helper shortcuts ;; 8) vajra-migration-helper terminal ;; esac
        ;;
    windows)
        echo "  Windows -> Vajra app equivalents:"
        echo "    Edge/Chrome -> Firefox ESR (pre-installed)"
        echo "    MS Office -> LibreOffice (vajra-download install libreoffice)"
        echo "    Photoshop -> GIMP (vajra-download install gimp)"
        echo "    Premiere -> Kdenlive (vajra-download install kdenlive)"
        echo "    WMP/VLC -> VLC (pre-installed)"
        echo "    File Explorer -> Files/Nautilus / vajra-files"
        echo "    Notepad -> vajra-text / Neovim"
        echo "    Task Manager -> vajra-task-manager"
        echo "    CMD/PowerShell -> Terminal (Bash)"
        echo "    Settings -> vajra-settings-* (10 panels)"
        echo "    Windows Defender -> ClamAV + UFW firewall"
        echo "    Steam -> Steam + Proton (vajra-download install steam)"
        echo "    Outlook -> Thunderbird (vajra-download install thunderbird)"
        ;;
    mac)
        echo "  Mac -> Vajra app equivalents:"
        echo "    Safari -> Firefox ESR"
        echo "    Pages/Numbers/Keynote -> LibreOffice Writer/Calc/Impress"
        echo "    Preview -> GIMP / feh"
        echo "    iMovie -> Kdenlive / OBS Studio"
        echo "    Finder -> Files (Nautilus)"
        echo "    TextEdit -> vajra-text / gedit"
        echo "    Terminal (zsh) -> Terminal (bash)"
        echo "    Spotlight -> vajra-spotlight"
        echo "    System Preferences -> vajra-settings-*"
        echo "    FaceTime -> Jitsi Meet / Zoom"
        echo "    Messages -> Signal Desktop / Telegram"
        ;;
    transfer-win)
        echo "  Transfer from Windows:"
        echo "  Method 1 (USB): Copy files to USB on Windows, plug into Vajra OS"
        echo "  Method 2 (Network): sudo apt-get install openssh-server; use WinSCP from Windows"
        echo "  Method 3 (Cloud): Upload to Google Drive, download on Vajra"
        echo "  Transfer: Documents, Photos, Downloads, Desktop, Bookmarks"
        ;;
    transfer-mac)
        echo "  Transfer from Mac:"
        echo "  Method 1 (USB): Copy files to USB via Finder"
        echo "  Method 2 (SSH): Mac > System Settings > Sharing > Remote Login; scp from Vajra"
        echo "  Method 3 (Cloud): Google Drive / Dropbox"
        echo "  Transfer: ~/Documents, ~/Pictures, ~/Downloads, ~/Desktop, Bookmarks"
        ;;
    bookmarks)
        echo "  Import bookmarks:"
        echo "  Chrome: Bookmark Manager > Export to HTML > Firefox > Import from HTML"
        echo "  Firefox: Bookmarks > Manage > Export to HTML > Import on Vajra Firefox"
        ;;
    email)
        echo "  Import email:"
        echo "  Outlook: Export to PST > Install Thunderbird > Import PST"
        echo "  Gmail/Yahoo: Just add account in Thunderbird - emails sync automatically"
        ;;
    shortcuts)
        echo "  Shortcuts: Vajra uses Ctrl (not Cmd). Same as Windows mostly."
        echo "  Ctrl+C/V/X/A = Copy/Paste/Cut/Select All"
        echo "  Ctrl+Alt+T = Open Terminal"
        echo "  Ctrl+Alt+L = Lock screen"
        echo "  Alt+Tab = Switch apps"
        echo "  PrtScn = Screenshot"
        ;;
    terminal)
        echo "  CMD vs Bash:"
        echo "    dir -> ls -la | cd -> cd | del -> rm | copy -> cp | move -> mv"
        echo "    type -> cat | findstr -> grep | ipconfig -> ip addr"
        echo "    tasklist -> ps aux | taskkill -> kill"
        ;;
    help|*) echo "  Run: vajra-migration-helper menu" ;;
esac
