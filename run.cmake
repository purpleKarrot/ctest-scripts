#!/usr/bin/env -S ctest -S

cmake_minimum_required(VERSION 3.30)

set(CTEST_SITE "purplekarrot.net")
set(CTEST_CMAKE_GENERATOR "Ninja")
set(CTEST_USE_LAUNCHERS ON)

if(NOT DEFINED CTEST_BUILD_NAME)
  message(FATAL_ERROR "CTEST_BUILD_NAME must be set!")
endif()

set(__pipeline_dir "${CMAKE_CURRENT_LIST_DIR}/pipeline")
set(__toolchain_dir "${CMAKE_CURRENT_LIST_DIR}/toolchain")
set(__pipeline_file "${__pipeline_dir}/${CTEST_BUILD_NAME}.cmake")
set(__toolchain_file "${__toolchain_dir}/${CTEST_BUILD_NAME}.cmake")

if(EXISTS "${__toolchain_file}")
  set(ENV{CMAKE_TOOLCHAIN_FILE} "${__toolchain_file}")
endif()

if(EXISTS "${__pipeline_file}")
  include("${__pipeline_file}")
else()
  message(FATAL_ERROR "Unknown CTEST_BUILD_NAME=${CTEST_BUILD_NAME}!")
endif()

if(NOT DEFINED CTEST_SOURCE_DIRECTORY)
  message(FATAL_ERROR "CTEST_SOURCE_DIRECTORY must be set!")
endif()

string(MD5 src_md5 "${CTEST_SOURCE_DIRECTORY}")
file(REAL_PATH "~/.cache/build/${src_md5}" CTEST_BINARY_DIRECTORY EXPAND_TILDE)
file(REMOVE_RECURSE "${CTEST_BINARY_DIRECTORY}")

execute_process(COMMAND git rev-parse HEAD
  WORKING_DIRECTORY "${CTEST_SOURCE_DIRECTORY}"
  OUTPUT_VARIABLE CTEST_CHANGE_ID
  OUTPUT_STRIP_TRAILING_WHITESPACE
  )

cmake_host_system_information(RESULT nproc QUERY NUMBER_OF_LOGICAL_CORES)

ctest_start("Experimental")
ctest_submit(PARTS "Start")

ctest_configure(OPTIONS "${CTEST_CONFIGURE_OPTIONS}")
ctest_submit(PARTS "Configure")

ctest_build(PARALLEL_LEVEL ${nproc})
ctest_submit(PARTS "Build")

if(CTEST_MEMORYCHECK_COMMAND OR CTEST_MEMORYCHECK_TYPE)
  ctest_memcheck(PARALLEL_LEVEL ${nproc})
  ctest_submit(PARTS "MemCheck")
else()
  ctest_test(PARALLEL_LEVEL ${nproc})
  ctest_submit(PARTS "Test")
endif()

if(CTEST_COVERAGE_COMMAND)
  ctest_coverage()
  ctest_submit(PARTS "Coverage")
endif()

if(DEFINED CPACK_GENERATOR)
  execute_process(COMMAND "${CMAKE_CPACK_COMMAND}" -G "${CPACK_GENERATOR}"
    "-DCPACK_THREADS=${nproc}"
    WORKING_DIRECTORY "${CTEST_BINARY_DIRECTORY}"
    OUTPUT_VARIABLE cpack_output
    )
  set(package_regex "CPack: - package: ([^\n;]+) generated.")
  string(REGEX MATCHALL "${package_regex}" matches "${cpack_output}")
  string(REGEX REPLACE "${package_regex}" "\\1" files "${matches}")
  ctest_upload(FILES ${files})
  ctest_submit(PARTS "Upload")
endif()

ctest_submit(PARTS "Done")
file(REMOVE_RECURSE "${CTEST_BINARY_DIRECTORY}")
