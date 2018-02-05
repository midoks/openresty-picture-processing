#
# MAINTAINER		midoks <midoks@163.com>
# DOCKER-VERSION 	17.12.0-ce, build c97c6d6
#
# Dockerizing Ubuntu: Dockerfile for building Ubuntu images

FROM		midoks/centos:7.1

ADD openresty.repo /etc/yum.repos.d/openresty.repo

#RUN sudo yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo



RUN yum install -y openresty GraphicsMagick

RUN groupadd www
RUN useradd -g www www

RUN mkdir -p /www/app
RUN mkdir -p /www/app/image
RUN mkdir -p /www/app/thumbnail
RUN mkdir -p /www/cmd

ADD app/image/img1.jpg /www/app/image
ADD app/image/img2.jpg /www/app/image
ADD app/image/img3.jpg /www/app/image
ADD app/image/img4.jpg /www/app/image
ADD app/image/img5.jpg /www/app/image
ADD app/404.lua /www/app
ADD app/curl.lua /www/app
ADD app/format.lua /www/app
ADD app/quality.lua /www/app
ADD app/tclip.lua /www/app
ADD app/thumb.lua /www/app
ADD app/thumb_fixed.lua /www/app
ADD app/index.html /www/app


#opencv install https://github.com/opencv/opencv/archive/2.4.9.tar.gz
ADD opencv-2.4.9.tar.gz /www/
#RUN tar zxvf /www/opencv-2.4.9.tar.gz
RUN cd /www/opencv-2.4.9/ && cmake CMakeLists.txt && make -j $(cat /proc/cpuinfo|grep processor|wc -l) && make install

ADD cmd/tclip.sh /www/cmd
ADD cmd/tclip.cpp /www/cmd


RUN chmod +x /www/cmd/tclip.sh
RUN echo "/usr/local/lib/" > /etc/ld.so.conf.d/opencv.conf
RUN ldconfig -v


ENV PKG_CONFIG_PATH=/usr/lib/pkgconfig/:/usr/local/lib/pkgconfig


RUN cd /www/cmd && /bin/sh tclip.sh
RUN cd /www/cmd && cp -f tclip /bin


RUN chown -R www:www /www/cmd
RUN chown -R www:www /www/app

ADD lua-resty-gm/lib /usr/local/openresty/lualib/resty/

RUN mkdir -p /usr/local/openresty/nginx/conf/vhost
ADD conf/nginx.conf /usr/local/openresty/nginx/conf
RUN chown -R www:www /usr/local/openresty

RUN chown root:www /usr/local/openresty/nginx/sbin/nginx
RUN chmod 750 /usr/local/openresty/nginx/sbin/nginx
RUN chmod u+s /usr/local/openresty/nginx/sbin/nginx


ADD	supervisor_openresty.conf /etc/supervisor.conf.d/supervisor_openresty.conf