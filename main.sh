# to run on an image
# ./darknet detect cfg/yolo.cfg yolo.weights data/dog.jpg

DATAPATH=/data/yolo_movies/
count=0
for f in $DATAPATH
do
	echo "processing $f video into frames"
	python vid2frames.py $f
	echo "done processing; frames should be in $f/"
	echo "running darknet on each frame"

	FRAMEPATH=$f/
	echo "the path we're writing frames to $FRAMEPATH"

	for img in $FRAMEPATH
	do
		./darknet detect cfg/yolo.cfg yolo.weights $img
		rename="output"
		rename="$rename$count"
		count=$((count+1))
		mv "./predictions.png" "$f/$rename.png"
	done
done
