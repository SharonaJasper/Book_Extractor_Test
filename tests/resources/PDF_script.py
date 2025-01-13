import sys
import os
from PIL import Image

def images_to_pdf(folder_path, output_pdf_path):
    image_files = [f for f in os.listdir(folder_path) if f.endswith('.png')]
    image_files.sort()
    image_list = [Image.open(os.path.join(folder_path, f)).convert("RGB") for f in image_files]

    if image_list:
        image_list[0].save(output_pdf_path, save_all=True, append_images=image_list[1:])
        print(f"PDF created successfully: {output_pdf_path}")
    else:
        print("No PNG files found in the specified folder.")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python images_to_pdf.py <folder_path> <output_pdf_path>")
        sys.exit(1)

    folder_path = sys.argv[1]
    output_pdf_path = sys.argv[2]
    images_to_pdf(folder_path, output_pdf_path)
