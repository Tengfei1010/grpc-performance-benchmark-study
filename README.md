### 1. How to run grpc performence benchmark?


#### 1.1 Install grpc and grpc-go
``` sh
$ ./install_requirements.sh
# input your password
$ git clone -b v1.2.3  https://github.com/grpc/grpc.git
$ cd grpc
$ git submodule update --init
$ make
# it will take some minutes to build third libraries
$ sudo make install
$ make clean
$ cp build_performance_go.sh tools/run_tests/performance/
```

#### 1.2 Run grpc c++ performance benchmark
```sh
# this script will start a port server for testing
$ tools/run_tests/start_port_server.py
# it will build , if you encounter a buidl problem, please use make clean in grpc root
$ tools/run_tests/run_performance_tests.py -l c++
```

#### 1.3 Run grpc-go performance benchmark
```sh
# it will take some minutes to build.
$ tools/run_tests/run_performance_tests.py -l go
```
