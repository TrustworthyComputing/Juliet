client_scripts_cpu: client/keygen.c client/preprocessor.c client/decrypt.c client/filenames.c 
	gcc -o client/keygen client/keygen.c -ltfhe-spqlios-fma
	gcc -o client/preprocessor client/preprocessor.c client/filenames.c -ltfhe-spqlios-fma
	gcc -o client/decrypt client/decrypt.c -ltfhe-spqlios-fma

client_scripts_gpu: client/keygen.cu client/preprocessor.cu client/decrypt.cu
	nvcc -o client/keygen.out client/keygen.cu -lcufhe_gpu  -Xcompiler -Wall
	nvcc -o client/preprocessor client/preprocessor.cu -lcufhe_gpu  -Xcompiler -Wall
	nvcc -o client/decrypt.out client/decrypt.cu -lcufhe_gpu  -Xcompiler -Wall
	
encalu_cpu: cloud_enc/encalu.c cloud_enc/filenames.c
	gcc -o cloud_enc/encalu_cpu cloud_enc/encalu.c cloud_enc/filenames.c -ltfhe-spqlios-fma

encalu_gpu: cloud_enc/encalu_gpu.cu
	nvcc -c -o cloud_enc/encalu_gpu.o cloud_enc/encalu_gpu.cu -lcufhe_gpu  -Xcompiler -Wall 