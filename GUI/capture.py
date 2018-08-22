import pygame
import pygame.camera
from PIL import Image
import numpy as np

#size = 640, 480
size = 1280, 720
pygame.camera.init()
pygame.camera.list_cameras() #Camera detected or not
cam = pygame.camera.Camera("/dev/video0",(size))

def getImg():
	cam.start()
	img = cam.get_image()
	cam.stop()
	return pygame.image.tostring(img,'RGBA')

controls = cam.get_controls()
print(controls)
#TODO set camera controls here... (hflip, vflip, brightness)

imgstring = getImg()
mode = 'RGBA'
img = Image.frombytes(mode, size, imgstring)

img.show()
npimg = np.array(img)
# Process array to normalize brightness?


newimg = Image.fromarray(npimg)
newimg.save('processed.jpg')
