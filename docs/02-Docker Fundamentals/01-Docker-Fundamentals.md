# Docker Fundamentals

> **Automation-Lab Documentation**
> **Author:** Sanvi Sharma
> **Version:** 1.0

---
# 📚 Table of Contents

MODULE 01 — Introduction to Docker
1. Introduction
2. What is Docker?
3. Why Was Docker Invented?
4. History of Containerization
5. Traditional Deployment Problems
6. Virtual Machines vs Docker
7. Docker Architecture
8. Docker Components
9. Docker Workflow
10. Advantages of Docker
11. Limitations of Docker
12. Key Takeaways

---
# MODULE 01

---

# Introduction

Docker is one of the most widely used technologies in modern software development and DevOps. Whether you're deploying a web application, hosting an AI model, running a database, or building automation workflows with n8n, Docker provides a consistent and isolated environment that ensures applications run the same way everywhere.

Understanding Docker is not about memorizing commands. It is about understanding how applications are packaged, distributed, and executed efficiently.

By the end of this chapter, you should understand not only *how* Docker works, but *why* it became one of the most influential technologies in cloud computing.

---

# What is Docker?

Docker is an **open-source containerization platform** that allows developers to package an application along with all its dependencies into a lightweight, portable unit called a **container**.

A container includes everything the application needs to run:

* Application source code
* Runtime environment
* System libraries
* Dependencies
* Configuration
* Environment variables

This ensures the application behaves consistently across different machines.

Instead of saying:

> "Install Python, then install Flask, then install these packages..."

Docker packages everything into one portable container.

---

## Simple Definition

> Docker is a platform that packages applications and their dependencies into containers, allowing them to run consistently across different environments.

---

# Real-Life Analogy

Imagine you're moving to another city.

Without Docker, you pack every item separately.

* Clothes
* Books
* Laptop
* Charger
* Kitchen items
* Documents

When you reach your destination, you unpack everything and hope nothing is missing.

With Docker, everything is packed inside a **shipping container**.

```
+--------------------------------------+
|          Shipping Container          |
|                                      |
|  Clothes                             |
|  Laptop                              |
|  Books                               |
|  Charger                             |
|  Kitchen Items                       |
|                                      |
+--------------------------------------+
```

The shipping company doesn't care what's inside.

It only transports the container.

Similarly,

Docker doesn't care whether you're running:

* Python
* Java
* Node.js
* PostgreSQL
* Redis
* n8n

Everything is packaged inside a container.

---

# Why Was Docker Invented?

Before Docker existed, software deployment was difficult.

Developers often encountered a common problem:

> **"It works on my machine."**

Imagine a team with three developers.

```
Developer A
Windows
Python 3.12
Flask 3.1

Developer B
Ubuntu
Python 3.10
Flask 2.2

Production Server
Ubuntu
Python 3.8
Flask 1.1
```

The application behaves differently on each machine.

One developer says:

> "The code is fine."

Another says:

> "I'm getting an error."

The production server crashes.

No one knows why.

The issue isn't the code.

The issue is the environment.

---

# The Real Problem

Applications depend on many things besides source code.

Examples include:

* Operating System
* Python version
* Java version
* Node version
* Installed libraries
* Environment variables
* Database drivers
* System packages

Even a small difference can cause failures.

---

# Docker's Solution

Docker packages everything together.

Instead of sharing only the code:

```
Application
```

Developers share:

```
Application

+

Python

+

Libraries

+

Dependencies

+

Configurations
```

Everything is bundled into a Docker Image.

Every machine runs exactly the same environment.

---

# Traditional Deployment

Without Docker:

```
Application

↓

Install Python

↓

Install Libraries

↓

Install Dependencies

↓

Install Database Drivers

↓

Configure Environment

↓

Run Application
```

Every step introduces the possibility of failure.

---

# Deployment with Docker

```
Docker Image

↓

Docker Container

↓

Application Runs
```

Only two steps.

Much simpler.

---

# Virtual Machines vs Docker

Before Docker became popular, Virtual Machines (VMs) were the primary solution for isolating applications.

Both Virtual Machines and Docker isolate applications, but they do so differently.

---

# Virtual Machine Architecture

```
+------------------------------------+
|        Application                 |
+------------------------------------+
|      Guest Operating System        |
+------------------------------------+
|            Hypervisor              |
+------------------------------------+
|        Host Operating System       |
+------------------------------------+
|            Hardware                |
+------------------------------------+
```

Each Virtual Machine contains its own operating system.

This makes VMs:

* Heavy
* Slow to boot
* Memory intensive

---

# Docker Architecture

```
+------------------------------------+
|        Application                 |
+------------------------------------+
|          Docker Container          |
+------------------------------------+
|          Docker Engine             |
+------------------------------------+
|        Host Operating System       |
+------------------------------------+
|            Hardware                |
+------------------------------------+
```

Containers share the host operating system kernel.

There is no separate guest operating system for every application.

This makes containers:

* Lightweight
* Fast
* Efficient

---

# VM vs Docker Comparison

| Feature      | Virtual Machine | Docker       |
| ------------ | --------------- | ------------ |
| Guest OS     | Required        | Not Required |
| Startup Time | Minutes         | Seconds      |
| Memory Usage | High            | Low          |
| Performance  | Lower           | Near Native  |
| Size         | GBs             | MBs          |
| Portability  | Moderate        | Excellent    |
| Isolation    | Very Strong     | Strong       |

---

# Why Containers Are Faster

Suppose you want to run five applications.

Using Virtual Machines:

```
App 1 + Ubuntu
App 2 + Ubuntu
App 3 + Ubuntu
App 4 + Ubuntu
App 5 + Ubuntu
```

Five operating systems.

Using Docker:

```
Host Linux Kernel

↓

Container 1

Container 2

Container 3

Container 4

Container 5
```

One operating system.

Multiple containers.

Much more efficient.

---

# Docker Architecture

Docker consists of three primary components.

```
              Docker Client
                     │
                     │
              Docker Commands
                     │
                     ▼
              Docker Daemon
             (Docker Engine)
             /      |      \
            /       |       \
       Images   Containers  Networks
                    |
                 Volumes
```

---

# Docker Client

The Docker Client is the command-line interface (CLI) that developers interact with.

Examples:

```bash
docker run nginx

docker ps

docker images

docker build
```

The client does not run containers.

It simply sends instructions to Docker Engine.

---

# Docker Engine (Docker Daemon)

Docker Engine is the heart of Docker.

It receives commands from the Docker Client and performs all the actual work.

Responsibilities include:

* Pulling images
* Building images
* Creating containers
* Starting containers
* Stopping containers
* Managing networks
* Managing volumes

Think of Docker Engine as the **manager** of the entire Docker ecosystem.

---

# Docker Workflow

A typical Docker workflow looks like this:

```
Developer

↓

docker run nginx

↓

Docker Client

↓

Docker Engine

↓

Checks Local Images

↓

Image Found?
      │
   Yes │ No
      │
      ▼
Download Image from Docker Hub

↓

Create Container

↓

Run Container
```

---

# Key Takeaways

* Docker packages applications together with their dependencies.
* Containers solve the "It works on my machine" problem.
* Containers share the host operating system kernel.
* Docker containers are lightweight and start quickly.
* Docker Engine manages all Docker resources.
* Docker Client communicates with Docker Engine.
* Docker provides consistent environments across development, testing, and production.

---
