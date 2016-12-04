FROM jupyterhub/jupyterhub
MAINTAINER Glenn Y. Rolland <glenux@glenux.net>

ENV DEBIAN_FRONTEND noninteractive

## Install base packages for building jupyterhub kernels

RUN apt-get update                                               \
	&& apt-get install -y libzmq3 libzmq3-dev gnuplot-nox        \
					   libgsl0-dev libtool autoconf automake     \
					   zlib1g-dev libsqlite3-dev libmagick++-dev \
					   imagemagick libatlas-base-dev             \
					   libtool libtool-bin                       \
					   autoconf g++ gcc make                     \
	&& apt-get clean


## Update jupyter version

RUN pip install jupyter


## Create user

RUN useradd --create-home --user-group --shell /bin/bash admin \
	&& echo "admin:admin" | chpasswd


## Install NodeJS kernel

USER root 

RUN apt-get update                         \
	&& apt-get install -y nodejs npm       \
	&& apt-get clean                       \
	&& ln -s /usr/bin/nodejs /usr/bin/node

USER admin 

WORKDIR /home/admin

RUN git clone https://github.com/notablemind/jupyter-nodejs.git \
	&& cd jupyter-nodejs                                        \
	&& mkdir -p ~/.ipython/kernels/nodejs/                      \
	&& npm install                                              \
	&& node install.js                                          \
	&& make

## Install Ruby kernel 

USER root

RUN apt-get update                          \
	&& apt-get install -y ruby2.1 ruby-dev  \
	&& apt-get clean                        \
	&& ln -s /usr/bin/ruby2.1 /usr/bin/ruby \
	&& ln -s /usr/bin/gem2.1 /usr/bin/gem

#RUN gem install rbczmq -- --with-system-libs                 \
RUN gem install rbczmq                 \
    && gem install pry awesome_print gnuplot rubyvis nyaplot \
	&& gem install iruby

USER admin

RUN iruby register

## Run jupyterhub

USER root

WORKDIR /srv/jupyterhub

