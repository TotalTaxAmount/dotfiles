import random
import time
import os

time.sleep(2)

dir = f"/home/{os.getlogin()}/.config/hypr/wallpapers/"
max = 0
for path in os.listdir(dir):
    if os.path.isfile(os.path.join(dir, path)):
        max += 1

number = random.randint(1, max)

print(number)
print(f"Wallpaper: {dir}/{number}.jpg")
os.system(f"hyprctl hyprpaper wallpaper eDP-1,{dir}{number}.jpg")