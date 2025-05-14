set(ENV{CC}  "/usr/bin/clang")
set(ENV{CXX} "/usr/bin/clang++")

set(ENV{CFLAGS}   "-fno-omit-frame-pointer -fsanitize=address")
set(ENV{CXXFLAGS} "-fno-omit-frame-pointer -fsanitize=address")

set(CTEST_MEMORYCHECK_TYPE "AddressSanitizer")
