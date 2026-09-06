#!/bin/bash
# Vajra OS Media Converter (FFmpeg wrapper)
set -e
echo "=== Vajra OS Media Converter ==="
echo "  1. Video to MP4"
echo "  2. Video to MP3 (extract audio)"
echo "  3. Image to PNG"
echo "  4. Image resize"
echo "  5. Video compress"
echo "  6. Batch convert (all in folder)"
echo "  7. Exit"
read -p "Choice: " choice
case "$choice" in
    1) read -p "Input file: " inf; read -p "Output name: " out
       ffmpeg -i "$inf" -c:v libx264 -preset fast "$out.mp4" 2>/dev/null && echo "[+] Converted to $out.mp4" ;;
    2) read -p "Input video: " inf; read -p "Output name: " out
       ffmpeg -i "$inf" -vn -acodec libmp3lame "$out.mp3" 2>/dev/null && echo "[+] Audio extracted to $out.mp3" ;;
    3) read -p "Input image: " inf; read -p "Output name: " out
       ffmpeg -i "$inf" "$out.png" 2>/dev/null && echo "[+] Converted to $out.png" ;;
    4) read -p "Input image: " inf; read -p "Width: " w; read -p "Height: " h
       ffmpeg -i "$inf" -vf "scale=$w:$h" "resized_$(basename "$inf")" 2>/dev/null && echo "[+] Resized" ;;
    5) read -p "Input video: " inf; read -p "Output name: " out
       ffmpeg -i "$inf" -crf 28 -preset slow "$out.mp4" 2>/dev/null && echo "[+] Compressed" ;;
    6) read -p "Folder: " folder; read -p "Format (e.g. mp4): " fmt
       for f in "$folder"/*; do ffmpeg -i "$f" -c:v libx264 "${f%.*}.$fmt" 2>/dev/null; done
       echo "[+] Batch conversion done" ;;
    7) exit 0 ;;
esac