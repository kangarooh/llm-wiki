# CLAUDE.md

本文件为 Claude Code (claude.ai/code) 在此仓库中工作时提供指引。

## 项目概述

本项目是一个**工具仓库**，用于生成基于 [Andrej Karpathy LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) 模式的个人知识库。核心产出是一个自包含的 shell 脚本，一条命令即可初始化完整的知识库结构。

本仓库不是知识库本身，而是创建知识库的工具。

## 开发原则

1. **示例同步**：任何功能开发都必须保证 `examples/` 下的示例项目内容为最新且可运行。示例是工具正确性的直接证明。
2. **脚本同步**：任何功能变更都必须同步更新 `llm-wiki-init/llm-wiki-init.sh`。脚本是唯一的交付产物，示例和脚本必须保持一致。
3. **体验优先**：任何功能都必须保证合理性、易用性、便利性。不合理的功能不做，不好用的功能不加，不方便的设计不推。

## 项目结构

```
llm-wiki/
├── .skills/                 # npx skills 包（全局安装到各 AI 工具）
│   ├── llm-wiki/            # 知识库 schema 定义
│   ├── wiki-create/         # 创建知识库
│   ├── wiki-ingest/         # 收录技能（跨知识库路由）
│   ├── wiki-query/          # 查询技能（跨知识库搜索）
│   ├── wiki-lint/           # 健康检查
│   ├── wiki-manage/         # 注册表管理技能
│   └── obsidian-cli/        # Obsidian CLI 工具参考
├── AGENTS.md                # 跨工具主指令文件
├── llm-wiki-init/
│   └── llm-wiki-init.sh    # 核心工具：自包含初始化脚本
├── examples/
│   └── java-tech-wiki/     # 示例：工具生成的知识库样本
├── karpathy-wiki.md         # Karpathy 原始理念文档（英文）
└── docs/                    # 设计文档
```

**关键区分：**
- `.skills/` — 跨工具技能（通过 `npx skills add` 安装到各 AI 工具）
- `AGENTS.md` — 跨工具主指令，描述 LLM Wiki 系统和技能用法
- `llm-wiki-init/` — 初始化脚本（改进系统时编辑这里的文件）
- `examples/` — 工具生成的示例输出（仅供参考）
- `karpathy-wiki.md` — LLM Wiki 理念的权威来源

**注册表机制：**
- 初始化脚本自动将新知识库注册到 `~/.llm-wiki/registry.yaml`
- 全局技能读取注册表实现跨知识库路由和搜索

## 运行初始化脚本

脚本完全自包含，所有模板和 skill 文件以 heredoc 形式内嵌，无外部依赖。

```bash
bash llm-wiki-init/llm-wiki-init.sh
```

脚本通过交互式问答，在 `~/my-llm-wiki/<名称>/` 下生成完整知识库：
- `CLAUDE.md` — schema，定义 LLM 如何维护 wiki
- `raw/` — 原始资料收件箱（articles、papers、transcripts）
- `wiki/` — 生成的 wiki 页面（entities、concepts、sources、syntheses）
- `~/.llm-wiki/registry.yaml` — 自动注册到全局注册表

技能通过 `npx skills add . -g` 全局安装，不在每个知识库中重复生成。

## 占位符系统

脚本使用以下占位符，生成时由 `sed` 替换：
- `{{KB_NAME}}` — 知识库名称
- `{{KB_TOPIC}}` — 主题/用途描述
- `{{KB_LANG}}` — 撰写语言
- `{{KB_TERM}}` — 技术术语处理方式

## 修改脚本指南

编辑 `llm-wiki-init.sh` 时注意：
- 模板使用 heredoc 语法：`<< 'EOF'`（引用，不展开变量）或 `<< EOF`（不引用，展开变量）
- 使用 `perl -i -pe` 进行占位符替换（macOS `sed` 不支持 UTF-8）
- 脚本使用 `set -e`，任何命令失败都会中止执行

## 无构建/测试流程

本仓库没有包管理器、测试套件或 CI 流程。验证方式为手动：
1. 运行 `bash llm-wiki-init/llm-wiki-init.sh`
2. 检查 `~/my-llm-wiki/` 下生成的结构是否正确
3. 检查 `~/.llm-wiki/registry.yaml` 是否自动注册
4. 在 Claude Code 中打开生成的知识库，测试 `/wiki-ingest`、`/wiki-query`、`/wiki-lint`
5. 测试全局技能：`npx skills add . -g`，然后在其他目录测试 `/wiki-ingest`、`/wiki-query`

## 参考资料

- [Karpathy LLM Wiki 原文](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
- [搭建指南](https://zhuanlan.zhihu.com/p/2028732075109261574)
