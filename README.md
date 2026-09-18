# code-compass

项目上下文路由 + 自进化记忆技能，面向 [ZCode](https://z.ai) / 兼容 `.agents/skills/` 约定的 AI 编码助手。

## 解决什么问题

新开会话（新窗口）时，AI 习惯全量重读整个代码库——烧 token、慢，长上下文一满又得换窗口，恶性循环。

code-compass 用**一张路由表 + 分层记忆**替代全量读取：

- 根目录 `AGENTS.md` 只做路由（约 20 行，会话自动加载），所有规则外置到 `.ai/rules/`
- `.ai/index/code-map.md` 记录"模块 → 文件 → 职责 → 处理哪些数据"，先查地图再读代码
- 每完成一个任务自动写 journal；常问问题蒸馏成 FAQ——**路由表随使用越来越准（自进化）**
- 任务状态变化即落盘 active.md，新窗口第一件事读它 → **跨会话记得上次做到哪**

语言无关（C++ / Rust / Python / Go / 混合栈通用），零外部依赖，纯 markdown + git。

## 数据层布局（项目内 init 生成）

    AGENTS.md                  # 纯路由，ZCode 自动加载
    .ai/
    ├── index/code-map.md      # 模块→文件→职责→处理哪些数据
    ├── index/faq.md           # 常问问题→答案→相关文件
    ├── rules/                 # 编码规范、领域规则
    └── memory/
        ├── active.md          # 当前工作焦点（跨窗口记忆的关键）
        ├── decisions.md       # 为什么这么设计
        ├── progress.md        # 初始状态 + 各阶段快照（自进化原始数据）
        └── journal/*.md       # 每任务一条记录

## 四角色工作流

| 角色 | 执行者 | 时机 |
|---|---|---|
| Scout 检索路由 | Explore 子agent（大仓库/跨模块）；小问题内联查 code-map | 动手前 |
| Analyst 分析实现 | 主agent，只读定位出的文件 | Scout 返回后 |
| Reviewer 审核 | general-purpose 子agent（全新上下文，不带实现者偏见） | 非平凡改动完成后 |
| Scribe 记录 | 主agent，任务状态每次变化时落盘 | 全程 |

## 安装

**方式一：git clone 到用户级技能目录**（本人所有项目可用）

```bash
# Linux / WSL / macOS
git clone https://github.com/ceoifung/code-compass.git ~/.agents/skills/code-compass

# Windows (Git Bash)
git clone https://github.com/ceoifung/code-compass.git "$USERPROFILE/.agents/skills/code-compass"
```

**方式二：放进项目仓库的 `.agents/skills/code-compass/`**（随 git 分发，团队 clone 即得，优先级高于用户级）

## 快速开始

1. 在项目里对 AI 说 **"初始化 code-compass"** → 生成 AGENTS.md 路由节 + `.ai/` 数据层 + 初始状态审计（Stage 0）
2. 正常开发。问"X 功能在哪个文件"会走路由；新窗口说"继续上次的任务"从 active.md 恢复
3. 任务完成后 AI 自动写 journal；攒 5 条（或主动说 **"复盘"**）触发蒸馏：FAQ 提炼、code-map 修正、规则升格、progress 记新阶段

## 设计原则

- code-map 是地图不是副本：模块级条目、每模块 ≤8 行，细节靠定向 grep
- AGENTS.md 永远只做路由，规则一律进 `.ai/rules/`，常驻上下文不膨胀
- 记忆文件提交 git：团队共享、可追溯、蒸馏错了能 revert
- 蒸馏是进化引擎：journal 是原始数据，蒸馏把它变成更准的路由表、FAQ 和规则

## 致谢

设计借鉴了 [Aider repo-map](https://aider.chat/docs/repomap.html) 的 token 精简索引思想、[Cline Memory Bank](https://docs.cline.bot/best-practices/memory-bank) 的记忆文件分类法、以及 [AGENTS.md 路由实践](https://developers.redhat.com/articles/2026/07/27/standardize-project-context-agentsmd-and-agent-skills)。
