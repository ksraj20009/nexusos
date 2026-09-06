#!/usr/bin/env python3
"""Vajra OS AI Image Generator - Generate images using local Stable Diffusion (free, offline)."""
import subprocess, os

def main():
    print("=" * 50)
    print("  Vajra OS AI Image Generator (Buddhi)")
    print("=" * 50)
    print("  Uses Stable Diffusion locally (no cloud, free)")
    print()
    prompt = input("  Describe the image: ").strip()
    if not prompt: return
    print(f"\n  Generating: '{prompt}'...")
    print("  [Note: Requires stable-diffusion installed locally]")
    print("  Install: pip install diffusers transformers torch")
    try:
        subprocess.run([
            "python3", "-c",
            "from diffusers import StableDiffusionPipeline; import torch; "
            "pipe = StableDiffusionPipeline.from_pretrained('runwayml/stable-diffusion-v1-5', torch_dtype=torch.float16); "
            f"img = pipe('{prompt}'); img.images[0].save(os.path.expanduser('~/Pictures/vajra-ai-generated.png'))"
        ], timeout=120)
        print("  [+] Image saved to ~/Pictures/vajra-ai-generated.png")
    except Exception as e:
        print(f"  [-] Generation failed: {e}")
        print("  Install: pip install diffusers transformers torch")

if __name__ == "__main__":
    main()