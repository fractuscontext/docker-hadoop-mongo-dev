# Local Hadoop & MongoDB Cluster

Containerised Apache Hadoop (HDFS + YARN) and MongoDB cluster for local development. ARM64 / Apple Silicon native.

- **Python3 Pre-installed:** Fixed Hadoop image for Streaming/MapReduce jobs.
- **Universal Workspace:** Shared `./workspace` as mountpoint for instant data sync.
- **Resource Capped:** Internal JVMs capped at 512MB, and YARN containers capped at 1024MB, keeping the overall stack tightly within a 6GB Docker memory limit to prevent OOM crashes, leaving 2GB of RAM for the host.

## Prerequisites & Resource Allocation

Ensure your Podman or Docker provider has **at least 8GB RAM and 4 CPUs allocated** before starting the cluster. This allows 6GB for the containers, leaving 2GB for your host machine to remain stable.

If you are using Podman Machine (macOS/Windows):

```bash
podman machine stop
podman machine set --memory 8192 --cpus 4
podman machine start
```

## Commands

*(Note: Ensure `mapper.py`, `reducer.py`, and `data.txt` are created inside your local `./workspace` folder before running MapReduce jobs)*

```bash
# Start, first time only (builds the Python image)
podman compose up -d --build --force-recreate

# Run this for subsequent starts (starts instantly)
podman compose up -d

# Enter NameNode Shell:
podman exec -it namenode bash

# --- INSIDE NAMENODE SHELL ---

# Setup HDFS directories
hadoop fs -mkdir -p /user/input
hadoop fs -put /workspace/data.txt /user/input/

# Run the streaming task
hadoop jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-*.jar \
    -files /workspace/mapper.py,/workspace/reducer.py \
    -mapper "python3 /workspace/mapper.py" \
    -reducer "python3 /workspace/reducer.py" \
    -input /user/input/data.txt \
    -output /user/output

# --- NAMENODE SHELL END ---

# Stop containers
podman compose down

# Wipe all cluster data (HDFS and MongoDB volumes)
rm -rf hdfs/ mongo_data/
```

## Service Access & Volume Mounts

| Service | Host Access / URL | Container Path |
| :--- | :--- | :--- |
| **HDFS NameNode Web Interface** | [http://localhost:9870](http://localhost:9870) | - |
| **HDFS DataNode Web Interface** | [http://localhost:9864](http://localhost:9864) | - |
| **YARN ResourceManager Web Interface** | [http://localhost:8088](http://localhost:8088) | - |
| **YARN NodeManager Web Interface** | [http://localhost:8042](http://localhost:8042) | - |
| **HDFS NameNode RPC** | [hdfs://localhost:9000](http://localhost:9000) | - |
| **HDFS DataNode Data Transfer** | [tcp://localhost:9866](http://localhost:9866) | - |
| **YARN ResourceManager RPC** | [tcp://localhost:8032](http://localhost:8032) | - |
| **MongoDB Instance** | [mongodb://localhost:27017](mongodb://localhost:27017) | - |
| **Project Workspace** | `./workspace` | `/workspace` |
| **HDFS Storage Directory** | `./hdfs` | `/opt/hadoop/dfs` |
| **MongoDB Data Volume** | `./mongo_data` | `/data/db` |
