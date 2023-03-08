import os


cwd = os.getcwd() 
diffuse = os.path.join(cwd, "diffuse2")
alpha = os.path.join(cwd, "alpha2")
overlay = os.path.join(cwd, "overlay2")

diffuse_array = []
alpha_array = []

if os.path.exists(diffuse):

    for file in os.listdir(diffuse):
        if file.endswith(".png") or file.endswith(".jpg"):
            diffuse_array.append(file)

if os.path.exists(alpha):
    for file in os.listdir(alpha):
        if file.endswith(".png") or file.endswith(".jpg"):
            alpha_array.append(file)


#Zip the two lists together, and create a dictionary out of the zipped lists
mapping = tuple(zip(diffuse_array, alpha_array))
for j,i in enumerate(mapping):
    new_img_path = os.path.join(overlay, f"test_{j}.png")
    diffuse_img_path = os.path.join(diffuse, f"{i[0]}")
    alpha_img_path = os.path.join(alpha, f"{i[1]}")
    os.system(f"magick composite -gravity center  {alpha_img_path} {diffuse_img_path} {new_img_path}" )
 
