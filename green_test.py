#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import pandas as pd
from skimage import io, color, img_as_ubyte
import matplotlib.pyplot as plt
import numpy as np
import os

# === CONFIGURATION ===
csv_path = "\\wsl.localhost\CentOS7\root\RESHAPE_clean\REShAPE\images\Processed\Analysis\Image 1 zo-1 donut b&w_Data.csv"        # your CSV file
img_path = "\\wsl.localhost\CentOS7\root\RESHAPE_clean\REShAPE\images\Processed\Segmented Images\Image 1 zo-1 donut b&w_Outlines.tif"   # associated image
out_path = "overlay_check.png"     # output visualization
dot_size = 3                       # radius of the red markers

# === LOAD DATA ===
df = pd.read_csv(csv_path)
img = io.imread(img_path)

# Convert grayscale image to RGB for plotting red points
if img.ndim == 2:
    img_rgb = np.dstack([img, img, img])
else:
    img_rgb = img.copy()

# === PLOT ===
fig, ax = plt.subplots(figsize=(10, 10))
ax.imshow(img_rgb, cmap='gray')

# If coordinates seem flipped, try swapping X/Y order later
ax.scatter(df["X"], df["Y"], s=dot_size, c='red', marker='o')

ax.set_title("Cell centroid overlay")
ax.axis('off')
plt.tight_layout()

plt.savefig(out_path, dpi=300)
plt.show()

print("Saved overlay as {}".format(os.path.abspath(out_path)))

