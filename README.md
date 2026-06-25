# DocLens MVP v0.2.0

本地隐私优先的图片文档转可编辑文档工具。双模式运行。

## 两种模式

**本地上传模式** — 拖拽上传图片，全程离线处理，建议断网使用
**飞书链接模式** — 粘贴飞书文档链接，自动提取图片做 OCR，生成新的可编辑飞书文档

## 快速开始

```bash
# 1. 安装 (首次)
chmod +x setup.sh && ./setup.sh

# 2. 启动
source .venv/bin/activate
python main.py

# 浏览器自动打开 http://localhost:8910
```

## 飞书模式配置

1. 在 [飞书开放平台](https://open.feishu.cn/) 创建企业自建应用
2. 开启「机器人」能力
3. 申请权限: `im:message`、`drive:media`、`docx:document`
4. 在 DocLens 页面「飞书链接」tab → 展开配置 → 填入 App ID 和 App Secret
5. 凭证保存在本机 `config.json`，不会上传

## 网络策略

- 本地模式: 自动检测网络状态，页面顶部提示断网建议
- 飞书模式: 仅与 open.feishu.cn 通信，OCR 始终在本地
- 服务仅监听 127.0.0.1，外部无法访问

## 依赖

- Python >= 3.10
- PaddleOCR (自动安装，模型约 150MB)
- pandoc (可选，DOCX 导出): `brew install pandoc`

## 目录

```
doclens/
├── main.py             # 后端 (FastAPI, OCR, 飞书 API)
├── static/index.html   # 前端
├── setup.sh            # 安装脚本
├── requirements.txt
├── config.json         # 飞书凭证 (自动生成，gitignore)
└── data/               # 运行时数据
```
