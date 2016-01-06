# A base docker image that includes juptyerhub and IPython master
#
# Build your own derivative images starting with
#
# FROM jupyter/jupyterhub:latest
#

FROM jupyter/jupyterhub:latest

MAINTAINER cts <chengts95@163.com>
RUN useradd -m "cts" -p "123456" && \
chmod 777 /etc/sudoers && \
echo "cts ALL=(ALL) ALL">/etc/sudoers && \
chmod 440 /etc/sudoers && \
apt-get update && \
apt-get upgrade -y

RUN apt-get build-dep python3-matplotlib -y && \
    apt-get build-dep python3-scipy -y && \
    RUN apt-get install openssh-server -y && \
    RUN service ssh start && \
    pip3 install -U jupyter && \
    pip3 install numpy && \
    pip3 install matplotlib && \
    pip3 install scipy && \
    pip3 install sympy && \
    pip3 install nbgrader && \
    nbgrader extension install && \
    echo "cts:123456" | chpasswd && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*
ADD jupyterhub_config.py /srv/jupyterhub/

WORKDIR /home/cts
RUN mkdir assigns
WORKDIR /home/cts/assigns 
RUN mkdir source  release  submitted  autograded  feedback 
USER root
EXPOSE 22

RUN mkdir /srv/nbgrader && \
    mkdir /srv/nbgrader/exchange && \
    chmod -R 777 /srv/nbgrader

WORKDIR /srv/jupyterhub/


CMD ["jupyterhub", "-f", "/srv/jupyterhub/jupyterhub_config.py"]
