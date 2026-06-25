#!/bin/bash
# ============================================================
# DocLens 启动 (macOS) —— 双击运行
# 启动后端并自动打开浏览器，关闭本窗口即停止服务
# ============================================================
cd "$(dirname "$0")" || exit 1

if [ ! -d ".venv" ]; then
  echo "  ❌ 还没安装。请先双击「安装.command」。"
  read -p "  按回车退出..."; exit 1
fi

source .venv/bin/activate
# 本机回环不走代理；离线也能识别
export NO_PROXY="127.0.0.1,localhost"
export no_proxy="127.0.0.1,localhost"

echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║          DocLens 启动中...           ║"
echo "  ╚══════════════════════════════════════╝"
echo ""
echo "  🌐 浏览器将自动打开 http://127.0.0.1:8910"
echo "  ⏹  要停止：关闭本窗口，或按 Ctrl+C"
echo ""

python main.py
