---
name: code-compass
description: 项目上下文路由与自进化记忆系统。凡是仓库里存在 .ai/ 目录（或用户要求建立）时的代码工作都应使用：改代码、查代码、定位"哪个文件处理哪个数据"、新窗口继续上次的任务、代码完成后的审核与记忆记录、复盘蒸馏。当用户说 init/初始化/建索引/上下文路由，说"继续上次的问题"，问"这个功能在哪个文件"，或不满 AI 重复全量读代码时，必须触发本技能。
---

# Code Compass — 上下文路由 + 自进化记忆

解决的问题：新窗口冷启动时 AI 全量读代码，烧 token 又慢。本系统用一张路由表（code-map）
加分层记忆（journal / faq / active / progress）替代全量读取，并且每完成一个任务就沉淀一次记录，
让路由表随使用越来越准——这就是"自进化"。

## 数据层布局（init 后存在于仓库根）

    AGENTS.md                  # 纯路由，约 20 行，ZCode 自动加载（提交 git，对全团队生效）
    .ai/
    ├── index/code-map.md      # 模块→文件→职责→处理哪些数据
    ├── index/faq.md           # 常问问题→答案→相关文件
    ├── rules/                 # 所有规则：coding.md 及按领域拆分的文件
    └── memory/
        ├── active.md          # 当前工作焦点（跨窗口记忆的关键）
        ├── decisions.md       # 为什么这么设计
        ├── progress.md        # 初始状态 + 各阶段快照（自进化原始数据）
        └── journal/*.md       # 每任务一条记录

若仓库没有 `.ai/` 且用户要求初始化 → 读 `references/init.md` 执行。

## 冷启动协议（每个新会话开始时）

1. AGENTS.md 由 ZCode 自动加载，其路由指向：
2. 读 `.ai/index/code-map.md` 与 `.ai/memory/active.md`（这两个必读，其余按需）。
3. 若 active.md 显示有未完成任务，先向用户确认是否继续，再动手。
4. 之后只读 code-map 定位出的文件。禁止全量读取仓库代码。

这保证"新窗口记得上一个窗口在做什么"：会话之间不共享对话记忆，但 active.md 在每个任务
状态变化时落盘（见 `references/scribe.md`），新会话第一件事就是读它。

## 标准工作流：Scout → Analyst → Reviewer → Scribe

| 角色 | 执行者 | 时机 | 详见 |
|---|---|---|---|
| Scout 检索路由 | Explore 子agent（大仓库/跨模块问题时）；小问题内联查 code-map | 动手前 | references/scout.md |
| Analyst 分析实现 | 主agent自己 | Scout 返回候选文件后，只读这些文件 | — |
| Reviewer 审核 | general-purpose 子agent（全新上下文） | 非平凡改动完成后（>1 文件或逻辑复杂） | references/reviewer.md |
| Scribe 记录 | 主agent自己 | 任务状态每次变化时（不只是完成时） | references/scribe.md |

分工理由：Scout / Reviewer 派子agent是因为"干净上下文"有价值（检索不被对话污染、审核不带
实现者偏见）；Analyst / Scribe 由主agent做是因为前者会重复读文件，后者需要写权限且必须可靠。

小改动豁免：单文件且 <20 行的改动可跳过 Scout 与 Reviewer，但 Scribe 的 journal + active.md
更新不可跳过——记忆是系统进化的燃料。

## 任务收尾（每次必做）

1. 按 `references/scribe.md` 写 journal 条目、更新 active.md；涉及设计取舍的补 decisions.md。
2. 若改动新增/删除/重命名了文件 → 同步修正 code-map 对应条目。
3. 检查未蒸馏 journal 数量：`grep -L "distilled:" .ai/memory/journal/*.md | wc -l`
   ≥5，或用户说"复盘/蒸馏" → 按 `references/scribe.md` 的蒸馏流程执行。

## 关键原则

- code-map 是地图不是副本：模块级条目，每模块 ≤8 行；细节靠定向 grep。
- AGENTS.md 永远只做路由，规则一律进 `.ai/rules/`——否则常驻上下文越积越重，适得其反。
- 记忆文件提交 git：团队共享、历史可追溯、蒸馏错了能 revert。
- 语言无关：不依赖 tree-sitter 等外部工具，C++/Rust/Python/Go 等任何栈用同一套流程。
- 蒸馏是进化的引擎：journal 是原始数据，蒸馏把它变成更准的路由表、FAQ 和规则。
