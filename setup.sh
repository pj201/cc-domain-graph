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

echo "--> Configuring ssh..."

# TODO: Replace with your key below (generated from EC2 keypair service)
KEY="billsdata-us-east-1.pem"
#KEY="paulj-us-east-1.pem"

eval `ssh-agent`
#ssh-agent bash # Stops script by forking a new bash
ssh-add $KEY
ssh-keygen -q -P "" -f ~/.ssh/id_rsa

echo "--> Finished ssh keygen."

for x in `cat slaves`
do
    echo "--> Copying keys into slave node: " $x
    ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub $x
done

#################################################################
# install packages across slave nodes

echo "--> Installing packages across slaves (this may take a few mins)..."
pssh -h ./slaves -t 100000000 'sudo yum update; sudo yum -y install git; sudo yum -y install pssh; sudo pip install -e git+https://github.com/commoncrawl/gzipstream.git#egg=gzipstream; sudo pip install warc ujson sklearn'

# NOTE: the option -t 10000000 is to prevent time-out during install of 
# scipy (needed for sklearn) which does a lot of compiling.

#################################################################

