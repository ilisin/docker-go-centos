FROM centos

MAINTAINER ilisin gao <ilisin.gao@gmail.com>

RUN yum update -y
RUN yum install -y passwd openssh-server initscripts
RUN yum install -y gcc make git wget

RUN echo 'root:root123' | chpasswd
RUN /usr/sbin/sshd-keygen

# download and config go
RUN wget https://dl.google.com/go/go1.11.linux-amd64.tar.gz -O /opt/go1.11.linux-amd64.tar.gz
RUN tar xvf /opt/go1.11.linux-amd64.tar.gz -C /opt/

RUN echo "export GOROOT=/opt/go" >> $HOME/.bashrc
RUN echo "export GOARCH=amd64" >> $HOME/.bashrc
RUN echo "export GOOS=linux" >> $HOME/.bashrc
RUN echo "export GOPATH=$HOME/go" >> $HOME/.bashrc
RUN echo "export PATH=\$PATH:\$GOPATH/bin:\$GOROOT/bin" >> $HOME/.bashrc

# download and config ssh
RUN yum install -y ruby ruby-devel lua lua-devel luajit luajit-devel ctags python python-devel tcl-devel ncurses-devel
RUN git clone https://github.com/vim/vim /opt/vim
RUN cd /opt/vim && \
     ./configure --with-features=huge --enable-multibyte --enable-rubyinterp --enable-pythoninterp --enable-luainterp --enable-gui=gtk2 --enable-cscope --with-tlib=ncurses --prefix=/usr && \
    make && make install

# copy file
ADD .vimrc /root/.vimrc

ENV GOROOT=/opt/go
ENV GOPATH=/root/go

# config vim
RUN mkdir -p ~/.vim/ && git clone https://github.com/tomasr/molokai /tmp/molokai && mv /tmp/molokai/colors ~/.vim/
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

RUN yum install dos2unix -y
RUN dos2unix /root/.vimrc
RUN vim +PluginInstall +qall
# RUN vim +'silent :PluginInstall' +qall

ENV PATH=${PATH}:${GOPATH}/bin:${GOROOT}/bin
RUN vim +'silent :GoInstallBinaries' +qall
# RUN vim +GoInstallBinaries +qall

# https://github.com/fatih/vim-go/blob/master/plugin/go.vim#L33
# RUN go get github.com/klauspost/asmfmt/cmd/asmfmt && \
#     go get github.com/derekparker/delve/cmd/dlv && \
#     go get github.com/kisielk/errcheck && \
#     go get github.com/davidrjenni/reftools/cmd/fillstruct && \
#     go get github.com/mdempsky/gocode && \
#     go get github.com/rogpeppe/godef && \
#     go get github.com/zmb3/gogetdoc && \
#     go get golang.org/x/tools/cmd/goimports && \
#     go get github.com/golang/lint/golint && \
#     go get github.com/alecthomas/gometalinter && \
#     go get github.com/fatih/gomodifytags && \
#     go get golang.org/x/tools/cmd/gorename && \
#     go get github.com/jstemmer/gotags && \
#     go get golang.org/x/tools/cmd/guru && \
#     go get github.com/josharian/impl && \
#     go get honnef.co/go/tools/cmd/keyify && \
#     go get github.com/fatih/motion && \
#     go get github.com/koron/iferr 

EXPOSE 22

CMD /usr/sbin/sshd -D