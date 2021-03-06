# Script for initial provisioning of EMR master node
# Copies key and setup script, then logs in and creates tunnels for Zeppelin and Ganglia
# BO/PJ 8/9/17

# TODO: Replace with your key below (generated from EC2 keypair service)
#KEY="/Users/49269/.ssh/billsdata-us-east-1.pem"
#KEY="/Users/paulj/.ssh/paulj-us-east-1.pem"
KEY="/Users/paulj/.ssh/PaulJ-20170907.pem"
#KEY="/Users/paulj/.ssh/paulj-ireland-1.pem"

[ $# -eq 0 ] && { echo "Usage: $0 AWS_Hostname"; exit 1; }

# Copy key and setup script to master node
scp -i $KEY $KEY hadoop@$1:~
scp -i $KEY ./emr_setup.sh hadoop@$1:~

# Login to master, with tunnel for Ganglia, Spark and Zeppelin respectively
ssh -i $KEY -L 8880:localhost:80 -L 8818:localhost:18080 -L 8890:localhost:8890 hadoop@$1
