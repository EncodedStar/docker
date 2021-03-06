FROM centos:7.2.1511

# author label
LABEL maintainer="XinStar"

# install related packages
ENV ENVIRONMENT DOCKER_PROD
RUN cd / && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
	&& yum makecache \
	&& yum install -y wget aclocal automake autoconf make gcc gcc-c++ python-devel mysql-devel bzip2 libffi-devel epel-release \
	&& yum install -y epel-release \
	&& yum install -y python-pip \
	&& yum clean all

# install python 3.7.0
#RUN wget https://npm.taobao.org/mirrors/python/3.7.0/Python-3.7.0.tar.xz \
#    && tar -xvf Python-3.7.0.tar.xz -C /usr/local/ \
#	&& rm -rf Python-3.7.0.tar.xz \
#	&& cd /usr/local/Python-3.7.0 \
#	&& ./configure && make && make install

#RUN pip install locust

# 创建src目录
COPY robot /root/robot
#WORKDIR /root/robot

# install related packages
#RUN pip3 install -i https://pypi.doubanio.com/simple/ -r requirements.txt
ADD requirements.txt /requirements.txt
RUN pip install --upgrade setuptools
RUN pip install -r /requirements.txt

# expose port
EXPOSE 15731

# install ssh
RUN yum -y update; yum clean all
RUN yum -y install openssh-server passwd; yum clean all
ADD ./start.sh /start.sh
RUN mkdir /var/run/sshd

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''

RUN chmod 755 /start.sh
RUN /start.sh
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
