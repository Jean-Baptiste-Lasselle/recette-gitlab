# installation de Docker sur centos 7
																						
# update CentOS 7
sudo yum clean all -y && sudo yum update -y
# DOCKER EASE BARE-METAL-INSTALL - CentOS 7
sudo systemctl stop docker
sudo systemctl start docker


# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							ENV								##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------
sudo chmod +x ./docker-EASE-SPACE-BARE-METAL-SETUP.sh
sudo chmod +x ./installation-docker-gitlab.rectte-jibl.sh
./docker-EASE-SPACE-BARE-METAL-SETUP.sh && ./installation-docker-gitlab.rectte-jibl.sh




