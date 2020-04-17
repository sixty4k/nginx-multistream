all:
	@echo "nothing by default"

docker-build: 
	docker build -t nginx-multistream .

docker-run:
	docker run \
		-p 1935:1935 -p 8080:8080 \
		--mount type=bind,source=$(CURDIR)/nginx.conf,target=/usr/local/nginx/conf/nginx.conf \
		-it \
		nginx-multistream:latest
