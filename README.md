# hemo-career-compass

职业罗盘。通过「大厂 vs 国企」这两个参照系，帮助应届生深度挖掘内心，完成对未来生活期望的梳理，看清自己到底想要什么。

## 快速安装

### 方式一：一键安装脚本（推荐）

**macOS / Linux:**
```bash
curl -sL https://raw.githubusercontent.com/whlmpower/hemo-career-compass/main/install.sh | bash
```

**Windows (PowerShell):**
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/whlmpower/hemo-career-compass/main/install.bat" -OutFile "install.bat"
.\install.bat
```

### 方式二：手动安装

#### 平台安装目录对照

| 平台 | 项目级 | 全局级 (macOS/Linux) | 全局级 (Windows) |
|---|---|---|---|
| Trae Code | `.trae/skills/` | `~/.trae/skills/` | `%userprofile%/.trae/skills/` |
| Codex CLI | `.agents/skills/` 或 `.codex/skills/` | `~/.codex/skills/` | `%userprofile%/.codex/skills/` |
| Claude Code | `.claude/skills/` | `~/.claude/skills/` | `%userprofile%\.claude\skills\` |
| 千问办公 | `.qwen/skills/` | `~/.qwenworkcn/skills/` | `%userprofile%/.qwenworkcn/skills/` |
| WorkBuddy | 不支持 | `~/.workbuddy/skills/` | `C:\Users\<用户名>\.workbuddy\skills\` |

#### 安装步骤

1. 克隆或下载本仓库
2. 将 `hemo-career-compass/` 目录复制到对应平台的 Skill 目录
3. 重启 AI Agent

## 验证安装

安装完成后，在 AI Agent 中输入触发词：
- 「大厂和国企怎么选」
- 「我职业选择很迷茫」

如果 AI 以「职业罗盘」身份回应，说明安装成功。

## 文件结构

```
hemo-career-compass/
├── SKILL.md              # Skill 入口文件，定义触发条件和使用方式
├── README.md             # 本文件，面向开发者的说明文档
├── install.sh            # macOS/Linux 一键安装脚本
├── install.bat           # Windows 一键安装脚本
├── docs/
│   └── developer.md      # 开发者详细说明
├── prompts/
│   ├── system.md         # 系统提示词（核心），5层架构
│   ├── warmup.md         # 暖启动话术库
│   ├── socratic.md       # 苏格拉底式提问话术库
│   └── report.md         # 报告生成模板
├── frameworks/
│   ├── bigfive.md        # 大五人格诊断框架
│   ├── schein.md         # 施恩职业锚框架
│   ├── schwartz.md       # 施瓦茨价值观框架
│   ├── attachment.md     # 依恋类型框架
│   └── risk-tolerance.md # 风险容忍度框架
└── references/
    └── insights.md       # 两篇资料的核心洞察和金句库
```

## 核心设计理念

**不替用户做选择，而是帮他照见自己。**

传统职业咨询的问题是：顾问给出建议，用户被动接受。本 Skill 的假设是：用户内心已经有答案，只是被噪音掩盖了。AI 的角色是一面犀利、直接、不回避矛盾的镜子。

### 关键设计决策

| 决策点 | 选择 | 理由 |
|---|---|---|
| 用户画像 | 985/211 应届生为主 | 这是大厂和国企的主流竞争池，需求最集中 |
| 交付形式 | 对话式问卷 | 深度挖掘需要多轮对话，表单无法承载 |
| 心理学视角 | 混合多模型 | 大五做表层，职业锚/价值观/依恋做深层交叉验证 |
| AI 角色 | 诊断师 | 对话中实时分析并追问，而非事后出报告 |
| 输出边界 | 先放一边 | 核心目标是自我认知深化，大厂/国企建议是副产品 |
| 对话轮次 | 自适应 | 根据用户回答深度动态决定，浅的少问，深的多问 |
| 犀利度 | 犀利 | 应届生需要被挑战，而非被安抚 |

## 平台兼容性

本 Skill 采用标准格式设计，可在以下平台运行：
- Trae Code
- WorkBuddy
- 千问办公
- Codex
- 其他支持 Skill 标准的 AI Agent

### 兼容性要求

1. **文件读取**：Agent 需要能够读取本地文件系统（`prompts/`、`frameworks/`、`references/` 目录）
2. **多轮对话**：Agent 需要支持上下文保持，能够跨轮次引用之前的对话内容
3. **文件写入**：如果需要支持多 Session，Agent 需要能够写入会话摘要文件

## 开发说明

### 如何测试

1. 将 `.trae/skills/hemo-career-compass/` 目录放到项目根目录
2. 在 AI Agent 中触发 Skill（见 `SKILL.md` 中的触发条件）
3. AI 应自动读取 `prompts/system.md` 作为系统提示词
4. 根据对话状态，AI 应引用 `prompts/warmup.md`、`prompts/socratic.md`、`frameworks/*.md` 等文件

### 核心文件说明

| 文件 | 用途 | 重要性 |
|---|---|---|
| `prompts/system.md` | AI 的「灵魂」，定义角色、原则、对话策略、诊断框架 | 极高 |
| `prompts/socratic.md` | 苏格拉底式提问策略库，是产品的核心竞争力 | 极高 |
| `references/insights.md` | 两篇资料的核心洞察，作为诊断话术的弹药 | 高 |
| `prompts/report.md` | 报告生成模板，定义输出结构和话术 | 高 |
| `frameworks/*.md` | 5 个心理学维度的详细定义和诊断逻辑 | 中 |

### 迭代方向

1. **v1.0（当前）**：基础框架 + 5 个维度 + 报告模板
2. **v1.1**：增加更多金句库、优化苏格拉底式提问策略
3. **v2.0**：增加具体职业路径分析（互联网/国企/金融等）
4. **v3.0**：增加多 Session 进度追踪和用户画像持久化

## 版本历史

- v1.0.0 (2026-08-09): 初始版本，包含 5 个心理学维度、自适应对话流程、报告模板、跨平台安装脚本
