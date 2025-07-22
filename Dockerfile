FROM kasmweb/desktop:1.14.0-rolling
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|http://mirror.kakao.com/ubuntu/|g' /etc/apt/sources.list
RUN apt upgrade -y

RUN  rm -rf /var/lib/apt/lists/* \
    && apt-get update \
    && apt-get install -y sudo \
    && echo 'kasm-user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && apt-get install -y uim uim-byeoru \
    && apt-get install -y openssh-server

COPY id_rsa.pub /tmp/id_rsa.pub
RUN mkdir /home/kasm-user/.ssh \
     && mkdir -p /var/run/sshd \
     && sed -i 's/#\?PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config \
     && sed -i 's/#\?PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config \
     && sed -i 's/#\?PubkeyAuthentication .*/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
     && mkdir -p /home/kasm-user/.ssh \
     && cat /tmp/id_rsa.pub >> /home/kasm-user/.ssh/authorized_keys \
     && chown -R kasm-user:kasm-user /home/kasm-user/.ssh \
     && chmod 700 /home/kasm-user/.ssh \
     && chmod 600 /home/kasm-user/.ssh/authorized_keys \
     && chmod 755 /home/kasm-user \
     && echo '\nexport LOGIN_SHELL_INITIALIZED=true' >> /home/kasm-user/.bashrc \
     && /usr/sbin/sshd \
     && /usr/sbin/usermod --shell /bin/bash kasm-user

RUN  add-apt-repository ppa:openjdk-r/ppa \
    && apt-get update \
    && apt-get install -y openjdk-17-jdk \
    && add-apt-repository ppa:maarten-fonville/android-studio \
    && apt-get update \
    && apt-get install -y android-studio

RUN  apt-get install -y software-properties-common apt-transport-https \
    && curl -sSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" \
    && apt-get update \
    && apt-get install -y code

RUN  add-apt-repository ppa:mmk2410/intellij-idea -y \
    && apt-get install intellij-idea-community -y

RUN  sudo add-apt-repository ppa:deadsnakes/ppa -y \
    && sudo apt update \
	&& sudo apt install python3.10 -y \
	&& sudo apt install python3.10-distutils -y \
	&& curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3.10 \
	&& sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1 \
	&& sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.10 2 \
	&& sudo ln -sf /usr/bin/python3.10 /usr/bin/python \
    && sudo apt install python3-pip -y \
    && curl -s https://s3.eu-central-1.amazonaws.com/jetbrains-ppa/0xA6E8698A.pub.asc | gpg --dearmor | sudo tee /usr/share/keyrings/jetbrains-ppa-archive-keyring.gpg > /dev/null \
	&& echo "deb [signed-by=/usr/share/keyrings/jetbrains-ppa-archive-keyring.gpg] http://jetbrains-ppa.s3-website.eu-central-1.amazonaws.com any main" | sudo tee /etc/apt/sources.list.d/jetbrains-ppa.list > /dev/null \
	&& apt update \
	&& apt install pycharm-community -y 

RUN  apt-get install -y mariadb-client
RUN  apt-get install -y redis-tools
# CMD ["/usr/sbin/sshd", "-D"]
######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000

