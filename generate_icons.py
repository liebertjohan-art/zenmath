from PIL import Image
import os

sizes = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
}

base_dir = '/root/Desktop/flutter-test/zenmath/android/app/src/main/res'
image_path = '/root/.gemini/antigravity-cli/brain/40bdf2c4-3ab2-4738-9f14-3761557cf2a4/zenmath_logo_1786462634747.jpg'

try:
    img = Image.open(image_path)
    # Convert to RGBA to ensure png compatibility if needed
    img = img.convert("RGBA")
    
    for mipmap, size in sizes.items():
        out_dir = os.path.join(base_dir, mipmap)
        os.makedirs(out_dir, exist_ok=True)
        
        resized = img.resize((size, size), Image.Resampling.LANCZOS)
        out_path = os.path.join(out_dir, 'ic_launcher.png')
        resized.save(out_path, 'PNG')
        print(f"Generated {out_path}")
        
except Exception as e:
    print(f"Error: {e}")
