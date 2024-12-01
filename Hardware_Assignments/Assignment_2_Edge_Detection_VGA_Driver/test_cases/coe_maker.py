# from PIL import Image
# import numpy as np

# img = Image.open("input.png")
# img_array = np.array(img)
# a, b = img_array.shape

# coe_file_name = "input.coe"

# with open(coe_file_name, 'w') as coe_file:
#     coe_file.write("memory_initialization_radix=2;\n")
#     coe_file.write("memory_initialization_vector=\n")
#     for i in range(a):
#         for j in range(b):
#             if ( i != a-1 or j != b-1):
#                 coe_file.write( format(img_array[i][j], '08b') + ",\n")
#             else:
#                 coe_file.write( format(img_array[i][j], '08b')+ ";\n")



from PIL import Image, ImageDraw
import numpy as np

# Define the dimensions of the image
width, height = 256, 256

# Create a new image with a white background
img = Image.new("RGB", (width, height), "white")

# Create a drawing context
draw = ImageDraw.Draw(img)

# Draw facial features
# Draw a head (circle)
head_radius = 80
draw.ellipse([(width//2 - head_radius, height//2 - head_radius), (width//2 + head_radius, height//2 + head_radius)], outline="black")

# Draw eyes (circles)
eye_radius = 10
eye_distance = 30
eye_y = height // 2 - 40
draw.ellipse([(width//2 - eye_distance - eye_radius, eye_y - eye_radius), (width//2 - eye_distance + eye_radius, eye_y + eye_radius)], fill="black")
draw.ellipse([(width//2 + eye_distance - eye_radius, eye_y - eye_radius), (width//2 + eye_distance + eye_radius, eye_y + eye_radius)], fill="black")

# Draw nose (triangle)
nose_y = height // 2 - 20
draw.polygon([(width//2, nose_y - 10), (width//2 - 10, nose_y + 10), (width//2 + 10, nose_y + 10)], outline="black")

# Draw mouth (simulate an arc with small line segments)
for i in range(10, 170, 10):
    x1 = width // 2 - 20 + int(30 * np.cos(np.radians(i)))
    y1 = height // 2 + 25 + int(15 * np.sin(np.radians(i)))
    x2 = width // 2 - 20 + int(30 * np.cos(np.radians(i + 10)))
    y2 = height // 2 + 25 + int(15 * np.sin(np.radians(i + 10)))
    draw.line([(x1, y1), (x2, y2)], fill="black")

# Save the image
img.save("face_simulation.png")

img_array = np.array(img)
a, b, _ = img_array.shape
coe_file_name = "face_simulation.coe"

with open(coe_file_name, 'w') as coe_file:
    coe_file.write("memory_initialization_radix=2;\n")
    coe_file.write("memory_initialization_vector=\n")
    for i in range(a):
        for j in range(b):
            pixel_value = img_array[i, j, 0]  # Use the red channel for grayscale representation
            binary_value = format(pixel_value, '08b')  # Convert pixel value to 8-bit binary
            coe_file.write(binary_value)
            if i != a - 1 or j != b - 1:
                coe_file.write(",\n")
            else:
                coe_file.write(";\n")