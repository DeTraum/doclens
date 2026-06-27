#!/bin/bash
# ============================================================
# DocLens 一键安装 (macOS) —— 双击运行即可
# 自动：装Python(如缺) → 建虚拟环境 → 装依赖 → 下载OCR模型
# ============================================================
cd "$(dirname "$0")" || exit 1

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
ok(){ echo -e "  ${GREEN}✅ $1${NC}"; }
warn(){ echo -e "  ${YELLOW}⚠️  $1${NC}"; }
fail(){ echo -e "  ${RED}❌ $1${NC}"; }

echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║        DocLens 安装向导              ║"
echo "  ╚══════════════════════════════════════╝"
echo ""

# 找一个 >=3.10 的 python3
find_python() {
  for c in python3.12 python3.11 python3.10 python3; do
    if command -v "$c" &>/dev/null; then
      if "$c" -c 'import sys; exit(0 if sys.version_info>=(3,10) else 1)' 2>/dev/null; then
        echo "$c"; return 0
      fi
    fi
  done
  return 1
}

# 把 Homebrew 加到当前会话 PATH
load_brew() {
  [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
  [ -x /usr/local/bin/brew ] && eval "$(/usr/local/bin/brew shellenv)"
}

echo "  [1/4] 检查 Python..."
PY="$(find_python)"
if [ -z "$PY" ]; then
  warn "未检测到 Python 3.10+，开始自动安装（可能需要输入开机密码）"
  load_brew
  if ! command -v brew &>/dev/null; then
    echo "      正在安装 Homebrew（国内可能较慢，请耐心；会提示输入密码）..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    load_brew
  fi
  if command -v brew &>/dev/null; then
    echo "      正在用 Homebrew 安装 Python..."
    brew install python@3.12
    load_brew
    PY="$(find_python)"
  fi
fi

if [ -z "$PY" ]; then
  fail "自动安装 Python 没成功"
  echo "      请手动安装：即将打开下载页，下载并安装后，重新双击本文件。"
  open "https://www.python.org/downloads/macos/"
  read -p "  按回车退出..."; exit 1
fi
ok "Python 就绪 ($($PY --version 2>&1))"

# 2) 建虚拟环境
echo "  [2/4] 创建虚拟环境..."
if [ ! -d ".venv" ]; then "$PY" -m venv .venv; fi
source .venv/bin/activate
python -m pip install --upgrade pip -q
ok "虚拟环境就绪"

# 3) 装依赖
echo "  [3/4] 安装依赖（首次较慢，请耐心等待）..."
pip install -r requirements.txt 2>&1 | tail -3
ok "依赖安装完成"

# 4) 下载 OCR 模型（国内源，无需翻墙）
echo "  [4/4] 下载 OCR 模型（约 1-2GB，仅首次）..."
if [ -f "$HOME/mineru.json" ]; then
  ok "模型已下载，跳过"
else
  mineru-models-download -s modelscope -m pipeline 2>&1 | grep -E "Downloading model|successfully|completed" | tail -10
fi
ok "模型下载完成"

echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║          ✅ 安装完成!                 ║"
echo "  ╚══════════════════════════════════════╝"
echo ""
echo "  下一步：双击「启动.command」即可使用。"
echo ""
read -p "  按回车关闭本窗口..."
