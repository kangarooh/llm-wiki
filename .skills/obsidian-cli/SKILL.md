---
name: obsidian-cli
description: >
  Obsidian CLI 工具参考。在执行 wiki-ingest、wiki-query、wiki-lint 时，涉及文件搜索、
  关键词检索、死链排查，优先使用 obsidian-cli 命令。如果未安装则回退使用文件工具。
user-invocable: false
---

# obsidian-cli 技能

## 核心准则

在执行 `wiki-ingest`、`wiki-query`、`wiki-lint` 任务时，只要涉及查找文件、检索关键词或排查错误链接，**必须优先**通过终端执行本技能列出的 `obsidian-cli` 命令，禁止使用 grep/cat 硬扫整个文件夹。

## 安装

```bash
# Mac
brew install yakitrak/yakitrak/obsidian-cli
```

## 核心命令参考手册

**所有写操作必须加上 `silent` 参数以防止打断用户界面的弹窗。**

### 1. 快速搜索 (Search)

- 语法：`obsidian search query="[关键词]"`
- 场景：寻找包含特定词汇的笔记列表。

### 2. 精准读取 (Read)

- 语法：`obsidian read file="[文件名]"`（无需 `.md` 后缀和完整路径，只要名字即可）
- 场景：在获取搜索结果后，精准读取某一篇笔记的详细内容。

### 3. 健康检查 (Linting)

- 查找死链（未创建但被引用的节点）：`obsidian unresolved`
- 查找孤儿（没有任何双链指向的节点）：`obsidian orphans`

### 4. 新建与追加 (Write/Append)

- 新建：`obsidian create name="[笔记名]" content="[Markdown内容]" silent`
- 追加：`obsidian append name="[笔记名]" content="[追加的内容]" silent`（常用于追加 log.md）

## 避坑指南

- 如果搜索结果为空，尝试缩减关键词长度，或只搜索核心词根。
- 只有在明确知道笔记标题时，才使用 read 命令；不确定时先用 search。
- 如果 obsidian-cli 未安装或不可用，回退使用 Read、Grep、Glob 等文件工具。
