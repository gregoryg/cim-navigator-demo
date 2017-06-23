# Build ssh command.
sudo yum install -y git epel-release htop wget curl telnet finger mlocate
sudo yum install -y git epel-release htop wget curl telnet finger mlocate
sudo groupadd supergroup
sudo useradd training
cd /home/training
sudo -u training git clone http://github.mtv.cloudera.com/foe/NavigatorDemo.git
sudo -u hdfs hadoop fs -mkdir /user/training /dualcore /realestate
sudo -u hdfs hadoop fs -chown -R training:supergroup /user/training /dualcore /realestate
sudo -u training NavigatorDemo/demo/bin/setup.sh

# Done!
echo "Demo setup complete! Your environment is now ready."
