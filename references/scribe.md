# Scribe — 记忆与蒸馏规范

Scribe 是自进化的引擎。核心原则：记录发生在**任务状态变化时**，不是只在完成时——
否则窗口突然关闭，下一个会话就失忆了。

## active.md 更新时机（每次都要落盘）

任务开始 / 状态变化（如 in-progress → blocked）/ 受阻等待用户 / 完成。
写法见模板：current、status、context（关键文件/分支）、next、open-questions，全文 ≤50 行。
任务完成或归档后，内容收进 journal，active.md 只留新焦点。

## journal 条目

命名：`YYYY-MM-DD-<短横线-slug>.md`，按 assets/templates/journal-entry.md.tpl。
必填项：
- intent：用户真实意图，尽量保留原话关键词——蒸馏 FAQ 全靠它
- pitfalls：定位错误、误解需求、绕的弯路都要写，这是进化的原料，不是丢脸记录

## 蒸馏（触发：未蒸馏条目 ≥5，或用户说"复盘 / 蒸馏"）

未蒸馏计数：`grep -L "distilled:" .ai/memory/journal/*.md | wc -l`

流程：

1. **FAQ**：把 intent 中出现 ≥2 次的同类问题蒸馏成新条目（用用户原话做问题，答案 ≤5 行，附 files）。
2. **code-map 修正**：汇总本轮 journal pitfalls 里"map 指错 / 缺失"的记录，逐条修正；新模块补条目。
3. **rules 提炼**：出现 ≥2 次的同类坑 → 升格为 `.ai/rules/` 新条目（或新文件），一条规则配一个反例。
4. **decisions**：值得长期记住的取舍 → 补 decisions.md。
5. **progress.md 追加一阶段**：`## Stage N — <主题> (日期)`，3-5 行：这阶段改了什么、
   路由表/规则因此变准了什么。
6. **标记已消费**：给每个处理过的 journal 文件追加一行 `distilled: <日期>`
   （不改名不移动，保持 git 历史干净）。

## 大小纪律

active.md ≤50 行；faq 单条 ≤10 行；code-map 每模块 ≤8 行。
超限的处理不是删内容而是归档：旧的活跃焦点进 journal；过时的 FAQ 条目移入 faq.md 底部
`## archived` 区。记忆文件的价值在于"准且短"，不在全。
