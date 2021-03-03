install_tfhe:
	sudo apt-get install build-essential cmake cmake-curses-gui
  git clone https://github.com/tfhe/tfhe.git
	cd tfhe
	mkdir build
	cd build
	ccmake ../src
	make
	make install

setenv:
	TFHE_PREFIX=/usr/local
	export C_INCLUDE_PATH=$C_INCLUDE_PATH:$TFHE_PREFIX/include
	export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:$TFHE_PREFIX/include
	export LIBRARY_PATH=$LIBRARY_PATH:$TFHE_PREFIX/lib
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$TFHE_PREFIX/lib

keygen: client/keygen.c
	gcc -o client/keygen client/keygen.c -ltfhe-spqlios-fma
	./client/keygen

build_enc_func_units: encrypted_functional_units/*.c
	gcc -o encrypted_functional_units/encrnot encrypted_functional_units/filenames.c encrypted_functional_units/encrnot.c -ltfhe-spqlios-fma
	gcc -o encrypted_functional_units/encrand encrypted_functional_units/filenames.c encrypted_functional_units/encrand.c -ltfhe-spqlios-fma
	gcc -o encrypted_functional_units/encrnand encrypted_functional_units/filenames.c encrypted_functional_units/encrnand.c -ltfhe-spqlios-fma
	gcc -o encrypted_functional_units/encror encrypted_functional_units/filenames.c encrypted_functional_units/encror.c -ltfhe-spqlios-fma
	gcc -o encrypted_functional_units/encrnor encrypted_functional_units/filenames.c encrypted_functional_units/encrnor.c -ltfhe-spqlios-fma
	gcc -o encrypted_functional_units/encrxor encrypted_functional_units/filenames.c encrypted_functional_units/encrxor.c -ltfhe-spqlios-fma
	gcc -o encrypted_functional_units/encrxnor encrypted_functional_units/filenames.c encrypted_functional_units/encrxnor.c -ltfhe-spqlios-fma
	gcc -o encrypted_functional_units/encrmux encrypted_functional_units/filenames.c encrypted_functional_units/encrmux.c -ltfhe-spqlios-fma
	gcc -o encrypted_functional_units/encradd encrypted_functional_units/filenames.c encrypted_functional_units/encradd.c -ltfhe-spqlios-fma
	gcc -o encrypted_functional_units/encrmul encrypted_functional_units/filenames.c encrypted_functional_units/encrmul.c -ltfhe-spqlios-fma
	gcc -o encrypted_functional_units/encrconst encrypted_functional_units/filenames.c encrypted_functional_units/encrconst.c -ltfhe-spqlios-fma
	gcc -o encrypted_functional_units/encrcomp encrypted_functional_units/filenames.c encrypted_functional_units/encrcomp.c -ltfhe-spqlios-fma
