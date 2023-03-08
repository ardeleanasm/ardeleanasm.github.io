{
  :title "Jupyter notebook in Docker"
  :layout :post
  :tags ["python", "docker"]
  :toc true}
 
 ---

## Why?

2 days ago I was thinking about machine learning. I used some classification algorithms and analyzed the results, it's not a new domain to me but... it was always a process of:

1. Let's find how to do that, if I can find a tutorial, that's great.
2. Let's call some functions in Python, aka **spells** or **magical incantations**.

So, I decided to start learning.

## How?

Well, the first step was to find some online courses (Thanks Coursera!) and some books (An Introduction to Statistical Learning is great!). But how about the environment? That's the topic for this post.

Since I mainly use Windows OS, installing Python and R was not a solution. Installing a full Linux based OS in a virtual environment... hmm, nice but not great. I use this approach for my projects in C++ and SystemVerilog but I really don't like the solution at all. How about Docker? Well, sounds good, let's give it a chance.

## Setup

I just needed to have Jupyter Lab installed, Python and, of course, R. So, first step was to find a Jupyter docker image. And found it really easy ([Jupyter/datascience-notebook](https://hub.docker.com/r/jupyter/datascience-notebook)). but I didn't need all the stacks. So, let's create our basic image starting from this image.

```docker
ARG ROOT_CONTAINER=jupyter/base-notebook:latest


FROM $ROOT_CONTAINER

WORKDIR /app

USER root

```
so, until now I just fetch the base container, define the working directory and the user. Let's install R and dependencies:

```dockerfile

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    fonts-dejavu \
    unixodbc \
    unixodbc-dev \
    r-cran-rodbc \
    gfortran \
    gcc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
```

Ok, now we should switch back the user and install in R with mamba. And, some Python libraries.

```dockerfile
RUN mamba install --quiet --yes \
    'r-base' \
    'r-caret' \
    'r-crayon' \
    'r-devtools' \
    'r-e1071' \
    'r-forecast' \
    'r-hexbin' \
    'r-htmltools' \
    'r-htmlwidgets' \
    'r-irkernel' \
    'r-nycflights13' \
    'r-randomforest' \
    'r-rcurl' \
    'r-rmarkdown' \
    'r-rodbc' \
    'r-rsqlite' \
    'r-shiny' \
    'r-tidymodels' \
    'r-tidyverse' \
    'unixodbc' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"


RUN pip install -U matplotlib numpy scikit-learn jupyterlab ipywidgets ipympl
```

## How to run it?

First, let's build the image:

```sh
docker build -t jupyter .
```

and run the container:

```sh
docker run -p 8888:8888 -it -v C:\work:/app --entrypoint /bin/bash jupyter
```