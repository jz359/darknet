import cv2
video_capture = cv2.VideoCapture("sample.mp4")

count=0

while True:
    # get frame by frame
    ret, frame = video_capture.read()
    if ret is True:
        cv2.imwrite('image'+str(count)+'.jpg',frame)
        count+=1
    else:
        break
video_capture.release()