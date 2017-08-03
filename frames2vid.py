import cv2
import numpy as np
import os

fourcc = cv2.VideoWriter_fourcc(*'XVID')
out = cv2.VideoWriter('output.avi',fourcc, 30.0, (704,400))

PATHS = [ os.path.join('./output/', 'frame{}.jpg'.format(i)) for i in range(0, 3382) ]


for frame in PATHS:
	img = cv2.imread(frame)
	out.write(img)
	#cv2.imshow('frame', img)
	#cv2.waitKey(0)


out.release()
