# kasm-vdi
kasm-ubuntu 를 사용한 VDI Docker image

### 1. Create a `.env` file(Mandatory) and Copy `id_rsa.pub` file from client for ssh.(If you want) 

Add a `.env` file in the project root directory to define environment variables:

```env
ASM_VNC_PW=password
VNC_PORT=6901
SSH_PORT=22
```


### 2. Deploy with Docker

Use Docker Compose to build and run the deployment:

```
$ docker-compose build
$ docker-compose up -d
```


### 3. Set environment variable

After docker container run, edit ~/.bashrc file in container to use React-Native:

```
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export ANDROID_HOME="/home/kasm-user/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
```


### 4. Start ssh service

Enable ssh service:

```
$ service ssh status
$ service ssh start
```
