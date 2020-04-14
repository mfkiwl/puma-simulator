set -v
set -e
path=/home/nano01/a/snegi/Projects/NAS/puma  #path to your puma directory
cppfile=mlp_l4_mnist #name for cpp file that you want to compile ex- mlp_l4_mnist.cpp, conv-layer.cpp, convmax-layer.cpp
name=mlp #name for the folder generated by compiler
pumaenv=pumaenv #name for the environment 

rm ${path}/puma-simulator/include/config.py #remove existing config file
cp ${path}/puma-simulator/include/example-configs/config-mlp.py  ${path}/puma-simulator/include/config.py #copy the mlp config file to include


# chmod u+r+x filename.sh
cd ${path}/puma-compiler/src
source ~/.bashrc
conda activate ${pumaenv}

make clean
make

cd ${path}/puma-compiler/test
make clean
make ${cppfile}.test
export LD_LIBRARY_PATH=`pwd`/../src:$LD_LIBRARY_PATH
./${cppfile}.test
echo $cppfile  
./generate-py.sh 
cp -r ${name} ../../puma-simulator/test/testasm

cd ${path}/puma-simulator/src


python dpe.py -n ${name} 



