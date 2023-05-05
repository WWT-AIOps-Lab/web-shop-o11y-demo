#!/bin/bash

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -u|--url)
      export PUBLIC_APP_URL="$2"
      shift
      shift
      ;;
    *)
      echo "Unknown option: $1"
      return
      ;;
  esac
done

# Check for operating system type
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Check for Linux distribution/flavor
  if [ -f /etc/os-release ]; then
      . /etc/os-release
      echo "This is a $NAME ($VERSION) system"
      if [[ "$NAME" == "CentOS Linux" ]]; then
        echo "This is a CentOS system"
        yum -y install git-all
        git --version
        yum install -y yum-utils
        yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        systemctl start docker
        docker --version
        docker run hello-world
        . ./up.sh
        . ./setup/add_products.sh default
        docker ps -a
      elif [[ "$NAME" == "Amazon Linux" ]]; then
        
      else
        echo "Not supported"
      fi
  elif [ -f /etc/lsb-release ]; then
      . /etc/lsb-release
      echo "This is a $DISTRIB_ID ($DISTRIB_RELEASE) system"
  elif [ -f /etc/redhat-release ]; then
      echo "This is a $(cat /etc/redhat-release) system"
      if grep -q "CentOS" /etc/redhat-release; then
        echo "This is a CentOS system"
      fi
  else
      echo "Unable to determine Linux distribution/flavor"
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  echo "This is a macOS system"
elif [[ "$OSTYPE" == "cygwin" ]]; then
  echo "This is a Cygwin system"
elif [[ "$OSTYPE" == "msys" ]]; then
  echo "This is a Windows MSYS system"
elif [[ "$OSTYPE" == "win32" ]]; then
  echo "This is a Windows system"
else
  echo "This operating system is not supported"
fi

