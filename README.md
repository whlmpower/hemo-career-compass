# hemo-career-compass

职业罗盘。通过「多参照系」进行通用职业自我认知诊断，帮助用户深度挖掘内心，完成对未来生活期望的梳理，看清自己到底想要什么。

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
- 「考公还是去企业」
- 「要不要创业」
- 「外企怎么样」
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

## 核心设计理念

**不替用户做选择，而是帮他照见自己。**

传统职业咨询的问题是：顾问给出建议，用户被动接受。本 Skill 的假设是：用户内心已经有答案，只是被噪音掩盖了。AI 的角色是一面犀利、直接、不回避矛盾的镜子。

### 关键设计决策

| 决策点 | 选择 | 理由 |
|---|---|---|
| 用户画像 | 面向所有面临职业选择的年轻人 | 不仅限于应届生，也适合工作几年后重新选择的人群 |
| 交付形式 | 对话式问卷 | 深度挖掘需要多轮对话，表单无法承载 |
| 心理学视角 | 混合多模型 | 大五做表层，职业锚/价值观/依恋做深层交叉验证 |
| AI 角色 | 诊断师 | 对话中实时分析并追问，而非事后出报告 |
| 输出边界 | 自我认知深化优先 | 核心目标是帮用户看清自己，职业建议是副产品 |
| 对话轮次 | 自适应 | 根据用户回答深度动态决定，浅的少问，深的多问 |
| 犀利度 | 犀利 | 用户需要被挑战，而非被安抚 |
| 参照系 | 多参照系可扩展 | 大厂/国企、考公、外企、创业等，用户可随时切换 |

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
| `references/insights.md` | 通用金句库，作为诊断话术的弹药 | 高 |
| `prompts/report.md` | 报告生成模板，定义输出结构和话术 | 高 |
| `frameworks/*.md` | 5 个心理学维度的详细定义和诊断逻辑 | 中 |
| `referencers/*/` | 参照系模块，定义不同职业路径的专属分析 | 中 |

### 迭代方向

1. **v1.0**：基础框架 + 5 个维度 + 大厂/国企参照系
2. **v1.1（当前）**：扩展多参照系（考公、外企、创业）+ 动态权重矩阵 + 价值观冲突检测 + 压力类型分析 + 决策风格分析 + Mermaid 可视化 + 伦理边界声明
3. **v1.2**：增加测试场景、完善「如何新增参照系」文档
4. **v2.0**：增加更多参照系（学术、自由职业、转行等）+ 多 Session 进度追踪和用户画像持久化

## 版本历史

- v1.1.0 (2026-08-09): 扩展支持多参照系（考公、外企、创业），增加动态权重矩阵、价值观冲突检测、压力类型分析、决策风格分析、Mermaid 可视化、伦理边界声明
- v1.0.0 (2026-08-09): 初始版本，包含 5 个心理学维度、自适应对话流程、报告模板、跨平台安装脚本
