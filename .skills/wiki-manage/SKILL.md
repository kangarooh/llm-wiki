---
name: wiki-manage
description: >
  管理 LLM Wiki 知识库注册表——列出、注册、注销、更新知识库元数据。触发词：
  "列出知识库"、"我的知识库"、"注册知识库"、"注销知识库"、"list wikis"、
  "register wiki"、"unregister wiki"。
user-invocable: true
---

# Wiki Manage — 注册表管理

管理 `~/.llm-wiki/registry.yaml`，该文件跟踪所有 LLM Wiki 知识库。

## 注册表格式

```yaml
wikis:
  - name: wiki-name
    path: ~/my-llm-wiki/wiki-name
    topic: 知识库主题描述
    updated: YYYY-MM-DD
```

## 列出知识库

读取 `~/.llm-wiki/registry.yaml`，展示所有已注册知识库：

```
已注册知识库：
  1. java-tech-wiki — Java 技术栈，Spring Boot、MyBatis（~/my-llm-wiki/java-tech-wiki）
  2. ai-notes — 机器学习、LLM、RAG（~/my-llm-wiki/ai-notes）
```

文件不存在或无条目 → 提示暂无已注册知识库。

## 注册知识库

向注册表添加新条目。需要 name、path、topic。

1. 读取注册表（不存在则创建文件和目录）
2. 检查名称是否重复
3. 验证路径存在且有 `wiki/` 目录
4. 追加新条目
5. 确认注册

## 注销知识库

从注册表移除条目。**不删除**知识库文件。

1. 读取注册表
2. 按名称查找
3. 移除条目
4. 确认移除

## 更新知识库信息

更新已有条目的 `topic` 或 `updated` 字段。

1. 读取注册表
2. 按名称查找
3. 更新字段
4. 写回

## 文件位置

`~/.llm-wiki/registry.yaml`（目录不存在则自动创建）
