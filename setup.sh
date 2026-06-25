#!/bin/bash
# ============================================================
# DocLens 一键安装脚本 (macOS / Linux)
# ============================================================

set -e

echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║       DocLens 环境安装向导            ║"
echo "  ╚══════════════════════════════════════╝"
echo ""

# 颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ok()   { echo -e "  ${GREEN}✅ $1${NC}"; }
warn() { echo -e "  ${YELLOW}⚠️  $1${NC}"; }
fail() { echo -e "  ${RED}❌ $1${NC}"; }

# ---- 检查 Python ----
echo "  [1/5] 检查 Python..."
if command -v python3 &>/dev/null; then
    PY_VER=$(python3 --version 2>&1 | awk '{print $2}')
    PY_MAJOR=$(echo $PY_VER | cut -d. -f1)
    PY_MINOR=$(echo $PY_VER | cut -d. -f2)
    if [ "$PY_MAJOR" -ge 3 ] && [ "$PY_MINOR" -ge 10 ]; then
        ok "Python $PY_VER"
    else
        fail "需要 Python >= 3.10，当前 $PY_VER"
        echo "     请升级: brew install python@3.12"
        exit 1
    fi
else
    fail "Python3 未安装"
    echo "     请安装: brew install python@3.12"
    exit 1
fi

# ---- 创建虚拟环境 ----
echo "  [2/5] 创建虚拟环境..."
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
    ok "虚拟环境已创建"
else
    ok "虚拟环境已存在"
fi
source .venv/bin/activate

# ---- 安装 Python 依赖 ----
echo "  [3/5] 安装 Python 依赖 (首次较慢)..."
pip install --upgrade pip -q
pip install -r requirements.txt -q 2>&1 | tail -1
ok "Python 依赖安装完成"

# ---- 检查 pandoc (可选，用于 DOCX 导出) ----
echo "  [4/5] 检查 pandoc (可选, 用于导出 Word)..."
if command -v pandoc &>/dev/null; then
    PANDOC_VER=$(pandoc --version | head -1 | awk '{print $2}')
    ok "pandoc $PANDOC_VER"
else
    warn "pandoc 未安装，DOCX 导出不可用"
    echo "       安装方法: brew install pandoc"
fi

# ---- 预下载 OCR 模型 ----
echo "  [5/5] 预下载 OCR 模型 (约 150MB, 仅首次)..."
python3 -c "
from paddleocr import PaddleOCR
print('    下载 OCR 模型中...')
ocr = PaddleOCR(use_angle_cls=True, lang='ch', show_log=False, use_gpu=False)
print('    OCR 模型就绪')
" 2>&1 | grep -E "(下载|就绪|Downloading)"
ok "模型下载完成，后续可离线使用"

# ---- 完成 ----
echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║          ✅ 安装完成!                 ║"
echo "  ╚══════════════════════════════════════╝"
echo ""
echo "  启动命令:"
echo "    source .venv/bin/activate"
echo "    python main.py"
echo ""
echo "  浏览器会自动打开 http://localhost:8910"
echo "  处理敏感文档时建议断开网络连接"
echo ""
