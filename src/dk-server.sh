#!/bin/bash

# 安装xlinker到模拟器
# 自动启动xlinker到调试器
# 启动本地的调试器，并且与远程对接

# 默认的目标名称
Target="./udog"
TargetTest="./libhello.so"
GdbServerPort=1234
Gdb="a-gdbtui"

echo "[INFO]remove target"
rm ./udog

echo "[INFO]make target"
make udog DEBUG=1

echo "[INFO]adb push target to /data"
adb push ./udog /data

echo "[INFO]adb push target test file to /data"
adb push ./libhello.so /data

# grep -Po '(?<=\[\d\]\s)\d+'
# gdbserver :$GdbServerPort --attach 
# 匹配以[数字]任意空格 开头的字符然后在匹配后面的一个或多个数字
echo "[INFO]set adb forward port"
adb forward tcp:$GdbServerPort tcp:$GdbServerPort

echo "[INFO]start debugging $Target"
adb shell <<EOF
cd /data
gdbserver :$GdbServerPort $Target $TargetTest
EOF
