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
| Technology        | Purpose                                                              |
|-------------------|----------------------------------------------------------------------|
| Java/ Spring Boot | Core backend development and independently deployable microservices  |
| Spring Web        | RESTful API development and HTTP request handling                    |
| Spring Security   | Authentication, authorization, and security configuration            |
| Spring Data/ JPA  | Database access, persistence, and object-relational mapping          |
| Maven             | Dependency management, application compilation, and build automation |
| JUnit             | Unit and integration testing                                         |

#### API Communication & Identity Security
| Technology                           | Purpose                                                                        |
|--------------------------------------|--------------------------------------------------------------------------------|
| REST API/ Backend-for-Frontend (BFF) | Client-facing API layer and communication between backend services             |
| Amazon ECS Service Connect           | Service discovery and internal communication between ECS microservices         |
| Mutual TLS (mTLS)                    | Secured service-to-service communication and client certificate authentication |
| Spring Security                      | Application-level authentication and authorization framework                   |
| Amazon Cognito                       | Identity management, user authentication, and token issuance                   |
| JSON Web Token (JWT)                 | Carries signed authentication and authorization claims                         |
| Lambda@Edge                          | Performs JWT validation at the CloudFront edge                                 |
| AWS Secrets Manager                  | Secure storage and retrieval of credentials and sensitive configuration        |
| AWS IAM/IAM Roles                    | Fine-grained access control for AWS resources and application workloads        |

#### Data Management & Persistence
| Technology                  | Purpose                                                                                               |
|-----------------------------|-------------------------------------------------------------------------------------------------------|
| Amazon Aurora PostgreSQL    | Relational database supporting transactional application workloads                                    |
| Aurora Global Database      | Cross-region database replication supporting disaster recovery                                        |
| Amazon RDS Proxy            | Database connection pooling, connection management, and improved application-to-database connectivity |
| HikariCP                    | Application-level JDBC connection pooling                                                             |
| Amazon ElastiCache (Valkey) | Distributed in-memory data stored and reduce database load                                            |

#### Containerization & Compute
| Technology              | Purpose                                                                                             |
|-------------------------|-----------------------------------------------------------------------------------------------------|
| Docker                  | Containerization of Spring Boot microservices                                                       |
| Amazon ECR              | Private container image registry                                                                    |
| Amazon ECS/ AWS Fargate | Container orchestration and Serverless container compute                                            |
| ECS Task Definitions    | Define application containers, resources, environment variables, secrets, and runtime configuration |
| EC2                     | Bastion host as single secure entry point connect to private resources (Aurora, Valkey)             |
| AWS Lambda              | Executes logic as serverless modelization                                                           |

#### Networking & Content Delivery
| Technology                             | Purpose                                                                       |
|----------------------------------------|-------------------------------------------------------------------------------|
| Amazon VPC                             | Isolated networking environment for AWS workloads                             |
| Subnets, Internet Gateway, Route Table | Network segmentation and traffic routing                                      |
| NAT Gateway/ VPC Endpoints             | Outbound internet access and private connectivity to AWS services             |
| Security Groups / NACLs                | Stateful and stateless network access control                                 |
| Application Load Balancer (ALB)        | HTTP routing and traffic distribution to application services                 |
| Amazon CloudFront                      | Global content delivery, HTTPS entry point, edge routing, and reduced latency |

#### Infrastructure Automation & CI/CD
| Technology                | Purpose                                                                  |
|---------------------------|--------------------------------------------------------------------------|
| Terraform                 | Infrastructure provisioning, configuration, and lifecycle management     |
| Terraform Modules         | Reusable and modular infrastructure components                           |
| Terraform State           | Tracks deployed infrastructure and resource relationships                |
| GitHub                    | Source code management and collaboration                                 |
| GitHub Actions            | Automated CI/CD workflows                                                |
| GitHub Actions OIDC       | Secure federated authentication between GitHub and AWS                   |
| ECS Deployment Management | Automates how containerized applications are rolled out, updated, scaled |

#### Observability & Monitoring
| Technology                                | Purpose                                                                                    |
|-------------------------------------------|--------------------------------------------------------------------------------------------|
| Amazon CloudWatch Logs, Metrics & Alarms  | Centralized logging, performance monitoring, and operational alerting                      |
| CloudWatch Synthetics                     | End-to-end availability monitoring through synthetic requests                              |
| Amazon EventBridge                        | Event-driven integration between monitoring, incident detection, and automation components |

#### Disaster Recovery & Resilience
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

#### Solution - ECS Service Connect for microservices communication
 - Decision made: BFF service communicates with Driver service through native ECS Service Connect connectivity
 - Alternatives considered: 
    - AWS Cloud Map for service discovery: DNS resolves the service name to task IPs -> DNS resolution could leads to stale addresses, does not support the traffic-distribution
    - Internal ALB for traffic distribution -> introduce additional target group, health-check capabilities to maintain 
 - Advantages: Build-in services discovering and round-robin load balancing distribution without additional managed resources
 - Disadvantages: Introduces an additional managed sidecar proxy into ecs task's networking architecture
 - Trade-off:
   - Simplified service discovery, reduced need for dedicated internal load balancers
   - Additional ECS Service Connect configuration, troubleshooting becomes more complicated

### Authentication Architecture
 - The project implements a centralized, token-based authentication architecture using OAuth 2.0, OpenID Connect (OIDC), Amazon Cognito, and Spring Security.
 - Amazon Cognito acts as the centralized Identity Provider and Authorization Server, responsible for authenticating users and issuing access tokens and ID tokens. Spring Security integrates with Cognito to secure Spring Boot applications

#### Application-Layer Authorization
 - The architecture adopts two OAuth 2.0 grant types to address different authentication requirements:
 - Authorization Code Grant: The BFF acts as an OAuth2 server, while Amazon Cognito as authorization server handles customer authentication and token issuance.
 - Client Credentials Grant: Does not involve an interactive login or an individual user. The BFF authenticates itself as a confidential OAuth2 client using its dedicated client ID and client secret against Driver-service as OAuth2 server. Amazon Cognito issues an access token representing the BFF application, establish machine-to-machine authentication.
 
![Application-Layer Authentication architecture](images/Capstone-Authentication.jpg)

#### Solution - Google as External Identity Provider
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
- Trade-off:
  - Amazon Cognito remains the application's centralized Authorization Server and token issuer
  - The architecture introduces additional configuration and operational complexity compared with Cognito-native authentication alone

#### Transport-Layer Authentication
 - Mutual Transport Layer Security (mTLS) is implemented to secure internal communication between backend microservices. mTLS requires both the client and server to authenticate each other using trusted certificates issued by a trusted authority can establish a connection.
 - Benefits:
   - Encrypted Communication: Protects data exchanged between microservices against interception
   - Combines transport-level authentication with OAuth 2.0 application-level authorization to strengthen service-to-service security through defense in depth

 ![Authentication Architecture Diagram](images/Capstone-mTLS.jpg)
 - Solution for improvement: Strengthen communication between CloudFront and the Application Load Balancer (ALB) with mTLS
 - Outcome: Establish End-to-End Transport Security 


### Database Architecture
#### Solution - Leverage Amazon RDS Proxy
- Decision made: Use Amazon RDS Proxy as the database connection layer between ECS Fargate microservices and Aurora PostgreSQL Serverless
- Alternative considered: Direct Aurora Connection
  - Frequent ECS task scaling can cause repeated database connection establishment and termination, increasing connection-management overhead on Aurora.
- Advantages:
  - Connection Pooling: Reuses established database connections to reduce connection overhead
  - Failover Resilience: RDS Proxy can queue incoming requests while the writer is unavailable, then send them to the new writer once it is available, it also doesn't have to rely on the application's DNS resolution and caching behavior to find the new writer
- Disadvantages:
  - Introduces additional infrastructure cost and a network infrastructure
  - RDS Proxy must register a specific regional Aurora DB cluster as its target. Can NOT configure RDS Proxy to use the Aurora Global Database writer endpoint directly as its targets
- Trade-off:
  - Improve database connection management and failover resilience
  - Introduces additional cost and infrastructure complexity

#### Solution - Leverage Amazon ElastiCache for Valkey
- Decision made: ElastiCache for Valkey as a distributed caching layer for selected frequently accessed data
- Alternative considered: Retrieve data directly from Aurora PostgreSQL without an additional caching layer
   - Database capacity may become a bottleneck as application traffic peaks
- Advantages:
   - Low-Latency Data Access: Retrieves frequently accessed data from in-memory storage instead of repeatedly querying Aurora
   - Horizontal Scalability: Provides a shared distributed caching across horizontally ECS services scale. Reduces per-instance cache duplication
- Disadvantages:
   - Introduces additional infrastructure costs and network communication between applications and the cache
   - Requires cache invalidation and expiration strategies to prevent stale data
- Trade-off:
   - Repeated database queries can be reduced for workloads with high cache-hit rates
   - Cache invalidation, expiration (TTL), and consistency strategies must be implemented and maintained

### Disaster Recovery (DR) Architecture
#### Solution - Pilot Light Strategy
- Decision made: Singapore as the primary production region and Tokyo as the disaster recovery region. Provisioned most critical core resources on DR region (VPC, subnets, Aurora Global Database). Keep other resources scaled to 0 until DR is activated
- Advantages:
   - Cost-effective compare to full scaled strategy (warm standby/ active-active). Reducing cost on resource hourly charges (NAT gateway, interface endpoint, RDS proxy)
   - Well-organized infrastructure, rapidly scale up to full production capacity
- Disadvantages:
   - Higher RTO/RPO compare to full scaled strategy due to need of deploy and scale infrastructure
   - Required operate a global database failover in order to promote the secondary cluster to primary (writer)
   - Keep a single terraform source for provisioning infrastructures on multi-region require extra effort in state management in order to prevent conflicts and duplicate resources
- Trade-off:
   - Cost-effective, RTO ~ 6 mins
   - Extra effort in modular architecture and state resources management on terraform

### Infrastructure as Code
#### Terraform Infrastructure
- The AWS infrastructure is provisioned and managed using Terraform, enabling repeatable deployments, consistent infrastructure configuration, and version-controlled infrastructure changes
- Organized into three main Terraform projects

| Module                 | Resources                                                                                                                                                                                                          |
|------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| aws-infrastructure     | Main cloud-native infrastructure responsible for provisioning and managing application platform resources, network, compute services, databases, load balancing, security, monitoring, and supporting AWS services |
| legacy-network         | Foundational network infrastructure that provisions the required networking resources for both the primary and DR regions - including VPCs, db-subnets, security groups                                            |
| secrets-infrastructure | Responsible for managing AWS Secrets Manager resources used to securely store and manage sensitive application and infrastructure data, including TLS certificates, database credentials                           |

#### Infrastructure Design Principles
 - Modularity: Organizes infrastructure into reusable Terraform modules, separating application infrastructure, networking, database resources, security, and supporting services
 - Multi-Region support: Uses multiple AWS provider configurations to provision and manage resources across Singapore (ap-southeast-1) and Tokyo (ap-northeast-1), supporting the Aurora Global Database and regional disaster recovery architecture
 - Reusability: Stores Terraform state in Amazon S3, allowing infrastructure resources are reusable and accessed across deployment workflows
 - Security: Manage sensitive information through AWS Secrets Manager rather than hardcoding credentials or certificates into infrastructure configuration
 - Automation: Integrate Terraform operations with GitHub Actions to reduce manual deployment steps
    
