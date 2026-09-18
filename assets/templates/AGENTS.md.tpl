<!-- code-compass:route -->
## Code Compass 路由

本仓库使用 code-compass 上下文系统（`.ai/` 目录，已提交 git）。做任何代码工作前按序读取：

1. `.ai/index/code-map.md` — 模块→文件→职责→数据处理。先查地图，再读代码。
2. `.ai/memory/active.md` — 当前工作焦点；若有未完成任务，先与用户确认是否继续。
3. 按需：常见问题 → `.ai/index/faq.md`；历史任务 → grep `.ai/memory/journal/`；
   编码/领域规则 → `.ai/rules/`；设计原因 → `.ai/memory/decisions.md`。

硬性约束：

- 禁止全量读取仓库代码；只读 code-map 定位出的文件，细节用定向 grep。
- 修改前核对 code-map 中该模块的条目，避免改错层。
- 任务完成或状态变化时，按 code-compass 技能更新 journal 与 active.md。
