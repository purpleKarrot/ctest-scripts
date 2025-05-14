set(ENV{CC}  "/usr/bin/clang")
set(ENV{CXX} "/usr/bin/clang++")

set(ENV{CFLAGS}   "-fno-omit-frame-pointer -fsanitize=undefined")
set(ENV{CXXFLAGS} "-fno-omit-frame-pointer -fsanitize=undefined")

set(CTEST_MEMORYCHECK_TYPE "UndefinedBehaviorSanitizer")
