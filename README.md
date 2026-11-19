# Cloud-Native Capstone Microservices
***

Project: Capstone  
Architecture: Spring Boot Microservices on cloud-native infrastructure
Cloud Provider: Amazon Web Services  
Infrastructure as Code: Terraform  
Application Runtime: Spring Boot / Java  
Container Platform: Amazon ECS Fargate  
CI/CD: GitHub Actions  
Primary Region: Singapore (ap-southeast-1)  
DR Region: Tokyo (ap-northeast-1)  
Architecture Style: Microservices, API Gateway Pattern, Multi-Region Disaster Recovery  

## Project Overview  
***
### Introduction  
***
 - This project demonstrates the design, implementation and deployment of a cloud-native microservices platform using Spring Boot and Amazon Web Services.
 - The application is decomposed into independently deployable services, with each microservice responsible for a specific application capability. Services communicate through defined API contracts and operate within a secured AWS environment.
 - The platform uses Amazon ECS Fargate to run containerized Spring Boot applications, Application Load Balancer and CloudFront to expose application endpoints, and Amazon Aurora PostgreSQL to provide persistent data storage.
 - Infrastructure provisioning and application deployment are managed through Terraform and GitHub Actions, providing repeatable infrastructure deployment and automated CI/CD workflows.
 - Beyond application deployment, the platform incorporates security controls, database connection management, observability, performance testing and a multi-region Pilot Light disaster recovery strategy.

### Project Objective
***
 - Design and implement a modular Spring Boot microservices architecture.
 - Deploy independently containerized services on AWS.
 - Establish secure communication between microservices.
 - Implement centralized application entry through the BFF pattern.
 - Provide reliable database access using Aurora PostgreSQL and RDS Proxy.
 - Implement authentication and authorization using Spring Security / Amazon Cognito.
 - Automate infrastructure provisioning through Terraform.
 - Automate application build and deployment using GitHub Actions.
 - Monitor application health and infrastructure performance.
 - Design a multi-region disaster recovery solution.
 - Evaluate architecture decisions through technical trade-off analysis.

### Technology Stack
***
The platform is built using a layered architecture, combining Spring Boot microservices, AWS managed services, Infrastructure as Code, and automated CI/CD pipelines.

#### Application Layer — Backend Microservices
| Technology         | Purpose                                                                         |
|--------------------|---------------------------------------------------------------------------------|
| Java               | Primary programming language for backend application development                |
| Spring Boot        | Framework for building independently deployable microservices and REST APIs     |
| Spring Web         | RESTful API development and HTTP request handling                               |
| Spring Security    | Authentication, authorization, and security configuration                       |
| Spring Data / JDBC | Database access and persistence                                                 |
| Hibernate / JPA    | Object-relational mapping                                                       |
| Maven              | Dependency management, application compilation, and build automation            |
| JUnit              | Unit and integration testing                                                    |

#### Application Communication
| Technology                 | Purpose                                                                         |
|----------------------------|---------------------------------------------------------------------------------|
| REST API                   | Communication between frontend clients, BFF, and backend services               |
| Backend-for-Frontend (BFF) | Aggregates backend APIs and provides a dedicated interface for client consuming |
| Amazon ECS Service Connect | Service discovery and internal communication between ECS microservices          |
| Mutual TLS (mTLS)          | Secured service-to-service communication and client certificate authentication  |
| HTTP / HTTPs               | Object-relational mapping                                                       |


#### Identity and Security
| Technology          | Purpose                                                                     |
|---------------------|-----------------------------------------------------------------------------|
| Amazon Cognito      | Identity management, user authentication, and token issuance                |
| JWT                 | Stateless authentication and identity propagation                           |
| Lambda@Edge         | JWT validation at the CloudFront edge before requests reach the application |
| AWS Secrets Manager | Secure storage and retrieval of credentials and sensitive configuration     |
| AWS IAM             | Fine-grained access control for AWS resources and application workloads     |
| IAM Roles           | Grant AWS permissions to application containers without static credentials  |

#### Data Layer
| Technology               | Purpose                                                                                               |
|--------------------------|-------------------------------------------------------------------------------------------------------|
| Amazon Aurora PostgreSQL | Relational database supporting transactional application workloads                                    |
| Aurora Global Database   | Cross-region database replication supporting disaster recovery                                        |
| Amazon RDS Proxy         | Database connection pooling, connection management, and improved application-to-database connectivity |
| HikariCP                 | Application-level JDBC connection pooling                                                             |
| Amazon ElastiCache       | Distributed in-memory data stored and reduce database load                                            |

#### Containerization and Compute Layer
| Technology           | Purpose                                                                                             |
|----------------------|-----------------------------------------------------------------------------------------------------|
| Docker               | Containerization of Spring Boot microservices                                                       |
| Amazon ECR           | Private container image registry                                                                    |
| Amazon ECS           | Container orchestration and service management                                                      |
| AWS Fargate          | Serverless container compute for running microservices without managing                             |
| ECS Task Definitions | Define application containers, resources, environment variables, secrets, and runtime configuration |
| EC2                  | Bastion host as single secure entry point connect to private resources (Aurora, Valkey)             |
| AWS Lambda           | Executes logic as serverless modelization                                                           |

 
#### Networking and CDN Layer
| Technology                         | Purpose                                                                       |
|------------------------------------|-------------------------------------------------------------------------------|
| Amazon VPC                         | Isolated networking environment for AWS workloads                             |
| Public and Private Subnets         | Network segmentation for internet-facing and internal resources               |
| Internet Gateway                   | Internet connectivity for public-facing infrastructure                        |
| NAT Gateway                        | Outbound internet connectivity for private subnet workloads                   |
| VPC Endpoints                      | Secured internal connect from VPC to AWS services                             |
| Network Access Control List (NACL) | Stateless network access control                                              |
| Security Groups                    | Stateful network access control                                               |
| Route Tables                       | Control network traffic routing between subnets and network destinations      |
| Application Load Balancer (ALB)    | HTTP routing and traffic distribution to application services                 |
| Amazon CloudFront                  | Global content delivery, HTTPS entry point, edge routing, and reduced latency |

#### Infrastructure as Code
| Technology         | Purpose                                                               |
|--------------------|-----------------------------------------------------------------------|
| Terraform          | Infrastructure provisioning, configuration, and lifecycle management  |
| Terraform Modules  | Reusable and modular infrastructure components                        |
| Terraform State    | Tracks deployed infrastructure and resource relationships             |

#### CI/CD and Automation
| Technology                | Purpose                                                                  |
|---------------------------|--------------------------------------------------------------------------|
| GitHub                    | Source code management and collaboration                                 |
| GitHub Actions            | Automated CI/CD workflows                                                |
| GitHub Actions OIDC       | Secure federated authentication between GitHub and AWS                   |
| ECS Deployment Management | Automates how containerized applications are rolled out, updated, scaled |

#### Observability and Monitoring
| Technology            | Purpose                                                                                    |
|-----------------------|--------------------------------------------------------------------------------------------|
| CloudWatch Logs       | Application, container, and infrastructure logs                                            |
| CloudWatch Metrics    | Monitoring application and infrastructure performance                                      |
| CloudWatch Alarms     | Detect abnormal infrastructure and application conditions                                  |
| CloudWatch Synthetics | End-to-end availability monitoring through synthetic requests                              |
| Amazon EventBridge    | Event-driven integration between monitoring, incident detection, and automation components |

#### Disaster Recovery and Resilience
| Technology             | Purpose                                                                                    |
|------------------------|--------------------------------------------------------------------------------------------|
| Aurora Global Database | Cross-region database replication                                                          |
| AWS Step Functions     | Orchestrates disaster recovery workflows                                                   |
| Amazon DynamoDB        | Stores incident state, health signals, approval records, and recovery workflow metadata    |
| Amazon SNS             | Sends operator notifications and disaster recovery alerts                                  |


## Project Architecture
***
![Project Architecture Diagram](images/Capstone-Architecting.jpg)






