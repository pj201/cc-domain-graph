KEY="/Users/49269/.ssh/Billsdata-20170604.pem"
#KEY="/Users/paulj/.ssh/paulj-us-east-1.pem"

[ $# -eq 0 ] && { echo "Usage: $0 AWS_Hostname"; exit 1; }

# Copy key and setup script to master node
scp -i $KEY ./gpu_setup.sh ubuntu@$1:~
scp -i $KEY ./ ubuntu@$1:~

# Login to master, with tunnel for Jupyter
ssh -i $KEY -L 8888:localhost:8888 -L 6006:localhost:6006 ubuntu@$1
