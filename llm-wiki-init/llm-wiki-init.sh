#!/bin/bash
set -e
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ============================================================
# LLM Wiki Init
# 一键初始化 LLM Wiki 知识库（单文件自包含版本）
# 用法: bash llm-wiki-init.sh
# ============================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  LLM Wiki 知识库初始化工具${NC}"
echo -e "${BLUE}  基于 Andrej Karpathy 的 LLM Wiki 模式${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# ============================================================
# 步骤 1：交互式问答
# ============================================================

echo -e "${YELLOW}请回答以下问题来配置你的知识库（直接回车使用默认值）：${NC}"
echo ""

read -p "知识库名称（推荐英文，如 java-tech-wiki）: " KB_NAME
KB_NAME="${KB_NAME:-my-wiki}"

read -p "知识库主题/用途描述: " KB_TOPIC
KB_TOPIC="${KB_TOPIC:-通用知识库}"

read -p "撰写语言（中文/英文）: " KB_LANG
KB_LANG="${KB_LANG:-中文}"

read -p "技术术语处理方式（保留英文原文/翻译为中文）: " KB_TERM
KB_TERM="${KB_TERM:-保留英文原文}"

echo ""
echo -e "${BLUE}配置确认：${NC}"
echo "  知识库名称: $KB_NAME"
echo "  主题描述:   $KB_TOPIC"
echo "  撰写语言:   $KB_LANG"
echo "  术语处理:   $KB_TERM"
echo ""

read -p "确认创建？(y/n): " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "已取消。"
    exit 0
fi

# ============================================================
# 步骤 2：创建目录结构
# ============================================================

TARGET_DIR="$HOME/my-llm-wiki/$KB_NAME"

echo ""
echo -e "${YELLOW}创建目录结构...${NC}"

mkdir -p "$TARGET_DIR/assets"
mkdir -p "$TARGET_DIR/raw/articles"
mkdir -p "$TARGET_DIR/raw/papers"
mkdir -p "$TARGET_DIR/raw/transcripts"
mkdir -p "$TARGET_DIR/raw/archive"
mkdir -p "$TARGET_DIR/wiki/concepts"
mkdir -p "$TARGET_DIR/wiki/entities"
mkdir -p "$TARGET_DIR/wiki/sources"
mkdir -p "$TARGET_DIR/wiki/syntheses"
touch "$TARGET_DIR/assets/.gitkeep"
touch "$TARGET_DIR/raw/articles/.gitkeep"
touch "$TARGET_DIR/raw/papers/.gitkeep"
touch "$TARGET_DIR/raw/transcripts/.gitkeep"
touch "$TARGET_DIR/raw/archive/.gitkeep"

# ============================================================
# 步骤 3：生成 CLAUDE.md
# ============================================================

echo -e "${YELLOW}生成配置文件...${NC}"

TODAY=$(date +%Y-%m-%d)

cat > "$TARGET_DIR/CLAUDE.md" << 'CLAUDE_EOF'
# {{KB_NAME}}

{{KB_TOPIC}}。
基于 Andrej Karpathy 的 LLM Wiki 模式。

## 核心规则

1. **双链驱动**：所有生成内容必须使用 `[[双括号链接]]` 关联相关页面，不允许产生孤岛页面。
2. **读写权限**：只读 `raw/`，读写 `wiki/`，处理完资料必须归档到 `raw/archive/`。
3. **日志规范**：每次操作必须在 `wiki/log.md` 记录时间戳与变更。
4. **原子化**：保持笔记短小精悍，通过链接编织网络。
5. **语言**：{{KB_LANG}}撰写，技术术语{{KB_TERM}}。

## 目录结构

```
assets/               # 统一附件层：图片、PDF、多媒体
raw/                  # 原始资料收件箱（事实层）
├── articles/         # 网页剪藏、技术文章
├── papers/           # 论文、深度研报
├── transcripts/      # 视频/播客转录
└── archive/          # 已处理归档（禁止读取）
wiki/                 # 知识编译层（AI 管理层）
├── index.md          # 全局目录：所有 wiki 节点的一句话索引
├── log.md            # 行为日志：记录收录/查询/检查历史
├── concepts/         # 抽象层：方法论、架构模式、原则
├── entities/         # 实体层：人名、公司、工具、项目
├── sources/          # 摘要层：原始文件的一对一核心提炼
└── syntheses/        # 综合层：AI 生成的深度研究报告
CLAUDE.md             # 本文件：智能体全局规范
```

**页面分类原则**：
- 记录一个具体事物（框架、API、工具、人物、公司）→ `entities/`
- 解释一个抽象概念或原理 → `concepts/`
- 单份资料的摘要 → `sources/`
- 跨多个来源的综合分析或对比 → `syntheses/`

## 页面格式

所有 wiki 页面使用 YAML frontmatter + markdown 正文。

### 通用 frontmatter

```yaml
---
title: 页面标题
tags: [tag1, tag2]
sources: [source-file-1.pdf, source-file-2.md]
updated: YYYY-MM-DD
type: entity | concept | source | synthesis
---
```

### 实体页（entities/）

文件名：TitleCase，如 `SpringBoot.md`、`MyBatis.md`

```markdown
---
title: 实体名称
tags: [tag1, tag2]
sources: [source.pdf]
updated: YYYY-MM-DD
type: entity
---

## 定义
一到两句话说明这是什么、解决什么问题。

## 核心概念
主要概念和工作原理。

## 详细信息
从源文件中提取的关键信息。

## 使用场景
什么时候用、什么时候不用。

## 常见问题
踩坑记录、常见错误。

## 关联连接
- [[related-concept]] — 相关概念
- [[RelatedEntity]] — 相关实体
```

### 概念页（concepts/）

文件名：kebab-case，如 `ioc-container.md`、`design-patterns.md`

```markdown
---
title: 概念名称
tags: [tag1, tag2]
sources: [source.pdf]
updated: YYYY-MM-DD
type: concept
---

## 定义
一到两句话说明这个概念。

## 原理
详细解释原理和机制。

## 与其他概念的关系
和相关概念的联系与区别。

## 实际应用
在哪些场景中使用。

## 关联连接
- [[related-concept]] — 相关概念
- [[RelatedEntity]] — 相关实体
```

### 来源摘要（sources/）

文件名：`source-` 前缀，如 `source-spring-in-action.md`

```markdown
---
title: 资料标题
tags: [tag1, tag2]
sources: [raw/articles/xxx.md]
updated: YYYY-MM-DD
type: source
---

## 资料信息
- 类型：书籍/文章/视频/论文
- 来源：作者或网站

## 核心摘要
3-5 句话的核心总结。

## 关键概念
- [[concept-name]]：相关说明

## 个人笔记
阅读过程中的思考和收获。

## 关联连接
- [[RelatedEntity]] — 相关实体
- [[related-concept]] — 相关概念
```

### 综合页（syntheses/）

文件名：`synthesis-` 前缀，如 `synthesis-topic-summary.md`

```markdown
---
title: 综合分析标题
tags: [tag1, tag2]
sources: [source1.pdf, source2.md]
updated: YYYY-MM-DD
type: synthesis
---

## 概述
综合多个来源的分析结论。

## 详细分析
核心分析内容。

## 对比总结

| 维度 | 方案A | 方案B |
|------|------|------|
| 维度1 | ... | ... |

## 结论与建议
基于分析的推荐。

## 待验证
哪些结论还需要进一步验证。

## 关联连接
- [[RelatedEntity]] — 相关实体
- [[related-concept]] — 相关概念
```

## 命名规范

| 页面类型 | 文件名格式 | 示例 |
|----------|-----------|------|
| 实体页 | TitleCase | `SpringBoot.md`、`MyBatis.md` |
| 概念页 | kebab-case | `ioc-container.md`、`design-patterns.md` |
| 来源摘要 | `source-` + kebab-case | `source-spring-in-action.md` |
| 综合页 | `synthesis-` + kebab-case | `synthesis-microservice-frameworks.md` |

## 引用规则

- 每条事实性陈述标注来源：`(来源: filename.pdf)`
- 两个来源有矛盾时，明确标注并说明差异
- 无来源的陈述标注 `⚠️ 待验证`

## 操作流程

技能通过 `npx skills add` 全局安装，在任意 AI 工具中可用：

- **收录**：`/wiki-ingest` — 将 raw/ 中的资料编译到 wiki/
- **查询**：`/wiki-query` — 基于知识库回答问题
- **健康检查**：`/wiki-lint` — 检测死链、孤岛、冲突
- **创建知识库**：`/wiki-create` — 交互式创建新知识库
- **管理注册表**：`/wiki-manage` — 管理已注册的知识库
CLAUDE_EOF

# 替换占位符
perl -i -pe "
  s|{{KB_NAME}}|$KB_NAME|g;
  s|{{KB_TOPIC}}|$KB_TOPIC|g;
  s|{{KB_LANG}}|$KB_LANG|g;
  s|{{KB_TERM}}|$KB_TERM|g;
" "$TARGET_DIR/CLAUDE.md"

# ============================================================
# 步骤 4：生成 index.md
# ============================================================

cat > "$TARGET_DIR/wiki/index.md" << INDEX_EOF
---
title: 知识库目录
updated: $TODAY
---

# $KB_NAME 目录

wiki 所有页面的内容目录。每次收录新资料时由 Claude 更新。

## Entities（实体层）

具体事物：框架、工具、API、人物、公司、项目。

| 页面 | 摘要 | 来源 | 更新日期 |
|------|------|------|----------|

## Concepts（概念层）

抽象概念：方法论、架构模式、原则、理论。

| 页面 | 摘要 | 来源 | 更新日期 |
|------|------|------|----------|

## Sources（摘要层）

每份收录资料的核心提炼。

| 页面 | 资料 | 类型 | 日期 |
|------|------|------|------|

## Syntheses（综合层）

跨多个来源的深度分析、对比研究。

| 页面 | 摘要 | 来源 | 更新日期 |
|------|------|------|----------|
INDEX_EOF

# ============================================================
# 步骤 5：生成 log.md
# ============================================================

cat > "$TARGET_DIR/wiki/log.md" << LOG_EOF
---
title: 行为日志
description: 记录收录/查询/检查操作的只追加日志
---

# 行为日志

格式：\`## [YYYY-MM-DD] 类型 | 描述\`

类型包括：\`wiki-ingest\`（收录）、\`wiki-query\`（查询）、\`wiki-lint\`（健康检查）

可使用 \`grep "^## \\[" log.md | tail -5\` 快速查看最近 5 条记录。
LOG_EOF

# ============================================================
# 步骤 6：生成 README.md
# ============================================================

cat > "$TARGET_DIR/README.md" << README_EOF
# $KB_NAME

$KB_TOPIC。

## 简介

这是一个基于 [Karpathy LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) 模式构建的个人知识库。核心理念是：不再碎片化地剪藏资料，而是让 AI 帮你"编译"知识——将原始资料消化为结构化、相互链接的 wiki 页面，形成可复利的知识网络。

搭建指南参考：[Karpathy LLM Wiki 个人知识库系统搭建指南](https://zhuanlan.zhihu.com/p/2028732075109261574)

## 目录结构

\`\`\`
├── CLAUDE.md              # 智能体规范（schema）
├── README.md              # 本文件
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
\`\`\`

## 使用方式

### 前置条件

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI 已安装
- （可选）[Obsidian](https://obsidian.md/) 用于浏览 wiki
- （可选）[obsidian-cli](https://github.com/yakitrak/obsidian-cli) 用于高效检索

### 收录资料

1. 将资料放入 \`raw/\` 对应子目录（articles/papers/transcripts）
2. 在 Claude Code 中执行：

\`\`\`
/wiki-ingest
\`\`\`

或处理指定文件：

\`\`\`
/wiki-ingest raw/articles/some-article.md
\`\`\`

或直接粘贴文本：

\`\`\`
/wiki-ingest <粘贴的文本内容>
\`\`\`

### 查询知识库

\`\`\`
/wiki-query llm-wiki 的知识编译方法论是什么
\`\`\`

或自然语言：

\`\`\`
我的笔记里关于 IoC 是怎么记录的
\`\`\`

### 健康检查

\`\`\`
/wiki-lint
\`\`\`

检测死链、孤岛页面、未同步索引、知识冲突。

## 核心理念

**知识复利**：AI 不只是搜索工具，而是知识库的"管理员"。每次收录新资料，它会消化内容、创建页面、更新关联，让知识网络越来越丰富。

**持久化记忆**：与 RAG 系统不同，wiki 是持久化、可积累的。问过的好问题、做过的分析、发现的关联，都可以回写为新页面，形成长期的"第二大脑"。

**人机协作**：人负责选题、提问、判断；AI 负责编译、链接、维护。

## 参考资料

- [Karpathy LLM Wiki 原文](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
- [搭建指南](https://zhuanlan.zhihu.com/p/2028732075109261574)
README_EOF

# 替换 README 中的占位符
perl -i -pe "
  s|{{KB_NAME}}|$KB_NAME|g;
  s|{{KB_TOPIC}}|$KB_TOPIC|g;
" "$TARGET_DIR/README.md"

# ============================================================
# 步骤 7：注册到全局注册表
# ============================================================

echo -e "${YELLOW}注册知识库...${NC}"

LLM_WIKI_DIR="$HOME/.llm-wiki"
REGISTRY_FILE="$LLM_WIKI_DIR/registry.yaml"

mkdir -p "$LLM_WIKI_DIR"

if [ ! -f "$REGISTRY_FILE" ]; then
    cat > "$REGISTRY_FILE" << 'REGISTRY_EOF'
# LLM Wiki Registry
# Auto-managed by llm-wiki-init.sh. Do not edit manually.

wikis:
REGISTRY_EOF
fi

# Check if wiki is already registered
if grep -q "name: $KB_NAME" "$REGISTRY_FILE" 2>/dev/null; then
    echo -e "  ${YELLOW}⚠ 知识库 '$KB_NAME' 已在注册表中，跳过注册${NC}"
else
    cat >> "$REGISTRY_FILE" << REGISTRY_EOF
  - name: $KB_NAME
    path: $TARGET_DIR
    topic: $KB_TOPIC
    updated: $TODAY
REGISTRY_EOF
    echo -e "  ${GREEN}✓ 已注册到 $REGISTRY_FILE${NC}"
fi

# ============================================================
# 完成
# ============================================================

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  知识库创建成功！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "  路径: ${BLUE}$TARGET_DIR${NC}"
echo -e "  注册表: ${BLUE}$REGISTRY_FILE${NC}"
echo ""
echo -e "  目录结构:"
echo "  ├── CLAUDE.md              # 智能体规范"
echo "  ├── README.md              # 使用说明"
echo "  ├── assets/                # 附件层"
echo "  ├── raw/                   # 收件箱"
echo "  │   ├── articles/"
echo "  │   ├── papers/"
echo "  │   ├── transcripts/"
echo "  │   └── archive/"
echo "  ├── wiki/                  # 知识编译层"
echo "  │   ├── index.md"
echo "  │   ├── log.md"
echo "  │   ├── concepts/"
echo "  │   ├── entities/"
echo "  │   ├── sources/"
echo "  │   └── syntheses/"
echo ""
echo -e "  使用方式:"
echo "  1. 将资料放入 raw/ 目录"
echo "  2. 在 Claude Code 中执行 /wiki-ingest 开始收录"
echo "  3. 使用 /wiki-query 查询知识库"
echo "  4. 使用 /wiki-lint 检查健康状态"
echo ""
echo -e "  ${BLUE}跨工具使用（Claude Code / Codex / Gemini CLI / Cursor）:${NC}"
echo "  npx skills add kangarooh/llm-wiki -g"
echo "  然后在任意 AI 工具中使用 /wiki-ingest、/wiki-query"
echo ""
