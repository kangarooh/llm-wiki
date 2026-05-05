---
name: wiki-create
description: >
  创建新的 LLM Wiki 知识库。交互式询问名称、主题、语言等信息，自动生成完整目录结构、
  配置文件和技能文件，并注册到全局注册表。触发词："创建知识库"、"新建知识库"、
  "初始化知识库"、"create wiki"、"new wiki"。
user-invocable: true
---

# Wiki Create — 创建知识库

一站式创建新 LLM Wiki 知识库。目录结构、配置文件、技能文件、注册，全部由 AI 完成。

## 交互流程

1. 询问用户以下信息（可用默认值）：
   - **知识库名称**（推荐英文 kebab-case，如 `java-tech-wiki`）
   - **主题描述**（一句话说明用途）
   - **撰写语言**（默认：中文）
   - **技术术语处理**（默认：保留英文原文）

2. 确认后执行创建。

## 目标目录

`~/my-llm-wiki/<名称>/`

## 创建目录结构

```
<名称>/
├── assets/
├── raw/
│   ├── articles/
│   ├── papers/
│   ├── transcripts/
│   └── archive/
├── wiki/
│   ├── concepts/
│   ├── entities/
│   ├── sources/
│   └── syntheses/
└── .claude/skills/
```

每个空目录放 `.gitkeep` 保持结构。

## 生成文件清单

### 1. CLAUDE.md

知识库 schema，包含：
- 核心规则（双链驱动、读写权限、日志规范、原子化、语言设置）
- 目录结构说明
- 四种页面类型模板（参照 `llm-wiki` skill）
- 命名规范、引用规则
- 操作流程引用（/ingest-wiki、/query-wiki、/lint-wiki）

### 2. wiki/index.md

```markdown
---
title: 知识库目录
updated: YYYY-MM-DD
---

# <名称> 目录

wiki 所有页面的内容目录。每次收录新资料时由 AI 更新。

## Entities（实体层）

| 页面 | 摘要 | 来源 | 更新日期 |
|------|------|------|----------|

## Concepts（概念层）

| 页面 | 摘要 | 来源 | 更新日期 |
|------|------|------|----------|

## Sources（摘要层）

| 页面 | 资料 | 类型 | 日期 |
|------|------|------|------|

## Syntheses（综合层）

| 页面 | 摘要 | 来源 | 更新日期 |
|------|------|------|----------|
```

### 3. wiki/log.md

```markdown
---
title: 行为日志
description: 记录收录/查询/检查操作的只追加日志
---

# 行为日志

格式：`## [YYYY-MM-DD] 类型 | 描述`
```

### 4. .claude/skills/ingest-wiki.md

库内收录技能，处理 `raw/` 中的资料并编译到 `wiki/`。参照项目根目录 `.skills/wiki-ingest/SKILL.md` 的流程，但作用于本知识库内部。

### 5. .claude/skills/query-wiki.md

库内查询技能，在本知识库内搜索和回答。参照 `.skills/wiki-query/SKILL.md`。

### 6. .claude/skills/lint-wiki.md

知识库健康检查：死链、孤岛页面、未同步索引、知识冲突。

### 7. README.md

知识库使用说明，包含目录结构、使用方式、参考资料。

## 注册

创建完成后，将知识库注册到 `~/.llm-wiki/registry.yaml`：

```yaml
wikis:
  - name: <名称>
    path: ~/my-llm-wiki/<名称>
    topic: <主题描述>
    updated: YYYY-MM-DD
```

如果注册表文件或目录不存在则自动创建。检查名称是否重复。
