# Docker sur centos 7


# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							ENV								##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------
# - Variables d'environnement héritées de "operations.sh":
#                >>>   export ADRESSE_IP_SRV_GITLAB
# --------------------------------------------------------------------------------------------------------------------------------------------
GITLAB_INSTANCE_NUMBER=1
# --------------------------------------------------------------------------------------------------------------------------------------------
#														RESEAU-HOTE-DOCKER																	 #
# --------------------------------------------------------------------------------------------------------------------------------------------
# [SEGMENT-IP alloués par DHCP bytes: 192.168.1.123 => 192.168.1.153]
# ADRESSE_IP_LINUX_NET_INTERFACE_1=192.168.1.123
# ADRESSE_IP_LINUX_NET_INTERFACE_2=192.168.1.124
# ADRESSE_IP_LINUX_NET_INTERFACE_3=192.168.1.125
# ADRESSE_IP_LINUX_NET_INTERFACE_4=192.168.1.126
# --------------------------------------------------------------------------------------------------------------------------------------------

#			MAPPING des répertoires d'installation de gitlab dans les conteneurs DOCKER, avec des répertoires de l'hôte DOCKER				 #
# --------------------------------------------------------------------------------------------------------------------------------------------
# 
# ---------------------------------------
# - répertoires d'installation de gitlab
# ---------------------------------------
GITLAB_CONFIG_DIR=/etc/gitlab
GITLAB_DATA_DIR=/var/opt/gitlab
GITLAB_LOG_DIR=/var/log/gitlab
# ---------------------------------------
# - répertoires  dans l'hôte docker
# ---------------------------------------
export REP_GESTION_CONTENEURS_DOCKER=/conteneurs-docker
# - répertoires associés
CONTENEUR_GITLAB_MAPPING_HOTE_CONFIG_DIR=$REP_GESTION_CONTENEURS_DOCKER/noeud-gitlab-$GITLAB_INSTANCE_NUMBER/config
CONTENEUR_GITLAB_MAPPING_HOTE_DATA_DIR=$REP_GESTION_CONTENEURS_DOCKER/noeud-gitlab-$GITLAB_INSTANCE_NUMBER/data
CONTENEUR_GITLAB_MAPPING_HOTE_LOG_DIR=$REP_GESTION_CONTENEURS_DOCKER/noeud-gitlab-$GITLAB_INSTANCE_NUMBER/logs

export REP_BCKUP
# export OPSTIMESTAMP=`date +"%d-%m-%Y-time-%Hh-%Mm-%Ss"`
export REP_BCKUP_CONTENEURS_DOCKER=$REP_GESTION_CONTENEURS_DOCKER/bckups
# export REP_BCKUP_COURANT=$REP_GESTION_CONTENEURS_DOCKER/bckups/$OPSTIMESTAMP

# rm -rf $REP_BCKUP_COURANT
# mkdir -p $REP_BCKUP_COURANT/log
# mkdir -p $REP_BCKUP_COURANT/data
# mkdir -p $REP_BCKUP_COURANT/config

# TODO => demander interactivement à l'utilisateur le nom du conteneur docker à backup/restore ### DOIT AUSSI DEVENIR VARIABLE D'ENVIRONNEMENT
# mais d'ailleurs, concrètement, c'est à ce point exact qu'est fait le lien entre les dépendances:
#           NOM_CONTENEUR_DOCKER <=> noms du répertoire [$REP_GESTION_CONTENEURS_DOCKER/noeud-gitlab-$GITLAB_INSTANCE_NUMBER]
# Sachant que al règle implicite est que pour chaque service gitlab, un conteneur est créé avec un nom, et un répertoire lui
# est donné, [$REP_GESTION_CONTENEURS_DOCKER/noeud-gitlab-$GITLAB_INSTANCE_NUMBER], dans lequel on a, pour chaque conteneurs, 5 sous répertoires en arbre:
# [$REP_GESTION_CONTENEURS_DOCKER]
#				| 
#				| 
# 		[$REP_GESTION_CONTENEURS_DOCKER/noeud-gitlab-$GITLAB_INSTANCE_NUMBER]
# 											|
# 											|__ mapping-volumes
# 											|	   	  |__ data
# 											|	   	  |__ config
# 											|	   	  |__ log
# 											|
# 											|
# 											|__ bckups
# 											|	   |
# 											|	   |__ unedate/
# 											|	   |	  |__ data
# 											|	   |	  |__ config
# 											|	   |	  |__ log
# 											|	   |	  |
# 											|	   |	  |
# 											|	   |
# 											|	   |
# 											|	   |__ uneautredate/
# 											|	   |	  |__ data
# 											|	   |	  |__ config
# 											|	   |	  |__ log
# 											|	   |	  |
# 											|	   |	  |
# 											|	   |
# 											|	   |
# 											|	   
# 											|	      
#    
#    
#    
export NOM_CONTENEUR_DOCKER=conteneur-kytes.io.gitlab.$GITLAB_INSTANCE_NUMBER

##############################################################################################################################################

# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							FONCTIONS						##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------

demander_emplacement_bckup () {

	echo "Dans le répertoire [$REP_BCKUP_CONTENEURS_DOCKER], Quel est le "
	echo "nom du répertoire du backup sur lequel baser ce restore?"
	echo "-"
	echo "C'est l'un des suivants:"
	echo " "
	ll $REP_GESTION_CONTENEURS_DOCKER
	echo " "
	echo " Part défaut, le répertoire de backup le plus récent sera utilisé, soit:"
	echo " "
	ls -t $REP_GESTION_CONTENEURS_DOCKER | head -1
	echo " "
	read REP_BCKUP_CHOISIT
	if [ "x$REP_BCKUP_CHOISIT" = "x" ]; then
       REP_BCKUP_CHOISIT=$(ls -t $REP_GESTION_CONTENEURS_DOCKER | head -1)
	fi
	
	REP_BCKUP=$REP_BCKUP_CHOISIT
	echo " le répertoire de backup qui sera utilisé pour ce backup est: $REP_BCKUP_CHOISIT/$REP_BCKUP";
}


# - hostname:  archiveur-prj-pms.io
demander_emplacement_bckup
# 1./ Le conteneur doit être arrêté, et détruis:
sudo docker stop $NOM_CONTENEUR_DOCKER
sudo docker rm $NOM_CONTENEUR_DOCKER

# 2./ On détruis les répertoires du conteneur à backupper, pour les re-créer vierges
sudo rm -rf $CONTENEUR_GITLAB_MAPPING_HOTE_CONFIG_DIR
sudo rm -rf $CONTENEUR_GITLAB_MAPPING_HOTE_DATA_DIR
sudo rm -rf $CONTENEUR_GITLAB_MAPPING_HOTE_LOG_DIR
sudo mkdir -p $CONTENEUR_GITLAB_MAPPING_HOTE_CONFIG_DIR
sudo mkdir -p $CONTENEUR_GITLAB_MAPPING_HOTE_DATA_DIR
sudo mkdir -p $CONTENEUR_GITLAB_MAPPING_HOTE_LOG_DIR

# 3./ On copie le backup 
# Pourquoi sudo? parce que l'utilisateur réalisant le backup, n'est pas forcément doté des droits nécessaires pour copier les fichiers exploités par le process gitlab.
# Voir comissionner des utilisateurs linux plus fins.
sudo cp -Rf $REP_BCKUP_CHOISIT/$REP_BCKUP/config $CONTENEUR_GITLAB_MAPPING_HOTE_CONFIG_DIR/*
sudo cp -Rf $REP_BCKUP_CHOISIT/$REP_BCKUP/log $CONTENEUR_GITLAB_MAPPING_HOTE_LOG_DIR/*
sudo cp -Rf $REP_BCKUP_CHOISIT/$REP_BCKUP/data $CONTENEUR_GITLAB_MAPPING_HOTE_DATA_DIR/*

# 4./ On relance un conteneur neuf, en liant ses volumes sur les répertoires backuppés.


# --------------------------------------------------------------------------------------------------------------------------------------------
# Installation de l'instance gitlab dans un conteneur, à partir de l'image officielle :
# https://docs.gitlab.com/omnibus/docker/README.html
# --------------------------------------------------------------------------------------------------------------------------------------------
# ce conteneur docker est lié à l'interface réseau d'adresse IP [$ADRESSE_IP_SRV_GITLAB]:
# ==>> Les ports ouverts avec loption --publish seront accessibles uniquement par cette adresse IP
#
# sudo docker run --detach --hostname gitlab.$GITLAB_INSTANCE_NUMBER.kytes.io --publish $ADRESSE_IP_SRV_GITLAB:4433:443 --publish $ADRESSE_IP_SRV_GITLAB:8080:80 --publish 2227:22 --name $NOM_CONTENEUR_DOCKER --restart always --volume $CONTENEUR_GITLAB_MAPPING_HOTE_CONFIG_DIR:$GITLAB_CONFIG_DIR --volume $CONTENEUR_GITLAB_MAPPING_HOTE_LOG_DIR:$GITLAB_LOG_DIR --volume $CONTENEUR_GITLAB_MAPPING_HOTE_DATA_DIR:$GITLAB_DATA_DIR gitlab/gitlab-ce:latest
# Mais maintenant, j'utilise le nom d'hôte de l'OS, pour régler la question du nom de domaine ppour accéder à l'instance gitlab en mode Web.
# export NOMDHOTE=archiveur-prj-pms.io
sudo docker run --detach --hostname $HOSTNAME --publish $ADRESSE_IP_SRV_GITLAB:433:443 --publish $ADRESSE_IP_SRV_GITLAB:80:80 --publish 2227:22 --name $NOM_CONTENEUR_DOCKER --restart always --volume $CONTENEUR_GITLAB_MAPPING_HOTE_CONFIG_DIR:$GITLAB_CONFIG_DIR --volume $CONTENEUR_GITLAB_MAPPING_HOTE_LOG_DIR:$GITLAB_LOG_DIR --volume $CONTENEUR_GITLAB_MAPPING_HOTE_DATA_DIR:$GITLAB_DATA_DIR gitlab/gitlab-ce:latest




##########################################################################################
#			configuration du nom de domaine pou l'accès à l'instance gitlab   		   	 #  
##########################################################################################
# ----------------------------------------------------------------------------------------
#  - 4 adresses IP dans la VM hôte docker.
# ----------------------------------------------------------------------------------------
# Dans l'hôte docker, on utilise "/etc/hosts" pour config. la résolution noms de domaines:
#
#  - Une des 4 adresses IP de la VM hôte Docker <=> HOSTNAME du conteneur docker/gitlab
#  - On pourra alors avoir jusqu'à 4 conteneurs Docker, accessibles depuis la
#	 VM hôte docker, par 4 noms de domaines différents, correspondant aux 4 hostnames
#	 utilisés pour créer les conteneurs (option --hostname).
# ----------------------------------------------------------------------------------------
# Contenu qui doit être ajouté dans le fichier "/etc/hosts"
# ----------------------------------------------------------------------------------------
# # -----------------------------
# # BYTES CI/CD 
# # -----------------------------
# # + kytes.iofactory jenkins-node
# jenkins.$JENKINS_INSTANCE_NUMBER.bytes.com $ADRESSE_IP_LINUX_NET_INTERFACE_1
# # + bytes.factory artifactory-node
# jenkins.$JENKINS_INSTANCE_NUMBER.bytes.com $ADRESSE_IP_LINUX_NET_INTERFACE_2
# # + bytes.factory gitlab-node ---------------------------------------------------------------------------- >> celui-là c'est le noeud gitlab
# gitlab.$GITLAB_INSTANCE_NUMBER.bytes.com $ADRESSE_IP_SRV_GITLAB
# ----------------------------------------------------------------------------------------


# éditer dans le conteneur docker, le fichier "/etc/gitlab/gitlab.rb":
# sudo docker exec -it gitlab vi /etc/gitlab/gitlab.rb
# et donner la valeur suivante au paramètre "external_url":
# external_url "http://gitlab.$GITLAB_INSTANCE_NUMBER.bytes.com:8080"
# autre exemple avec une valeur exemple d'url
# external_url "http://gitlab.example.com"



##########################################################################################
#				DOC OFFICELLE POUR CONFIG GITLAB DANS CONTENEUR DOCKER 					 #
##########################################################################################
# export AUTRE_OPTION= ce que vou voulez parmi els optiosn de config gitlab
# --env GITLAB_OMNIBUS_CONFIG="external_url 'http://my.domain.com/'; $AUTRE_OPTION;"
# Exemple valide:
# --env GITLAB_OMNIBUS_CONFIG="external_url 'http://my.domain.com/';"
##########################################################################################
# By adding the environment variable GITLAB_OMNIBUS_CONFIG to docker run command.
# This variable can contain any gitlab.rb setting and will be evaluated before loading
# the container's gitlab.rb file.
##########################################################################################
# HTTPS et GITLAB ==>> 
##########################################################################################
# 
# 
# 
# 
# 
# 


