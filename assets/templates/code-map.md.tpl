# Code Map（路由总表）

> 目标：让 AI 不全量读代码就能定位。模块级为主，只列关键文件，其余靠 grep。
> 维护：init 生成；每次蒸馏时按 journal 的 pitfalls 修正。每模块 ≤8 行，3-15 个模块为宜。

## module: <名称>
- entry: <关键文件/入口，1-3 个>
- responsibility: <一句话职责>
- data: <处理哪些数据/协议/存储/表>
- depends: <依赖的其他模块>
- notes: <关键约束/坑，1 行；没有则整行删除>
