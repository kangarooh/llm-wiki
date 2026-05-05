# LLM Wiki

基于 [Andrej Karpathy 的 LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) 模式，开发的通用个人知识库初始化工具。

一键生成完整的 LLM Wiki 知识库结构，包含目录、配置和 Claude Code 技能文件。

## 核心理念

传统 RAG 系统每次查询都从原始文档中重新检索，没有积累。LLM Wiki 的思路不同：AI 不只是搜索工具，而是知识库的"管理员"——它读取资料、提炼要点、创建页面、维护链接，让知识网络越来越丰富。

**知识复利**：每次收录新资料，AI 会更新相关页面、标记矛盾、补充关联。知识库越用越值钱。

**持久化**：wiki 是持久化、可积累的。问过的好问题、做过的分析，都可以回写为新页面。

**人机协作**：人负责选题、提问、判断；AI 负责编译、链接、维护。

思想来源：[Karpathy LLM Wiki 原文](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
搭建参考：[Karpathy LLM Wiki 个人知识库系统搭建指南](https://zhuanlan.zhihu.com/p/2028732075109261574)

## 快速开始

```bash
# 下载脚本
curl -O https://raw.githubusercontent.com/YOUR_USERNAME/llm-wiki/main/llm-wiki-init/llm-wiki-init.sh

# 运行
bash llm-wiki-init.sh
```

脚本会交互式询问几个问题，然后在 `~/my-llm-wiki/你的知识库名称/` 下生成完整结构，并自动注册到全局注册表。

## 生成的内容

```
~/.llm-wiki/
└── registry.yaml              # 全局注册表（自动管理）

~/my-llm-wiki/你的知识库/
├── CLAUDE.md              # 智能体规范（schema）
├── README.md              # 知识库使用说明
├── assets/                # 统一附件层
├── raw/                   # 原始资料收件箱
│   ├── articles/          # 网页剪藏、技术文章
│   ├── papers/            # 论文、深度研报
│   ├── transcripts/       # 视频/播客转录
│   └── archive/           # 已处理归档
├── wiki/                  # 知识编译层
│   ├── index.md           # 全局目录
│   ├── log.md             # 行为日志
│   ├── concepts/          # 概念页
│   ├── entities/          # 实体页
│   ├── sources/           # 来源摘要
│   └── syntheses/         # 综合分析
└── .claude/skills/        # Claude Code 技能
    ├── wiki-ingest.md     # 收录技能
    ├── wiki-query.md      # 查询技能
    ├── wiki-lint.md       # 健康检查
    └── obsidian-cli.md    # Obsidian 命令参考
```

## 使用方式

### 跨工具安装

通过 `npx skills` 将技能安装到所有 AI 工具（Claude Code、Codex CLI、Gemini CLI、Cursor 等）：

```bash
npx skills add YOUR_USERNAME/llm-wiki -g
```

安装后在任意 AI 工具中可使用：
- `/wiki-ingest` — 收录资料（自动路由到正确的知识库）
- `/wiki-query` — 查询知识库（跨库搜索）
- `/wiki-manage` — 管理知识库注册表

### 收录资料

将资料放入 `raw/` 对应子目录，然后在 AI 工具中：

```
/wiki-ingest                              # 扫描所有未处理文件
/wiki-ingest raw/articles/some-article.md # 处理指定文件
/wiki-ingest <粘贴的文本内容>               # 直接处理粘贴内容
```

当存在多个知识库时，系统会自动根据内容语义匹配到正确的知识库。

### 查询知识库

```
/wiki-query Spring Boot 自动配置原理是什么
```

或自然语言：

```
我的笔记里关于 IoC 是怎么记录的
之前读过的那篇文章说了什么
帮我整理一下微服务相关的知识
```

### 管理知识库

```
/wiki-manage list            # 列出所有已注册知识库
/wiki-manage register        # 注册新知识库
/wiki-manage unregister      # 注销知识库
```

### 健康检查

```
/wiki-ingest lint
```

检测死链、孤岛页面、未同步索引、知识冲突。

## 项目结构

```
llm-wiki/
├── README.md                          # 本文件
├── AGENTS.md                          # 跨工具主指令
├── karpathy-wiki.md                   # Karpathy 原始理念文档
├── .skills/                           # npx skills 包
│   ├── llm-wiki/                      # 知识库 schema
│   ├── wiki-ingest/                   # 收录技能
│   ├── wiki-query/                    # 查询技能
│   └── wiki-manage/                   # 注册表管理
├── llm-wiki-init/
│   └── llm-wiki-init.sh              # 核心工具：一键初始化脚本
├── examples/
│   └── java-tech-wiki/               # 示例：Java 技术知识库
└── docs/
    └── superpowers/specs/             # 设计文档
```

## 前置条件

- 任意 AI CLI 工具：[Claude Code](https://docs.anthropic.com/en/docs/claude-code)、[Codex CLI](https://github.com/openai/codex)、[Gemini CLI](https://github.com/google-gemini/gemini-cli)、[Cursor](https://cursor.sh/) 等
- [npx](https://docs.npmjs.com/cli/v10/commands/npx)（用于安装技能）
- （可选）[Obsidian](https://obsidian.md/) — 用于浏览 wiki
- （可选）[obsidian-cli](https://github.com/yakitrak/obsidian-cli) — 用于高效检索

## 参考资料

- [Karpathy LLM Wiki 原文](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
- [搭建指南](https://zhuanlan.zhihu.com/p/2028732075109261574)
