<h1 align="center">Juliet <a href="https://github.com/TrustworthyComputing/Juliet/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg"></a> </h1>
<h3 align="center">An Execution Engine for an Encrypted Processor</h3>

### Prerequisites 
1. Install [TFHE](https://github.com/tfhe/tfhe) 
2. Update library path if necessary: \
``export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:<TFHE_INSTALL_DIR>/lib``
``export LIBRARY_PATH=$LIBRARY_PATH:<CUFHE_DIR>/cufhe/bin``
``export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:<CUFHE_DIR>/cufhe/include``

### Overview
Juliet is a framework for general-purpose computation with Fully Homomorphic
Encryption (FHE).

docker build -t juliet .

docker run --rm -i -t juliet bash

<p align="center">
    <img src="./logos/twc.png" height="20%" width="20%">
</p>
<h4 align="center">Trustworthy Computing Group</h4>
