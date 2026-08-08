# Docker Containers

> **Automation-Lab Documentation**
> **Author:** Sanvi Sharma
> **Version:** 1.0

---
# 📚 Table of Contents
MODULE 03 — Docker Containers
1. What is a Container?
2. Container Architecture
3. Image vs Container
4. Container Lifecycle
5. Running Containers
6. Listing Containers
7. Starting Containers
8. Stopping Containers
9. Restarting Containers
10. Pausing Containers
11. Removing Containers
12. Inspecting Containers
13. Viewing Logs
14. Executing Commands Inside Containers
15. Attaching to Containers
16. Container Resource Limits
17. Best Practices
18. Common Mistakes
19. Summary

---
# MODULE 03

# Docker Containers

> "If Docker Images are blueprints,
> Docker Containers are the actual running applications."

---

# Module Overview

In the previous module, we explored **Docker Images**, which are immutable templates used to package applications and their dependencies.

However, an image by itself does nothing.

An image cannot execute code.

It cannot serve web pages.

It cannot respond to API requests.

It cannot store temporary data.

To transform an image into a running application, Docker creates a **Container**.

A Docker Container is a lightweight, isolated runtime environment created from a Docker Image.

Every application you run using Docker eventually executes inside a container.

Whether you're deploying:

- a web application
- a database
- an AI model
- a microservice
- a reverse proxy

everything ultimately runs inside one or more Docker Containers.

Understanding containers is therefore one of the most important milestones in learning Docker.

---

# Learning Objectives

After completing this module, you will be able to:

✔ Understand what Docker Containers are.

✔ Explain the relationship between Images and Containers.

✔ Run containers using Docker CLI.

✔ Understand the Container Lifecycle.

✔ Manage running containers.

✔ Execute commands inside containers.

✔ Understand Detached and Interactive modes.

✔ Monitor container resources.

✔ Work with logs.

✔ Understand container storage.

✔ Understand container networking.

✔ Apply production-ready container best practices.

---

# Prerequisites

Before beginning this module, you should already understand:

- Docker Architecture
- Docker Images
- Docker Image Layers
- Image Tags
- Image Lifecycle
- Docker Hub
- Docker Build Process

If not,

complete Module 02 first.

---

# Why This Module Matters

Many beginners believe Docker Images are the most important concept.

In reality,

containers are what actually execute applications.

For example,

when you visit

```
www.netflix.com
```

or

```
api.spotify.com
```

you are interacting with applications running inside thousands of containers distributed across cloud servers.

Modern cloud-native infrastructure is built around containers.

Understanding containers opens the door to:

- Kubernetes
- Docker Compose
- CI/CD Pipelines
- Microservices
- DevOps
- Cloud Computing

---

# Real-World Analogy

Imagine an architect designing a house.

First,

the architect prepares a blueprint.

```
Blueprint

↓

House Construction

↓

Family Lives Inside
```

Docker follows the same idea.

```
Docker Image

↓

Docker Container

↓

Running Application
```

The image is the blueprint.

The container is the actual house.

---

# Module Roadmap

Throughout this module,

we will build our understanding step by step.

```
Introduction

↓

Running Containers

↓

Managing Containers

↓

Working Inside Containers

↓

Storage

↓

Networking

↓

Resource Management

↓

Lifecycle

↓

Production Best Practices

↓

Labs

↓

Mini Project
```

Each section builds on the previous one.

Do not skip sections.

Docker concepts become much easier when learned sequentially.

---

# Expected Outcome

By the end of this module,

you will be comfortable:

- launching containers
- stopping containers
- inspecting containers
- debugging containers
- connecting containers
- storing data
- managing resources

These skills form the foundation of modern containerized application development.

---

# Key Takeaway

A Docker Image is only a template.

A Docker Container is the running application created from that template.

Everything you deploy with Docker eventually runs inside one or more containers.

This module is dedicated to understanding how those containers are created, managed, monitored, and optimized.

---

# What is a Docker Container?

---

## Learning Objectives

After completing this section, you will be able to:

- Define a Docker Container.
- Explain how a container is created.
- Understand the relationship between Images and Containers.
- Explain why containers are lightweight.
- Understand container isolation.
- Understand what actually happens when a container starts.
- Differentiate containers from traditional applications.

---

# Introduction

In Module 02, we learned that a Docker Image is a blueprint.

However,

a blueprint alone cannot perform any work.

Imagine having the blueprint of a house.

Can you live inside it?

No.

The blueprint only describes **how the house should be built.**

Similarly,

a Docker Image only describes:

- the operating system
- installed software
- application code
- dependencies
- startup command

Until Docker creates a running instance,

the image remains inactive.

That running instance is called a **Container.**

---

# Definition

A Docker Container is an isolated runtime environment created from a Docker Image.

It contains everything required for an application to execute,

including:

- application code
- libraries
- runtime
- dependencies
- configuration

while sharing the host machine's operating system kernel.

In simple words,

> A Docker Container is a running application packaged inside an isolated environment.

---

# Breaking Down the Definition

Let's simplify the definition.

**"Running Application"**

The application is actually executing.

It consumes CPU.

It consumes memory.

It performs tasks.

Unlike an Image,

a container is alive.

---

**"Packaged"**

Everything the application needs already exists inside the container.

For example,

a Python application contains:

- Python Interpreter
- Required Packages
- Application Code
- Configuration Files

Everything travels together.

---

**"Isolated Environment"**

Even though multiple containers run on the same computer,

they cannot directly interfere with one another.

Each container behaves as though it owns its own:

- filesystem
- processes
- network interfaces
- hostname

This isolation is one of Docker's biggest strengths.

---

# Real-World Analogy

Imagine a large apartment building.

Each apartment contains:

- furniture
- kitchen
- bedroom
- bathroom
- television

Families live independently.

One family cannot accidentally rearrange another family's furniture.

Yet,

all apartments share the same building.

Docker works similarly.

```
Host Operating System

│

├── Container A

├── Container B

├── Container C

└── Container D
```

Each container is isolated,

but all share the same underlying operating system.

---

# Image vs Container

Imagine a recipe book.

```
Recipe

↓

Cook Meal

↓

Serve Food
```

The recipe itself is not food.

It only describes how to prepare it.

Docker follows the same principle.

```
Docker Image

↓

docker run

↓

Docker Container
```

The Image describes the application.

The Container runs the application.

---

# One Image, Many Containers

A single Docker Image can create multiple Containers.

Example:

```
Python Image

│

├── Container 1

├── Container 2

├── Container 3

└── Container 4
```

Each container runs independently.

If one container crashes,

the others continue running.

---

# What Happens When You Run a Container?

Suppose you execute:

```bash
docker run nginx
```

Internally,

Docker performs several operations.

```
Locate Image

↓

Image Exists?

↓

Yes

↓

Create Writable Layer

↓

Allocate Container ID

↓

Configure Network

↓

Mount Filesystem

↓

Start Process

↓

Container Running
```

Notice something important.

Docker does **not** modify the original Image.

Instead,

it creates a new writable layer on top of the Image.

The Image remains unchanged.

---

# Why Containers Are Lightweight

Virtual Machines include an entire operating system.

Containers do not.

Containers share the host operating system kernel.

```
Host Kernel

│

├── Container A

├── Container B

├── Container C
```

Because containers avoid duplicating the kernel,

they:

- start quickly
- consume less memory
- require less storage
- achieve higher density on a single server

This efficiency is one of Docker's greatest advantages.

---

# Container Isolation

Although containers share the same kernel,

they remain isolated.

Each container has its own:

- Process Space
- Network Stack
- Filesystem View
- Hostname
- User Space

A process running inside one container normally cannot access another container's internal processes or files.

Docker achieves this isolation using Linux kernel features such as **Namespaces** and **Control Groups (cgroups)**.

You don't need to master these yet—we'll explore them in later modules.

---

# Container State

A container is not always running.

It transitions through different states.

```
Created

↓

Running

↓

Paused

↓

Stopped

↓

Removed
```

We'll explore the full lifecycle in a later section of this module.

---

# Containers Are Temporary

One of Docker's core philosophies is that containers should be **ephemeral**.

That means they can be:

- created quickly
- destroyed quickly
- recreated whenever needed

If a container fails,

it is often replaced instead of repaired.

This makes deployments more reliable and repeatable.

---

# Industry Perspective

Modern organizations rely heavily on containers.

Examples include:

- Web Applications
- REST APIs
- Machine Learning Services
- Databases
- Reverse Proxies
- Background Workers
- Microservices

Companies such as Netflix, Spotify, Amazon, Google, and Uber run millions of containers every day to power their platforms.

---

# Best Practices

✅ Keep one primary application per container.

✅ Treat containers as disposable.

✅ Store persistent data outside containers using volumes.

✅ Avoid making manual changes inside running production containers.

✅ Build new images instead of modifying existing containers.

---

# Common Mistakes

❌ Thinking a container is the same as an image.

❌ Treating containers like virtual machines.

❌ Storing important data only inside containers.

❌ Logging into production containers to make manual changes.

❌ Running many unrelated applications inside a single container.

---

# Interview Questions

### Q1. What is a Docker Container?

### Q2. What is the relationship between an Image and a Container?

### Q3. Why are Docker Containers lightweight?

### Q4. Can multiple containers be created from a single image?

### Q5. Why are containers considered ephemeral?

---

# Mini Lab

## Objective

Create your first container.

### Tasks

1. Pull the latest Ubuntu image.

```bash
docker pull ubuntu
```

2. Run an interactive container.

```bash
docker run -it ubuntu
```

3. Verify that you are inside the container.

4. Exit the container.

5. List all containers.

```bash
docker ps -a
```

Observe that the container still exists, even though it has stopped.

---

# Summary

In this section, you learned:

- What a Docker Container is.
- How containers are created from images.
- Why containers are lightweight.
- How container isolation works.
- Why containers are considered temporary.
- The relationship between images and containers.
- The internal workflow that occurs when a container starts.

A Docker Container is the running execution environment that transforms a static Docker Image into a functioning application.

# Why Do We Need Containers?

---

## Learning Objectives

After completing this section, you will be able to:

- Understand the problems of traditional software deployment.
- Explain why Docker Containers were introduced.
- Understand the concept of "Works on My Machine."
- Recognize the advantages of containerization.
- Explain why containers have become the industry standard.

---

# Introduction

Imagine you have developed a web application on your laptop.

Everything works perfectly.

The application starts successfully.

The database connects without issues.

The APIs respond correctly.

You test everything thoroughly and confidently send the project to your teammate.

A few minutes later, you receive a message:

> "The application doesn't work on my machine."

This single sentence became one of the biggest frustrations in software development.

It highlighted a major challenge:

Applications behaved differently depending on where they were executed.

Docker Containers were created to solve exactly this problem.

---

# The Traditional Deployment Problem

Before Docker, deploying software was often a difficult and time-consuming process.

A developer would build an application on one machine, while the production server had a completely different environment.

Even small differences could cause failures.

Examples include:

- Different operating system versions
- Different programming language versions
- Missing libraries
- Different package dependencies
- Different environment variables
- Different database configurations

Although the application itself was correct, the surrounding environment was not.

---

# Real-World Analogy

Imagine a chef preparing a special recipe.

The recipe requires:

- A gas stove
- A specific type of pan
- Fresh ingredients
- A particular oven temperature

Now imagine asking another chef to recreate the same dish without providing those tools or ingredients.

The recipe may be correct, but the result will likely be different.

Software behaves in the same way.

An application depends not only on its code but also on its entire execution environment.

---

# The "Works on My Machine" Problem

Consider the following scenario.

### Developer's Laptop

```text
Ubuntu 24.04

Python 3.12

Node.js 22

Redis 8

PostgreSQL 17

Application Works ✅
```

### Testing Server

```text
Ubuntu 22.04

Python 3.10

Node.js 18

Redis Missing

PostgreSQL 15

Application Fails ❌
```

The source code is identical.

The only difference is the environment.

Yet the application behaves differently.

This became one of the biggest deployment challenges before containers.

---

# Traditional Solution

Before Docker, teams often documented every requirement manually.

For example:

```
Install Ubuntu

↓

Install Python

↓

Install Pip

↓

Install Dependencies

↓

Install Database

↓

Configure Environment Variables

↓

Install Redis

↓

Start Application
```

A single mistake during setup could prevent the application from running.

This process was:

- Slow
- Error-prone
- Difficult to reproduce
- Hard to maintain

---

# Docker's Solution

Docker changed the approach completely.

Instead of documenting the environment,

Docker packages the entire application environment into an image.

```
Application Code

+

Libraries

+

Dependencies

+

Runtime

+

Configuration

↓

Docker Image

↓

Docker Container

↓

Runs Anywhere
```

Rather than telling someone how to prepare the environment,

you simply provide the Docker Image.

---

# Build Once, Run Anywhere

One of Docker's biggest advantages is consistency.

The same Docker Image can run on:

- Developer Laptop
- Testing Server
- Staging Environment
- Production Server
- Cloud Virtual Machine

The environment remains identical everywhere.

This principle is often summarized as:

> **Build Once, Run Anywhere**

---

# Why Containers Became Popular

Containers quickly became popular because they solved multiple problems at once.

### Consistency

Every developer uses the same environment.

---

### Portability

Applications can move between machines without modification.

---

### Faster Deployment

Instead of configuring a server manually,

developers simply run a container.

---

### Better Resource Utilization

Containers share the host operating system kernel,

making them lightweight compared to virtual machines.

---

### Scalability

Need more application instances?

Simply start more containers.

```
Application

↓

Container 1

Container 2

Container 3

Container 4

Container 5
```

---

### Simplified Collaboration

Instead of sharing setup instructions,

teams share Docker Images.

Every developer works in the same environment.

---

# Real-World Example

Imagine you're building an e-commerce platform.

Without Docker:

Every new developer spends hours installing:

- Java
- Maven
- PostgreSQL
- Redis
- RabbitMQ
- Elasticsearch

With Docker:

The developer clones the project and runs:

```bash
docker compose up
```

Within minutes,

the complete development environment is ready.

---

# Why Companies Love Containers

Organizations adopt containers because they provide:

- Predictable deployments
- Faster releases
- Easier scaling
- Better resource utilization
- Simplified CI/CD pipelines
- Cloud portability
- Faster disaster recovery

Today, nearly every major cloud-native application relies on containers.

---

# Industry Insight

Companies such as:

- Netflix
- Spotify
- Amazon
- Google
- Uber
- Airbnb
- Microsoft

run thousands—or even millions—of containers every day.

Containers have become the foundation of modern cloud-native software development.

---

# Best Practices

✅ Package every application with its dependencies.

✅ Keep images lightweight.

✅ Version your Docker Images.

✅ Use Docker Compose for multi-container applications.

✅ Treat infrastructure as code.

---

# Common Mistakes

❌ Assuming Docker only works for web applications.

❌ Believing containers replace virtual machines completely.

❌ Ignoring dependency management.

❌ Treating containers as long-lived servers.

---

# Interview Questions

### Q1. What problem does Docker solve?

### Q2. What is meant by "Works on My Machine"?

### Q3. Why are containers more portable than traditional deployments?

### Q4. What does "Build Once, Run Anywhere" mean?

### Q5. Why have containers become the industry standard?

---

# Mini Lab

## Objective

Observe Docker's portability.

### Tasks

1. Pull the latest Nginx image.

```bash
docker pull nginx
```

2. Run the container.

```bash
docker run -d -p 8080:80 nginx
```

3. Open your browser and visit:

```
http://localhost:8080
```

4. Stop the container.

```bash
docker stop <container_id>
```

5. Run the same image again.

Notice that no installation or reconfiguration is required.

The same image behaves consistently every time.

---

# Summary

In this section, you learned:

- Why traditional deployments were difficult.
- The "Works on My Machine" problem.
- How Docker solves environment inconsistencies.
- Why containers are portable.
- The meaning of "Build Once, Run Anywhere."
- Why containers became the industry standard.

Docker Containers are not just another way to run applications.

They represent a new deployment model—one that makes software portable, reproducible, and consistent across development, testing, and production environments.

# Images vs Containers

---

## Learning Objectives

After completing this section, you will be able to:

- Understand the relationship between Images and Containers.
- Differentiate between Images and Containers.
- Explain why Images are immutable.
- Explain why Containers are mutable.
- Understand how multiple Containers can be created from one Image.
- Answer one of the most common Docker interview questions confidently.

---

# Introduction

One of the biggest misconceptions among beginners is believing that Docker Images and Docker Containers are the same thing.

Although they are closely related, they serve completely different purposes.

Think of it this way:

- An Image is **what should run.**
- A Container is **what is currently running.**

An Image is a blueprint.

A Container is the actual implementation of that blueprint.

Without an Image, a Container cannot be created.

Without a Container, an Image remains inactive.

---

# Real-World Analogy 1 — Blueprint and House

Imagine an architect designing a house.

First, the architect creates a blueprint.

```
Blueprint

↓

House Construction

↓

Family Lives Inside
```

The blueprint describes:

- Number of rooms
- Kitchen layout
- Doors
- Windows
- Electrical wiring

However,

you cannot live inside a blueprint.

Only after the house is constructed does it become usable.

Docker works exactly the same way.

```
Docker Image

↓

Docker Container

↓

Running Application
```

---

# Real-World Analogy 2 — Recipe and Meal

Imagine a cookbook.

```
Recipe

↓

Cooking

↓

Prepared Meal
```

The recipe explains:

- Ingredients
- Quantity
- Cooking method
- Serving instructions

The recipe itself cannot satisfy your hunger.

Only the cooked meal can.

Similarly,

a Docker Image stores instructions,

while a Docker Container is the running result.

---

# Image Characteristics

A Docker Image is:

- Read-only
- Immutable
- Reusable
- Portable
- Used as a template
- Stored on disk
- Not executing

Think of an Image as a package waiting to be used.

---

# Container Characteristics

A Docker Container is:

- Running
- Mutable
- Writable
- Temporary
- Created from an Image
- Consumes CPU and Memory
- Executes processes

A Container represents a live application.

---

# One Image, Multiple Containers

One of Docker's greatest strengths is that a single Image can create multiple independent Containers.

```
           Python Image

                 │

      ┌──────────┼──────────┐

      ▼          ▼          ▼

 Container A  Container B  Container C

      │          │          │

 Flask App   API Server   Worker Process
```

Every Container starts from the same Image,

but each has its own:

- Filesystem changes
- Process list
- Network namespace
- Memory allocation
- Writable layer

This means changes inside one Container do **not** affect the others.

---

# What Happens When You Run a Container?

Suppose you execute:

```bash
docker run nginx
```

Docker performs the following steps:

```
Locate Image

↓

Create Writable Layer

↓

Allocate Container ID

↓

Configure Network

↓

Mount Filesystem

↓

Start Main Process

↓

Container Running
```

Notice that the Image itself is never modified.

Instead, Docker creates a new writable layer above the Image.

---

# Immutable vs Mutable

This is one of Docker's most important concepts.

### Images are Immutable

Immutable means:

> Once created, an Image does not change.

If you want to modify an Image,

you build a new one.

```
Image v1

↓

Modify Dockerfile

↓

Build Again

↓

Image v2
```

The original image remains unchanged.

---

### Containers are Mutable

Containers allow changes while running.

For example,

inside a container you can:

- Install packages
- Create files
- Delete files
- Modify configurations

These changes exist only inside that specific container.

---

# Where Are Changes Stored?

Docker creates a writable layer above every Image.

```
+----------------------------+
| Writable Layer             |
| (Container Changes)        |
+----------------------------+
| Docker Image (Read Only)   |
+----------------------------+
```

Whenever you:

- create a file
- delete a file
- install software

Docker stores those modifications in the writable layer.

The original Image remains untouched.

---

# Life Cycle Comparison

### Image Lifecycle

```
Dockerfile

↓

docker build

↓

Docker Image

↓

docker tag

↓

docker push
```

Images are created, tagged, shared, and reused.

---

### Container Lifecycle

```
docker run

↓

Running

↓

Paused

↓

Stopped

↓

Removed
```

Containers have a shorter lifecycle.

They are created, executed, and eventually destroyed.

---

# Image vs Container Comparison

| Feature | Docker Image | Docker Container |
|---------|--------------|------------------|
| Purpose | Blueprint | Running Instance |
| State | Static | Dynamic |
| Writable | No | Yes |
| Immutable | Yes | No |
| Stores Data | No | Temporary |
| Consumes CPU | No | Yes |
| Consumes Memory | No | Yes |
| Executes Processes | No | Yes |
| Can Create Multiple Instances | Yes | N/A |
| Lifecycle | Long-lived | Usually Short-lived |

---

# Industry Perspective

Modern software rarely runs directly on servers.

Instead,

companies build an Image once,

store it in a registry,

and launch hundreds or thousands of Containers from that single Image.

For example:

```
Docker Image

↓

100 Kubernetes Pods

↓

100 Running Containers
```

This approach provides consistency, scalability, and easier deployments.

---

# Best Practices

✅ Build Images once and reuse them.

✅ Avoid modifying running production Containers manually.

✅ Store application changes in Dockerfiles, not inside Containers.

✅ Treat Containers as disposable.

✅ Rebuild Images instead of patching Containers.

---

# Common Mistakes

❌ Saying an Image and a Container are the same thing.

❌ Editing production Containers directly.

❌ Assuming changes inside one Container affect all others.

❌ Storing important data inside Containers instead of Volumes.

---

# Interview Questions

### Q1. What is the difference between an Image and a Container?

### Q2. Why are Images immutable?

### Q3. Why are Containers mutable?

### Q4. Can multiple Containers be created from one Image?

### Q5. Where are changes made inside a running Container stored?

---

# Mini Lab

## Objective

Observe the relationship between an Image and multiple Containers.

### Step 1: Pull an Image

```bash
docker pull nginx
```

### Step 2: Run Two Containers

```bash
docker run -d --name nginx1 nginx
```

```bash
docker run -d --name nginx2 nginx
```

### Step 3: List Running Containers

```bash
docker ps
```

Observe that both containers were created from the same Image.

### Step 4: Stop One Container

```bash
docker stop nginx1
```

Notice that:

- `nginx2` continues running.
- The Image remains unchanged.
- Stopping one Container does not affect the other.

---

# Summary

In this section, you learned:

- Images are templates; Containers are running instances.
- Images are immutable and read-only.
- Containers are mutable and have a writable layer.
- A single Image can create multiple independent Containers.
- Docker never modifies the original Image when a Container runs.
- Understanding the distinction between Images and Containers is fundamental to mastering Docker.

# Container Lifecycle

> **Difficulty Level:** 🟢 Beginner → 🟡 Intermediate

---

# Learning Objectives

After completing this section, you will be able to:

- Understand the lifecycle of a Docker Container.
- Identify every container state.
- Explain how a container transitions between states.
- Understand which Docker commands change container states.
- Understand why containers stop.
- Understand the difference between a stopped container and a removed container.

---

# Introduction

Imagine you're watching a movie.

Every movie follows a sequence.

```
Planned

↓

Filmed

↓

Edited

↓

Released

↓

Archived
```

A Docker Container follows a similar journey.

A container is **not always running**.

Instead, it moves through different stages during its lifetime.

Understanding these stages is essential because every Docker command you use later—such as `docker run`, `docker stop`, `docker restart`, or `docker rm`—simply moves the container from one state to another.

---

# What is the Container Lifecycle?

The **Container Lifecycle** is the sequence of states a container passes through from the moment it is created until it is permanently removed.

You can think of it as the "life story" of a container.

---

# Complete Lifecycle

```
                docker create
                      │
                      ▼
                 ┌──────────┐
                 │ Created  │
                 └──────────┘
                      │
             docker start/run
                      ▼
                 ┌──────────┐
                 │ Running  │
                 └──────────┘
                  │   │   │
     docker pause │   │ docker stop
                  │   ▼
                  │ Stopped
                  │
                  ▼
              Paused
                  │
       docker unpause
                  ▼
              Running
                  │
            docker rm
                  ▼
               Removed
```

Every Docker Container eventually follows this journey.

---

# Stage 1 — Created

```
Created
```

A container has been created,

but its main application has **not started yet**.

Docker has already:

- Allocated a Container ID
- Created the writable layer
- Prepared networking
- Stored metadata

However,

no process is running.

Think of it as a newly built car parked in a showroom.

Everything is ready,

but nobody has turned on the engine.

---

# Stage 2 — Running

```
Running
```

This is the state you'll work with most often.

When a container is running,

its main process (PID 1) is executing.

Examples:

- Nginx serving web pages
- MySQL accepting connections
- Redis caching data
- Python executing an application

The container now consumes:

- CPU
- Memory
- Network
- Storage

---

# Stage 3 — Paused

Sometimes,

you don't want to stop the application completely.

Instead,

you temporarily freeze it.

Docker allows this using the **Paused** state.

During this state:

✅ Memory remains allocated.

✅ Processes remain in memory.

❌ CPU execution stops.

Think of pressing the **Pause** button on a video.

The movie doesn't end.

It simply waits until you resume it.

---

# Stage 4 — Stopped

A stopped container is **not deleted**.

Its application has exited,

but Docker still remembers:

- Container ID
- Name
- Metadata
- Filesystem
- Writable layer

This allows you to start it again later.

Think of turning off your laptop.

The laptop still exists.

It simply isn't running.

---

# Stage 5 — Removed

This is the final stage.

The container no longer exists.

Docker deletes:

- Container metadata
- Writable layer
- Runtime configuration

After removal,

the container cannot be restarted.

If you need it again,

Docker creates a **new container** from the image.

---

# Real-World Analogy

Imagine renting a hotel room.

```
Room Prepared

↓

Guest Checks In

↓

Guest Sleeping

↓

Guest Checks Out

↓

Room Cleaned
```

Docker Container Lifecycle

```
Created

↓

Running

↓

Paused

↓

Stopped

↓

Removed
```

The hotel room (Image) still exists,

but each guest stay (Container) has its own lifecycle.

---

# State Transition Commands

| Command | Current State | New State |
|----------|---------------|-----------|
| `docker create` | None | Created |
| `docker start` | Created / Stopped | Running |
| `docker run` | Image | Running |
| `docker pause` | Running | Paused |
| `docker unpause` | Paused | Running |
| `docker stop` | Running | Stopped |
| `docker kill` | Running | Stopped |
| `docker restart` | Running | Running (restarted) |
| `docker rm` | Stopped | Removed |

---

# 🔍 Behind the Scenes

Suppose you execute:

```bash
docker run nginx
```

Internally, Docker performs these operations:

```
Image Lookup

↓

Create Writable Layer

↓

Allocate Container ID

↓

Create Namespace

↓

Assign cgroups

↓

Configure Network

↓

Mount Filesystem

↓

Start PID 1

↓

Running
```

When you later run:

```bash
docker stop <container_id>
```

Docker sends a **SIGTERM** signal to the main process.

If the application doesn't stop within the timeout period,

Docker sends **SIGKILL** to force termination.

We'll explore signals in a later section.

---

# Why Do Containers Stop?

Many beginners think a container should run forever.

In reality,

a container runs **only as long as its main process is alive**.

Example:

```bash
docker run ubuntu
```

Ubuntu starts,

has nothing to execute,

and immediately exits.

The container stops because PID 1 finished.

---

# 💡 Concept Box

```
Container Running

↓

Main Process (PID 1)

↓

Process Ends

↓

Container Stops
```

A container's life depends entirely on its main process.

---

# 🏢 Industry Insight

Container orchestration platforms like Kubernetes continuously monitor container states.

If a container crashes unexpectedly,

Kubernetes automatically creates a replacement container to maintain application availability.

This is why containers are designed to be disposable rather than manually repaired.

---

# 📚 Did You Know?

A stopped container still occupies disk space because Docker preserves its writable layer and metadata.

Only `docker rm` permanently removes the container.

---

# Best Practices

✅ Treat containers as temporary resources.

✅ Store persistent data in Docker Volumes.

✅ Restart containers instead of modifying them manually.

✅ Monitor container health.

✅ Remove unused stopped containers regularly.

---

# ⚠ Common Mistakes

❌ Assuming `docker stop` deletes a container.

❌ Confusing `docker kill` with `docker rm`.

❌ Storing important data inside containers.

❌ Assuming containers run forever.

---

# 🧠 Interview Questions

### Q1. What are the different states of a Docker Container?

### Q2. What is the difference between a stopped container and a removed container?

### Q3. Why does a Docker Container stop automatically?

### Q4. What happens when you run `docker rm`?

### Q5. Why is the main process (PID 1) important?

---

# 🧪 Hands-on Experiment

## Objective

Observe the complete lifecycle of a container.

### Step 1

Create a container without starting it.

```bash
docker create --name lifecycle-demo nginx
```

### Step 2

View all containers.

```bash
docker ps -a
```

Notice that the container is in the **Created** state.

### Step 3

Start the container.

```bash
docker start lifecycle-demo
```

### Step 4

Pause it.

```bash
docker pause lifecycle-demo
```

### Step 5

Resume it.

```bash
docker unpause lifecycle-demo
```

### Step 6

Stop it.

```bash
docker stop lifecycle-demo
```

### Step 7

Remove it.

```bash
docker rm lifecycle-demo
```

Observe how the container transitions through every lifecycle stage.

---

# Summary

In this section, you learned:

- The five primary container states.
- How containers transition between states.
- Why containers stop.
- The relationship between the main process (PID 1) and the container's lifecycle.
- The Docker commands used to manage lifecycle transitions.

Understanding the container lifecycle provides the foundation for the next section, where we'll start running and managing containers using the Docker CLI.

# Container Architecture

> **Difficulty Level:** 🟡 Intermediate

---

# Learning Objectives

After completing this section, you will be able to:

- Understand the internal architecture of a Docker Container.
- Identify the major components of a container.
- Explain how Docker isolates applications.
- Understand the role of Namespaces and cgroups.
- Explain the purpose of the Writable Layer.
- Understand what happens inside the Linux kernel when a container starts.

---

# Introduction

When beginners first see Docker, they often imagine that a container is a miniature virtual machine.

This is one of the biggest misconceptions in containerization.

A Docker Container is **not** a tiny computer.

It is **not** a miniature operating system.

It is **not** a lightweight virtual machine.

Instead,

a Docker Container is simply a **Linux process** that has been isolated using features provided by the Linux kernel.

This idea completely changes how we think about containers.

---

# The Big Picture

Whenever you execute:

```bash
docker run nginx
```

Docker does **not** create another operating system.

Instead,

Docker creates an isolated environment around a normal Linux process.

That isolated environment becomes the Docker Container.

Think of Docker as creating a secure room inside a large building rather than constructing an entirely new building.

---

# Overall Architecture

```
+------------------------------------------------+
|                User Application                |
+------------------------------------------------+
|              Docker Container                  |
|                                                |
|  +------------------------------------------+  |
|  | Writable Layer                           |  |
|  +------------------------------------------+  |
|  | Read-Only Image Layers                   |  |
|  +------------------------------------------+  |
|  | Processes (PID 1, Child Processes)       |  |
|  +------------------------------------------+  |
|  | Network Namespace                        |  |
|  +------------------------------------------+  |
|  | Mount Namespace                          |  |
|  +------------------------------------------+  |
|  | IPC Namespace                            |  |
|  +------------------------------------------+  |
|  | UTS Namespace                            |  |
|  +------------------------------------------+  |
|  | User Namespace (Optional)                |  |
|  +------------------------------------------+  |
|  | cgroups                                  |  |
|  +------------------------------------------+  |
+------------------------------------------------+
                │
                ▼
        Linux Kernel (Shared)
                │
                ▼
          Physical Hardware
```

---

# The Six Core Components

Every Docker Container is built from six major components.

```
Docker Container

│

├── Image

├── Writable Layer

├── Process

├── Namespaces

├── cgroups

└── Network
```

Let's understand each one.

---

# 1. Docker Image

Every container begins with an Image.

The image provides:

- Operating system files
- Installed software
- Libraries
- Runtime
- Application code
- Startup command

Think of the image as the container's foundation.

Without an image,

no container can exist.

---

# 2. Writable Layer

Images are read-only.

But applications constantly modify files.

For example,

- creating log files
- updating configuration
- writing temporary data

Docker solves this by adding a **Writable Layer** above the image.

```
+---------------------------+

Writable Layer

+---------------------------+

Read-Only Image

+---------------------------+
```

Every file modification happens here.

The original image never changes.

---

# 3. Process

Every container runs one primary process.

This process is called:

```
PID 1
```

Examples:

```
nginx

mysqld

redis-server

python app.py
```

The entire container depends on this process.

If PID 1 exits,

the container stops.

---

# 4. Linux Namespaces

Namespaces provide isolation.

Without namespaces,

every application on Linux would see:

- every process
- every network interface
- every mounted drive
- every hostname

Namespaces create the illusion that each container owns its own system.

Each container receives its own:

- Process list
- Network stack
- Filesystem
- Hostname
- IPC resources

Even though everything shares one kernel.

---

# Namespace Types

| Namespace | Purpose |
|------------|----------|
| PID | Process Isolation |
| NET | Network Isolation |
| MNT | Filesystem Isolation |
| UTS | Hostname Isolation |
| IPC | Shared Memory Isolation |
| USER | User & Group Isolation |

Together,

these namespaces make containers appear independent.

---

# 5. cgroups

Isolation alone isn't enough.

Imagine one container consuming:

- 100% CPU
- All available RAM

Every other application would slow down.

Docker prevents this using **Control Groups (cgroups).**

cgroups allow Docker to limit:

- CPU
- RAM
- Disk I/O
- Network bandwidth
- Number of processes

Think of cgroups as resource managers.

---

# 6. Network

Every container receives its own virtual network interface.

Docker automatically assigns:

- IP Address
- MAC Address
- Virtual Ethernet Pair

Containers communicate through Docker networks.

We'll study networking in a dedicated module later.

---

# Behind the Scenes

Suppose you execute:

```bash
docker run nginx
```

Docker performs approximately the following sequence:

```
Locate Image

↓

Create Writable Layer

↓

Allocate Container ID

↓

Create PID Namespace

↓

Create Network Namespace

↓

Create Mount Namespace

↓

Assign cgroups

↓

Create Virtual Ethernet Pair

↓

Connect to Docker Bridge

↓

Mount Image

↓

Start nginx (PID 1)

↓

Container Running
```

Although the entire process completes in seconds,

many operations occur behind the scenes.

---

# Why Containers Start So Quickly

Containers reuse the host operating system kernel.

Unlike virtual machines,

they do not need to:

- Boot BIOS
- Start another kernel
- Initialize hardware drivers

Docker simply starts a new isolated process.

This is why containers often launch in under a second.

---

# Industry Insight

When Kubernetes creates a Pod,

it is ultimately asking the container runtime to repeat the exact process described above.

Understanding container architecture today will make Kubernetes much easier to learn later.

---

# Did You Know?

Docker itself doesn't implement Namespaces or cgroups.

These are **Linux kernel features**.

Docker simply orchestrates them to create containers.

---

# Best Practices

✅ Treat containers as isolated processes.

✅ Store persistent data in volumes.

✅ Limit CPU and memory using cgroups.

✅ Avoid modifying the writable layer in production.

✅ Rebuild images instead of patching containers.

---

# Common Mistakes

❌ Thinking containers have their own kernel.

❌ Believing containers are miniature virtual machines.

❌ Ignoring resource limits.

❌ Assuming writable-layer data is permanent.

---

# Interview Questions

### Q1. Is a Docker Container a virtual machine?

### Q2. What are Linux Namespaces?

### Q3. What are cgroups?

### Q4. Why do containers start faster than virtual machines?

### Q5. What happens if PID 1 exits?

---

# Hands-on Experiment

## Objective

Inspect the internal configuration of a running container.

### Step 1

Run an Nginx container.

```bash
docker run -d --name architecture-demo nginx
```

### Step 2

Inspect the container.

```bash
docker inspect architecture-demo
```

Observe:

- Container ID
- Network settings
- Mounts
- Hostname
- Image
- Process configuration

### Step 3

Stop and remove the container.

```bash
docker stop architecture-demo
docker rm architecture-demo
```

---

# Summary

In this section, you learned that a Docker Container is not a virtual machine but an isolated Linux process.

You explored its core components:

- Docker Image
- Writable Layer
- Main Process (PID 1)
- Linux Namespaces
- cgroups
- Virtual Networking

These components work together to provide isolation, portability, efficiency, and resource management.

Understanding this architecture forms the foundation for every Docker command you'll use in the rest of this handbook.

# SECTION 07

# Running Your First Container

> **Difficulty Level:** 🟢 Beginner

---

# Learning Objectives

After completing this section, you will be able to:

- Run your first Docker Container.
- Understand what `docker run` does internally.
- Explain every step involved in creating a container.
- Verify that a container is running.
- Stop and remove a container.
- Understand the complete workflow from Image to Running Container.

---

# Introduction

Up until now, we've studied Docker Images and Containers from a theoretical perspective.

Now it's time to put that knowledge into practice.

The first command every Docker user learns is:

```bash
docker run
```

Although it appears to be a single command, Docker performs many operations behind the scenes before your application starts.

Understanding these operations will help you debug problems and become more confident when working with Docker.

---

# Prerequisites

Before proceeding, ensure that:

- Docker is installed.
- Docker Engine is running.
- You have access to the terminal.
- Internet connectivity is available (for pulling images).

Verify your installation:

```bash
docker --version
```

Example Output:

```text
Docker version 28.x.x, build xxxxx
```

Check Docker Engine:

```bash
docker info
```

If this command displays Docker system information, Docker is running correctly.

---

# What is `docker run`?

The `docker run` command creates and starts a new container from a Docker Image.

General syntax:

```bash
docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
```

### Breakdown

| Part | Description |
|------|-------------|
| `docker` | Docker CLI |
| `run` | Create and start a container |
| `OPTIONS` | Additional settings (ports, names, volumes, etc.) |
| `IMAGE` | The image used to create the container |
| `COMMAND` | Optional command to override the default command |
| `ARG...` | Arguments passed to the command |

---

# Your First Container

Let's start with the simplest example.

```bash
docker run hello-world
```

Press **Enter**.

Docker will automatically begin working.

---

# What Happens Behind the Scenes?

Although you typed only one command, Docker performs many tasks.

```
User

↓

docker run hello-world

↓

Check Local Image Cache

↓

Image Found?

↓

No

↓

Download Image

↓

Create Writable Layer

↓

Create Namespaces

↓

Assign cgroups

↓

Configure Network

↓

Start Main Process

↓

Display Output

↓

Container Stops
```

This entire workflow usually takes only a few seconds.

---

# Why Does Docker Download the Image?

The first time you run:

```bash
docker run hello-world
```

Docker checks whether the image already exists locally.

If it does not, Docker automatically downloads it from Docker Hub.

Example Output:

```text
Unable to find image 'hello-world:latest' locally

latest: Pulling from library/hello-world

Digest: sha256:...

Status: Downloaded newer image for hello-world:latest
```

This process is called **Pulling an Image**.

---

# What Does the Hello-World Container Do?

The `hello-world` image is designed specifically for beginners.

Its purpose is to verify that Docker is working correctly.

Internally, it performs the following:

1. Starts a container.
2. Prints a welcome message.
3. Exits.

Because its main process finishes immediately, the container stops automatically.

---

# Expected Output

You should see something similar to:

```text
Hello from Docker!

This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:

1. The Docker client contacted the Docker daemon.
2. The Docker daemon pulled the image.
3. The Docker daemon created a new container.
4. The Docker daemon streamed the output.
5. The container exited successfully.
```

Congratulations!

You have just run your first Docker Container.

---

# Why Did the Container Stop?

Many beginners expect the container to remain running.

Instead, it exits immediately.

Why?

Because the container's main process has finished.

Remember:

```
PID 1 Ends

↓

Container Stops
```

A Docker Container lives only as long as its main process.

---

# Checking Running Containers

Display all currently running containers:

```bash
docker ps
```

Since the Hello World container has already exited, the output will likely be empty.

Example:

```text
CONTAINER ID   IMAGE   COMMAND   STATUS
```

---

# Viewing All Containers

To display both running and stopped containers:

```bash
docker ps -a
```

Example Output:

```text
CONTAINER ID   IMAGE         STATUS
abc123456789   hello-world   Exited (0)
```

Notice the **Exited (0)** status.

This means:

- The container completed successfully.
- Exit code `0` indicates no errors.

---

# Running a Long-Lived Container

The Hello World container exits immediately.

Let's run a container that continues running.

```bash
docker run nginx
```

The Nginx web server starts and keeps running because its main process (`nginx`) remains active.

To stop it, press:

```text
CTRL + C
```

---

# Running Nginx in Detached Mode

Instead of keeping the terminal occupied, run it in the background:

```bash
docker run -d nginx
```

Docker returns a long hexadecimal string.

Example:

```text
d7f89ac82abf64d...
```

This is the **Container ID**.

---

# Verify the Running Container

Check active containers:

```bash
docker ps
```

Example:

```text
CONTAINER ID   IMAGE   STATUS
d7f89ac82abf   nginx   Up 20 seconds
```

Now your container is actively running.

---

# Stopping the Container

First, identify the Container ID:

```bash
docker ps
```

Then stop it:

```bash
docker stop <container_id>
```

Example:

```bash
docker stop d7f89ac82abf
```

Docker sends a termination signal, allowing the application to shut down gracefully.

---

# Removing the Container

Stopping a container does not delete it.

Remove it manually:

```bash
docker rm <container_id>
```

Example:

```bash
docker rm d7f89ac82abf
```

The container has now been permanently removed.

---

# 💡 Concept Box

```
Docker Image

↓

docker run

↓

Running Container

↓

docker stop

↓

Stopped Container

↓

docker rm

↓

Removed Container
```

---

# 🔍 Behind the Scenes

When you execute:

```bash
docker run nginx
```

Docker performs approximately these steps:

```
Locate Image

↓

Download Image (if necessary)

↓

Create Writable Layer

↓

Create Container Metadata

↓

Assign Container ID

↓

Create Namespaces

↓

Assign cgroups

↓

Configure Virtual Network

↓

Mount Image Filesystem

↓

Start PID 1

↓

Container Running
```

Each of these steps happens automatically, often in less than a second.

---

# 🏢 Industry Insight

In production environments, engineers rarely run containers manually.

Instead, tools like Docker Compose, Kubernetes, or CI/CD pipelines execute `docker run` (or equivalent container runtime operations) automatically based on deployment configurations.

Understanding `docker run` is still essential because those higher-level tools build upon the same underlying concepts.

---

# 📚 Did You Know?

The `docker run` command is actually a shortcut for multiple Docker operations.

Conceptually, it combines:

```text
docker pull

↓

docker create

↓

docker start
```

into a single command.

---

# Best Practices

✅ Use official images whenever possible.

✅ Verify the image before running it.

✅ Remove unused containers regularly.

✅ Use meaningful container names.

✅ Prefer detached mode for long-running services.

---

# ⚠ Common Mistakes

❌ Confusing `docker run` with `docker start`.

❌ Assuming `docker stop` removes a container.

❌ Forgetting to check stopped containers with `docker ps -a`.

❌ Expecting every container to stay running.

---

# 🧠 Interview Questions

### Q1. What does `docker run` do?

### Q2. What happens if the image does not exist locally?

### Q3. Why does the Hello World container exit immediately?

### Q4. What is the difference between `docker ps` and `docker ps -a`?

### Q5. Does `docker run` always download an image?

---

# 🧪 Hands-on Experiment

## Objective

Run and manage your first Docker Container.

### Step 1

Run the Hello World container:

```bash
docker run hello-world
```

### Step 2

List all containers:

```bash
docker ps -a
```

### Step 3

Run an Nginx container in detached mode:

```bash
docker run -d --name my-nginx nginx
```

### Step 4

Verify it is running:

```bash
docker ps
```

### Step 5

Stop the container:

```bash
docker stop my-nginx
```

### Step 6

Remove the container:

```bash
docker rm my-nginx
```

---

# Summary

In this section, you learned how to run your first Docker Container using `docker run`. You explored the lifecycle from image lookup to container creation, understood why some containers exit immediately, learned how to inspect running and stopped containers, and practiced stopping and removing containers. Most importantly, you now understand that `docker run` is not just a command—it is a sequence of coordinated operations that transform a static image into a running application.

---

# Managing Docker Containers

> Once a container has been created, it must be managed throughout its lifecycle. Docker provides a rich set of commands that allow you to monitor, control, inspect, and troubleshoot containers. In this part of the module, you'll learn how to manage containers effectively using the Docker CLI.

---

# Table of Contents

## 1. Listing Containers
- Why list containers?
- Understanding `docker ps`
- Understanding `docker ps -a`
- Understanding Container States
- Reading the Output Columns
- Formatting the Output
- Filtering Containers
- Showing Only Container IDs
- Real-World Examples
- Best Practices
- Common Mistakes
- Hands-on Lab

---

## 2. Starting Containers
- Introduction
- Understanding `docker start`
- Command Syntax
- Starting a Single Container
- Starting Multiple Containers
- Start vs Run
- Starting Containers in Detached Mode
- Common Use Cases
- Best Practices
- Common Mistakes
- Hands-on Lab

---

## 3. Stopping Containers
- Introduction
- Understanding `docker stop`
- Command Syntax
- Graceful Shutdown
- Stop Timeout
- Stopping Multiple Containers
- Stop vs Kill
- Real-World Examples
- Best Practices
- Common Mistakes
- Hands-on Lab

---

## 4. Restarting Containers
- Introduction
- Understanding `docker restart`
- Restart Workflow
- Restarting Multiple Containers
- Restart Policies Overview
- Real-World Scenarios
- Best Practices
- Common Mistakes
- Hands-on Lab

---

## 5. Pausing Containers
- Introduction
- Understanding `docker pause`
- Understanding `docker unpause`
- What Happens Internally?
- Pause vs Stop
- Resource Behavior During Pause
- Common Use Cases
- Best Practices
- Common Mistakes
- Hands-on Lab

---

## 6. Removing Containers
- Introduction
- Understanding `docker rm`
- Removing a Single Container
- Removing Multiple Containers
- Force Removing Containers
- Removing All Stopped Containers
- Container Pruning
- Best Practices
- Common Mistakes
- Hands-on Lab

---

## 7. Inspecting Containers
- Introduction
- Understanding `docker inspect`
- Inspecting Container Metadata
- Understanding JSON Output
- Network Information
- Mount Information
- Process Information
- Practical Examples
- Best Practices
- Common Mistakes
- Hands-on Lab

---

## 8. Viewing Container Logs
- Introduction
- Understanding `docker logs`
- Viewing Complete Logs
- Following Live Logs
- Viewing Recent Logs
- Timestamped Logs
- Log Troubleshooting
- Real-World Examples
- Best Practices
- Common Mistakes
- Hands-on Lab

---

## 9. Executing Commands Inside Containers
- Introduction
- Understanding `docker exec`
- Interactive Shell
- Executing Single Commands
- Running Administrative Commands
- Installing Software Inside Containers
- Practical Examples
- Exec vs Attach
- Best Practices
- Common Mistakes
- Hands-on Lab

---

## 10. Attaching to Containers
- Introduction
- Understanding `docker attach`
- How Attach Works
- Attach vs Exec
- Safely Detaching from Containers
- Production Considerations
- Practical Examples
- Best Practices
- Common Mistakes
- Hands-on Lab

---

## 11. Container Resource Limits
- Why Resource Limits Matter
- CPU Limits
- Memory Limits
- Swap Limits
- PIDs Limit
- Monitoring Resource Usage
- Resource Management Best Practices
- Practical Examples
- Common Mistakes
- Hands-on Lab

---

## 12. Best Practices
- One Process Per Container
- Use Meaningful Container Names
- Keep Containers Stateless
- Store Persistent Data in Volumes
- Use Detached Mode for Services
- Prefer `docker exec` Over `docker attach`
- Remove Unused Containers
- Keep Images Immutable
- Monitor Container Logs
- Set Resource Limits
- Follow the Principle of Least Privilege
- Production Recommendations

---

## 13. Common Mistakes
- Confusing Images with Containers
- Using `docker run` Instead of `docker start`
- Confusing Stop, Kill, and Remove
- Editing Production Containers
- Storing Important Data Inside Containers
- Ignoring Container Logs
- Forgetting Resource Limits
- Running Multiple Unrelated Applications in One Container
- Leaving Unused Containers Behind
- Assuming Stopped Containers Are Deleted

---

## 14. Module Summary
- Key Concepts
- Important Docker Commands
- Quick Revision Notes
- Command Cheat Sheet
- Docker Management Workflow
- Interview Questions
- Scenario-Based Questions
- Hands-on Lab
- Mini Project
- Challenge Exercise
- Further Reading

---

# Learning Outcomes

By the end of this part of the module, you will be able to:

- List and identify running and stopped containers.
- Start, stop, restart, pause, and remove containers confidently.
- Inspect container metadata and troubleshoot issues.
- Access logs for debugging applications.
- Execute commands safely inside running containers.
- Understand the difference between `exec` and `attach`.
- Apply CPU and memory limits to containers.
- Follow Docker management best practices used in production environments.
- Avoid common mistakes made by beginners.
- Manage Docker containers efficiently using the Docker CLI.

---