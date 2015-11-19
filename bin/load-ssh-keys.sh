#!/bin/bash

cp /vagrant/untracked-files/ssh/* ~/.ssh
chmod 600 ~/.ssh/*
cp /vagrant/files/known_hosts ~/.ssh
chmod 644 ~/.ssh

#cp /vagrant/untracked-files/ssh/* /home/vagrant/.ssh
#chown -R vagrant:vagrant /home/vagrant/.ssh/*
#chmod 600 /home/vagrant/.ssh/*
#cp /vagrant/files/known_hosts /home/vagrant/.ssh
#chmod 644 /home/vagrant/.ssh

