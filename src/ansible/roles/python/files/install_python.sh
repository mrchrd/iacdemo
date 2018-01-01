#!/bin/sh

install_apt () {
  DEBIAN_FRONTEND='noninteractive'
  apt-get update -qy

  if ! python --version; then
    apt-get install -qy python-minimal python-pip
  fi
}

install_pypy () {
  PYPY_VERSION='5.9'

  if ! python --version; then
    [ ! -d /opt/bin ] && mkdir -p /opt/bin

    wget -qO- "https://bitbucket.org/squeaky/portable-pypy/downloads/pypy-${PYPY_VERSION}-linux_x86_64-portable.tar.bz2" | tar -xj -C /opt
    ln -sf "pypy-${PYPY_VERSION}-linux_x86_64-portable" /opt/pypy

    cat > /opt/bin/python <<- 'EOF'
	#!/bin/bash
	export LD_LIBRARY_PATH=/opt/pypy/lib:$LD_LIBRARY_PATH
	exec /opt/pypy/bin/pypy "$@"
	EOF
    chmod +x /opt/bin/python

    wget -qO- https://bootstrap.pypa.io/get-pip.py | python

    cat > /opt/bin/pip <<- 'EOF'
	#!/bin/bash
	export LD_LIBRARY_PATH=/opt/pypy/lib:$LD_LIBRARY_PATH
	exec /opt/pypy/bin/pip "$@"
	EOF
    chmod +x /opt/bin/pip
  fi
}

install_yum () {
  if ! python --version; then
    yum install -qy python python-pip
  fi
}

if apt-get --version; then
  install_apt
elif yum --version; then
  install_yum
else
  install_pypy
fi

python --version
