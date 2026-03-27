# Local Hadoop & MongoDB Cluster

Containerised Apache Hadoop (HDFS + YARN) and MongoDB cluster for local development. ARM64 / Apple Silicon native.

- **Python3 Pre-installed:** Fixed Hadoop image for Streaming/MapReduce jobs.
- **Universal Workspace:** Shared `./workspace` folder for instant data sync.
- **Resource Capped:** Internal JVMs capped at 512MB to prevent OOM crashes.

## Commands

Ensure your provider has >~6GB RAM allocated to handle the Java daemons:

```bash
# Start, first time only (builds the Python image)
podman compose up -d --build

# Run this for subsequent starts (starts instantly)
podman compose up -d

# Enter NameNode Shell:
podman exec -it namenode bash

# Run MapReduce (Inside Shell):
hadoop fs -mkdir -p /user/input
hadoop fs -put /workspace/data.txt /user/input/
hadoop jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-*.jar \
    -files mapper.py,reducer.py -mapper "python3 mapper.py" \
    -reducer "python3 reducer.py" -input /user/input/data.txt -output /user/output

# Reset everything:
rm -rf hdfs/ mongo_data/

# Stop containers:
podman compose down
```

## Resource Allocation

```bash
podman machine stop
podman machine set --memory 8192 --cpus 4
podman machine start
```

## Service Access & Mounts

| Service | Host Access / Path | Container Path |
| :--- | :--- | :--- |
| **HDFS UI** | [http://localhost:9870](http://localhost:9870) | - |
| **YARN UI** | [http://localhost:8088](http://localhost:8088) | - |
| **MongoDB** | `mongodb://localhost:27017` | - |
| **Workspace** | `./workspace` | `/workspace` |
| **HDFS Data** | `./hdfs/` | `/opt/hadoop/dfs/` |
| **Mongo Data** | `./mongo_data/` | `/data/db` |
