# Vajra OS Web — Vercel Deployment

## Deploy to Vercel

1. Go to [vercel.com](https://vercel.com) and sign in
2. Import the GitHub repo: `ksraj20009/vajra-os`
3. Set the root directory to `web/`
4. Deploy

The site will be live at `https://vajra-os.vercel.app`

## What's Here

- `index.html` — Landing page with download links and feature overview
- `vercel.json` — Vercel config with correct MIME types for APT repo
- `apt-repo/` — APT repository (symlink to ../apt-repo/ in repo root)

## APT Repository URL

After deploying to Vercel, the APT repository will be at:

```
https://vajra-os.vercel.app/apt-repo
```

Use it on any Debian/Ubuntu system:

```bash
curl -fsSL https://vajra-os.vercel.app/apt-repo/vajra-archive-keyring.asc | gpg --dearmor -o /usr/share/keyrings/vajra-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/vajra-archive-keyring.gpg] https://vajra-os.vercel.app/apt-repo vajra main" | sudo tee /etc/apt/sources.list.d/vajra.list
sudo apt update
sudo apt install vajra-core vajra-buddhi-ai vajra-security-center
```
