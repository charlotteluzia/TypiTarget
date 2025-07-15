# -*- coding: utf-8 -*-
"""
Created on Sat Apr 12 13:43:44 2025

@author: Charlotte
"""

import os, sys
from PIL import Image

#filename = "C:/Users/User/deepMem/datasets/140_stimuli/bedroom/img_0eflx.png"
#filename = "C:/Users/User/MATLAB/TypiTarget/stimuli_target_non/pexels-andreaedavis-13757468.jpg"
#pexels-arina-krasnikova-6653896.jpg

# image3 = Image.open("C:/Users/User/MATLAB/TypiTarget/stimuli_target_non/demi-kyu-gZPDNM0VfO8-unsplash.jpg")
# image2 = Image.open("C:/Users/User/MATLAB/TypiTarget/stimuli_target_non/pexels-arina-krasnikova-6653896.jpg")
# image = Image.open("C:/Users/User/MATLAB/TypiTarget/stimuli_target_non/pexels-andreaedavis-13757468.jpg")
# image.thumbnail((512, 512))
# image2.thumbnail((512,512))
# image3.thumbnail((512,512))
# image.save('image_thumbnail.jpg')
# print(image.size) # Output: (400, 350)
# new_image = image.resize((512, 512))
# new_image.save('myimage_500.jpg')
# new_image = image3.resize((512, 512))
# new_image.save('myimage3_500.jpg')


# infile = "C:/Users/User/MATLAB/TypiTarget/stimuli_target_non/demi-kyu-gZPDNM0VfO8-unsplash.jpg"
# size = 512, 512

# for infile in sys.argv[1:]:
#     outfile = os.path.splitext(infile)[0] + ".thumbnail"
#     if infile != outfile:
#         try:
#             im = Image.open(infile)
#             im.thumbnail(size, Image.Resampling.LANCZOS)
#             im.save(outfile, "JPEG")
#         except IOError:
#             print ("cannot create thumbnail for '%s'", infile)
            


def crop_center_square(img):
    width, height = img.size
    min_dim = min(width, height)
    
    # Calculate cropping box (center square)
    left = (width - min_dim) // 2
    top = (height - min_dim) // 2
    right = left + min_dim
    bottom = top + min_dim

    return img.crop((left, top, right, bottom))

# def crop_to_512(img_path, save_path=None):
#     with Image.open(img_path) as img:
#         # Crop to center square
#         cropped = crop_center_square(img)
#         # Resize to 512x512
#         resized = cropped.resize((512, 512), Image.LANCZOS)

#         if save_path:
#             resized.save(save_path)
#         return resized

# Example usage
#output_image = crop_to_512("C:/Users/User/MATLAB/TypiTarget/stimuli_target/demi-kyu-gZPDNM0VfO8-unsplash.jpg", "output_512.jpg")
#output_image.show()

#output_image = crop_to_512("C:/Users/User/MATLAB/TypiTarget/stimuli_nontarget/pexels-arina-krasnikova-6653896.jpg", "output2.jpg")
#output_image.show()

path = "C:/Users/User/MATLAB/TypiTarget/stimuli_nontarget/"
# dir_resize = '"C:/Users/User/MATLAB/TypiTarget/stimuli_nontarget/resized_images/'
list_imageFiles = []
imageFil = []

for file in os.listdir(path):
    if file.endswith('.jpg'):
        list_imageFiles.append(file)
        os.path.splitext(file)
        file_name_with_extension = os.path.basename(file)
        file_name, _ = os.path.splitext(file_name_with_extension)
        imageFil.append(file_name)
        # imageFil.append(file_name)
        with Image.open(path+file, "r") as img:
            cropped = crop_center_square(img)
            # Resize to 512x512
            resized = cropped.resize((512, 512), Image.LANCZOS)
            
            resized.save(file_name + '_resized.jpg') #, 'JPEG')
                
