# Recette provision instance gitlab rapide

# stdpsbckups

* client:
  * save local
  * push remote if there are more local commits  than remote
  * resolve conflicts if there are more local commits  than remote, with:
    * copy versioned directory to another, as backup
    * clone the remote
    * automatically present list of files missing or presenting differences
	* automatically add missing files
	* which will leave only a list of files with differences to remote
* server:
  * bakup gitlab data, config & log dir
  * restore instance
  * wikis not included, README.md versioned with source code
  
  
* launching ops

```
# mkdir doc-pms && cd doc-pms && git clone "" . && sudo chmod +x ./operations.sh && ./operations.sh
# mkdir doc-pms && cd doc-pms && git clone "https://github.com/Jean-Baptiste-Lasselle/recette-gitlab" . && sudo chmod +x ./operations.sh && ./operations.sh

```

# TODOs

## 1. Sur les opérations de backup/restore

* Future règle à implémenter:
```
# La règle implicite est que pour chaque service gitlab, un conteneur est créé avec un nom, et un répertoire lui
# est donné : [$REP_GESTION_CONTENEURS_DOCKER/noeud-gitlab-$GITLAB_INSTANCE_NUMBER].
# Dans lequel ce répertoire on a, pour chaque conteneur, 5 sous répertoires en arbre:
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
```

* Dépendances entre variables d'env.

Le fichier `./operations-std/serveur/restore.sh`, est pour le moment le point exact est fait l'association entre: 

```
 NOM_CONTENEUR_DOCKER <=> noms du répertoire dédié au conteneur $NOM_CONTENEUR_DOCKER (exemple: [$REP_GESTION_CONTENEURS_DOCKER/noeud-gitlab-$GITLAB_INSTANCE_NUMBER])
```
est faite.

* à implémenter:

Demander interactivement à l'utilisateur le nom du conteneur docker à backup/restore, ainsi que le chemin de son répertoire dédié

De la sorte, l'association est déléguée intractivement ou avec avec arguments en ligne de commande:

* si aucun argument n'est passé à `./operations-std/serveur/restore.sh`, il demande interactivement le nom du conteneur docjker, et le chemin de son répertoire dédié (exemple: [`$REP_GESTION_CONTENEURS_DOCKER/noeud-gitlab-$GITLAB_INSTANCE_NUMBER`])
* si un seul argument est passé, alors un message d'erreur est affiché, et l'aide affichée.
* si deux arguments sont passés, alors:
  * le premier est considéré comme étant le nom du conteneur docker (et alors s'il la commande `docker ps -a` ne renvoie pas une sortie standard contenant le nom du conteneur, une erreur est levée)
  * le second est considéré comme étant le chemin du répertoire dédié du conteneur docker, et alors une erreur est levée si les conditions suivnates ne sont pas vérifiées:
    *  - le répertoire indiqué existe dans le système,
    *  - le répertoire indiqué contient un répertoire de nom "mapping-volumes", qui doit contenir aussi 3 répertoires "data", "config", "log", 
    *  - le répertoire indiqué contient un répertoire de nom "bckups", qui doit contenir au moins un répertoire (un backup), qui lui-même doit contenir aussi 3 répertoires "data", "config", "log"


