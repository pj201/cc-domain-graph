# cc-domain-graph
## Scripts for running CommonCrawl analysis on EMR.

Usage:

- Generate an EC2 keypair, and save the private key to your local machine
- Create an EMR cluster and add your keypair
- Update KEY in emr.sh and run to provision your master node and log into it.
- Run setup.sh from the master to install dependencies and provision slave nodes.

Then connect to Zeppelin at localhost:8890 and start working with pyspark notebooks.
