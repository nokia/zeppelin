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

# Install R dependencies if SPARKR is true
if [[ "${SPARKR}" = "true" ]] ; then
  R -e ".libPaths()"
  mkdir -p ~/R
  R -e ".libPaths( c( .libPaths(), '~/R') )"
  R -e ".libPaths()"
  R -e "install.packages(c('evaluate','base64enc','base64enc','knitr','ggplot2'), repos = 'http://cran.us.r-project.org', lib='~/R')"  > /dev/null 2>&1
fi

if [[ -n "$PYTHON" ]] ; then

  if [[ "$PYTHON" == "2" ]] ; then
    export PYTHON_VERSION="2.7.13"
  fi

  if [[ "$PYTHON" == "3" ]] ; then
    export PYTHON_VERSION="3.5.3"
  fi

  pyenv install $PYTHON_VERSION
  pyenv global $PYTHON_VERSION

  pip install --quiet -U virtualenv

  pip install --quiet setuptools grpcio bkzep python-Levenshtein==0.12.0 cython==0.26.1 numpy==1.13.1 pandas==0.20.3 matplotlib==2.0.2 py4j==0.10.6 scipy==0.19.1 ggplot==0.11.5 fuzzywuzzy==0.15.1

fi
