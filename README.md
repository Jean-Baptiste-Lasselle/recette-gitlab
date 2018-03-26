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
  * bakup gtilab data dir
  * restore instance
  * wikis not included, README.md versioned with source code