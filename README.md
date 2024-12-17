# VPC Test

Difference between EC2 & Lambda.

EC2 instance can live in a subnet with routing to **IGW** (internet gateway) and have access to internet.

Lambda function needs to live in a subnet with routing to a **NAT** gateway in order to have access to internet. 