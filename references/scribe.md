# Scribe — 记忆与蒸馏规范

Scribe 是自进化的引擎。两条核心原则：

1. 记录发生在**任务状态变化时**，不是只在完成时——否则窗口突然关闭，下一个会话就失忆了。
2. **确认门：journal 与 progress 只收"用户确认已解决"的任务。** 一条失实的"已解决"记录
   经蒸馏会污染 FAQ、code-map 和规则，之后每次会话都被它误导。记忆宁缺毋滥。

## 确认门（写 journal / progress 前必须通过，没有例外）

改动实施后，明确询问用户："问题解决了吗 / 效果符合预期吗？"

**通过的唯一形式**：用户在本会话中的真实回复——明确确认，或亲自验证（跑了程序、看了效果）后认可。

**不算确认**：用户沉默或未回应；AI 自问自答替用户回答；Reviewer 子agent 审核通过
（它只审代码质量，不能代替用户验证效果）；测试全绿但用户尚未表态——可以拿着测试结果去问，
但答案必须出自用户。

分支处理：

- 用户确认 → 写 journal（confirmed 字段填确认日期与方式），active.md 转为 done。
- 用户说没解决 → **不写 journal**；把"尝试了什么、实际现象"简要记入 active.md
  （status 保持 in-progress 或 blocked），继续修，或留给下次会话接续。
- 用户没回复会话就结束 → 什么都不补写；active.md 保持 awaiting-confirmation，
  下个会话开场即请用户验证这个悬置改动。

## active.md 更新时机（每次都要落盘，但只记状态、不记功劳）

任务开始 / 状态变化（如 in-progress → blocked）/ 受阻等待用户 / 改动实施完
（awaiting-confirmation）/ 用户确认解决（done）。
写法见模板：current、status、context（关键文件/分支）、next、open-questions，全文 ≤50 行。
status 语义：done 仅在拿到用户确认后使用；awaiting-confirmation = 已实施但未经用户验证，
此状态下不得在任何记忆文件里表述为"已解决/已修复"。
任务完成或归档后，内容收进 journal，active.md 只留新焦点。

## journal 条目

命名：`YYYY-MM-DD-<短横线-slug>.md`，按 assets/templates/journal-entry.md.tpl。
必填项：
- confirmed：用户确认的日期与方式——没有用户确认，本目录不收这条记录
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
