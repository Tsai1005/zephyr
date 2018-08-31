#!/bin/sh

#-----------------------Parser Makefile---------------------------------
TARGET_ARCH=arm
TARGET_VENDOR=nordic
TARGET_BOARD=nrf52_pca10040

DIR=.
#-----------------------Create Clang Completer Database---------------------------------
echo reloading ARCH :[${TARGET_ARCH}] / Vendor :[${TARGET_VENDOR}] / Board :[${TARGET_BOARD}] project ...

# echo "Syncing ... apps";
# bear make -j dry_run > /dev/null 2>&1;

# /opt/utils/remove_db_target compile_commands.json compile_commands.json

#-----------------------Project Dir switch---------------------------------
find ${DIR} -path "${DIR}/boards/*" ! -path "${DIR}/boards/${TARGET_ARCH}*" -prune -o \
    -path "${DIR}/boards/${TARGET_ARCH}/*" ! -path "${DIR}/boards/${TARGET_ARCH}/${TARGET_BOARD}*" -prune -o \
    -path "${DIR}/arch/${TARGET_ARCH}/soc/*" ! -path "${DIR}/arch/${TARGET_ARCH}/soc/${TARGET_VENDOR}*" -prune -o \
    -path "${DIR}/tools*" -prune -o \
    -name "*.[Sch]" -print > cscope.files


# ----------- lookup file
export FIND_EXCEPT="find . -path "*${DIR}/boards/*" ! -path "*${DIR}/boards/${TARGET_ARCH}*" -prune -o \
    -path "*${DIR}/boards/${TARGET_ARCH}/*" ! -path "*${DIR}/boards/${TARGET_ARCH}/${TARGET_BOARD}*" -prune -o \
    -path "*${DIR}/arch/*" ! -path "*${DIR}/arch/${TARGET_ARCH}*" -prune -o \
    -path "*${DIR}/arch/${TARGET_ARCH}/soc/*" ! -path "*${DIR}/arch/${TARGET_ARCH}/soc/${TARGET_VENDOR}*" -prune -o \
    -path "*${DIR}/tools*" -prune -o"

export FORMAT='.*\.\(c\|h\|s\|S\|ld\|s51\|lst\|map\|txt\)'

ctags -R --fields=+lS --languages=+Asm 

# ----------- cscope
cscope -bR

# ----------- lookup file
echo -e "!_TAG_FILE_SORTED\t2\t/2=foldcase/">filenametags
# echo ${FIND_EXCEPT}
${FIND_EXCEPT} -regex ${FORMAT} -type f -printf "%f\t%p\t1\n" | sort -f>>filenametags


