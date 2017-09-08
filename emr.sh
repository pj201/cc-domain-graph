scp -i /Users/49269/.ssh/billsdata-us-east-1.pem /Users/49269/.ssh/billsdata-us-east-1.pem hadoop@$1:~
scp -i /Users/49269/.ssh/billsdata-us-east-1.pem ./setup.sh hadoop@$1:~
ssh -i /Users/49269/.ssh/billsdata-us-east-1.pem -L 8890:localhost:8890 hadoop@$1
