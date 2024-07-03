#!/bin/bash

mkdir build_libjpeg && cd  build_libjpeg

echo "******************PRINTENV******************"
printenv
echo "********************************************"
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
