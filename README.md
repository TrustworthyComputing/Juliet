<h1 align="center">Juliet <a href="https://github.com/TrustworthyComputing/Juliet/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg"></a> </h1>
<h3 align="center">An Execution Engine for an Encrypted Processor</h3>

### Prerequisites 
1. Install [TFHE](https://github.com/tfhe/tfhe) 
2. Update library path if necessary:
```bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:<TFHE_INSTALL_DIR>/lib
export LIBRARY_PATH=$LIBRARY_PATH:<CUFHE_DIR>/cufhe/bin
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:<CUFHE_DIR>/cufhe/include
```

### Overview
Juliet is a framework for general-purpose computation with Fully Homomorphic
Encryption (FHE).

docker build -t juliet .

docker run --rm -i -t juliet bash

### Client Setup
1. Run ``make client_scripts_cpu`` for the CPU-based TFHE backend or ``make client_scripts_gpu`` for
   the cuFHE GPU-based backend.
2. Navigate to the ``client`` directory and run ``./keygen.out`` to generate an
   FHE keypair. The evaluation key needed for FHE operations will be placed in
   the ``cloud_enc`` directory.
3. Create a file named ``preAux.txt`` and load this with cleartext integer inputs (one
   per line) that represent sensitive data and will serve as sensitive program inputs
   for Juliet. 
4. Run ``./ppscript.sh`` to automatically generate a ciphertext memory
   directory, which will be placed in the ``cloud_enc`` directory. 
5. Upload the entire ``cloud_enc`` directory to the cloud server.

### How to cite this work
The Juliet paper can be accessed [here](https://trustworthycomputing.github.io/Juliet/Juliet.2024.pdf) and [here](https://ieeexplore.ieee.org/document/10564806); you can cite this work as follows:
```
@article{gouert2024Juliet,
    author       = {Gouert, Charles and Mouris, Dimitris and Tsoutsos, Nektarios Georgios},
    title        = {{Juliet: A Configurable Processor for Computing on Encrypted Data}},
    journal      = {IEEE Transactions on Computers},
    publisher    = {IEEE},
    year         = {2024},
    pages        = {1-14},
    doi          = {10.1109/TC.2024.3416752},
    note         = {\url{https://trustworthycomputing.github.io/Juliet/Juliet.2024.pdf}},
}
```

## Acknowledgments
This work was supported by the National Science Foundation (Award #2239334).

<p align="center">
    <img src="./logos/twc.png" height="20%" width="20%">
</p>
<h4 align="center">Trustworthy Computing Group</h4>
