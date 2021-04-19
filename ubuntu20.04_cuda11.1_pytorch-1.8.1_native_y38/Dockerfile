# Download base image ubuntu 16.04
FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04
MAINTAINER Marco Ciccone "marco.ciccone@polimi.it"

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ENV NUM_CORES 10

# Update Ubuntu Software repository
RUN apt-get update --fix-missing
RUN apt-get -y upgrade
RUN apt install -y --no-install-recommends apt-utils

# Build tools.
RUN apt-get update && apt-get install -y build-essential cmake git

# Conda supports delegating to pip3 to install dependencies
# that aren’t available in anaconda or need to be compiled
# for other reasons. In our case, we need psycopg compiled
# with SSL support. These commands install prereqs necessary
# to build psycopg.
RUN apt-get install -y libpq-dev

# Fonts.
RUN apt-get install -y fonts-liberation

# Utilities.
RUN apt-get install -y \
    bc \
    vim \
	nano \
	wget \
    htop \
    tmux \
	screen \
    curl \
    pkg-config \
    rsync \
    software-properties-common \
    unzip \
        && \
    apt-get clean && \
    apt-get autoremove

RUN apt-get install ffmpeg libsm6 libxext6  -y
RUN apt install python3-pip -y

# -- From now on you can customize

# -- Install pytorch
RUN pip3 install torch==1.8.1+cu111 torchvision==0.9.1+cu111 torchaudio==0.8.1 -f https://download.pytorch.org/whl/torch_stable.html

# -- Install basic ML tools
RUN pip3 install numpy \
    scipy \
    scikit-learn sklearn-extras \
    statsmodels

# -- Install image utils
RUN pip3 install opencv-python \
    Pillow \
    imageio \
    scikit-image \
    imgaug \
    imagecorruptions \
    wand
RUN apt-get install -y libmagickwand-dev

# -- Install plot and data sciene utils
RUN pip3 install matplotlib \
    plotly \
    seaborn \
    pandas

# -- Install other ML utils
RUN pip3 install termcolor \
    -U tqdm \
    -U lrcurve \
    hydra-core --upgrade \
    wandb \
    neptune-client psutil \
    neptune-contrib[all] \
    ipdb pudb>=2020

# -- TSNE
# RUN conda install tsnecuda cuda101 -c cannylab"
# RUN pip3 install MulticoreTSNE wurlitzer"


# # -- EXTRA
# # RUN pip3 install -U https://s3-us-west-2.amazonaws.com/ray-wheels/latest/ray-0.9.0.dev0-cp36-cp36m-manylinux1_x86_64.whl"
# RUN pip3 install --upgrade --pre omegaconf==2.0.0rc15"
RUN pip3 install aiohttp psutil setproctitle grpcio \
    ray \
    ray[tune] \
    torchmeta
# RUN pip3 install py3nvml
# RUN pip3 install cffi

RUN mkdir /exp
RUN chmod 777 /exp

RUN mkdir /.cache
RUN chmod 777 /.cache

RUN mkdir /.config
RUN chmod 777 /.config

RUN mkdir /.config/pudb
RUN chmod 777 /.config/pudb
COPY pudb.cfg /.config/pudb/pudb.cfg

RUN mkdir /.virtual_documents
RUN chmod 777 /.virtual_documents

RUN mkdir /.local
RUN chmod 777 /.local

RUN mkdir /.npm
RUN chmod 777 /.npm

# -- Install npm, nodejs, yarn
RUN apt-get install curl && curl -sL https://deb.nodesource.com/setup_15.x | bash -
RUN apt-get install -y nodejs
RUN apt-get install gcc g++ make
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn

RUN pip3 install nodejs \
    ipython \
    future \
    ipympl \
    ipywidgets

# -- Jupyterlab
RUN pip3 install 'jupyterlab>=3.0.0,<4.0.0a0'

# RUN chmod -R 777 /opt/conda/envs/py38/share/jupyter/lab/

# -- JupyterLab extensions (build all together at the end)
ENV NODE_OPTIONS="--max-old-space-size=8192"
RUN jupyter serverextension enable --py jupyterlab --minimize=False
RUN jupyter labextension install  \
    @jupyter-widgets/jupyterlab-manager \
    jupyterlab-plotly@4.14.3 \
    plotlywidget@4.14.3 \
    @jupyterlab/toc --no-build


RUN jupyter lab build --minimize=False --dev-build=False
RUN jupyter lab clean
RUN jlpm cache clean
RUN npm cache clean --force

# -- jupyterlab-lsp
RUN pip3 install jupyterlab-lsp
RUN pip3 install 'python-language-server[all]'

# -- Jupyter VIM extension
RUN pip3 install jupyterlab_vim
# -- Jupyter interactive widgets framework
RUN pip3 install ipympl
# -- Jupyter dash (from plotly)
RUN pip3 install jupyter-dash

# --------------------------------------------------------------

RUN pip3 install pytorch-lightning pytorch-lightning-bolts

CMD ["bash"]


WORKDIR /exp

