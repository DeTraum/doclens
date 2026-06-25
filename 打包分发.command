#!/bin/bash
# ============================================================
# DocLens 打包分发 —— 双击生成一个干净的、可直接发给别人的压缩包
# 白名单方式：只复制别人需要的文件，绝不含你的凭证/记录/缓存
# ============================================================
cd "$(dirname "$0")" || exit 1
SRC="$(pwd)"
STAGE="$SRC/../DocLens_分发包"
ZIP="$SRC/../DocLens_分发包.zip"

echo ""
echo "  正在生成干净的分发包..."

rm -rf "$STAGE" "$ZIP"
mkdir -p "$STAGE"

# 只带这些（白名单），其余一律不带
for item in main.py requirements.txt README.md 配置说明.md 飞书配置图文教程.md 安装.command 启动.command 打包分发.command static; do
  if [ -e "$SRC/$item" ]; then
    cp -R "$SRC/$item" "$STAGE/"
  fi
done

# 保险：清掉可能混入的缓存
find "$STAGE" -name '__pycache__' -type d -exec rm -rf {} + 2>/dev/null
find "$STAGE" -name '.DS_Store' -delete 2>/dev/null
find "$STAGE" -name '*.pyc' -delete 2>/dev/null

# 压缩（用绝对路径，避免 cd 混乱）
( cd "$SRC/.." && zip -r -q "DocLens_分发包.zip" "DocLens_分发包" )

CNT=$(find "$STAGE" -type f | wc -l | tr -d ' ')
echo ""
echo "  ✅ 完成！打包了 $CNT 个文件。"
echo "     分发包: $(cd "$SRC/.." && pwd)/DocLens_分发包.zip"
echo ""
echo "  发给别人，对方解压后：双击安装 → 双击启动 → 按配置说明填飞书凭证/登录"
echo ""
read -p "  按回车关闭..."
