#!/bin/bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Script for installing R / Python dependencies for Travis CI
set -ev
touch .environ

# # Install R dependencies if SPARKR is true
# if [[ "${SPARKR}" = "true" ]] ; then
#   echo "export R_LIBS=~/R" >> .environ
#   source .environ
#   if [[ ! -d "$HOME/R/knitr" ]] ; then
#     mkdir -p ~/R
#     R -e "install.packages('evaluate', repos = 'http://cran.us.r-project.org', lib='~/R')"  > /dev/null 2>&1
#     R -e "install.packages('base64enc', repos = 'http://cran.us.r-project.org', lib='~/R')"  > /dev/null 2>&1
#     R -e "install.packages('knitr', repos = 'http://cran.us.r-project.org', lib='~/R')"  > /dev/null 2>&1
#     R -e "install.packages('ggplot2', repos = 'http://cran.us.r-project.org', lib='~/R')"  > /dev/null 2>&1
#   fi
# fi
#
# # Install Python dependencies for Python specific tests
# if [[ -n "$PYTHON" ]] ; then
#   wget https://repo.continuum.io/miniconda/Miniconda${PYTHON}-4.2.12-Linux-x86_64.sh -O miniconda.sh
#   bash miniconda.sh -b -p $HOME/miniconda
#   echo "export PATH='$HOME/miniconda/bin:$PATH'" >> .environ
#   source .environ
#   hash -r
#   conda config --set always_yes yes --set changeps1 no
#   conda update -q conda
#   conda info -a
#   conda config --add channels conda-forge
#   conda install -q matplotlib=2.1.2 pandasql ipython=5.4.1 jupyter_client ipykernel matplotlib bokeh=0.12.10
#   pip install -q grpcio ggplot bkzep==0.4.0 python-Levenshtein==0.12.0
# fi

if [[ -n "$PYTHON" ]] ; then

  # pip install -q requests==2.5.3 virtualenv==13.1.2
  # Dependencies for installing Python
  # apt-get install build-essential
  # apt-get install libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev

  # to be refactored ...
  if [[ "$PYTHON" == "2" ]] ; then
    # Download Python 2.7.9 and extract
    # cd $HOME
    # wget --quiet https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz
    # tar -xf Python-2.7.9.tgz
    #
    # # Install Python 2.7.9
    # cd $HOME/Python-2.7.9
    # ./configure > /dev/null 2> /dev/null
    # make -j2 build_all > /dev/null 2> /dev/null
    # make install

    export PYENV_VERSION='2.7.13'
    # export PYENV_VERSION_STRING='Python 2.7.13'

    export PYENV_ROOT='~/.travis-pyenv'
    export PYENV_CACHE_PATH='~/.pyenv_cache'


    if [[ -n "$PYENV_VERSION" ]]; then
      wget https://github.com/praekeltfoundation/travis-pyenv/releases/download/0.4.0/setup-pyenv.sh
      source setup-pyenv.sh
    fi

    python --version

    # export PYTHON_EXEC=$HOME/Python-2.7.9/python

    # export PYTHON_EXEC=/usr/bin/python2.7
  fi

  # if [[ "$PYTHON" == "3" ]] ; then
  #   # Download python 3.4.3 and extract
  #   cd $HOME
  #   wget --quiet https://www.python.org/ftp/python/3.4.3/Python-3.4.3.tgz
  #   tar -xf Python-3.4.3.tgz
  #
  #   # Install Python 3.4.3
  #   cd $HOME/Python-3.4.3
  #   ./configure --prefix=$HOME/Python-3.4.3 > /dev/null 2> /dev/null
  #   make -j2 build_all > /dev/null 2> /dev/null
  #
  #   export PYTHON_EXEC=$HOME/Python-2.4.3/python
  # fi

  # mkdir -p ${HOME}/zeppelin
  # cd ${HOME}
  # virtualenv --python=$PYTHON_EXEC zeppelin
  # source ${HOME}/zeppelin/bin/activate

  pip install setuptools grpcio bkzep python-Levenshtein==0.12.0 cython==0.26.1 numpy==1.13.1 pandas==0.20.3 matplotlib==2.0.2 sympy==1.1.1 py4j==0.10.6 pattern==2.6 scipy==0.19.1 nltk==3.2.4 gensim==2.3.0 sklearn==0.0 stemming==1.0.1 ggplot==0.11.5 fuzzywuzzy==0.15.1 boto==2.48.0
else
  mkdir -p ${HOME}/zeppelin/bin
  touch ${HOME}/zeppelin/bin/activate
fi
