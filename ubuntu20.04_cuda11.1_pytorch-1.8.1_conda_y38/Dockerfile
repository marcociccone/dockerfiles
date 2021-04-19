# Download base image ubuntu 20.04
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

# Conda supports delegating to pip to install dependencies
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

# -- Install Miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc

ENV PATH "/opt/conda/bin:$PATH"
ENV PATH "/opt/conda/envs:$PATH"
ENV PATH "/opt/conda/envs/py38/bin:$PATH"

# -- Make sure you have the most recent version
RUN conda update -n base -c defaults conda

# https://github.com/ContinuumIO/docker-images/issues/89
#  -- Update conda and setup environment
RUN conda create -y -n py38 python=3.8 pip && \
    echo ". activate py38" >> ~/.bashrc

# -- From now on you can customize -- if installing python packages remember to start with RUN /bin/bash -c ". activate py38"

# -- Install pytorch
RUN /bin/bash -c ". activate py38 && conda install pytorch torchvision torchaudio cudatoolkit=11.1 -c pytorch -c conda-forge"

# -- Install basic ML tools
RUN /bin/bash -c ". activate py38 && pip install \
    numpy \
    scipy \
    scikit-learn \
    sklearn-extras \
    statsmodels"

# -- Install image utils
RUN /bin/bash -c ". activate py38 && pip install \
    opencv-python \
    Pillow \
    imageio \
    scikit-image \
    imgaug \
    imagecorruptions \
    wand"
RUN apt-get install --no-install-recommends  -y libmagickwand-dev

# -- Install plot and data sciene utils
RUN /bin/bash -c ". activate py38 && pip install matplotlib \
    plotly \
    seaborn \
    pandas"

# -- Install other ML utils
RUN /bin/bash -c ". activate py38 && pip install termcolor \
    -U tqdm \
    -U lrcurve \
    -U hydra-core \
    install wandb \
    neptune-client psutil \
    neptune-contrib[all]"

# -- TSNE
# RUN /bin/bash -c ". activate py38 && conda install tsnecuda cuda101 -c cannylab"
# RUN /bin/bash -c ". activate py38 && pip install MulticoreTSNE wurlitzer"

# -- debuggers
RUN /bin/bash -c ". activate py38 && pip install ipdb pudb>=2020"

# # -- EXTRA
# RUN /bin/bash -c ". activate py38 && pip install --upgrade --pre omegaconf==2.0.0rc15"
RUN /bin/bash -c ". activate py38 && pip install aiohttp psutil setproctitle grpcio"
RUN /bin/bash -c ". activate py38 && pip install ray ray[tune]"
RUN /bin/bash -c ". activate py38 && pip install torchmeta"
# RUN /bin/bash -c ". activate py38 && pip install py3nvml"
# RUN /bin/bash -c ". activate py38 && pip install cffi"

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

# -- Jupyterlab
RUN /bin/bash -c ". activate py38 && conda install -c conda-forge 'jupyterlab>=3.0.0,<4.0.0a0'"
RUN /bin/bash -c ". activate py38 && conda install -c conda-forge nodejs"
RUN /bin/bash -c ". activate py38 && conda install -c conda-forge ipython future ipympl ipywidgets"
RUN chmod -R 777 /opt/conda/envs/py38/share/jupyter/lab/

# -- JupyterLab extensions (build all together at the end)
ENV NODE_OPTIONS="--max-old-space-size=8192"
RUN /bin/bash -c ". activate py38 && jupyter serverextension enable --py jupyterlab --minimize=False"
RUN /bin/bash -c ". activate py38 && jupyter labextension install \
    @jupyter-widgets/jupyterlab-manager \
    jupyterlab-plotly@4.14.3 \
    plotlywidget@4.14.3 \
    @jupyterlab/toc --no-build"

RUN /bin/bash -c ". activate py38 && jupyter lab build --minimize=False --dev-build=False"
RUN /bin/bash -c ". activate py38 && jupyter lab clean"
RUN /bin/bash -c ". activate py38 && jlpm cache clean"
RUN /bin/bash -c ". activate py38 && npm cache clean --force"

# -- jupyterlab-lsp
RUN /bin/bash -c ". activate py38 && conda install -c conda-forge jupyterlab-lsp python-language-server"
# -- Jupyter VIM extension
RUN /bin/bash -c ". activate py38 && pip install jupyterlab_vim"
# -- Jupyter interactive widgets framework
RUN /bin/bash -c ". activate py38 && conda install -c conda-forge ipympl"
# -- Jupyter dash (from plotly)
# RUN /bin/bash -c ". activate py38 && pip install jupyter-dash"


# -- Install npm, nodejs, yarn
# RUN apt-get install curl && curl -sL https://deb.nodesource.com/setup_13.x | bash -
# RUN apt-get install -y nodejs
# RUN apt-get install gcc g++ make
# RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# RUN apt-get update && apt-get install yarn

CMD ["bash"]
WORKDIR /exp
