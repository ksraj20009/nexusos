#!/usr/bin/env python3
"""
Vajra OS Default Wallpaper Generator
Generates beautiful Vajra-themed wallpapers using PIL/Pillow.
Creates multiple resolutions for different screen sizes.
"""

import os, sys, math, random
from pathlib import Path

try:
    from PIL import Image, ImageDraw, ImageFont, ImageFilter
except ImportError:
    os.system("pip install Pillow")
    from PIL import Image, ImageDraw, ImageFont, ImageFilter

COLORS = {
    "deep_blue": (10, 22, 40), "mid_blue": (26, 47, 78),
    "light_blue": (42, 63, 94), "gold": (255, 215, 0),
    "gold_dark": (184, 134, 11), "white": (232, 232, 232),
    "vajra_purple": (75, 0, 130), "vajra_orange": (255, 140, 0),
}

RESOLUTIONS = [
    (1920, 1080, "1920x1080"), (2560, 1440, "2560x1440"),
    (3840, 2160, "4K"), (1366, 768, "1366x768"),
    (1280, 720, "720p"), (2560, 1080, "ultrawide"),
    (1080, 1920, "mobile-portrait"), (1440, 2560, "mobile-2k"),
]

OUTPUT_DIR = "/usr/share/backgrounds/vajra"

def create_gradient(width, height, color1, color2, direction="vertical"):
    img = Image.new("RGB", (width, height))
    draw = ImageDraw.Draw(img)
    if direction == "vertical":
        for y in range(height):
            ratio = y / height
            r = int(color1[0] + (color2[0] - color1[0]) * ratio)
            g = int(color1[1] + (color2[1] - color1[1]) * ratio)
            b = int(color1[2] + (color2[2] - color1[2]) * ratio)
            draw.line([(0, y), (width, y)], fill=(r, g, b))
    elif direction == "radial":
        cx, cy = width // 2, height // 2
        max_dist = math.sqrt(cx**2 + cy**2)
        for y in range(0, height, 2):
            for x in range(0, width, 2):
                dist = math.sqrt((x - cx)**2 + (y - cy)**2)
                ratio = min(dist / max_dist, 1.0)
                r = int(color1[0] + (color2[0] - color1[0]) * ratio)
                g = int(color1[1] + (color2[1] - color1[1]) * ratio)
                b = int(color1[2] + (color2[2] - color1[2]) * ratio)
                draw.rectangle([x, y, x+1, y+1], fill=(r, g, b))
    return img

def draw_vajra_bolt(draw, cx, cy, size, color):
    points = [
        (cx, cy - size), (cx - size*0.3, cy - size*0.2),
        (cx - size*0.15, cy), (cx - size*0.4, cy + size),
        (cx + size*0.2, cy + size*0.1), (cx + size*0.1, cy - size*0.2),
        (cx + size*0.4, cy - size),
    ]
    draw.polygon(points, fill=color)

def draw_mandala(draw, cx, cy, radius, color, layers=3):
    for layer in range(layers):
        r = radius * (1 - layer * 0.2)
        draw.ellipse([cx-r, cy-r, cx+r, cy+r], outline=color, width=2)
        num_petals = 8 + layer * 4
        for i in range(num_petals):
            angle = 2 * math.pi * i / num_petals
            px = cx + r * 0.7 * math.cos(angle)
            py = cy + r * 0.7 * math.sin(angle)
            petal_r = r * 0.15
            draw.ellipse([px-petal_r, py-petal_r, px+petal_r, py+petal_r], outline=color, width=1)

def add_stars(draw, width, height, count=200):
    random.seed(42)
    for _ in range(count):
        x = random.randint(0, width)
        y = random.randint(0, height)
        brightness = random.randint(30, 100)
        size = random.choice([1, 1, 1, 2])
        draw.ellipse([x-size, y-size, x+size, y+size], fill=(brightness, brightness, brightness+20))

def generate_wallpaper(width, height, name, variant="default"):
    if variant == "default":
        img = create_gradient(width, height, COLORS["deep_blue"], COLORS["mid_blue"], "radial")
        draw = ImageDraw.Draw(img)
        add_stars(draw, width, height, count=150)
        cx, cy = width // 2, height // 2
        mandala_radius = min(width, height) * 0.3
        draw_mandala(draw, cx, cy, mandala_radius, (30, 50, 80), layers=4)
        bolt_size = min(width, height) * 0.12
        draw_vajra_bolt(draw, cx, cy, bolt_size, COLORS["gold"])
        img = img.filter(ImageFilter.GaussianBlur(radius=0.5))
        draw = ImageDraw.Draw(img)
        draw_vajra_bolt(draw, cx, cy, bolt_size, COLORS["gold"])
        try:
            font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", int(height * 0.04))
        except Exception:
            font = ImageFont.load_default()
        draw.text((cx, cy + bolt_size + 30), "VAJRA OS", fill=COLORS["gold"], font=font, anchor="mm")
    elif variant == "sunrise":
        img = create_gradient(width, height, COLORS["vajra_orange"], COLORS["deep_blue"], "vertical")
        draw = ImageDraw.Draw(img)
        cx, cy = width // 2, int(height * 0.6)
        for r in range(int(height*0.3), 0, -3):
            draw.ellipse([cx-r, cy-r, cx+r, cy+r], outline=(255, 200, 50))
        draw_vajra_bolt(draw, cx, int(height*0.3), min(width,height)*0.1, COLORS["white"])
    elif variant == "dark":
        img = Image.new("RGB", (width, height), COLORS["deep_blue"])
        draw = ImageDraw.Draw(img)
        add_stars(draw, width, height, count=300)
        draw_vajra_bolt(draw, int(width*0.85), int(height*0.15), min(width,height)*0.05, (40, 60, 90))
    elif variant == "geometric":
        img = create_gradient(width, height, COLORS["deep_blue"], COLORS["light_blue"], "diagonal")
        draw = ImageDraw.Draw(img)
        block = 80
        for y in range(0, height, block):
            for x in range(0, width, block):
                if (x + y) % (block * 3) == 0:
                    draw.polygon([(x, y), (x+block//2, y+block//2), (x, y+block), (x-block//2, y+block//2)], outline=(40, 60, 90), width=1)
    return img

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    variants = ["default", "sunrise", "dark", "geometric"]
    print("=== Vajra OS Wallpaper Generator ===")
    total = 0
    for width, height, name in RESOLUTIONS:
        for variant in variants:
            print(f"  Generating {name} ({variant})...", end="", flush=True)
            img = generate_wallpaper(width, height, name, variant)
            filepath = os.path.join(OUTPUT_DIR, f"vajra-{variant}-{name}.png")
            img.save(filepath, "PNG")
            print(f" done ({os.path.getsize(filepath)//1024}KB)")
            total += 1
    print(f"\n[+] Generated {total} wallpapers")

if __name__ == "__main__":
    main()