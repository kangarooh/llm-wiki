---
name: llm-wiki
description: >
  LLM Wiki 知识库 schema 定义。创建或编辑 wiki 页面、理解目录结构、应用命名规范时参考此 skill。
  wiki-ingest 和 wiki-query 的规则来源。
---

# LLM Wiki Schema

基于 [Andrej Karpathy 的 LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) 模式。

## 目录结构

```
assets/               # 图片、PDF、多媒体附件
raw/                  # 原始资料收件箱（未处理）
├── articles/         # 网页剪藏、技术文章
├── papers/           # 论文、深度研报
├── transcripts/      # 视频/播客转录
└── archive/          # 已处理归档（禁止读取）
wiki/                 # 知识编译层
├── index.md          # 全局目录：所有页面的一句话索引
├── log.md            # 只追加的操作日志
├── concepts/         # 抽象层：方法论、架构模式、原则
├── entities/         # 实体层：框架、工具、API、人物、公司
├── sources/          # 摘要层：每份资料的核心提炼
└── syntheses/        # 综合层：跨来源的深度分析
```

## 页面类型

### 实体页（`entities/`，TitleCase 文件名，如 `SpringBoot.md`）

```markdown
---
title: 实体名称
tags: [tag1, tag2]
sources: [source.pdf]
updated: YYYY-MM-DD
type: entity
---

## 定义
这是什么、解决什么问题。

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

### 概念页（`concepts/`，kebab-case 文件名，如 `ioc-container.md`）

```markdown
---
title: 概念名称
tags: [tag1, tag2]
sources: [source.pdf]
updated: YYYY-MM-DD
type: concept
---

## 定义
一到两句话说明。

## 原理
详细解释工作原理和机制。

## 与其他概念的关系
联系与区别。

## 实际应用
在哪些场景中使用。

## 关联连接
- [[related-concept]] — 相关概念
- [[RelatedEntity]] — 相关实体
```

### 来源摘要（`sources/`，`source-` 前缀，如 `source-spring-in-action.md`）

```markdown
---
title: "资料标题"
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

### 综合页（`syntheses/`，`synthesis-` 前缀，如 `synthesis-microservices.md`）

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
| ... | ... | ... |

## 结论与建议
基于分析的推荐。

## 待验证
哪些结论还需要进一步验证。

## 关联连接
- [[RelatedEntity]] — 相关实体
- [[related-concept]] — 相关概念
```

## 命名规范

| 类型 | 格式 | 示例 |
|------|------|------|
| 实体页 | TitleCase | `SpringBoot.md` |
| 概念页 | kebab-case | `ioc-container.md` |
| 来源摘要 | `source-` + kebab-case | `source-spring-in-action.md` |
| 综合页 | `synthesis-` + kebab-case | `synthesis-microservice-frameworks.md` |

## 规则

1. **双链驱动**：所有页面必须使用 `[[双括号链接]]` 关联相关页面，不允许孤岛页面。
2. **引用标注**：每条事实性陈述标注来源 `(来源: filename.pdf)`，矛盾时明确标注，无来源标注 `⚠️ 待验证`。
3. **原子化**：保持页面短小精悍，通过链接编织网络。
4. **分类原则**：具体事物（框架、工具、API、人物）→ `entities/`。抽象概念或原理 → `concepts/`。单份资料摘要 → `sources/`。跨来源综合分析 → `syntheses/`。

## 注册表格式

知识库注册在 `~/.llm-wiki/registry.yaml`：

```yaml
wikis:
  - name: java-tech-wiki
    path: ~/my-llm-wiki/java-tech-wiki
    topic: Java 技术栈，Spring Boot、MyBatis、微服务架构
    updated: 2026-05-05
```
