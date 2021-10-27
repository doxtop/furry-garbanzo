CXX=g++
PLATFORM=OS_MACOSX
JEMALLOC_VER=$(shell brew ls --versions jemalloc | cut -f 2 -d ' ')
JEMALLOC_INCLUDE="-I/usr/local/Cellar/jemalloc/${JEMALLOC_VER}/include"
JEMALLOC_LIB="/usr/local/Cellar/jemalloc/${JEMALLOC_VER}/lib/libjemalloc_pic.a"
PLATFORM_LDFLAGS= -lsnappy -lz -lbz2 -llz4 -lzstd ${JEMALLOC_LIB}
PLATFORM_CXXFLAGS=-std=c++11  -faligned-new -DHAVE_ALIGNED_NEW -DROCKSDB_PLATFORM_POSIX -DROCKSDB_LIB_IO_POSIX  -DOS_MACOSX -DSNAPPY -DZLIB -DBZIP2 -DLZ4 -DZSTD -DROCKSDB_BACKTRACE -Wshorten-64-to-32 -march=native   -DHAVE_SSE42  -DHAVE_PCLMUL  -DHAVE_AVX2  -DHAVE_BMI  -DHAVE_LZCNT -DHAVE_UINT128_EXTENSION -DROCKSDB_SUPPORT_THREAD_LOCAL
PLATFORM_CXXFLAGS += -DROCKSDB_JEMALLOC -DJEMALLOC_NO_DEMANGLE $(JEMALLOC_INCLUDE)
EXEC_LDFLAGS := $(JEMALLOC_LIB) $(EXEC_LDFLAGS) -lpthread
CXXFLAGS += -fno-rtti

all: simple_example

simple_example: simple_example.cc
	$(CXX) $(CXXFLAGS) $@.cc -o$@ librocksdb.a -Iinclude -O2 -std=c++11 $(PLATFORM_LDFLAGS) $(PLATFORM_CXXFLAGS) $(EXEC_LDFLAGS)

clean:
	rm -rf ./simple_example
