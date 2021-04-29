# devops-techtask

## Overview

Hopefully this tech task allows you to strut your stuff as much as you decide to!

This exercise should take you no more than a weekend. If you need any clarification, please don’t hesitate to ask us.

## Task details

This repository contains a simple golang service which serves a single endpoint: `/:id`. For each call to this endpoint, the service increments a counter, and returns the number of times the endpoint has been called for the given ID. State for the application is stored in and retrieved from redis, where the data is stored simply with `id` as the key, and the count as the value.

We'd like to deploy this application, and all its dependencies (in this case, redis) on kubernetes. It should be accessible from outside the cluster via HTTP, and should be deployed with high-availability in mind. You are highly encouraged to use any infrastructure automation or deployment tools that you are familiar with to do this. 

The entire solution should be able to run on an fresh ubuntu VM.

You may modify the application code as you see fit, but ensure that the functionality remains the same.

In your solution, include a readme containing the necessary steps to set up the environment, as well as to build, package and deploy the application. Also detail and explain your chosen architecture, as well as what tools were used in the deployment process.

## Requirements

- Simple to build and run
- Application is able to be deployed on kubernetes and can be accessed from outside the cluster
- Application must be able to survive the failure of one or more instances while staying highly-available
- Redis must be password protected
- Readme documents how to run the code and provides explanation regarding the implementation

# Solution

## Pre-requisites
You can use any OS you want however have not tested the deployment procedure with them, I prefered to use Google Cloud Shell to run my commands to bring up the infrastructure.
Please ensure you have terraform and docker and access to a GCP account.
I have already dockerised the GoLang Application shown in
https://hub.docker.com/repository/docker/watermellody/getground-techtest?ref=login

Install/Update terraform to version  
```
which terraform
wget https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_amd64.zip
Unzip the folder and move the content to the path specified in the "which terraform"
```

	
Create a project and keep note of the unique ID
Enable the google apis - Compute Engine, Redis (memorystore), VPC, Kubernetes Engine
Create a service account on IAM & Admin and create a Service Account with "Kubernetes Engine Admin" 
Once created click on the three dots and select manage keys.
Select "Add Key" and create a "JSON" key - keep this JSON file for later use

## Steps to build and run the environment
1. log into google cloud shell and either git clone or upload the zip to google cloud shell and unzip the content
2. Upload the service account json key to google cloud shell and move it to /devops/solution/terraform/
3. If a docker image is not available, please use the dockerfile within /devops/ and run "docker build -t devops-techtask:<version_number>"
4. Move into /devops/solution/terraform/ and change some variables found in terraform.tfvars specfically "credentials" where the value should match your Service Account key file name.
5. When ready to build - run "terraform init" -> "terraform plan" -> "terraform apply" - and this should build out all the infrastructure if pre-requisites have been followed. KEEP A NOTE OF THE OUTPUT FROM THE TERRAFORM RUN

Example of the terraform output:
```
kubernetes_cluster_host = "34.105.239.228"
kubernetes_cluster_name = "demotechtest-312210-gke"
project_id = "demotechtest-312210"
redis_host = "10.147.64.163"
redis_pass = "test"
redis_port = 6379
region = "europe-west2"
```

6. Ensure that everything has been built on VPC, Compute Engine, Redis (memorystore), Kubernetes Engine
7. Move into /devops/solution/kubernetes/ and change some variables within "techtest-appdeployment.yaml" and "deploy_kube_infra.sh"
	7.1: Things to change (techtest-appdeployment.yaml) -
	```
	"image: <imagename>:<imageversion>"
	"REDIS_HOST" value to "<redis_host>" from terraform output
	"REDIS_PASSWORD" value to "<redis_password>" from terraform output
	```
	7.2: Things to change (deploy_kube_infra.sh) -
	```
	Change <change_me> to your project id
	```
8. run the shell script using "bash deploy_kube_infra.sh" to bring up everything needed for the application to be running and accessible from outside the cluster.
9. DONE!! 

Steps to test functionality to test app:
1. Grab the loadbalancer ip from the Kubernetes Engine UI under "Services & Ingress" which is named "Endpoints" with the "getground-service"
2. Go onto any vm which has access to the internet and run "curl -kv <loadbalancer_ip>:80/ping" and should get a 200
3. Run another "curl -kv <loadbalancer_ip>:80/id/<any_number>" and should get a "{count: 1}" on intial run. If run multiple times it will increment every curl ran.

## Process:
I used terraform as it was something that I was comfortable with using as we use it a lot at sky however we have puppet integrated to make building more dynamic.
It is very easy to read and manipulate. One of the main things that I found with using GKE resource is it seems very easy to scale up as the variable I created for "gke_num_nodes" was set to 3 at the time and you can choose to deploy to a region rather than a zone.
So in return if a region was allocated it would create the num of nodes specified to all zones within a region. For example there would be 3 nodes for europe-west1-a -> europe-west1-d.

The thought of getting the kubernetes cluster open for public use was intreging as at Sky we don't usually have to deal with public being able to hit our cluster directly. I ended up doing this by creating an ingress and a service that exposes the Go Application's port 443 to path through 80.

With redis and terraform, it is possible to spin up a STANDARD_HA tier of redis which allos for highly available primary/replica instances.
When bringing up the redis initially I didn't realise it was not on the same VPC network as the current stack so that caused connection failures between the GKE cluster and redis.
This was fixed by explicity assigning the redis instance to the same VPC network as the rest of the stack - "<project_id>-vpc"

## If I had more time:
I would have loved to dynamically grabbed some of the variables which need to be changed during the steps taken.
I would have integrated Puppet or a similar configuration system to grab data and configure the infrastructure rather than having hardcoded values within the terraform folder.
I would introduce jenkins as a CI builder as it will hold a record of build completions or failures. In addition, I would split up the building of components such as the GKE cluster and redis which will result in faster build times.



