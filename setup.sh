#################################################################
# install packages on master node

sudo yum update
sudo yum -y install git 
sudo yum -y install pssh
sudo pip install -e git+https://github.com/commoncrawl/gzipstream.git#egg=gzipstream
sudo pip install warc ujson sklearn

#git clone https://github.com/box121209/cc-domain-graph
#export PYTHONPATH=$PYTHONPATH:/home/hadoop/cc-domain-graph/pyspark
#export SPARK_HOME=/usr/lib/spark
#export PYTHONPATH=$PYTHONPATH:$SPARK_HOME/python:$SPARK_HOME/python/lib
#sudo ln -s $SPARK_HOME /usr/local
#sudo pip install jupyter
#export PYSPARK_DRIVER_PYTHON=jupyter
#export PYSPARK_DRIVER_PYTHON_OPTS='notebook'
#aws s3 cp s3://aws-bigdata-blog/artifacts/aws-blog-emr-jupyter/install-jupyter-emr5.sh .
#chmod +x install-jupyter-emr5.sh
# the next bit takes quite a few minutes:
#./install-jupyter-emr5.sh —-toree
#sudo pip install toree
#sudo jupyter toree install --interpreters=PySpark,SQL


#################################################################
# locate slave nodes

hdfs dfsadmin -report | grep ^Name | cut -f2 -d: | cut -f2 -d' ' | sed -e 's/^/hadoop@/' > slaves
echo `wc -l slaves`

#################################################################
# add identity to slave nodes

ssh-agent bash
ssh-add billsdata-us-east-1.pem
ssh-keygen -q -P "" -f ~/.ssh/id_rsa

for x in `cat slaves`
do
    ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub $x
done

#################################################################
# install packages across slave nodes

pssh -h ./slaves -t 100000000 'sudo yum update; sudo yum -y install git; sudo yum -y install pssh; sudo pip install -e git+https://github.com/commoncrawl/gzipstream.git#egg=gzipstream; sudo pip install warc ujson sklearn'

# NOTE: the option -t 10000000 is to prevent time-out during install of 
# scipy (needed for sklearn) which does a lot of compiling.

#################################################################



