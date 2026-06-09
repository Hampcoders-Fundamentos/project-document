import os
from PIL import Image

# Configuración
TARGET_DIRS = ["assets/img", "report"] # Carpetas a escanear
MAX_WIDTH = 1200 # Ancho máximo ideal para el PDF de LaTeX
MAX_HEIGHT = 1200
QUALITY = 85 # Calidad de compresión (85 es el sweet spot)

def optimize_image(file_path):
    try:
        with Image.open(file_path) as img:
            orig_width, orig_height = img.size
            updated = False
            
            # Tramo 1: Redimensión si es excesivamente grande
            if orig_height > MAX_HEIGHT:
                ratio = MAX_HEIGHT / float(orig_height)
                new_width = int(float(orig_width) * float(ratio))
                img = img.resize((new_width, MAX_HEIGHT), Image.Resampling.LANCZOS)
                updated = True
                print(f"[RESIZED HEIGHT] {file_path} ({orig_height}px -> {MAX_HEIGHT}px)")
            
            # Tramo 2: Compresión y optimización
            # Guardamos temporalmente para verificar si reduce peso
            orig_size = os.path.getsize(file_path)
            
            # Si es PNG, lo optimizamos como tal, o puedes convertir a JPEG si no hay transparencias
            if file_path.lower().endswith('.png'):
                img.save(file_path, format="PNG", optimize=True)
            else:
                img.save(file_path, format="JPEG", quality=QUALITY, optimize=True)
                
            new_size = os.path.getsize(file_path)
            
            if updated or new_size < orig_size:
                reduction = ((orig_size - new_size) / orig_size) * 100
                print(f"[OPTIMIZED] {file_path} | Reducción: {reduction:.2f}%")
                
    except Exception as e:
        print(f"[ERROR] No se pudo procesar {file_path}: {e}")

def main():
    print("Iniciando agente de optimización de imágenes...")
    extensions = ('.png', '.jpg', '.jpeg')
    
    for target_dir in TARGET_DIRS:
        if not os.path.exists(target_dir):
            continue
        for root, _, files in os.walk(target_dir):
            for file in files:
                if file.lower().endswith(extensions):
                    file_path = os.path.join(root, file)
                    optimize_image(file_path)
    print("¡Optimización completada con éxito!")

if __name__ == "__main__":
    main()