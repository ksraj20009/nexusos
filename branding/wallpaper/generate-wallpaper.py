#!/usr/bin/env python3
"""
Vajra OS Wallpaper Generator
Generates a themed wallpaper with the Vajra (thunderbolt) symbol.
No external images needed — pure Python.
"""
import math, os, struct, zlib

WIDTH, HEIGHT = 1920, 1080
OUTPUT = "/usr/share/backgrounds/vajra/wallpaper.png"

def create_png(width, height, pixels):
    """Create PNG from RGBA pixel data."""
    def chunk(ctype, data):
        c = ctype + data
        return struct.pack('>I', len(data)) + c + struct.pack('>I', zlib.crc32(c) & 0xffffffff)
    
    raw = b''
    for y in range(height):
        raw += b'\x00'
        for x in range(width):
            idx = (y * width + x) * 4
            raw += bytes(pixels[idx:idx+4])
    
    ihdr = struct.pack('>IIBBBBB', width, height, 8, 6, 0, 0, 0)
    png = b'\x89PNG\r\n\x1a\n'
    png += chunk(b'IHDR', ihdr)
    png += chunk(b'IDAT', zlib.compress(raw, 9))
    png += chunk(b'IEND', b'')
    return png

def generate():
    pixels = bytearray(WIDTH * HEIGHT * 4)
    cx, cy = WIDTH // 2, HEIGHT // 2
    
    for y in range(HEIGHT):
        for x in range(WIDTH):
            idx = (y * WIDTH + x) * 4
            t = y / HEIGHT
            r = int(26 + t * 10)
            g = int(26 + t * 5)
            b = int(46 + t * 20)
            
            dx, dy = x - cx, y - cy
            dist = math.sqrt(dx*dx + dy*dy)
            angle = math.atan2(dy, dx)
            
            diamond_dist = abs(dx) / 200 + abs(dy) / 200
            if diamond_dist < 1.0:
                r, g, b = 200, 80, 12
                if diamond_dist < 0.7:
                    r, g, b = 255, 160, 40
            
            for i in range(8):
                a = i * math.pi / 4
                line_angle = angle - a
                if abs(math.sin(line_angle)) < 0.03 and dist < 400:
                    r, g, b = 200, 80, 12
                    if dist < 200:
                        r, g, b = 255, 160, 40
                    break
            
            if 350 < dist < 450:
                glow = 1.0 - abs(dist - 400) / 50
                r = min(255, int(r + 30 * glow))
                g = min(255, int(g + 15 * glow))
                b = min(255, int(b + 5 * glow))
            
            pixels[idx] = r
            pixels[idx+1] = g
            pixels[idx+2] = b
            pixels[idx+3] = 255
    
    os.makedirs(os.path.dirname(OUTPUT), exist_ok=True)
    png_data = create_png(WIDTH, HEIGHT, pixels)
    with open(OUTPUT, 'wb') as f:
        f.write(png_data)
    print(f"Wallpaper generated: {OUTPUT} ({len(png_data)} bytes)")

if __name__ == "__main__":
    generate()
