## Magento 2 PWA Installer on OSX/Linux Docker stack 
### Don not use in production yet
**Docker containers:  nodejs, watchtower**

### Get Source

    git clone https://github.com/aliuosio/mage2.pwa.git

### Installation
    
    cd mage2.pwa
    chmod +x bin/*.sh
    bin/start.sh
    
> use .env to change values after installation and activate on restart of containers with `bin/start.sh`

### Frontend
    http://localhost:10000/

OSX: on first run very slow due to docker-sync update of local shop files volume in the background. 
See `.docker-sync/daemon.log` for progress

#### Support
If you encounter any problems or bugs, please create an issue on [GitHub](https://github.com/aliuosio/mage2.pwa/issues).

#### Contribute
Please Contribute by creating a fork of this repository.  
Follow the instructions here: https://help.github.com/articles/fork-a-repo/

#### License
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://openng.de/source.org/licenses/MIT)
