# Docker Images

> **Automation-Lab Documentation**
> **Author:** Sanvi Sharma
> **Version:** 1.0

---
# 📚 Table of Contents
MODULE 02 — Docker Images
1. What is a Docker Image?
2. Image Architecture
3. Image Layers
4. Union File System (UnionFS)
5. Overlay File System (OverlayFS)
6. Layer Caching
7. Image Tags
8. Docker Image Lifecycle
9. Pulling Images
10. Searching Images
11. Building Images
12. Inspecting Images
13. Listing Images
14. Tagging Images
15. Removing Images
16. Saving and Loading Images
17. Exporting and Importing Images
18. Best Practices for Images
19. Common Mistakes
20. Summary

---

# MODULE 02 — Part A 

## Learning Objectives

After completing this module, you will be able to:

- Understand what a Docker Image is.
- Differentiate between Docker Images and Containers.
- Explain why Docker Images are immutable.
- Understand Image Layers.
- Learn how Union File System (UnionFS) works.
- Understand OverlayFS and its role in Docker.
- Explain why Docker Images are lightweight.
- Understand the complete Docker Image architecture.

---

# Introduction

Before running a Docker Container, Docker must first have something to run.

That "something" is called a **Docker Image**.

Most beginners think Images are just installation files.

That is incorrect.

A Docker Image is much more than a zip file or setup file.

It is an immutable blueprint that contains everything required to create one or multiple Docker Containers.

Without Images, Containers cannot exist.

Think of an Image as a class in Object-Oriented Programming.

Think of a Container as an object created from that class.

One Image can create hundreds of Containers.

---

# What is a Docker Image?

A Docker Image is a **read-only template** that contains everything required to run an application.

It includes:

- Application Source Code
- Runtime Environment
- System Libraries
- Dependencies
- Environment Variables
- Configuration Files
- Startup Commands

Everything required to execute the application exists inside the Image.

When Docker starts an Image, it creates a running instance called a **Container**.

---

## Simple Definition

> A Docker Image is an immutable, read-only template that contains everything required to create and run Docker Containers.

---

# Real-World Analogy

Imagine you're baking cookies.

You first prepare a cookie mould.

```
Cookie Mould

↓

Cookie

↓

Cookie

↓

Cookie

↓

Cookie
```

The mould never changes.

It simply creates cookies.

Similarly,

```
Docker Image

↓

Container

↓

Container

↓

Container

↓

Container
```

The Image remains unchanged.

Containers are created from it.

---

# Another Analogy

Think about a smartphone.

When you buy a new phone, it comes with a factory image.

Whenever something goes wrong, you perform a **Factory Reset**.

The phone always returns to the same original state.

Docker Images work similarly.

Every new Container starts from the same original Image.

No matter how many Containers you create, the Image never changes.

---

# Why are Docker Images Read-Only?

One of Docker's biggest design decisions is that Images cannot be modified after creation.

This provides several advantages.

- Predictability
- Security
- Faster deployments
- Easy rollback
- Version control

Imagine if every Container modified the original Image.

Soon, every developer would have a different version.

Docker avoids this by making Images immutable.

---

# Image vs Container

Many beginners confuse these two concepts.

They are completely different.

| Docker Image | Docker Container |
|--------------|-----------------|
| Blueprint | Running Application |
| Read-only | Read-Write |
| Immutable | Mutable |
| Cannot Execute | Executes Code |
| Used to Create Containers | Created from Images |

---

## Real-World Analogy

Architect's Blueprint

↓

House

The blueprint never becomes the house.

Instead,

the house is built using the blueprint.

Similarly,

```
Docker Image

↓

Docker Container
```

---

# Docker Image Architecture

A Docker Image is not one single file.

It consists of multiple **layers**.

Example:

```
+---------------------------+
| Flask Application         |
+---------------------------+
| Python                    |
+---------------------------+
| Ubuntu                    |
+---------------------------+
| Linux Kernel              |
+---------------------------+
```

Each block is called a Layer.

Docker stacks these layers together to build one Image.

---

# Why Layers?

Suppose two applications both require Ubuntu.

Application A

```
Ubuntu

↓

Python

↓

Flask

↓

Application
```

Application B

```
Ubuntu

↓

Node.js

↓

Express

↓

Application
```

Without layers,

Ubuntu would be downloaded twice.

Docker avoids duplication.

Ubuntu exists once.

Both Images reuse it.

This dramatically reduces storage consumption.

---

# Image Layers

Each instruction inside a Dockerfile creates a new layer.

For example,

```dockerfile
FROM ubuntu

RUN apt update

RUN apt install python3

COPY app.py /app

CMD ["python3","app.py"]
```

Docker creates layers like this.

```
Layer 5

CMD

----------------------

Layer 4

COPY app.py

----------------------

Layer 3

Install Python

----------------------

Layer 2

apt update

----------------------

Layer 1

Ubuntu Base Image
```

Each layer is cached independently.

---

# Why Layering is Powerful

Imagine editing only app.py.

Without Layers,

Docker would rebuild everything.

Ubuntu

↓

Python

↓

Dependencies

↓

Application

With Layers,

Docker rebuilds only the last layer.

Ubuntu remains.

Python remains.

Dependencies remain.

Only

```
COPY app.py
```

is rebuilt.

This is why Docker builds become extremely fast after the first build.

---

# Internal Working

When Docker builds an Image,

it performs these steps.

```
Dockerfile

↓

Instruction 1

↓

Create Layer

↓

Instruction 2

↓

Create Layer

↓

Instruction 3

↓

Create Layer

↓

Instruction 4

↓

Create Layer

↓

Final Docker Image
```

Every instruction becomes a snapshot.

Docker stores these snapshots individually.

---

# Union File System (UnionFS)

Now comes one of Docker's most important concepts.

Docker does not merge all files physically.

Instead,

it uses something called a **Union File System**.

A Union File System combines multiple directories into one virtual filesystem.

Imagine five transparent sheets.

```
Sheet 5

Application

------------

Sheet 4

Python

------------

Sheet 3

Libraries

------------

Sheet 2

Ubuntu

------------

Sheet 1

Linux
```

Individually,

they are separate.

Stack them together,

they appear as one complete operating system.

That is exactly what UnionFS does.

Docker combines multiple layers into a single unified filesystem.

---

# Advantages of UnionFS

- Layer reuse
- Reduced storage
- Faster downloads
- Faster builds
- Easy versioning
- Efficient updates

---

# OverlayFS

OverlayFS is the actual Linux filesystem implementation Docker commonly uses today.

Think of OverlayFS as the technology that implements the Union File System concept.

It consists of two primary layers.

```
Upper Layer

(Read-Write)

↓

Lower Layers

(Read-Only)
```

Lower Layers come from the Docker Image.

Upper Layer belongs to the running Container.

When the Container modifies a file,

Docker does **not** modify the Image.

Instead,

it copies the file into the Upper Layer.

This is called

**Copy-on-Write (CoW).**

---

# Copy-on-Write

Suppose

Image contains

```
config.json
```

Container edits it.

Docker performs

```
Image

↓

Copy config.json

↓

Upper Layer

↓

Modify Copy
```

Original Image remains untouched.

This is how Docker preserves Image immutability.

---

# Image Architecture Summary

```
Docker Image

↓

Multiple Layers

↓

UnionFS

↓

OverlayFS

↓

Read Only

↓

Container Created

↓

Writable Layer Added
```

---

# Key Takeaways

- Docker Images are immutable.
- Images are templates for creating Containers.
- Images consist of multiple layers.
- Every Dockerfile instruction creates a layer.
- Docker reuses layers to save storage.
- UnionFS combines layers into one filesystem.
- OverlayFS implements layered storage.
- Containers add a writable layer on top of Images.

---

# MODULE 02 — PART B

## Learning Objectives

After completing this section, you will be able to:

- Understand Docker's Build Cache.
- Explain why Docker builds become faster over time.
- Understand Image Tags and Versioning.
- Explain the Docker Image Lifecycle.
- Search Docker Images.
- Pull Images from Docker Hub.
- Understand what happens internally when Docker downloads an Image.

---

# Why Do Docker Builds Become Faster?

Suppose you build a Docker Image today.

It takes

```
5 minutes
```

Tomorrow,

you change only one line of code.

Surprisingly,

Docker rebuilds the Image in

```
8 seconds
```

How?

The answer lies in **Layer Caching**.

---

# What is Docker Layer Cache?

Docker never rebuilds everything unless it absolutely has to.

Instead,

it remembers every layer it has built previously.

If a layer hasn't changed,

Docker simply reuses it.

This is known as the **Build Cache**.

---

## Real World Analogy

Imagine building a LEGO house.

```
Foundation

↓

Walls

↓

Roof

↓

Windows

↓

Furniture
```

If you decide to change only the furniture,

you do **not** rebuild the entire house.

You simply replace the furniture.

Docker follows the exact same approach.

---

# Example

Consider this Dockerfile.

```dockerfile
FROM ubuntu

RUN apt update

RUN apt install python3

COPY app.py /app

CMD ["python3","app.py"]
```

During the first build,

Docker creates

```
Layer 1

Ubuntu

↓

Layer 2

apt update

↓

Layer 3

Python Installation

↓

Layer 4

Copy app.py

↓

Layer 5

CMD
```

Every layer is stored inside Docker's cache.

---

# Second Build

Now suppose

only

```
app.py
```

changes.

Docker checks every instruction.

```
Layer 1

No Change

Reuse

✔

-----------------

Layer 2

No Change

Reuse

✔

-----------------

Layer 3

No Change

Reuse

✔

-----------------

Layer 4

Changed

Rebuild

✔

-----------------

Layer 5

Rebuild

✔
```

Everything before the changed instruction is reused.

Only the affected layer and everything after it is rebuilt.

---

# Why Docker Rebuilds Everything After a Changed Layer

Many beginners ask:

> Why does Docker rebuild Layer 5 too?

Imagine writing a book.

```
Chapter 1

↓

Chapter 2

↓

Chapter 3

↓

Chapter 4
```

If Chapter 2 changes,

then the final book also changes.

Docker treats layers similarly.

Every layer depends on the previous one.

---

# Best Practice

Always place frequently changing files near the bottom of the Dockerfile.

Bad Example

```dockerfile
COPY . .

RUN npm install
```

Every code change forces Docker to reinstall dependencies.

Good Example

```dockerfile
COPY package.json .

RUN npm install

COPY . .
```

Now,

Docker only reinstalls packages when

```
package.json
```

changes.

Huge performance improvement.

---

# What are Docker Image Tags?

Imagine downloading Ubuntu.

Which version?

Ubuntu has many versions.

```
Ubuntu 18.04

Ubuntu 20.04

Ubuntu 22.04

Ubuntu 24.04
```

Docker needs a way to distinguish them.

That is the purpose of **Tags**.

---

# Image Naming Convention

Docker Images follow this format.

```
repository:tag
```

Example

```
ubuntu:24.04

python:3.12

node:22

nginx:latest
```

---

# Repository vs Tag

Example

```
python:3.12
```

Repository

```
python
```

Tag

```
3.12
```

Think of it like

```
Book

↓

Edition
```

Repository = Book

Tag = Edition

---

# What is the latest Tag?

Many beginners use

```
latest
```

Example

```
nginx:latest
```

Contrary to popular belief,

**latest does not always mean newest.**

It simply points to whatever version the image maintainer has designated as the default.

Therefore,

production environments should avoid relying on `latest`.

Instead,

use

```
python:3.12

postgres:16

redis:8
```

Specific versions provide reproducible deployments.

---

# Why Version Pinning Matters

Imagine today

```
node:latest

↓

Node 22
```

Next month

```
node:latest

↓

Node 23
```

Your application suddenly breaks.

Nothing in your code changed.

The image changed.

Production systems should always use explicit version numbers.

---

# Docker Image Lifecycle

Every Docker Image follows a lifecycle.

```
Search

↓

Pull

↓

Store Locally

↓

Run

↓

Modify

↓

Build New Image

↓

Push

↓

Delete
```

This cycle repeats throughout software development.

---

# Searching Images

Docker can search Docker Hub directly.

Example

```bash
docker search nginx
```

Output

```
NAME              DESCRIPTION

nginx             Official Build

linuxserver/nginx Community Image

bitnami/nginx     Enterprise Ready
```

---

# Official Images

Docker Hub contains two major categories.

Official Images

```
Ubuntu

Python

Redis

MySQL

PostgreSQL

Nginx
```

Community Images

```
username/project
```

Example

```
linuxserver/nginx

bitnami/postgresql
```

Whenever possible,

prefer Official Images.

---

# Pulling Images

Downloading an Image from Docker Hub is called

**Pulling**.

Example

```bash
docker pull nginx
```

Docker performs several internal operations.

```
Docker Client

↓

Docker Daemon

↓

Docker Hub

↓

Download Layers

↓

Verify Checksums

↓

Store Locally

↓

Ready to Run
```

---

# What Happens Internally?

Suppose you execute

```bash
docker pull python:3.12
```

Docker checks

```
Local Image Cache
```

↓

Image Present?

```
Yes

↓

Use Existing Image
```

or

```
No

↓

Connect to Docker Hub

↓

Download Missing Layers

↓

Verify Integrity

↓

Store Image

↓

Complete
```

Notice

Docker downloads only the layers that are missing.

Shared layers are reused.

This significantly reduces bandwidth.

---

# Listing Local Images

To see downloaded Images

```bash
docker images
```

Example

```
REPOSITORY      TAG

ubuntu          24.04

python          3.12

redis           8

postgres        16
```

Every Image stored locally appears here.

---

# Why Docker Images Are Efficient

Suppose

Ubuntu

is already downloaded.

Now you pull

```
python:3.12
```

Python already contains Ubuntu as its base layer.

Docker detects

Ubuntu already exists.

Instead of downloading it again,

Docker downloads only the missing layers.

This is one reason Docker is incredibly storage efficient.

---

# Production Tip

Never build every project from scratch.

Instead,

start from trusted base Images such as

- ubuntu
- alpine
- debian
- python
- node
- nginx

This improves security,

reduces build time,

and follows industry best practices.

---

# Common Mistakes

❌ Using `latest` in production.

❌ Rebuilding entire Images unnecessarily.

❌ Copying the entire project before installing dependencies.

❌ Pulling Images from untrusted publishers.

❌ Ignoring Image size.

---

# Best Practices

✅ Use Official Images.

✅ Pin Image versions.

✅ Optimize Dockerfile instruction order.

✅ Reuse Build Cache.

✅ Keep Images small.

✅ Remove unused Images regularly.

---

# Interview Questions

### Q1. What is Docker Layer Cache?

### Q2. Why are Docker Images immutable?

### Q3. What is the purpose of Image Tags?

### Q4. Why should we avoid using `latest` in production?

### Q5. What happens internally when we execute `docker pull nginx`?

### Q6. How does Docker reduce Image download size?

### Q7. Explain the Docker Image Lifecycle.

---

# Mini Lab

1. Search for the official Ubuntu Image.

2. Pull Ubuntu 24.04.

3. Pull Python 3.12.

4. List all downloaded Images.

5. Observe which layers Docker reused.

6. Compare Image sizes.

---

# Summary

In this chapter, you learned:

- Docker Layer Caching
- Why Docker builds become faster
- Image Tags
- Image Versioning
- Docker Image Lifecycle
- Searching Images
- Pulling Images
- Internal download process
- Production best practices

---
# MODULE 02 — Part C
---

# 1. Building Docker Images
---

## Learning Objectives

After completing this section, you will be able to:

- Understand what it means to build a Docker Image.
- Explain the complete image build process.
- Understand Docker Build Context.
- Differentiate between `docker build` and `docker run`.
- Learn how Docker processes a Dockerfile.
- Understand image creation from source code.
- Build your first custom Docker Image.

---

# Introduction

Until now, we have been using images created by someone else.

Examples include:

- nginx
- ubuntu
- python
- redis
- postgres

These images are downloaded directly from Docker Hub.

However, in real-world software development, developers rarely rely solely on pre-built images.

Instead, they create **custom Docker Images** that package their own applications together with all required dependencies.

This process is known as **Building a Docker Image**.

---

# What Does "Building an Image" Mean?

Building an image is the process of converting your application's source code and configuration into a reusable Docker Image.

Docker reads a special file called a **Dockerfile**, executes each instruction one by one, creates layers for each instruction, and finally packages everything into a single Docker Image.

Think of it as manufacturing a product in a factory.

---

# Real-World Analogy

Imagine you own a bakery.

Before selling cakes, you need a recipe.

The recipe contains every instruction required to bake the cake.

```
Recipe

↓

Collect Ingredients

↓

Mix Ingredients

↓

Bake

↓

Decorate

↓

Finished Cake
```

In Docker,

```
Dockerfile

↓

Collect Base Image

↓

Install Dependencies

↓

Copy Source Code

↓

Configure Application

↓

Create Docker Image
```

A Dockerfile is simply the recipe.

The Docker Image is the finished cake.

---

# What is Required to Build an Image?

Every Docker Image starts with three basic components.

```
Project Folder

+

Application Source Code

+

Dockerfile
```

Example

```
my-flask-app/

│

├── app.py

├── requirements.txt

└── Dockerfile
```

Docker enters this folder and begins building the image.

---

# The Docker Build Process

When you execute

```bash
docker build -t myapp .
```

Docker performs several steps internally.

```
Developer

↓

docker build

↓

Docker Client

↓

Docker Daemon

↓

Read Dockerfile

↓

Execute Instructions

↓

Create Layers

↓

Store Layers

↓

Generate Final Image
```

The final image is stored locally and can later be used to create one or more containers.

---

# Understanding Build Context

One of the most misunderstood concepts in Docker is the **Build Context**.

Consider this command:

```bash
docker build -t myapp .
```

Notice the period (`.`) at the end.

That single dot tells Docker:

> "Use the current directory as the build context."

The build context is the collection of files and folders Docker is allowed to access while building the image.

If your project looks like this:

```
my-project/

├── app.py

├── config.json

├── requirements.txt

└── Dockerfile
```

Docker can access every file inside this directory.

Files outside the build context cannot be copied into the image.

---

# Why Build Context Matters

Imagine inviting a chef into your kitchen.

The chef can only cook using ingredients available inside the kitchen.

He cannot magically fetch ingredients from another house.

Similarly,

Docker can only access files inside the build context.

Trying to copy files outside the build context will result in an error.

---

# The Dockerfile

The Dockerfile is the blueprint for building an image.

It contains a sequence of instructions.

Example:

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

CMD ["python", "app.py"]
```

Docker executes these instructions from top to bottom.

Each instruction creates a new image layer.

---

# Building an Image

General syntax:

```bash
docker build [OPTIONS] PATH
```

Example:

```bash
docker build -t my-python-app .
```

Explanation:

- `docker build` → Starts the image build process.
- `-t` → Assigns a name (tag) to the image.
- `my-python-app` → Image name.
- `.` → Current directory as the build context.

After the build completes, Docker stores the image locally.

---

# What Happens Internally?

Imagine the following Dockerfile.

```dockerfile
FROM ubuntu

RUN apt update

RUN apt install python3 -y

COPY app.py /app

CMD ["python3", "/app/app.py"]
```

Docker processes it step by step.

```
Step 1

Download Ubuntu Base Image

↓

Step 2

Create Layer

↓

Step 3

Run apt update

↓

Create Layer

↓

Step 4

Install Python

↓

Create Layer

↓

Step 5

Copy Source Code

↓

Create Layer

↓

Step 6

Store Startup Command

↓

Final Docker Image
```

Notice that Docker never performs all actions at once.

It executes instructions sequentially.

---

# Why Does Docker Build Layer by Layer?

Building layer by layer provides several advantages:

- Faster rebuilds through caching.
- Efficient storage.
- Easier debugging.
- Image versioning.
- Layer reuse across multiple images.

This layered architecture is one of Docker's biggest strengths.

---

# docker build vs docker run

Many beginners confuse these commands.

| docker build | docker run |
|--------------|------------|
| Creates an Image | Creates a Container |
| Uses a Dockerfile | Uses an Existing Image |
| Executed Once | Executed Every Time You Start a Container |
| Produces an Image | Produces a Running Process |

A simple way to remember this is:

```
Dockerfile

↓

docker build

↓

Image

↓

docker run

↓

Container
```

You **build** an image once.

You **run** containers many times.

---

# Best Practices

- Keep the Dockerfile simple and readable.
- Use official base images whenever possible.
- Organize instructions to maximize layer caching.
- Keep the build context small.
- Avoid copying unnecessary files into the image.
- Use a `.dockerignore` file to exclude logs, temporary files, and other unnecessary content.

---

# Common Mistakes

❌ Running `docker run` before building the image.

❌ Forgetting the `.` at the end of the `docker build` command.

❌ Giving images confusing names.

❌ Using an unnecessarily large build context.

❌ Copying secrets or credentials into the image.

---

# Interview Questions

### Q1. What is the purpose of the `docker build` command?

### Q2. What is a Docker Build Context?

### Q3. Why does Docker process a Dockerfile line by line?

### Q4. What is the difference between `docker build` and `docker run`?

### Q5. Why does each Dockerfile instruction create a new layer?

---

# Mini Lab

### Objective

Build your first custom Docker Image.

### Tasks

1. Create a new project folder.
2. Add a simple Python or Flask application.
3. Create a Dockerfile.
4. Build the image using `docker build`.
5. Verify the image using `docker images`.
6. Run the image as a container.

*(We'll complete this lab together in a later chapter after learning Dockerfiles in detail.)*

---

# Summary

In this section, you learned:

- What it means to build a Docker Image.
- The role of a Dockerfile.
- Docker Build Context.
- The complete image build process.
- The difference between `docker build` and `docker run`.
- Why Docker builds images layer by layer.
- Best practices and common mistakes.

This knowledge forms the foundation for creating your own containerized applications.

---

# 2. Inspecting Docker Images

---

## Learning Objectives

After completing this section, you will be able to:

- Understand why inspecting Docker Images is important.
- View metadata associated with an image.
- Differentiate between listing and inspecting images.
- Analyze image configuration and architecture.
- Learn common inspection commands used by DevOps engineers.

---

# Introduction

Imagine purchasing a new laptop.

Before using it, you probably want to know:

- Who manufactured it?
- Which processor does it have?
- How much RAM is installed?
- Which operating system is pre-installed?
- What is the serial number?

You inspect the laptop to learn about it.

Docker Images are no different.

Before deploying an image, developers often inspect it to understand:

- Which operating system it uses
- Which architecture it supports
- Who created it
- Which command starts the application
- Which environment variables are configured
- Which ports are exposed

This process is called **Image Inspection**.

---

# What is Image Inspection?

Inspecting a Docker Image means viewing all of its internal metadata.

Metadata is simply "information about the image."

Think of metadata as the identity card of a Docker Image.

It contains details that are not immediately visible but are essential for understanding how the image behaves.

---

# Real-World Analogy

Consider a medicine bottle.

The outside packaging tells you very little.

The information leaflet inside contains:

- Ingredients
- Dosage
- Manufacturer
- Expiry Date
- Warnings

Similarly,

A Docker Image has hidden information that Docker stores internally.

Inspection allows us to read this information.

---

# Listing vs Inspecting

Many beginners confuse these two operations.

### Listing Images

```bash
docker images
```

This command answers:

> "Which images are available on my system?"

Example:

```
REPOSITORY      TAG        IMAGE ID

ubuntu          24.04      a12b34c

python          3.12       d45e67f
```

Only a summary is displayed.

---

### Inspecting Images

```bash
docker inspect ubuntu:24.04
```

This command answers:

> "Tell me everything about this image."

Instead of a simple table,

Docker returns detailed JSON metadata.

---

# Why JSON?

Docker stores image information in a structured format.

That format is JSON.

Example:

```json
{
    "Architecture": "amd64",
    "Os": "linux",
    "Author": "Docker",
    "Created": "...",
    "Config": {
        "Cmd": ["/bin/bash"]
    }
}
```

Don't worry if this looks unfamiliar.

As you progress through DevOps, JSON will become one of your most frequently used data formats.

---

# Important Information Available

When inspecting an image, you can discover:

- Image ID
- Creation Time
- Image Size
- Operating System
- CPU Architecture
- Environment Variables
- Default Startup Command
- Working Directory
- Exposed Ports
- Labels
- Parent Image
- Layers

---

# Image ID

Every Docker Image has a unique identifier.

Example:

```
sha256:a3d8c1...
```

Think of it like an Aadhaar number.

Two images may have the same name,

but their Image IDs will always be unique.

---

# Architecture

Images are built for specific processor architectures.

Examples include:

- amd64
- arm64
- arm/v7

If you download an image built for the wrong architecture,

it may fail to run.

This becomes especially important when working with:

- Raspberry Pi
- Apple Silicon (M-series)
- AWS Graviton Instances

---

# Operating System

Docker Images are operating-system aware.

Common values include:

```
linux

windows
```

Linux images cannot run directly on Windows Containers and vice versa.

---

# Default Command

Every image has a default command.

Example:

```
python app.py
```

or

```
nginx -g daemon off;
```

When you run:

```bash
docker run nginx
```

Docker automatically executes the default command stored inside the image.

---

# Image History

Docker also stores the history of every layer.

Use:

```bash
docker history nginx
```

Example Output:

```
IMAGE          CREATED

COPY app

RUN apt install

FROM ubuntu
```

This helps developers understand how an image was built.

---

# Why Image History Matters

Imagine downloading an image from the internet.

Would you trust it without knowing how it was built?

Probably not.

Image history helps developers:

- Debug builds
- Audit images
- Understand dependencies
- Estimate image size

---

# Image Size

Another important property is image size.

Example:

```
Ubuntu

78 MB

------------

Python

1.1 GB

------------

Alpine

7 MB
```

Smaller images generally:

- Download faster
- Deploy faster
- Consume less storage
- Reduce attack surface

This is one reason Alpine Linux is popular in production.

---

# Production Perspective

Before deploying any image,

experienced DevOps engineers usually inspect:

- Image size
- Base image
- Environment variables
- Startup command
- Architecture
- Labels
- Build history

This simple habit can prevent many production issues.

---

# Best Practices

- Inspect third-party images before using them.
- Verify image architecture.
- Prefer smaller images whenever possible.
- Review image history.
- Avoid blindly trusting community images.

---

# Common Mistakes

❌ Deploying images without inspection.

❌ Ignoring architecture compatibility.

❌ Using oversized images.

❌ Trusting unknown publishers.

---

# Interview Questions

### Q1. What does `docker inspect` do?

### Q2. What information can be obtained from an image?

### Q3. Why is image history useful?

### Q4. Why is image architecture important?

### Q5. What is the difference between `docker images` and `docker inspect`?

---

# Mini Lab

### Objective

Explore Docker Image metadata.

### Tasks

1. Pull the latest Ubuntu image.
2. List all available images.
3. Inspect the Ubuntu image.
4. Identify:
   - Architecture
   - Operating System
   - Image Size
   - Default Command
5. View the image history.

---

# Summary

In this section, you learned:

- How to inspect Docker Images.
- Difference between listing and inspecting.
- Image metadata.
- Image history.
- Architecture and operating system information.
- Why image inspection is an essential DevOps practice.
  
---
# 3. Tagging Docker Images

---

## Learning Objectives

After completing this section, you will be able to:

- Understand what Docker Image Tagging is.
- Explain why tagging is important.
- Differentiate between image names, repositories, and tags.
- Create multiple tags for the same image.
- Rename Docker Images using tags.
- Understand semantic versioning.
- Learn image versioning best practices used in production.

---

# Introduction

Imagine you've written three versions of a report.

```
Report

↓

Version 1

↓

Version 2

↓

Version 3
```

Without version numbers,

you would have no idea which report is the latest.

Software development has the exact same problem.

Applications evolve over time.

```
Application

↓

Version 1.0

↓

Version 1.1

↓

Version 2.0

↓

Version 3.0
```

Docker solves this problem using **Image Tags**.

---

# What is Image Tagging?

A tag is simply a label attached to a Docker Image.

It helps identify a specific version of that image.

Think of it as the version number of your application.

For example,

```
python:3.12

nginx:1.27

postgres:16
```

Here,

```
python
```

is the repository,

while

```
3.12
```

is the tag.

---

# Real-World Analogy

Imagine a library.

Every book has:

- Title
- Edition

Example

```
Operating Systems

↓

1st Edition

↓

2nd Edition

↓

3rd Edition
```

The book title remains the same.

Only the edition changes.

Similarly,

```
Repository

↓

Tag
```

---

# Anatomy of an Image Name

Docker Images follow this structure.

```
repository:tag
```

Examples

```
ubuntu:24.04

python:3.12

redis:8

mysql:9
```

Repository

↓

Application Name

Tag

↓

Version

---

# What Happens if No Tag is Specified?

Suppose you run

```bash
docker pull nginx
```

Docker automatically assumes

```
nginx:latest
```

Many beginners think

```
latest
```

means

"The newest version."

That is incorrect.

The latest tag simply points to the default version selected by the image maintainer.

It may not always be the newest release.

---

# Why Do We Tag Images?

Imagine your application currently runs Version 1.0.

Tomorrow,

you release Version 2.0.

If something goes wrong,

you should be able to return to Version 1.0 immediately.

Tags make this possible.

```
myapp:1.0

↓

myapp:1.1

↓

myapp:2.0

↓

myapp:2.1
```

Every version remains available.

---

# Creating Tags

Docker allows multiple tags to point to the same image.

Command

```bash
docker tag SOURCE_IMAGE TARGET_IMAGE
```

Example

```bash
docker tag myapp:1.0 myapp:latest
```

Now,

both tags reference the same image.

```
Image ID

↓

myapp:1.0

↓

myapp:latest
```

No new image is created.

Only another label is added.

---

# Internal Working

Many beginners assume Docker duplicates the image.

It does not.

Suppose

```
Image ID

abc123
```

After tagging,

```
abc123

↓

myapp:1.0

↓

myapp:latest

↓

mycompany/web:v1
```

Three names.

One image.

This makes tagging extremely efficient.

---

# Listing Tagged Images

Run

```bash
docker images
```

Example

```
REPOSITORY      TAG

myapp           1.0

myapp           latest

mycompany/web   production
```

Notice

different tags,

same Image ID.

---

# Semantic Versioning

Most production systems follow Semantic Versioning.

Format

```
Major.Minor.Patch
```

Example

```
1.0.0

↓

1.1.0

↓

1.1.1

↓

2.0.0
```

Meaning

Major

↓

Breaking Changes

Minor

↓

New Features

Patch

↓

Bug Fixes

---

# Example

```
myapp:1.0.0

↓

myapp:1.1.0

↓

myapp:1.2.0

↓

myapp:2.0.0
```

This helps teams understand updates without reading release notes.

---

# Production Tagging Strategy

Instead of using only

```
latest
```

production teams often maintain multiple tags.

Example

```
myapp:1.4.2

myapp:stable

myapp:production

myapp:latest
```

Each serves a different purpose.

---

# Why "latest" is Dangerous

Suppose your production server uses

```
myapp:latest
```

Another developer pushes a new image.

Now,

```
latest
```

points to the new version.

The next deployment unexpectedly changes.

Your application may break,

even though you never modified your deployment script.

For this reason,

production systems should use explicit version numbers.

---

# Best Practices

✅ Always tag production releases.

✅ Follow Semantic Versioning.

✅ Avoid relying on latest.

✅ Use meaningful tag names.

✅ Keep version history.

---

# Common Mistakes

❌ Using only latest.

❌ Forgetting to update tags.

❌ Deleting previous versions.

❌ Creating inconsistent naming conventions.

---

# Interview Questions

### Q1. What is a Docker Image Tag?

### Q2. Why is tagging important?

### Q3. Does tagging duplicate the image?

### Q4. Explain Semantic Versioning.

### Q5. Why should latest be avoided in production?

---

# Mini Lab

1.

Pull Ubuntu.

2.

Create a new tag.

```bash
docker tag ubuntu:24.04 ubuntu:mybackup
```

3.

List all images.

4.

Observe the Image IDs.

5.

Verify that both tags point to the same image.

---

# Summary

In this section, you learned:

- What Docker Image Tags are.
- Repository vs Tag.
- How tagging works internally.
- Creating multiple tags.
- Semantic Versioning.
- Production tagging strategies.
- Why latest should be avoided in production.
  
---
  
# 4. Removing Docker Images

---

## Learning Objectives

After completing this section, you will be able to:

- Understand why Docker Images should be removed.
- Differentiate between removing Images and Containers.
- Learn how Docker deletes Images internally.
- Remove single and multiple Images.
- Force remove Images.
- Remove dangling Images.
- Clean unused Images.
- Understand Docker's image garbage collection.

---

# Introduction

As you continue working with Docker, your system gradually accumulates images.

Every project you build, every base image you download, and every version you create occupies storage space.

Over time, hundreds of unused images may consume several gigabytes—or even hundreds of gigabytes—of disk space.

Just as we regularly clean unnecessary files from our computer, Docker Images also need periodic maintenance.

This process is known as **Image Cleanup**.

---

# Why Remove Docker Images?

Docker Images occupy storage on your local machine.

Suppose you build an application multiple times during development.

```
myapp:v1

↓

myapp:v2

↓

myapp:v3

↓

myapp:v4

↓

myapp:v5
```

If only Version 5 is currently in use,

the previous versions continue occupying disk space unless you remove them.

---

# Real-World Analogy

Imagine your wardrobe.

Every year you buy new clothes.

Instead of throwing away old ones,

you keep everything.

Eventually,

the wardrobe becomes full,

making it difficult to organize or find anything.

Docker Images behave similarly.

Unused images continue consuming storage until you remove them.

---

# Images vs Containers

One of the most common beginner mistakes is confusing Images with Containers.

| Docker Image | Docker Container |
|--------------|------------------|
| Blueprint | Running Instance |
| Read-only | Read-Write |
| Used to Create Containers | Created From Images |
| Stored on Disk | Running Process |

Deleting an Image does **not** necessarily delete its Containers.

Similarly,

removing a Container does **not** remove its Image.

These are independent objects.

---

# Checking Local Images

Before deleting anything,

first check what exists.

Command:

```bash
docker images
```

Example Output

```
REPOSITORY     TAG

ubuntu         24.04

python         3.12

nginx          latest

redis          8
```

Review the list carefully before deleting images.

---

# Removing a Single Image

General Syntax

```bash
docker rmi IMAGE_NAME
```

Example

```bash
docker rmi nginx
```

Docker removes the specified image from local storage.

---

# Removing by Image ID

Every image has a unique Image ID.

Instead of using its name,

you may remove it using the ID.

Example

```bash
docker rmi 4f5d2c7b
```

This is useful when multiple images share similar names.

---

# What Happens Internally?

Suppose you execute

```bash
docker rmi nginx
```

Docker performs the following operations.

```
Locate Image

↓

Check Dependencies

↓

Is Any Container Using It?

↓

Yes

↓

Stop Removal

OR

No

↓

Delete Image Layers

↓

Free Storage
```

Docker never deletes an image that is actively required by a running container.

This prevents accidental data loss.

---

# Why Docker Refuses to Remove Some Images

Sometimes you may see an error such as:

```
Error:

image is being used by running container
```

This simply means

a container created from that image still exists.

Docker protects the image until the dependent container is removed.

---

# Force Removing Images

If you are certain the image is no longer required,

you can force Docker to remove it.

Command

```bash
docker rmi -f IMAGE_NAME
```

Example

```bash
docker rmi -f nginx
```

Use this command carefully.

Forcing removal may affect stopped containers that still reference the image.

---

# Removing Multiple Images

Docker also allows multiple images to be removed simultaneously.

Example

```bash
docker rmi nginx redis ubuntu
```

Docker processes each image one by one.

---

# Dangling Images

During development,

Docker often creates temporary images.

These images:

- have no tag
- are not referenced
- cannot be used directly

They are called **Dangling Images**.

Example

```
<none>

<none>

IMAGE ID
```

These images usually appear after rebuilding applications multiple times.

---

# Why Dangling Images Exist

Imagine editing a document repeatedly.

```
Draft 1

↓

Draft 2

↓

Draft 3

↓

Draft 4
```

Old drafts still exist,

but nothing references them anymore.

Docker behaves similarly.

When rebuilding images,

old intermediate layers may become dangling.

---

# Removing Dangling Images

Command

```bash
docker image prune
```

Docker automatically removes unused dangling images.

This is one of the safest cleanup commands.

---

# Removing All Unused Images

Suppose your machine contains dozens of unused images.

Instead of deleting them one by one,

Docker provides a cleanup command.

```bash
docker image prune -a
```

This removes all images that are not currently referenced by any container.

---

# Cleaning the Entire Docker Environment

Sometimes developers want to reclaim maximum storage.

Docker provides

```bash
docker system prune
```

This removes:

- stopped containers
- unused networks
- dangling images
- build cache

For a deeper cleanup,

```bash
docker system prune -a
```

Be cautious.

This command may delete resources you still need.

---

# Storage Management

Over time,

Docker environments can consume a surprising amount of storage.

A healthy maintenance routine includes:

- removing old images
- cleaning dangling images
- deleting unused containers
- pruning build cache

Regular cleanup keeps Docker efficient.

---

# Production Perspective

In production environments,

images are rarely removed manually.

Instead,

organizations implement automated cleanup policies.

Examples include:

- Scheduled cleanup jobs
- Registry retention policies
- CI/CD pipeline cleanup
- Automated image lifecycle management

This prevents servers from running out of storage.

---

# Best Practices

✅ Remove unused images regularly.

✅ Keep only required versions.

✅ Use `docker image prune` periodically.

✅ Monitor Docker disk usage.

✅ Avoid forcing image removal unless necessary.

---

# Common Mistakes

❌ Removing images currently used by containers.

❌ Forgetting to clean dangling images.

❌ Using `docker system prune -a` without understanding its impact.

❌ Keeping hundreds of obsolete image versions.

---

# Interview Questions

### Q1. What is the difference between removing an Image and removing a Container?

### Q2. Why does Docker refuse to remove some Images?

### Q3. What are Dangling Images?

### Q4. What is the difference between `docker image prune` and `docker system prune`?

### Q5. When should `docker rmi -f` be used?

---

# Mini Lab

## Objective

Practice Docker Image cleanup.

### Tasks

1. Pull Ubuntu, Redis, and Nginx images.
2. Verify they appear in `docker images`.
3. Remove one image by name.
4. Remove another using its Image ID.
5. Build an image multiple times to create dangling images.
6. Execute:

```bash
docker image prune
```

7. Observe the reclaimed storage.

8. Run:

```bash
docker system df
```

to analyze Docker disk usage.

---

# Summary

In this section, you learned:

- Why Docker Images should be removed.
- Difference between Images and Containers.
- How Docker deletes Images internally.
- Removing Images by name and ID.
- Force removal.
- Dangling Images.
- Image pruning.
- Docker storage management.
- Cleanup best practices.

With proper cleanup habits, Docker remains organized, efficient, and easy to manage—even in large development environments.

---
# 5. Saving and Loading Docker Images

---

## Learning Objectives

After completing this section, you will be able to:

- Understand why Docker Images are saved.
- Differentiate between local images and portable image archives.
- Learn how to save Docker Images into archive files.
- Load saved images back into Docker.
- Understand offline image distribution.
- Learn real-world use cases for saving and loading images.
- Understand image portability and backup strategies.

---

# Introduction

Normally, Docker Images are downloaded from Docker Hub or another container registry whenever they are needed.

However, what happens if:

- Your production server has no internet connection?
- Your company has an isolated (air-gapped) network?
- You need to transfer an image using a USB drive?
- You want to back up an image before deleting it?
- You want to send an image to a colleague without using Docker Hub?

In these situations, downloading the image again is not possible or practical.

Instead, Docker allows you to package an image into a portable archive file.

This process is called **Saving an Image**.

The reverse process, restoring that archive back into Docker, is called **Loading an Image**.

---

# Why Save Docker Images?

A Docker Image normally exists only inside Docker's local image store.

```
Docker Engine

↓

Local Images

↓

ubuntu

python

redis
```

If Docker is removed or the machine is formatted, these locally stored images are lost.

Saving an image creates a portable backup that can be restored later.

---

# Real-World Analogy

Imagine writing an important project report.

The report exists on your laptop.

To protect it, you copy it onto:

- a USB drive
- an external hard disk
- cloud storage

The report remains the same.

Only its location changes.

Docker Images behave similarly.

```
Docker Image

↓

Save

↓

Archive File (.tar)

↓

Transfer

↓

Load

↓

Docker Image
```

---

# What is `docker save`?

The `docker save` command packages one or more Docker Images into a single TAR archive.

Think of it as compressing an image into a portable package.

General Syntax

```bash
docker save [OPTIONS] IMAGE_NAME
```

Example

```bash
docker save -o nginx.tar nginx:latest
```

Explanation:

- `docker` → Docker CLI
- `save` → Save one or more images
- `-o` → Write the archive to a file
- `nginx.tar` → Output archive
- `nginx:latest` → Image to save

---

# What Happens Internally?

Suppose you execute:

```bash
docker save -o nginx.tar nginx:latest
```

Docker performs the following steps:

```
Locate Image

↓

Collect All Image Layers

↓

Collect Image Metadata

↓

Package Everything

↓

Create TAR Archive

↓

Save to Disk
```

The resulting archive contains:

- Image layers
- Metadata
- Tags
- Configuration
- Manifest

Nothing is lost.

---

# Why Use a TAR Archive?

A TAR archive is simply a collection of files bundled together.

Docker chooses TAR because:

- It preserves directory structure.
- It stores multiple files in one archive.
- It is supported across Linux, macOS, and Windows.
- It is easy to compress further if required.

---

# Saving Multiple Images

Docker can save multiple images into a single archive.

Example

```bash
docker save -o workshop-images.tar \
nginx:latest \
python:3.12 \
redis:8
```

Result:

```
workshop-images.tar

↓

nginx

python

redis
```

This is useful when distributing a complete application stack.

---

# Viewing the Archive

After saving an image:

```bash
ls
```

Example Output

```
nginx.tar
```

This file can now be:

- copied to another computer
- uploaded to cloud storage
- archived
- transferred via USB
- stored for disaster recovery

---

# Loading Images

The opposite of saving is loading.

General Syntax

```bash
docker load -i IMAGE_ARCHIVE
```

Example

```bash
docker load -i nginx.tar
```

Docker reads the archive and restores the image into the local image store.

---

# Internal Working of `docker load`

```
Read TAR Archive

↓

Extract Image Layers

↓

Restore Metadata

↓

Verify Image Integrity

↓

Store Image

↓

Ready to Use
```

Once loaded, the image behaves exactly like one downloaded from Docker Hub.

---

# Verifying the Image

After loading:

```bash
docker images
```

Example

```
REPOSITORY      TAG

nginx          latest
```

The image is now available for creating containers.

---

# Save vs Pull

Many beginners wonder:

> Why save an image if I can simply pull it again?

The answer depends on the environment.

| Pull from Registry | Save & Load |
|--------------------|------------|
| Requires Internet | Works Offline |
| Depends on Registry Availability | Fully Self-contained |
| Downloads Every Time | Restore from Local Archive |
| Good for Public Images | Ideal for Backups and Offline Transfers |

---

# Real-World Use Cases

## Air-Gapped Environments

Many government organizations, banks, defense agencies, and research laboratories operate networks with no internet access.

Images must be transferred manually.

---

## Disaster Recovery

Before major upgrades, teams often save important images.

If something goes wrong, the previous version can be restored immediately.

---

## Workshop Distribution

Imagine conducting a Docker workshop for 100 students.

Instead of asking every student to download several gigabytes of images,

you can provide a single archive containing everything required.

---

## CI/CD Artifact Storage

Some organizations archive production-ready images alongside application releases.

This provides an additional backup beyond the container registry.

---

# Best Practices

✅ Save important production images before major upgrades.

✅ Keep versioned archive names.

Example:

```
inventory-api-v2.3.1.tar
```

✅ Store backups in a secure location.

✅ Verify archives after loading.

✅ Archive only required images.

---

# Common Mistakes

❌ Assuming `docker save` exports running containers.

❌ Forgetting image versions.

❌ Deleting local images before verifying the backup.

❌ Storing archives without meaningful names.

---

# Did You Know?

`docker save` preserves:

- Image Layers
- Metadata
- Tags
- Manifest

It does **not** save:

- Running Containers
- Container Logs
- Writable Container Layer
- Volumes

Those belong to containers, not images.

---

# Production Perspective

Large organizations rarely use `docker save` for daily deployments.

Instead, they use container registries such as:

- Docker Hub
- Amazon ECR
- Azure Container Registry
- Google Artifact Registry
- GitHub Container Registry

However, `docker save` remains extremely valuable for:

- offline deployments
- backups
- training labs
- disaster recovery
- isolated environments

---

# Interview Questions

### Q1. What is the purpose of `docker save`?

### Q2. What does `docker load` do?

### Q3. What type of file is generated by `docker save`?

### Q4. Does `docker save` preserve image tags?

### Q5. When would you use `docker save` instead of Docker Hub?

---

# Mini Lab

## Objective

Back up and restore a Docker Image.

### Tasks

1. Pull the latest Nginx image.

2. Verify it exists.

```bash
docker images
```

3. Save the image.

```bash
docker save -o nginx.tar nginx:latest
```

4. Delete the image.

```bash
docker rmi nginx
```

5. Confirm it has been removed.

6. Restore the image.

```bash
docker load -i nginx.tar
```

7. Verify the image is available again.

---

# Summary

In this section, you learned:

- Why Docker Images are saved.
- How `docker save` works.
- How `docker load` restores images.
- The role of TAR archives.
- Real-world backup and offline deployment scenarios.
- Best practices for image portability.

You also learned that **saving and loading work only with Docker Images**.

In the next section, we'll explore **Exporting and Importing**, which operate on **containers** rather than images.

--- 
# 6. Exporting and Importing Docker Containers

---

## Learning Objectives

After completing this section, you will be able to:

- Understand the purpose of exporting Docker Containers.
- Differentiate between Images and Containers during backup.
- Learn how to export a container.
- Import an exported container as a new image.
- Understand what information is preserved and what is lost.
- Compare `docker save` vs `docker export`.
- Compare `docker load` vs `docker import`.
- Learn real-world scenarios for using export and import.

---

# Introduction

In the previous section, we learned how to save and load **Docker Images**.

Now imagine a different scenario.

You have a running container.

Inside that container, you have:

- Installed additional software
- Modified configuration files
- Created new directories
- Generated reports
- Downloaded data

These changes exist only inside the running container.

If the container is deleted,

those modifications disappear.

Instead of saving the original image,

Docker allows you to export the **current filesystem** of the container.

This process is called **Exporting a Container**.

---

# Real-World Analogy

Imagine purchasing a new apartment.

The apartment itself is like a Docker Image.

After moving in,

you arrange furniture,

paint the walls,

buy appliances,

and decorate the rooms.

Those modifications represent a Docker Container.

If someone asks,

"Can you give me your decorated apartment?"

You cannot simply hand over the original blueprint.

Instead,

you pack everything exactly as it currently exists.

That is what Docker Export does.

```
Blueprint

↓

Apartment

↓

Furniture

↓

Decorations

↓

Export Everything
```

---

# What is `docker export`?

The `docker export` command creates a TAR archive containing the **filesystem of a container**.

Unlike `docker save`,

it does **not** preserve image history,

layers,

or metadata.

General Syntax

```bash
docker export [OPTIONS] CONTAINER
```

Example

```bash
docker export -o mycontainer.tar my-container
```

---

# What Happens Internally?

Suppose you execute

```bash
docker export -o app.tar my-container
```

Docker performs the following steps.

```
Locate Container

↓

Read Container Filesystem

↓

Ignore Image Metadata

↓

Ignore Image Layers

↓

Package Filesystem

↓

Generate TAR Archive
```

Notice

Docker exports only

the final filesystem.

Everything else is discarded.

---

# What Gets Exported?

The exported archive contains:

- Files
- Directories
- Installed packages
- Modified configuration files
- Application data inside the container

---

# What Does NOT Get Exported?

Docker intentionally excludes:

- Image history
- Image layers
- Build cache
- Image tags
- Metadata
- Environment variables
- CMD instruction
- ENTRYPOINT
- Labels
- Exposed ports
- Volume data mounted from the host

This is an extremely important difference.

---

# Importing a Container

Once a container has been exported,

it can be converted into a new Docker Image.

General Syntax

```bash
docker import FILE IMAGE_NAME
```

Example

```bash
docker import mycontainer.tar workshop-image:v1
```

Docker creates a completely new image using the exported filesystem.

---

# Internal Working

```
Read TAR Archive

↓

Create New Filesystem

↓

Generate Fresh Image

↓

Assign Image ID

↓

Store Image
```

Unlike `docker load`,

Docker creates a brand-new image.

The original image history is gone.

---

# Export/Import Workflow

```
Docker Image

↓

Run Container

↓

Modify Container

↓

docker export

↓

container.tar

↓

docker import

↓

New Docker Image
```

This new image contains the modified filesystem,

but not the original build information.

---

# Save vs Export

This is the comparison every Docker learner should remember.

| docker save | docker export |
|--------------|---------------|
| Works with Images | Works with Containers |
| Preserves Layers | Flattens Filesystem |
| Preserves Tags | Removes Tags |
| Preserves Metadata | Metadata Lost |
| Preserves History | History Lost |
| Used for Image Backup | Used for Container Snapshot |

---

# Load vs Import

| docker load | docker import |
|--------------|---------------|
| Restores Saved Images | Creates New Image from Filesystem |
| Restores Layers | Creates Single-Layer Image |
| Restores Metadata | Metadata Not Restored |
| Restores Tags | Tags Must Be Assigned Again |
| Original Image Preserved | Original Build Information Lost |

---

# Save/Load vs Export/Import

```
docker save

↓

Image

↓

Image.tar

↓

docker load

↓

Same Image



docker export

↓

Container

↓

Filesystem.tar

↓

docker import

↓

New Image
```

One preserves everything.

The other preserves only the container's filesystem.

---

# Why Does Docker Remove Metadata?

Imagine receiving only a printed book.

You can read every page,

but you no longer know:

- who wrote it
- which software created it
- previous revisions
- publishing history

The content exists,

but the history is gone.

Docker behaves similarly.

---

# Production Perspective

Modern DevOps teams rarely use `docker export` during normal deployments.

Instead,

they:

- update Dockerfiles
- rebuild images
- push new versions

Export/Import is mainly used for:

- debugging
- migration
- legacy systems
- capturing temporary environments
- forensic analysis
- educational demonstrations

---

# Best Practices

✅ Prefer rebuilding images using Dockerfiles whenever possible.

✅ Use `docker export` only when the container itself contains valuable changes.

✅ Keep Dockerfiles under version control.

✅ Treat exported containers as temporary artifacts.

---

# Common Mistakes

❌ Assuming `docker export` preserves image metadata.

❌ Expecting imported images to contain history.

❌ Confusing `docker save` with `docker export`.

❌ Using export/import as a replacement for Dockerfiles.

---

# Did You Know?

An image created using `docker import` contains **only one filesystem layer**.

All previous image layers are flattened into a single layer.

This makes imported images fundamentally different from images built using a Dockerfile.

---

# Interview Questions

### Q1. What is the difference between `docker save` and `docker export`?

### Q2. Why is metadata lost during export?

### Q3. What does `docker import` create?

### Q4. Why do imported images contain only one layer?

### Q5. When should export/import be used?

---

# Mini Lab

## Objective

Export a modified container and import it as a new image.

### Tasks

1. Run an Ubuntu container.

```bash
docker run -it --name demo ubuntu
```

2. Inside the container:

- Create a new directory.
- Create a text file.
- Exit the container.

3. Export the container.

```bash
docker export -o demo.tar demo
```

4. Remove the container.

5. Import the archive.

```bash
docker import demo.tar demo-image:v1
```

6. Verify the new image.

```bash
docker images
```

7. Run a container from the imported image and confirm your files exist.

---

# Summary

In this section, you learned:

- What `docker export` does.
- How `docker import` works.
- The difference between images and containers during backup.
- Why metadata is lost.
- Why imported images have a single layer.
- The difference between Save/Load and Export/Import.

Understanding these differences is essential for interviews, troubleshooting, and real-world Docker administration.

# Image Management Best Practices

## Why Best Practices Matter

Docker makes it incredibly easy to create and distribute applications.

However, poorly managed Docker Images can quickly become:

- Large and slow to download
- Difficult to maintain
- Security risks
- Hard to debug
- Costly to store
- Inefficient in CI/CD pipelines

Following best practices ensures that your images remain lightweight, secure, maintainable, and production-ready.

---

# 1. Use Official Base Images

Whenever possible, use Official Images published by trusted maintainers.

Examples:

- ubuntu
- debian
- alpine
- nginx
- python
- node
- postgres
- redis

Official images are:

- Regularly updated
- Security patched
- Well documented
- Widely tested

Avoid downloading images from unknown publishers unless you trust the source.

---

# 2. Pin Image Versions

Avoid:

```dockerfile
FROM python:latest
```

Prefer:

```dockerfile
FROM python:3.12
```

Using explicit versions makes deployments reproducible.

Your application should behave the same today, tomorrow, and six months from now.

---

# 3. Keep Images Small

Smaller images offer many advantages:

- Faster downloads
- Faster deployments
- Lower storage usage
- Reduced network bandwidth
- Smaller attack surface

A good Docker image should include only what the application actually needs.

---

# 4. Reuse Existing Layers

Docker's layer caching is one of its greatest strengths.

Structure your Dockerfile to maximize cache reuse.

Instead of rebuilding everything,

allow Docker to reuse unchanged layers.

This dramatically reduces build times.

---

# 5. Remove Unused Images Regularly

Old images continue occupying storage.

Clean your Docker environment periodically using:

```bash
docker image prune
```

or

```bash
docker system prune
```

Regular cleanup prevents unnecessary disk usage.

---

# 6. Use Meaningful Image Tags

Avoid vague names like:

```
project

image

newimage

test
```

Instead,

use descriptive tags.

Examples:

```
inventory-api:v1.0.0

payment-service:v2.3.1

frontend:stable
```

Meaningful names make deployments easier to understand.

---

# 7. Never Store Secrets Inside Images

Avoid copying:

- Passwords
- API Keys
- SSH Keys
- Database Credentials
- Tokens

into Docker Images.

Instead,

provide secrets during runtime using:

- Environment Variables
- Secret Management Tools
- Container Orchestration Platforms

Images should remain portable and secure.

---

# 8. Use Dockerfiles as the Source of Truth

Never manually modify production containers and then rely on those changes.

Instead,

make changes in the Dockerfile,

rebuild the image,

and redeploy.

Infrastructure should always be reproducible.

---

# 9. Scan Images for Vulnerabilities

Before deploying an image,

scan it for known security vulnerabilities.

Common tools include:

- Docker Scout
- Trivy
- Snyk
- Grype

Security scanning should become part of every CI/CD pipeline.

---

# 10. Keep Image Lifecycle Organized

Follow a clear versioning strategy.

Example:

```
myapp:v1.0.0

↓

myapp:v1.1.0

↓

myapp:v1.2.0

↓

myapp:v2.0.0
```

Never overwrite production versions without proper version control.

---

# Production Perspective

Large organizations often automate image management.

Typical practices include:

- Automated builds
- Automated image scanning
- Registry cleanup policies
- Version pinning
- Immutable deployments

Automation reduces human error and improves reliability.

---

# Common Mistakes

Even experienced developers occasionally make mistakes when working with Docker Images.

Understanding these common pitfalls can save hours of debugging.

---

## 1. Using `latest` Everywhere

Many beginners rely entirely on the `latest` tag.

The problem is that `latest` can change over time.

A deployment that worked yesterday may behave differently today.

Always use explicit version numbers in production.

---

## 2. Building Extremely Large Images

Installing unnecessary packages,

copying unnecessary files,

or using oversized base images

results in slow builds and deployments.

Always aim for minimal images.

---

## 3. Ignoring Layer Caching

Changing frequently modified files near the top of the Dockerfile forces Docker to rebuild many layers unnecessarily.

Organize Dockerfiles to maximize cache efficiency.

---

## 4. Forgetting to Clean Old Images

Unused images accumulate quickly.

Without regular cleanup,

Docker may consume significant disk space.

Develop a habit of pruning unused resources.

---

## 5. Confusing Images and Containers

An Image is a blueprint.

A Container is a running instance.

Deleting one does not automatically remove the other.

Understanding this distinction is essential.

---

## 6. Using Community Images Without Verification

Not every image on Docker Hub is trustworthy.

Always verify:

- Publisher
- Documentation
- Update Frequency
- Community Adoption

Whenever possible,

prefer Official Images.

---

## 7. Storing Secrets in Images

Embedding credentials inside images creates serious security risks.

Secrets should always be injected during deployment.

---

## 8. Using Export/Import Instead of Dockerfiles

Some beginners export modified containers and use them as deployment artifacts.

While this works,

it removes build history and reproducibility.

Dockerfiles should remain the primary way of creating production images.

---

## 9. Forgetting Image Versioning

Without proper tags,

rolling back to previous releases becomes difficult.

Always follow a consistent versioning strategy.

---

## 10. Treating Docker as a Virtual Machine

Docker containers are lightweight processes,

not full operating systems.

Avoid managing them like traditional virtual machines.

---

# Module Summary

Congratulations!

You have completed **Module 02 — Docker Images**.

This module introduced one of Docker's most fundamental concepts: **Images**.

By understanding images, you now understand how Docker packages, distributes, and reproduces applications consistently across different environments.

---

# What You Learned

Throughout this module, you explored:

- What Docker Images are
- Why Docker Images exist
- Image Layers
- Union File Systems
- OverlayFS
- Layer Caching
- Image Tags
- Image Lifecycle
- Searching Images
- Pulling Images
- Building Images
- Inspecting Images
- Tagging Images
- Removing Images
- Saving and Loading Images
- Exporting and Importing Containers
- Image Management Best Practices
- Common Mistakes

---

# Key Takeaways

By now, you should understand that:

- Images are immutable templates.
- Containers are running instances of images.
- Every Docker Image is built layer by layer.
- Layer caching improves build performance.
- Tags identify image versions.
- Save/Load preserves images.
- Export/Import captures container filesystems.
- Smaller, versioned, and secure images are easier to maintain.

---

# Looking Ahead

In the next module,

you'll move from Images to **Docker Containers**.

If Images are the blueprints,

Containers are the actual running applications.

You'll learn:

- Creating Containers
- Running Containers
- Stopping and Restarting Containers
- Interactive Containers
- Detached Mode
- Container Lifecycle
- Logs
- Executing Commands
- Container Networking
- Volumes
- Resource Limits

By the end of the next module,

you'll be comfortable managing Docker applications in real-world development environments.

---

# Final Thought

A Docker Image is more than just a file.

It is a standardized, portable, and reproducible package that ensures software behaves consistently across laptops, testing environments, cloud servers, and production systems.

Mastering Docker Images is the first major milestone in becoming a proficient DevOps Engineer.

---

