# Reviewer — 代码审核规范

触发：改动涉及 >1 个文件，或逻辑非平凡（并发 / 内存 / 协议 / 权限 / 数据迁移 / 算法正确性）。
执行：派 general-purpose 子agent，给它**干净上下文**——只给材料清单，不要把整段对话历史贴给它。
干净上下文正是子agent审核的价值：它不受实现者的思路偏见影响。

## 提供给子agent的材料

1. 改动的文件清单 + diff（或改动后文件的相关区段）
2. `.ai/rules/` 中与本改动相关的规则文件内容
3. code-map 中受影响模块的条目
4. 本次任务的意图（journal 草稿的 intent 一句话即可）

## 检查清单（子agent按此逐项输出）

- correctness: 逻辑是否实现意图；边界条件；错误路径
- rules: 是否违反 .ai/rules/ 条目（逐条对照）
- risk: 安全（注入 / 越权 / 资源泄漏 / 未加锁的共享数据）；语言特有的坑
  （C++ 内存与 UB、Rust unsafe、Python GIL 造成的伪并发结论等）
- tests: 改动是否有测试覆盖；行为变化是否破坏既有测试
- drift: 新增/删除/重命名的文件是否会让 code-map 失真
- memory: scribe 是否已安排记录（journal / active / code-map）

## 输出格式

    verdict: pass | pass-with-notes | fail
    P0(必须改): ...
    P1(应该改): ...
    P2(建议): ...

Reviewer 只报告不修复；主agent决定是否修复，修复后视改动大小决定是否复审。
