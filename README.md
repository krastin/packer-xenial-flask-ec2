# packer-xenial-flask-ec2
An EC2 AMI based on ubuntu xenial with flask

# Prerequisites
## Install packer
Grab packer and learn how to install it from [here](https://www.packer.io/intro/getting-started/install.html).

## Install aws-cli
Grab aws-cli and learn how to install it from [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html).

## Install kitchen
Use the following instructions as a guidance. Different steps might have to be used ultimately.

### Install rbenv
<details>
  <summary>Install on MacOS</summary>

  ```
  brew install rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
rbenv init
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
  ```
</details>

<details>
  <summary>Install on Linux</summary>
  
  ```
apt update
apt install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev
wget -q https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer -O- | bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
rbenv init
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
  ```
</details>

### Install Ruby Gems
```
rbenv install 2.4.6
rbenv local 2.4.6
rbenv versions
gem install bundler
bundle install
```

# How to build the AWS AMI

    packer build template.json

# How to test
    bundle exec kitchen test
    

# Purpose

This repository attempts to store the minimum amount of code that is required to create a:
- Ubuntu Xenial64 box
- Flask running in development mode on port 8080
- Standard NGINX reverse proxy from port 80 to 8080
- using Packer
- for Amazon AWS EC2

# To Do
- [ ] create makefile
- [ ] add kitchen test to makefile

# Done
- [x] add kitchen install instructions
- [x] create kitchen test
- [x] add nginx to box
- [x] add flask to box
- [x] create json template file
- [x] build initial readme
