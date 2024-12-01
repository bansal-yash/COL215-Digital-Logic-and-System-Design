from PIL import Image
import numpy as np

img = Image.open("input.png")
img_array = np.array(img, dtype=np.int16)
a, b = img_array.shape

ans = np.zeros((a, b), dtype=np.uint8)

for i in range(a):
    for j in range(b):
        if j == 0 or j == b - 1:
            ans[i][j] = 0
        else:
            c = img_array[i][j + 1] - img_array[i][j]
            ans[i][j] = max(0, min(255, abs(c)))

final_img = Image.fromarray(ans, 'L')
final_img.save('output.png', 'PNG')