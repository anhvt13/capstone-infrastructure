# Cloud-Native Capstone Microservices

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
### Introduction
 - This project demonstrates the design, implementation and deployment of a cloud-native microservices platform using Spring Boot and Amazon Web Services.
 - The application is decomposed into independently deployable services, with each microservice responsible for a specific application capability. Services communicate through defined API contracts and operate within a secured AWS environment.
 - The platform uses Amazon ECS Fargate to run containerized Spring Boot applications, Application Load Balancer and CloudFront to expose application endpoints, and Amazon Aurora PostgreSQL to provide persistent data storage.
 - Infrastructure provisioning and application deployment are managed through Terraform and GitHub Actions, providing repeatable infrastructure deployment and automated CI/CD workflows.
 - Beyond application deployment, the platform incorporates security controls, database connection management, observability, performance testing and a multi-region Pilot Light disaster recovery strategy.

### Project Objective
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

### Feature
 - View Drivers - List all drivers with team
 - Add Driver - Create new driver record
 - Delete Driver - Remove driver record
 - Update Driver  - Modify driver record


### Technology Stack
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
| Technology           | Purpose                                                                    |
|----------------------|----------------------------------------------------------------------------|
| Spring Security      | Application-level authentication and authorization framework               |
| Amazon Cognito       | Identity management, user authentication, and token issuance               |
| JSON Web Token (JWT) | Carries signed authentication and authorization claims                     |
| Lambda@Edge          | Performs JWT validation at the CloudFront edge                             |
| AWS Secrets Manager  | Secure storage and retrieval of credentials and sensitive configuration    |
| AWS IAM              | Fine-grained access control for AWS resources and application workloads    |
| IAM Roles            | Grant AWS permissions to application containers without static credentials |

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


## Project Architecture Overview

![Project Architecture Diagram](images/Capstone-Architecting.jpg)

### Microservices Architecture
 - The application follows a microservices architecture in which application capabilities are separated into independently deployable Spring Boot services.
 - Instead of exposing every backend service directly to external clients, the platform uses a Backend-for-Frontend (BFF) service as the primary application entry point.
 - The BFF coordinates incoming client requests and communicates with internal services through private service-to-service connectivity.
#### BFF-service
 - Repository https://github.com/anhvt13/capstone-bff-client
 - Responsibility
   - Exposing client-facing REST APIs
   - Validating incoming requests
   - Coordinating calls to internal microservices
   - Aggregating responses from backend services  
 - Design Consideration  
    - Keep the BFF focused on client-facing orchestration  
    - Avoid implementing business logic that belongs to domain services  
    - Avoid direct database access where data ownership belongs to another microservice  
   
#### Driver-service
 - Repository: https://github.com/anhvt13/capstone-driver-service
 - Responsibility
   - Exposing internal REST APIs
   - Encapsulates driver-related business operations
   - Managing its database interactions
 - Design Consideration
   - Keep Driver business logic independent of the BFF
   - Restrict access to internal network paths
   - Authenticate and authorize service-to-service communication
   - Maintain controlled database connection pooling

#### Microservices Communication
 - Decision made: BFF service communicates with Driver service through native ECS Service Connect connectivity
 - Alternatives considered: 
    - AWS Cloud Map for service discovery: DNS resolves the service name to task IPs -> DNS resolution could leads to stale addresses, does not support the traffic-distribution
    - Internal ALB for traffic distribution -> introduce additional target group, health-check capabilities to maintain 
 - Advantages: build-in services discovering and round-robin load balancing distribution without additional managed resources
 - Disadvantages: introduces an additional managed sidecar proxy into ecs task's networking architecture
 - Consequences:
   - Simplified internal service discovery, reduced need for dedicated internal load balancers
   - Additional ECS Service Connect configuration, troubleshooting becomes more complicated

### Authentication Architecture
 - The project implements a centralized, token-based authentication architecture using OAuth 2.0, OpenID Connect (OIDC), Amazon Cognito, and Spring Security.
 - Amazon Cognito acts as the centralized Identity Provider and Authorization Server, responsible for authenticating users and issuing access tokens and ID tokens. Spring Security integrates with Cognito to secure Spring Boot applications

#### Authentication Microservices
 - The architecture adopts two OAuth 2.0 grant types to address different authentication requirements:
 - Authorization Code Grant: The BFF acts as an OAuth2 server, while Amazon Cognito as authorization server handles customer authentication and token issuance.
 - Client Credentials Grant: Does not involve an interactive login or an individual user. The BFF authenticates itself as a confidential OAuth2 client using its dedicated client ID and client secret against Driver-service as OAuth2 server. Amazon Cognito issues an access token representing the BFF application, establish machine-to-machine authentication.

 ![Authentication Architecture Diagram](images/Capstone-Authentication.jpg)

#### Google as External Identity Provider
- Decision made: Google is adopted as an external federated Identity Provider, while Amazon Cognito remains the centralized Authorization Server and identity integration layer.
- Alternatives considered: Cognito-native authentication alone 
  - Self-manage customer credential lifecycle operations
  - Limited Identity Provider Flexibility: Customers are restricted to authentication methods supported directly by the Cognito User Pool
- Advantages:
  - Simplified customer sign-in: Customers can authenticate using their existing Google account without creating and remembering another application-specific credential
  - Delegated identity verification: Google handles the authentication process, reducing the Cognito's responsibility for credential verification
  - Identity-provider flexibility: Another external identity providers can be integrated through Cognito without requiring major changes authentication architecture
- Disadvantages:
  - External-provider dependency: Google authentication introduces dependency on Google's authentication policies
  - Increased configuration complexity: Federation requires configuring Google OAuth credentials, Cognito identity-provider settings, attribute mappings, callback URLs, and allowed OAuth scopes
- Consequences:
  - Amazon Cognito remains the application's centralized Authorization Server and token issuer
  - The architecture introduces additional configuration and operational complexity compared with Cognito-native authentication alone




