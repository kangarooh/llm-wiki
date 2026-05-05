# LLM Wiki — 跨工具指令

基于 [Andrej Karpathy 的 LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) 模式的个人知识库系统。AI 担任知识管理员——消化原始资料，编译为结构化的、相互链接的 wiki 页面。

## 工作流程

```
原始资料（文章、论文、转录）
    ↓  wiki-ingest 技能
Wiki 页面（实体、概念、来源、综合）
    ↓  wiki-query 技能
带引用的回答
```

## 技能

| 技能 | 命令 | 用途 |
|------|------|------|
| `wiki-create` | `/wiki-create` | 创建新知识库 |
| `wiki-ingest` | `/wiki-ingest` | 收录内容到正确的知识库 |
| `wiki-query` | `/wiki-query` | 跨库搜索并回答问题 |
| `wiki-lint` | `/wiki-lint` | 知识库健康检查 |
| `wiki-manage` | `/wiki-manage` | 管理知识库注册表 |
| `llm-wiki` | （参考） | Schema、页面格式、命名规范 |

## 注册表

所有知识库注册在 `~/.llm-wiki/registry.yaml`。收录和查询技能读取此文件来定位和路由到正确的知识库。

## 快速开始

```bash
# 初始化知识库
bash llm-wiki-init.sh

# 为所有 AI 工具安装技能
npx skills add kangarooh/llm-wiki -g

# 在任意 AI 工具中使用
/wiki-ingest <内容或路径>
/wiki-query <问题>
/wiki-manage list
```

## 知识库结构

每个知识库遵循以下结构：

```
wiki-name/
├── CLAUDE.md              # 知识库专属 schema
├── raw/                   # 原始资料收件箱
│   ├── articles/
│   ├── papers/
│   ├── transcripts/
│   └── archive/
├── wiki/                  # 知识编译层
│   ├── index.md
│   ├── log.md
│   ├── concepts/
│   ├── entities/
│   ├── sources/
│   └── syntheses/
└── assets/
```

页面格式和命名规范请参考 `llm-wiki` 技能。
