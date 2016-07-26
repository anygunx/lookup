#!/bin/sh

if [ ! -x llvm ]; then
  svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm
#else
#  cd llvm 
#  svn revert -R ./
#  svn up
#  cd ..
fi

if [ ! -x extra ]; then
  svn co http://llvm.org/svn/llvm-project/clang-tools-extra/trunk extra
#else
#  cd extra
#  svn revert -R ./
#  svn up
#  cd ..
fi

if [ ! -x compiler-rt ]; then
  svn co http://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt
#else
#  cd compiler-rt
#  svn revert -R ./
#  svn up
#  cd ..
fi

if [ ! -x lldb ]; then
  svn co http://llvm.org/svn/llvm-project/lldb/trunk lldb
#else
#  cd lldb
#  svn revert -R ./
#  svn up
#  cd ..
fi

if [ ! -x clang ]; then
  svn co http://llvm.org/svn/llvm-project/cfe/trunk clang
#else
#  cd clang
#  svn revert -R ./
#  svn up
#  cd ..
fi

if [ -x ./llvm/tools/clang ]; then
  rm -rf ./llvm/tools/clang
fi

if [ -x ./llvm/tools/lldb ]; then
  rm -rf ./llvm/tools/lldb
fi

if [ -x ./clang/tools/extra ]; then
  rm -rf ./clang/tools/extra
fi

if [ -x ./llvm/projects/compiler-rt ]; then
  rm -rf ./llvm/projects/compiler-rt
fi

clang="`pwd`/clang"
lldb="`pwd`/lldb"
extra="`pwd`/extra"
rt="`pwd`/compiler-rt"

cd clang/tools
ln -s "${extra}"
cd ../../
cd llvm/tools
ln -s "${clang}"
ln -s "${lldb}"
cd ../projects
ln -s "${rt}"
cd ../../
echo `pwd`

mkdir clang-build
cd clang-build

cmake ../llvm -DLLDB_DISABLE_LIBEDIT=1 -DLLDB_DISABLE_CURSES=1

make -j8
