set(ENV{CC}  "/usr/bin/clang")
set(ENV{CXX} "/usr/bin/clang++")

set(CTEST_CONFIGURE_OPTIONS
  "-DCMAKE_C_INCLUDE_WHAT_YOU_USE=/usr/bin/include-what-you-use"
  "-DCMAKE_CXX_INCLUDE_WHAT_YOU_USE=/usr/bin/include-what-you-use"
  "-DCMAKE_LINK_WHAT_YOU_USE=ON"
  )
