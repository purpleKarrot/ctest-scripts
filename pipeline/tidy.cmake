set(ENV{CC}  "/usr/bin/clang")
set(ENV{CXX} "/usr/bin/clang++")

set(CTEST_CONFIGURE_OPTIONS
  "-DCMAKE_C_CLANG_TIDY=/usr/bin/clang-tidy"
  "-DCMAKE_CXX_CLANG_TIDY=/usr/bin/clang-tidy"
  )
