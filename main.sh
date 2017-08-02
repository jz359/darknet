# to run on an image
# ./darknet detect cfg/yolo.cfg yolo.weights data/dog.jpg

FRAMES=./frames/*
count=0
for f in $FRAMES
do
	echo "processing $f file"
	./darknet detect cfg/yolo.cfg yolo.weights ./frames/$f
	rename="frame"
	rename="$rename$count"
	count=$((count+1))
	#mv "./predictions.png" "./$rename.png"
done