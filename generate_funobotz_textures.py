import os
from PIL import Image, ImageDraw, ImageFont

OUT_DIR = r"E:\funobotz\game\assets\textures\funobotz"
os.makedirs(OUT_DIR, exist_ok=True)

def create_logo_texture():
    # 512x256 logo texture with crisp white background and FUNOBOTZ branding
    img = Image.new("RGBA", (512, 256), (248, 248, 246, 255))
    draw = ImageDraw.Draw(img)
    
    # Outer thin border
    draw.rectangle([4, 4, 507, 251], outline=(220, 160, 40, 255), width=4)
    draw.rectangle([12, 12, 499, 243], outline=(235, 235, 230, 255), width=2)
    
    # Draw "FUNOBOTZ" text
    # Try standard font or fallback to drawn geometric letters
    try:
        font_large = ImageFont.truetype("arialbd.ttf", 68)
        font_sub = ImageFont.truetype("arial.ttf", 22)
    except:
        font_large = ImageFont.load_default()
        font_sub = ImageFont.load_default()

    # Draw "FUN" in dark slate
    draw.text((45, 75), "FUN", fill=(30, 35, 45, 255), font=font_large)
    
    # Draw "O" in iconic orange box
    draw.rectangle([205, 68, 275, 148], fill=(245, 145, 25, 255), outline=(210, 110, 15, 255), width=3)
    draw.ellipse([223, 86, 257, 130], fill=(248, 248, 246, 255))
    draw.ellipse([233, 98, 247, 118], fill=(245, 145, 25, 255))
    
    # Draw "BOTZ" in dark slate
    draw.text((290, 75), "BOTZ", fill=(30, 35, 45, 255), font=font_large)
    
    # Subtitle
    draw.text((150, 175), "DISCOVERY WORLD", fill=(140, 140, 145, 255), font=font_sub)
    
    path = os.path.join(OUT_DIR, "funobotz_logo.png")
    img.save(path)
    print("Saved:", path)

def create_petalo_face():
    # 512x512 circular face
    img = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Outer dark chocolate brown disc
    draw.ellipse([20, 20, 492, 492], fill=(62, 38, 28, 255), outline=(235, 170, 30, 255), width=12)
    
    # Inner face circle
    draw.ellipse([45, 45, 467, 467], fill=(74, 45, 34, 255))
    
    # Cheerful big curved white smile
    draw.arc([130, 190, 382, 390], start=20, end=160, fill=(255, 255, 255, 255), width=18)
    
    # Smile end dots
    draw.ellipse([135, 245, 160, 270], fill=(255, 255, 255, 255))
    draw.ellipse([352, 245, 377, 270], fill=(255, 255, 255, 255))
    
    # White cheek blush circles
    draw.ellipse([95, 250, 135, 290], fill=(255, 210, 120, 220))
    draw.ellipse([377, 250, 417, 290], fill=(255, 210, 120, 220))
    
    # Cute eyes
    draw.ellipse([160, 150, 205, 205], fill=(255, 255, 255, 255))
    draw.ellipse([175, 160, 198, 195], fill=(30, 20, 15, 255))
    draw.ellipse([178, 163, 186, 173], fill=(255, 255, 255, 255)) # highlight
    
    draw.ellipse([307, 150, 352, 205], fill=(255, 255, 255, 255))
    draw.ellipse([314, 160, 337, 195], fill=(30, 20, 15, 255))
    draw.ellipse([317, 163, 325, 173], fill=(255, 255, 255, 255)) # highlight
    
    path = os.path.join(OUT_DIR, "petalo_face.png")
    img.save(path)
    print("Saved:", path)

def create_quacky_face():
    # 512x512 clean white panel with duck eyes and beak highlight
    img = Image.new("RGBA", (512, 512), (250, 250, 246, 255))
    draw = ImageDraw.Draw(img)
    
    # Subtle geometric origami facet lines
    draw.line([0, 0, 256, 120], fill=(225, 225, 220, 255), width=3)
    draw.line([512, 0, 256, 120], fill=(225, 225, 220, 255), width=3)
    draw.line([256, 120, 256, 512], fill=(225, 225, 220, 255), width=3)
    
    # Black dot eyes with highlights
    # Left eye
    draw.ellipse([90, 180, 150, 240], fill=(25, 25, 30, 255))
    draw.ellipse([100, 190, 115, 205], fill=(255, 255, 255, 255))
    
    # Right eye
    draw.ellipse([362, 180, 422, 240], fill=(25, 25, 30, 255))
    draw.ellipse([372, 190, 387, 205], fill=(255, 255, 255, 255))
    
    # Orange beak tip on lower center
    draw.polygon([(256, 260), (210, 380), (302, 380)], fill=(250, 140, 20, 255), outline=(210, 110, 10, 255))
    
    path = os.path.join(OUT_DIR, "quacky_face.png")
    img.save(path)
    print("Saved:", path)

def create_tolly_face():
    # 512x512 white cube face with friendly face
    img = Image.new("RGBA", (512, 512), (248, 248, 246, 255))
    draw = ImageDraw.Draw(img)
    
    # Orange outer corner accents (like papercraft folded tabs)
    draw.rectangle([10, 10, 502, 502], outline=(235, 150, 30, 255), width=6)
    
    # Dot eyes
    draw.ellipse([150, 190, 195, 235], fill=(30, 30, 35, 255))
    draw.ellipse([156, 196, 168, 208], fill=(255, 255, 255, 255))
    
    draw.ellipse([317, 190, 362, 235], fill=(30, 30, 35, 255))
    draw.ellipse([323, 196, 335, 208], fill=(255, 255, 255, 255))
    
    # Smile
    draw.arc([190, 250, 322, 340], start=15, end=165, fill=(30, 30, 35, 255), width=10)
    
    # Micro branding "TOLLY"
    try:
        f_sub = ImageFont.truetype("arialbd.ttf", 26)
    except:
        f_sub = ImageFont.load_default()
    draw.text((215, 385), "TOLLY", fill=(210, 130, 20, 255), font=f_sub)
    
    path = os.path.join(OUT_DIR, "tolly_face.png")
    img.save(path)
    print("Saved:", path)

def create_tolly_lights():
    # 512x512 cube side with green and red tollgate indicator lights
    img = Image.new("RGBA", (512, 512), (245, 245, 242, 255))
    draw = ImageDraw.Draw(img)
    
    draw.rectangle([10, 10, 502, 502], outline=(220, 140, 25, 255), width=5)
    
    # Top indicator: Red LED light
    draw.ellipse([216, 80, 296, 160], fill=(240, 45, 45, 255), outline=(180, 20, 20, 255), width=6)
    draw.ellipse([230, 94, 250, 114], fill=(255, 180, 180, 255))
    
    # Bottom indicator: Green LED light
    draw.ellipse([216, 240, 296, 320], fill=(40, 215, 75, 255), outline=(20, 150, 45, 255), width=6)
    draw.ellipse([230, 254, 250, 274], fill=(180, 255, 195, 255))
    
    try:
        f_sub = ImageFont.truetype("arialbd.ttf", 22)
    except:
        f_sub = ImageFont.load_default()
    draw.text((180, 400), "ACCESS STATUS", fill=(120, 120, 125, 255), font=f_sub)
    
    path = os.path.join(OUT_DIR, "tolly_lights.png")
    img.save(path)
    print("Saved:", path)

def create_tiko_truss():
    # 512x512 mechanical truss lattice pattern with FUNOBOTZ branding
    img = Image.new("RGBA", (512, 512), (248, 248, 246, 255))
    draw = ImageDraw.Draw(img)
    
    # Border
    draw.rectangle([8, 8, 504, 504], outline=(225, 145, 25, 255), width=6)
    
    # Triangular structural truss diagonals
    for i in range(0, 512, 96):
        draw.line([i, 0, i + 96, 512], fill=(215, 215, 210, 255), width=4)
        draw.line([i + 96, 0, i, 512], fill=(215, 215, 210, 255), width=4)
    
    # Gold/orange joint rivets
    for x in range(48, 512, 96):
        for y in range(48, 512, 96):
            draw.ellipse([x-8, y-8, x+8, y+8], fill=(240, 150, 25, 255), outline=(180, 100, 15, 255), width=2)
            
    # Center logo box
    draw.rectangle([80, 210, 432, 302], fill=(252, 252, 250, 255), outline=(225, 145, 25, 255), width=4)
    try:
        f_logo = ImageFont.truetype("arialbd.ttf", 44)
    except:
        f_logo = ImageFont.load_default()
    draw.text((105, 230), "FUNOBOTZ", fill=(35, 40, 50, 255), font=f_logo)
    
    path = os.path.join(OUT_DIR, "tiko_truss.png")
    img.save(path)
    print("Saved:", path)

if __name__ == "__main__":
    create_logo_texture()
    create_petalo_face()
    create_quacky_face()
    create_tolly_face()
    create_tolly_lights()
    create_tiko_truss()
    print("All Funobotz custom textures generated successfully!")
