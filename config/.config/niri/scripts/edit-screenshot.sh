#!/usr/bin/env bash

# 设置超时时间（例如：10秒）
TIMEOUT=10
# 计算循环次数（TIMEOUT / 0.05秒）
MAX_LOOPS=$((TIMEOUT / 5 * 100))
# 计数器
COUNT=0

# 1. 声明一个变量，值是根据wl-paste输出的当前剪贴版的数据计算出的哈希值
CLIPNOW=$(wl-paste | sha1sum)

# 2. 启动niri截图
niri msg action screenshot & # 使用 & 让 niri 命令在后台执行，避免阻塞脚本

# 3. 循环，不断等待剪贴板更新（直到超时或内容改变）
while [ "$(wl-paste | sha1sum)" = "$CLIPNOW" ]; do
    sleep .05
    COUNT=$((COUNT + 1))
    
    # 检查是否超时
    if [ "$COUNT" -ge "$MAX_LOOPS" ]; then
        echo "错误: 截图超时 ($TIMEOUT 秒)，剪贴板未更新。" >&2
        exit 1
    fi
done

# 4. 将新的剪贴板内容的数据传给satty打开
# 假设 wl-paste 输出的是截图文件的路径
wl-paste | satty -f -

echo "截图成功并使用 satty 打开。"
