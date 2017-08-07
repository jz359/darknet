import cv2
import argparse
import os

def main(args):
	video_capture = cv2.VideoCapture(args.input_video)
	framepath = os.path.basename(args.input_video)
	name, ext = framepath.split('.')
	dir_name = name

	if not os.path.exists('/data/yolo_movies/'+dir_name+'/'):
		os.makedirs('/data/yolo_movies/'+dir_name+'/')

	framepath = '/data/yolo_movies/'+dir_name+'/'

	count=0

	while True:
	    # get frame by frame
	    ret, frame = video_capture.read()
	    if ret is True:
	        cv2.imwrite(framepath+'image'+str(count)+'.jpg',frame)
	        count+=1
	    else:
	        break
	video_capture.release()


def parse_arguments(argv):
	parser = argparse.ArgumentParser()
	parser.add_argument('input_video', type=str, help='Target video to process into frames.')

	return parser.parse_args(argv)

if __name__ == '__main__':
	main(parse_arguments(sys.argv[1:]))