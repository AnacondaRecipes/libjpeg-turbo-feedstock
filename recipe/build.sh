#!/bin/bash

mkdir build_libjpeg && cd  build_libjpeg

# We build the binaries with the install rpaths, then test the installed binaries.
# If we don't do this, the build rpaths remain after installation on osx, resulting in DSO check failures.
# This seems to be an issue on our CI only, as local builds don't replicate it and conda-forge doesn't seem to
# have the same issue.

cmake -G"Ninja" \
      ${CMAKE_ARGS} -D CMAKE_INSTALL_PREFIX=$PREFIX \
      -D CMAKE_INSTALL_LIBDIR="$PREFIX/lib" \
      -D CMAKE_BUILD_TYPE=Release \
      -D ENABLE_STATIC=1 \
      -D ENABLE_SHARED=1 \
      -D WITH_JPEG8=1 \
      -D CMAKE_ASM_NASM_COMPILER=yasm \
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE \
      $SRC_DIR

ninja -j$CPU_COUNT

ninja install -j$CPU_COUNT

ninja test

# We can remove this when we start using the new conda-build.
find $PREFIX -name '*.la' -delete
