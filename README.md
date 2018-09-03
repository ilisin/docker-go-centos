### 编译


    docker build ./ -t centos-ssh



### run

    docker run -it --rm --name centos-ssh -p 222:22 centos-ssh


config go

```
wget https://dl.google.com/go/go1.11.linux-amd64.tar.gz -O /opt/go1.11.linux-amd64.tar.gz
tar xvf /opt/go1.11.linux-amd64.tar.gz -C /opt/

echo "export GOROOT=/opt/go" >> $HOME/.bashrc
echo "export GOARCH=amd64" >> $HOME/.bashrc
echo "export GOOS=linux" >> $HOME/.bashrc
echo "export GOPATH=$HOME/go" >> $HOME/.bashrc
echo "export PATH=\$PATH:\$GOPATH/bin:\$GOROOT/bin" >> $HOME/.bashrc

```


```

yum install -y ruby ruby-devel lua lua-devel luajit luajit-devel ctags python \
  python-devel tcl-devel ncurses-devel

git clone https://github.com/vim/vim /opt/vim

cd /opt/vim

./configure --with-features=huge --enable-multibyte --enable-rubyinterp --enable-pythoninterp --enable-luainterp --enable-gui=gtk2 --enable-cscope --with-tlib=ncurses --prefix=/usr

make && make install

# config vim
# copy .vimrc

mkdir -p ~/.vim/ && git clone https://github.com/tomasr/molokai /tmp/molokai && mv /tmp/molokai/colors ~/.vim/

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

vim +PluginInstall +qall

vim +GoInstallBinaries +qall
```