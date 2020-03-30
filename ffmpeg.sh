ffmpeg -i rtmp://localhost/live \
	-c:a aac \
	-ac 1 \
	-ar 44100 \
	-b:a 128k \
	-vcodec libx264 \
	-pix_fmt yuv420p \
	-r 30 \
	-g 60 \
	-maxrate 3000k \
	-bufsize 9000k \
	-preset veryfast \
	-f flv "rtmps://live-api-s.facebook.com:443/rtmp/KEY"
