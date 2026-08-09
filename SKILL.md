---
name: "hemo-career-compass"
description: "通过多参照系进行职业自我认知诊断。Invoke when user asks about career choice between big tech/SOE/civil service/foreign enterprise/startup, or expresses career confusion."
---

# hemo-career-compass

职业罗盘。通过「多参照系」进行通用职业自我认知诊断，帮助用户深度挖掘内心，完成对未来生活期望的梳理，看清自己到底想要什么。

## 触发条件

当用户表达以下意图时，触发本 Skill：
- 询问「大厂和国企怎么选」
- 询问「考公还是去企业」
- 询问「外企怎么样」
- 询问「要不要创业」
- 表达职业选择迷茫、纠结
- 询问职业规划、未来方向
- 想要了解自己适合什么样的工作
- 提到「央企」「体制内」「互联网」「稳定」「高薪」「创业」「外企」等关键词

## 使用方式

本 Skill 采用**自适应对话式诊断**流程，AI 作为「犀利诊断师」角色，通过多轮苏格拉底式提问，帮助用户完成自我认知深化。

### 核心流程

1. **暖启动**：建立信任，说明流程，管理预期
2. **基础信息采集**：家庭背景、个人履历、消费习惯、焦虑清单、决策风格
3. **参照系选择**：根据用户输入自动推荐参照系（大厂/国企、考公、外企、创业），用户可确认或切换
4. **深层诊断**：自适应展开 5 个心理学维度（大五人格、施恩职业锚、施瓦茨价值观、依恋类型、风险容忍度）
5. **综合诊断**：整合发现，识别矛盾和盲区，应用动态权重矩阵
6. **报告输出**：经用户确认后，输出「职业自我认知报告」（通用版 + 参照系专属分析）

### 文件结构

```
hemo-career-compass/
├── SKILL.md              # 本文件（AI 核心入口）
├── README.md             # 用户文档，包含安装说明
├── install.sh            # macOS/Linux 一键安装脚本
├── install.bat           # Windows 一键安装脚本
├── docs/
│   └── developer.md      # 开发者详细说明
├── prompts/
│   ├── system.md         # 系统提示词（核心，5层架构）
│   ├── warmup.md         # 暖启动话术库
│   ├── socratic.md       # 苏格拉底式提问话术库
│   └── report.md         # 报告生成模板
├── frameworks/
│   ├── bigfive.md        # 大五人格诊断框架
│   ├── schein.md         # 施恩职业锚框架
│   ├── schwartz.md       # 施瓦茨价值观框架
│   ├── attachment.md     # 依恋类型框架
│   ├── risk-tolerance.md # 风险容忍度框架
│   └── weights.md        # 动态权重矩阵（参照系差异化）
├── referencers/          # 参照系模块（可扩展）
│   ├── bigtech-vs-soe/   # 大厂 vs 国企
│   │   ├── meta.json     # 参照系元数据
│   │   ├── insights.md   # 核心洞察和金句
│   │   ├── outcomes.md   # 出路与风险分析
│   │   └── report-addon.md # 报告专属分析
│   ├── civil-service/    # 考公/体制内
│   │   ├── meta.json
│   │   ├── insights.md
│   │   ├── outcomes.md
│   │   └── report-addon.md
│   ├── foreign-enterprise/ # 外企
│   │   ├── meta.json
│   │   ├── insights.md
│   │   ├── outcomes.md
│   │   └── report-addon.md
│   └── startup/          # 创业
│       ├── meta.json
│       ├── insights.md
│       ├── outcomes.md
│       └── report-addon.md
└── references/
    └── insights.md       # 通用金句库和资料洞察
```

### 关键原则

- **不替用户做选择**：只照见，不建议
- **案例优先**：要求用户提供具体经历，而非抽象选项
- **犀利但慈悲**：挑战假设，但不评判
- **自适应轮次**：根据用户回答深度动态决定对话轮次，不固定问题数量
- **多 Session 支持**：支持用户带着新案例回来继续探索

## 平台兼容性

本 Skill 采用标准格式设计，支持跨平台安装：

### 支持的平台

| 平台 | 项目级 | 全局级 (macOS/Linux) | 全局级 (Windows) |
|---|---|---|---|
| Trae Code | `.trae/skills/` | `~/.trae/skills/` | `%userprofile%/.trae/skills/` |
| Codex CLI | `.agents/skills/` 或 `.codex/skills/` | `~/.codex/skills/` | `%userprofile%/.codex/skills/` |
| Claude Code | `.claude/skills/` | `~/.claude/skills/` | `%userprofile%\.claude\skills\` |
| 千问办公 | `.qwen/skills/` | `~/.qwenworkcn/skills/` | `%userprofile%/.qwenworkcn/skills/` |
| WorkBuddy | 不支持 | `~/.workbuddy/skills/` | `C:\Users\<用户名>\.workbuddy\skills\` |

### 安装方式

推荐使用一键安装脚本，详见 `README.md`。

### 兼容性要求

1. **文件读取**：Agent 需要能够读取本地文件系统（`prompts/`、`frameworks/`、`references/` 目录）
2. **多轮对话**：Agent 需要支持上下文保持，能够跨轮次引用之前的对话内容
3. **文件写入**：如果需要支持多 Session，Agent 需要能够写入会话摘要文件

## 版本历史

- v1.1.0 (2026-08-09): 扩展支持多参照系（考公、外企、创业），增加动态权重矩阵、价值观冲突检测、压力类型分析、决策风格分析、Mermaid 可视化、伦理边界声明
- v1.0.0 (2026-08-09): 初始版本，包含 5 个心理学维度、自适应对话流程、报告模板、跨平台安装脚本
