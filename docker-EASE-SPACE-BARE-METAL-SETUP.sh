# ----------------------------------------------------------------------------------------------------------------------
# 
# 
# Guide de l'utilisateur.
# -----------------------
# 
#		http://isoredirect.centos.org/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1708.iso
#		http://miroir.univ-paris13.fr/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1708.iso
#
# Nous utiliserons:
# 
# 	+ une VM [MachineHote], sur laquelle a été installé centos 7.4 . Les scripts ont été testés dans un environnement tel que :
#
#			[cat /etc/centos-release] imprime sur la sortie standard:
#			[CentOS Linux release 7.4.1708 (Core)]
#			[uname] imprime sur la sortie standard:
#			[CentOS Linux release 7.4.1708 (Core)]
# 
# 	+ 1 script:
# 
#  		- [bare-metal-docker-demo-BARE-METAL-SETUP.sh]
# 
# 1./ Ouvrir une session sftp avec WinSCP par exemple, vers la [MachineHote], puis 
# 	  copier le présent fichier "bare-metal-docker-demo-BARE-METAL-SETUP.sh" dans un
#	  répertoire dans [MachineHote].
# 
# 2./ Ouvrir une session ssh vers [MachineHote], puis exécuter : 
# 
# 			[sudo chmod +x ./bare-metal-docker-demo-BARE-METAL-SETUP.sh]
# 			[sudo ./bare-metal-docker-demo-BARE-METAL-SETUP.sh]
# 
# -----------------------------------------------------------------------------------------------------------------------
# installations bare-metal
# -----------------------------------------------------------------------------------------------------------------------
#
# sudo yum clean all -y && sudo yum update -y
sudo yum install -y wget
sudo rm -f index.html
sudo rm -f installation-docker-ce-not-production-env.sh
sudo wget https://get.docker.com/
sudo cp index.html installation-docker-ce-not-production-env.sh
sudo rm -f index.html
sudo yum --enablerepo=extras install -y epel-release
sudo yum update -y && sudo yum clean all -y && sudo yum update -y
sudo chmod +x installation-docker-ce-not-production-env.sh
sudo ./installation-docker-ce-not-production-env.sh
sudo usermod -aG docker $USER
# 
sudo systemctl enable docker
sudo systemctl start docker

# remarque :: La clé publique pour docker-ce-17.11.0.ce-1.el7.centos.x86_64.rpm n'est pas installée