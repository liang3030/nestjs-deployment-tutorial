### Introduction

It is used to familiar how to deploy an service on AWS. It has two parts, first one is `service`, it contains all business logic. Second one is `db`, it is postgreSQL database. (废话 haha)

#### Stages

##### Stage 1: Deploy on local docker environment

Deploy application in local docker environment. It has two containers, one is DB container, the other one is service container. The docker compose files is `docker-compose.yml`.

Store environment secrets in `.env` file and user command like below to start server
`docker-compose --env-file .env up`

In this process, I am struggle with `PnP` package manangement.

##### Stage 2: Deploy application in AWS through UI provided by AWS.

It will use ec2 with docker to deploy service. It will use RDS to set up a postgreSQL instance. The service will connect db through docker file.

1. Set up an ec2 instance from aws UI. It needs to create a key pair. After download key pair, it need to change permission of this file first with command `chmod 400 deployment.pem`. And then it is possible to connect instance with ssh.

   - Install docker commands.

2. Set up a postgreSQL database through aws RDS service, also use aws UI.

   - special configuration: db vpc should be same as ec2 instance.

3. Upload project file to aws ec2 instance, use `scp -r -i "deployment.pem" ./  ec2-user@ec2-3-71-21-245.eu-central-1.compute.amazonaws.com:/home/ec2-user/nestjs-deployment` to upload project file to aws ec2 instance.

4. Setup db connection

   - Make sure it is possible to connect database from ec2 instance to RDS. It could be done by follow the document provide by aws. See in reference 5. `psql --host=endpoint --port=5432 --dbname=postgres --username=postgres`, mostly only need to change `endpoint`.

   - It needs to setup an `parameter groups` of database first, and change `rds.forcerds.force_ssl` from 1 to 0. See in reference 4.

   - It needs to create database in db instance. Maybe it depends on project. In this nestjs demo project, It needs to setup database manually before start running service in the docker.

##### Stage 3: Use terraform IAC to create `hardware` for server.

1. Understanding network security and configuration in aws

##### Stage 4: Integration deployment with github actions.

#### Reference

1. [Interacting with a Postgres Server on an EC2 Instance From A Docker Container](https://medium.com/@afimaamedufie/interacting-with-a-postgres-server-on-an-ec2-instance-from-a-docker-container-75aeb7f32eec)

2. [Step-by-Step Guide to Install Docker on Amazon Linux machine in AWS](https://medium.com/@srijaanaparthy/step-by-step-guide-to-install-docker-on-amazon-linux-machine-in-aws-a690bf44b5fe)

3. [How To configure Docker & Docker-Compose in AWS EC2 [Amazon Linux 2023 AMI]](https://medium.com/@fredmanre/how-to-configure-docker-docker-compose-in-aws-ec2-amazon-linux-2023-ami-ab4d10b2bcdc)

4. [RDS while connection error: no pg_hba.conf entry for host](https://stackoverflow.com/questions/76899023/rds-while-connection-error-no-pg-hba-conf-entry-for-host)

5. [Step 3: Connect to a PostgreSQL DB instance](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_GettingStarted.CreatingConnecting.PostgreSQL.html#CHAP_GettingStarted.Connecting.PostgreSQL)
