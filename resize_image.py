# -*- coding: utf-8 -*-
"""
Created on Sat Apr 12 13:43:44 2025

@author: Charlotte
"""

import os, sys
from PIL import Image

#filename = "C:/Users/User/deepMem/datasets/140_stimuli/bedroom/img_0eflx.png"
filename = "C:/Users/User/MATLAB/TypiTarget/stimuli_target_non/pexels-andreaedavis-13757468.jpg"
#pexels-arina-krasnikova-6653896.jpg

image3 = Image.open("C:/Users/User/MATLAB/TypiTarget/stimuli_target_non/demi-kyu-gZPDNM0VfO8-unsplash.jpg")
image2 = Image.open("C:/Users/User/MATLAB/TypiTarget/stimuli_target_non/pexels-arina-krasnikova-6653896.jpg")
image = Image.open("C:/Users/User/MATLAB/TypiTarget/stimuli_target_non/pexels-andreaedavis-13757468.jpg")
image.thumbnail((512, 512))
image2.thumbnail((512,512))
image3.thumbnail((512,512))
image.save('image_thumbnail.jpg')
print(image.size) # Output: (400, 350)
new_image = image.resize((512, 512))
new_image.save('myimage_500.jpg')
new_image = image3.resize((512, 512))
new_image.save('myimage3_500.jpg')


infile = "C:/Users/User/MATLAB/TypiTarget/stimuli_target_non/demi-kyu-gZPDNM0VfO8-unsplash.jpg"
size = 512, 512

for infile in sys.argv[1:]:
    outfile = os.path.splitext(infile)[0] + ".thumbnail"
    if infile != outfile:
        try:
            im = Image.open(infile)
            im.thumbnail(size, Image.Resampling.LANCZOS)
            im.save(outfile, "JPEG")
        except IOError:
            print ("cannot create thumbnail for '%s'", infile)
            
            
