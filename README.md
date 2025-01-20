# Grav Containerized
## Overview of This Repo
Contains the Dockerfile and Docker Compose Yaml for deploying Grav CMS on the latest stable & long term support version Apache and PHP (Apache2 and PHP 8.4.1) in a Docker container. This is NOT production ready but can be run on a local virtual machine/laptop/desktop.
## Grav Overview
Grav is a CMS for making websites, you can find more info on the software here: [Grav About Page](https://getgrav.org/about). It can be deployed on a webserver, which you can do by following their instructions here: [Grav Webserver Installation](https://learn.getgrav.org/17/basics/installation#option-1-install-from-zip-package). However, modern day containerization allows us to abstract away the webserver by using a Docker container (more details below) so that you don't have to worry about managing a server at all, just the containers. This repo allows users to deploy Grav on such a container.   
  
For more information on what a Docker container is check out this video by NetworkChuck: [Docker Tutorial](https://youtu.be/eGz9DS-aIeY?si=FujiFNnIfH36p90j); note you'll also need to know about Docker Compose, I recommend this video, incidently also from NetworkChuck: [Docker Compose Tutorial](https://youtu.be/DM65_JyGxCo?si=660tnx5HmDhFAiHj).  
  
### Grav Overview - Webserver Deployment
Normal installation of Grav on webserver requires a webserver with an HTTP server and PHP installed. For example, if you deploy an Ubuntu server with Apache2 and PHP installed, all you would need to do is download the Grav files from Grav's website and move it to this folder: (/var/www/html). From there all you would need to go to that webserver from a browser and you would be met with the Grav homepage. Strictly speaking there are more steps that you would need to take but big picture that's it.  

## How to Use This Repo (Non-Production and Not Exposed to the Internet)
1. To deploy a Docker container with this repo, first you need the Docker image for it.
2. You can make it with the included Dockerfile OR use my current image from my DockerHub repo: `docker pull gmarioni/grav-containerized:ver0`  
    A. The image on DockerHub is made from the Dockerfile in this repo, either one will work the same.  
    B. To use the Dockerfile, save it to a folder on a computer (you NEED the grav.conf file to be in the same folder)  
    C. Open a terminal at that folder and run this command: `docker build -t <username>/<name-of-docker-repo> .`
3. Create a folder on your computer (recommend to make it different from the one for the Dockerfile) and save the docker-compose.yaml file provided in this repo.
4. Open a terminal at that folder and run this command: `docker compose up -d`
5. Done :)

## Details of the Docker Image and Dockerfile it's Built From
Going to be in the Wiki for this repo but that's not build out yet.

## Project Goal 
Cloud native deployment to be used for any cloud provider (for example Azure Container Services or AWS ECS).

## Project Roadmap (as of right now)
Phase 1: Update Dockerfile and docker-compose.yaml with industry standard security configurations for Apache and Grav.  
Phase 2: Configure Kubernetes as the Docker orchestrator for cloud deployment and autoscaling (and industry standard security configuration).  

## Project Status
So far I have all the configurations ready for the initial server deployment (as many security configurations are implemented as is practical). Now using them to configure Docker images, which includes mounting a folder on the host to the container for persistent storage.