# Specify parent image
ARG BASE_IMAGE=registry.git-ce.rwth-aachen.de/jupyter/singleuser/python:latest
FROM ${BASE_IMAGE}

# Update conda base environment to match specifications in environment.yml
ADD environment.yml /tmp/environment.yml
USER root
RUN sed -i "s|name\: exphys6|name\: base|g" /tmp/environment.yml # we need to replace the name of the environment with base such that we can update the base environment here
USER $NB_USER
RUN conda env update -f /tmp/environment.yml # All packages specified in environment.yml are installed in the base environment

# Execute postBuild script
ADD postBuild.sh /tmp/postBuild.sh
# Make the file executable (TODO: is this still needed?)
USER root 
RUN chmod +x /tmp/postBuild.sh
# 
USER $NB_USER
RUN /tmp/postBuild.sh

# Cleanup conda packages
RUN conda clean --all -f -y

ENV JUPYTER_ENABLE_LAB=yes

# Copy workspace
COPY ./ /home/jovyan
