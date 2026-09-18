# 初始化流程（init）

目标：在仓库生成路由层与记忆层，并完成初始状态审计。语言无关，只用 ls / grep / 读文件，
不引入任何外部工具依赖。

## 安全前置

- 若 `.ai/` 已存在：视作重建索引请求。保留 memory/ 与 rules/ 的全部内容，只重建
  index/code-map.md，并明确告知用户保留了什么。
- 若根目录已有 AGENTS.md 且含用户自己的内容：只**追加** `## Code Compass 路由` 一节
  （模板：assets/templates/AGENTS.md.tpl，含 `<!-- code-compass:route -->` 标记），
  绝不覆盖既有行。已含该标记则只更新该节。

## 步骤

1. **识别构建清单**（判断栈与模块边界）：
   `CMakeLists.txt` / `Makefile` / `meson.build` → C/C++；`Cargo.toml` → Rust；
   `pyproject.toml` / `requirements.txt` / `setup.py` → Python；`package.json` → Node；
   `go.mod` → Go。混合存在就多栈并列记录，这正是本系统的常态。
2. **目录审计**：递归列目录树（忽略 .git/、build/、node_modules/、target/、__pycache__/、
   dist/、vendor/、.venv/），结合清单里的 target/source 划分模块边界。
3. **抽读关键文件**：每个候选模块读入口文件（main / 路由注册 / 对外头文件）的前 ~100 行，
   确认职责与数据处理即可，不深读实现。
4. **生成文件**（模板在 assets/templates/）：
   - AGENTS.md（追加路由节）
   - `.ai/index/code-map.md`：按模板填模块条目；拿不准的职责写 `TODO(audit)`，不要编造。
   - `.ai/memory/active.md`、`decisions.md`、`progress.md`（Stage 0 初始状态审计）、
     `.ai/index/faq.md`（空骨架）
   - `.ai/rules/coding.md`：先只放确定成立的项目约定（从构建清单 / README / lint 配置提取），
     没有就留骨架。语言特有规范按需拆 `rules/cpp.md`、`rules/rust.md`、`rules/python.md`。
5. **progress.md 的 Stage 0 要求**：架构一句话、栈、规模粗估（文件数）、可运行状态、已知债务。
   这是自进化原始数据的起点，宁可朴素，不要虚构。
6. **向用户汇报**：展示 code-map 摘要，请其纠正明显错位的模块职责——用户花 1 分钟纠正，
   省掉后面无数次误路由。

## 验收标准

新开一个会话问"X 功能在哪个文件"，AI 只读 AGENTS.md / code-map / active.md 就能答对，
不需要全量扫代码 → init 合格。
