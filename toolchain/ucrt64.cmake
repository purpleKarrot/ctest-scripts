set(CMAKE_SYSTEM_NAME "Windows")
set(CMAKE_SYSTEM_PROCESSOR "x86_64")

set(__prefix "x86_64-w64-mingw32ucrt")

set(CMAKE_C_COMPILER   "/usr/bin/${__prefix}-gcc")
set(CMAKE_CXX_COMPILER "/usr/bin/${__prefix}-g++")
set(CMAKE_RC_COMPILER  "/usr/bin/${__prefix}-windres")

set(CMAKE_FIND_ROOT_PATH "/usr/${__prefix}/sys-root/mingw/")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_CROSSCOMPILING_EMULATOR ${CMAKE_COMMAND} -E env
  "WINEPATH=/usr/${__prefix}/sys-root/mingw/bin" -- /usr/bin/wine64
  )
