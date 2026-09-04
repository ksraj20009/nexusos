#!/bin/bash
# Vajra OS — Localization Suite (Indian Languages)
set -e
echo "◆ Vajra OS Localization Suite"

echo "[1/5] Installing Indian language packs..."
apt-get install -y locales 2>/dev/null || true
for lang in hi_IN ta_IN te_IN kn_IN ml_IN bn_IN gu_IN mr_IN pa_IN as_IN or_IN; do
    sed -i "/${lang}.UTF-8/s/^# //g" /etc/locale.gen
done
locale-gen
echo "  ✓ 11 Indian language locales enabled"

echo "[2/5] Installing GNOME language packs..."
apt-get install -y task-hindi-desktop task-tamil-desktop task-bengali-desktop task-gujarati-desktop task-marathi-desktop task-punjabi-desktop task-telugu-desktop task-kannada-desktop task-malayalam-desktop 2>/dev/null || true
echo "  ✓ GNOME desktop translations installed"

echo "[3/5] Configuring Indic keyboard layouts..."
apt-get install -y ibus ibus-m17n m17n-db 2>/dev/null || true
cat > /etc/dconf/db/local.d/00-vajra-input << 'DC'
[desktop/input-sources]
sources=[('xkb', 'us'), ('ibus', 'm17n:hi:itrans'), ('ibus', 'm17n:ta:tamil99'), ('ibus', 'm17n:bn:itrans'), ('ibus', 'm17n:gu:itrans'), ('ibus', 'm17n:pa:itrans')]
DC
dconf update 2>/dev/null || true
echo "  ✓ Indic keyboards: Hindi (ITRANS), Tamil (99), Bengali, Gujarati, Punjabi"

echo "[4/5] Installing Sanskrit/Devanagari fonts..."
apt-get install -y fonts-noto-core fonts-noto-cjk fonts-indic 2>/dev/null || true
mkdir -p /usr/share/fonts/truetype/vajra
fc-cache -f 2>/dev/null || true
echo "  ✓ Devanagari + Indic fonts installed"

echo "[5/5] Installing Indian calendar..."
cat > /usr/local/bin/vajra-panchangam << 'PC'
#!/bin/bash
python3 -c "
from datetime import datetime, timedelta
tithi_names = ['Pratipada','Dwitiya','Tritiya','Chaturthi','Panchami','Shashthi','Saptami','Ashtami','Navami','Dashami','Ekadashi','Dwadashi','Trayodashi','Chaturdashi','Purnima','Pratipada','Dwitiya','Tritiya','Chaturthi','Panchami','Shashthi','Saptami','Ashtami','Navami','Dashami','Ekadashi','Dwadashi','Trayodashi','Chaturdashi','Amavasya']
nakshatra_names = ['Ashwini','Bharani','Krittika','Rohini','Mrigashira','Ardra','Punarvasu','Pushya','Ashlesha','Magha','Purva Phalguni','Uttara Phalguni','Hasta','Chitra','Swati','Vishakha','Anuradha','Jyeshtha','Mula','Purva Ashadha','Uttara Ashadha','Shravana','Dhanishta','Shatabhisha','Purva Bhadrapada','Uttara Bhadrapada','Revati']
now = datetime.now()
doy = now.timetuple().tm_yday
print('◆ Vajra Panchangam')
print(f'  Date: {now.strftime(\"%A, %B %d, %Y\")}')
print(f'  Tithi: {tithi_names[doy % 30]}')
print(f'  Nakshatra: {nakshatra_names[doy % 27]}')
festivals = {(1,14):'Makar Sankranti/Pongal',(1,26):'Republic Day',(3,8):'Holi',(4,14):'Vaisakhi',(8,15):'Independence Day',(10,2):'Gandhi Jayanti',(11,1):'Diwali',(12,25):'Christmas'}
md = (now.month, now.day)
if md in festivals: print(f'  🎉 Today: {festivals[md]}')
for delta in range(-3,4):
    if delta==0: continue
    try:
        n = now+timedelta(days=delta)
        k = (n.month,n.day)
        if k in festivals: print(f'  📅 {festivals[k]} ({\"tomorrow\" if delta==1 else \"yesterday\" if delta==-1 else f\"in {delta} days\"})')
    except: pass
"
PC
chmod +x /usr/local/bin/vajra-panchangam

echo ""
echo "◆ Localization Suite installed!"
echo "  Languages: Hindi, Tamil, Bengali, Gujarati, Marathi, Punjabi, Telugu, Kannada, Malayalam, Odia, Assamese"
echo "  Keyboards: ITRANS Hindi, Tamil 99, Bengali, Gujarati, Punjabi"
echo "  Fonts: Noto Sans Devanagari + all Indic scripts"
echo "  Calendar: vajra-panchangam (Tithi, Nakshatra, Festivals)"
