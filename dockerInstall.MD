## **Docker Installation Guide**  

Below is a detailed guide for installing Docker on Linux

---

## **1. Install Docker on Linux**  

### **1.1 Update System Packages**
```bash
sudo apt update
sudo apt upgrade
```

### **1.2 Install Required Dependencies**
```bash
sudo apt install apt-transport-https ca-certificates curl software-properties-common
```

### **1.3 Add Docker's Official GPG Key**
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

### **1.4 Add Docker Repository**
```bash
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### **1.5 Install Docker Engine**
```bash
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
```

### **1.6 Start Docker Service and Enable Auto-start**
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

### **1.7 Verify Docker Installation**
```bash
sudo docker --version
sudo docker run hello-world
```

### **1.8 Add User to Docker Group (Non-root Access)**
```bash
sudo usermod -aG docker $USER
newgrp docker
```

### **1.9 [Required]Install the NVIDIA GPU driver for your Linux distribution. NVIDIA recommends installing the driver by using the package manager for your distribution.
Configure the production repository:
```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```
Update the packages list from the repository:
```bash
sudo apt-get update
```
Install the NVIDIA Container Toolkit packages:
```bash
sudo apt-get install -y nvidia-container-toolkit
```
Configuring Docker
Configure the container runtime by using the nvidia-ctk command:
```bash
sudo nvidia-ctk runtime configure --runtime=docker
```
The nvidia-ctk command modifies the /etc/docker/daemon.json file on the host. The file is updated so that Docker can use the NVIDIA Container Runtime.

Restart the Docker daemon:
```bash
sudo systemctl restart docker
```
DONE.

Others please refer to [Nvidia docs](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#installing-with-apt)
----------------


## **2. Common Docker Commands**

### **Basic Commands**
```bash
docker --version                 # Check Docker version
docker images                     # List all images
docker ps                         # List running containers
docker ps -a                      # List all containers
docker pull ubuntu                # Pull an image from Docker Hub
docker run -it ubuntu /bin/bash   # Start a container and open a shell
docker stop <container_id>        # Stop a running container
docker rm <container_id>          # Remove a container
docker rmi <image_id>             # Remove an image
```

### **Container Management**
```bash
docker exec -it <container_id> bash # Enter a running container
docker logs <container_id>          # View logs for a container
docker inspect <container_id>       # View detailed information about a container
```

### **Image Building**
```bash
docker build -t myapp .            # Build an image from a Dockerfile
```

---

## **3. Uninstall Docker (Linux)**  
```bash
sudo apt purge docker-ce docker-ce-cli containerd.io
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
```

---

## **6. Troubleshooting**

1. **Permission Denied When Running Docker**  
   - Add your user to the Docker group:
     ```bash
     sudo usermod -aG docker $USER
     ```

2. **Slow Image Downloads**  
   - Set up a mirror for faster downloads:
     ```bash
     sudo mkdir -p /etc/docker
     sudo tee /etc/docker/daemon.json <<-'EOF'
     {
       "registry-mirrors": ["https://registry.docker-cn.com"]
     }
     EOF
     sudo systemctl daemon-reload
     sudo systemctl restart docker
     ```

3. **Port Conflicts or Container Startup Failures**  
   - Check container logs:
     ```bash
     docker logs <container_id>
     ```
   - Resolve port conflicts by changing port bindings.

---

From ChatGPT

