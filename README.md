# make

Make utility designed to run under linux (2.6.17 or later),
using standard c++ 14 (gcc 5 fully supports this standard).

The build environment allows building shared libraries and applications using gnu make.

Originally built using the following distribution (Debian 9.0.0):
* Debian 4.9.30-2+deb9u2 (2017-06-26)
* g++ (Debian 6.3.0-18) 6.3.0 20170516

Should be placed under the BASE build directory.

## shared libraries

Create a **make.mk** file in the shared lib directory, example:
```
BLDLIBS += $(BASE)/import/thissharedlib

SLBUILDS += $(BASE)/othershared lib

CPPFLAGS += -isystem $(BASE)/import/thissharedlib/include -I $(BASE)/import/thissharedlib

include $(BASE)/othersharedlib

ifeq ($(BLDTYPE),debug)
LDFLAGS += -lgtestd
else
LDFLAGS += -lgtest
endif
```

Create a **Makefile** in the shared lib directory, example:
```
BASE = ../..

NAME = gtest

CPPFLAGS += -isystem include -I . # whatever you need

SRCS = src/gtest-all.cc

include $(BASE)/othersharedlib
include $(BASE)/make/sl.mk # the share lib build file
```

## applications

Create a **Makefile** in the application directory, example:
```
BASE = ../../..

NAME = gtest_all_test

CPPFLAGS += -I ..

SRCS = main.cc

include $(BASE)/import/googletest/make.mk # shared lib(s) to include

include $(BASE)/make/app.mk # the app build file
```

Build the app using one of the following commands:
```
$ make debug
$ make release
$ make clean # cleans app binaries and object files
$ make cleanlibs # cleans all shared libs
$ make cleanall # get rid of all binary and object files
```

After build, object files are in *BASE/obj* directory, example:
```
$ ls -l obj
total 8
drwxr-xr-x 2 mike mike 4096 Aug 18 23:19 gtest_all_test_d
drwxr-xr-x 3 mike mike 4096 Aug 18 23:19 gtest_d
```

Executables and shared libs are in the *BASE/bld* directory, example:
```
$ ls -l bin
total 10140
-rwxr-xr-x 1 mike mike 8225312 Aug 18 23:19 gtest_all_test_d
-rwxr-xr-x 1 mike mike 2153064 Aug 18 23:19 libgtestd.so
```

Can run the executable with the following command:
```
$ LD_LIBRARY_PATH=bin/ bin/gtest_all_test_d
[==========] Running 783 tests from 181 test cases.
[----------] Global test environment set-up.
[----------] 2 tests from GtestCheckDeathTest
...
```
