#!/bin/sh
set -e

prefix="/opt"
[ -n "$1" ] && prefix="$1"
cmake_pars="$2"

# Default Qt5 CMake config path on CentOS 7 packages:
QT5_CMAKE_DIR="/usr/lib64/cmake/Qt5"

# If caller didn't pass Qt5_DIR/CMAKE_PREFIX_PATH, add them.
case "$cmake_pars" in
  *Qt5_DIR* ) : ;;
  * ) cmake_pars="$cmake_pars -DQt5_DIR=$QT5_CMAKE_DIR" ;;
esac
case "$cmake_pars" in
  *CMAKE_PREFIX_PATH* ) : ;;
  * ) cmake_pars="$cmake_pars -DCMAKE_PREFIX_PATH=$QT5_CMAKE_DIR" ;;
esac

# Prefer cmake3 on CentOS 7
CMAKE_BIN="$(command -v cmake3 || command -v cmake)"

cdir="$PWD"
mkdir -p "${prefix}/VTK8"
unzip -q VTK-8.2.0.zip -d "${prefix}/VTK8"
mkdir -p "${prefix}/VTK8/VTK-8.2.0/build"
cd "${prefix}/VTK8/VTK-8.2.0/build"

# VTK 8.2: group switch enables Qt modules. Static libs are OK if you need them;
# you can flip to ON if you prefer shared libs.
"$CMAKE_BIN" \
  $cmake_pars \
  -DVTK_Group_Qt:BOOL=ON \
  -DVTK_LEGACY_SILENT:BOOL=ON \
  -DBUILD_SHARED_LIBS:BOOL=OFF \
  -DCMAKE_INSTALL_PREFIX:PATH="${prefix}/VTK8" \
  ..

gmake -j"$(nproc)"
gmake install

cd "$cdir"
