# A base docker image that includes juptyerhub and IPython master
#
# Build your own derivative images starting with
#
# FROM jupyter/jupyterhub:latest
#

FROM jupyter/jupyterhub:latest

MAINTAINER cts <chengts95@163.com>
RUN useradd -m "cts" -p "123456"
RUN chmod 777 /etc/sudoers
RUN echo "cts ALL=(ALL) ALL">/etc/sudoers
RUN chmod 440 /etc/sudoers
RUN pip3 install numpy
RUN pip3 install matplotlib
RUN pip3 install scipy
RUN pip3 install nbgrader
RUN nbgrader extension install
RUN echo "cts:123456" | chpasswd
ADD jupyterhub_config.py /srv/jupyterhub/

WORKDIR /home/cts
RUN mkdir assigns
WORKDIR /home/cts/assigns
RUN mkdir source  release  submitted  autograded  feedback
USER root
RUN apt-get install openssh-server -y
EXPOSE 22
RUN service ssh start

RUN mkdir /srv/nbgrader
RUN mkdir /srv/nbgrader/exchange
RUN chmod -R 777 /srv/nbgrader
WORKDIR /srv/jupyterhub/
ADD jupyterhub_config.py /srv/jupyterhub/

CMD ["jupyterhub", "-f", "/srv/jupyterhub/jupyterhub_config.py"]
