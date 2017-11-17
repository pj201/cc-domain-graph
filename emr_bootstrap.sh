#!/bin/bash -xe

# TODO: Add key distribution code here if need be

sudo yum update
sudo yum -y install git 
sudo yum -y install pssh
sudo pip install -e git+https://github.com/commoncrawl/gzipstream.git#egg=gzipstream
sudo pip install warc ujson sklearn pybloom langdetect pandas pycld2

