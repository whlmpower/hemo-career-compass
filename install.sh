#!/bin/bash
set -euo pipefail

# ============================================================
# hemo-career-compass 跨平台安装脚本
# 支持：Trae Code / Codex CLI / 千问办公 / WorkBuddy
# 支持：macOS / Linux / Windows (WSL/Git Bash)
# ============================================================

SKILL_NAME="hemo-career-compass"
SCRIPT_VERSION="1.0.0"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================
# 工具函数
# ============================================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# ============================================================
# 1. 检测操作系统
# ============================================================

detect_os() {
    case "$(uname -s)" in
        Linux*)     OS="linux";;
        Darwin*)    OS="macos";;
        CYGWIN*|MINGW*|MSYS*) OS="windows";;
        *)          OS="unknown";;
    esac
    echo "$OS"
}

# ============================================================
# 2. 检测已安装的 AI Agent
# ============================================================

detect_agents() {
    local agents=()
    local home="$HOME"
    
    # 检测 Trae Code
    if [ -d "$home/.trae/skills" ] || [ -d "$home/.trae-cn/skills" ]; then
        agents+=("trae")
    fi
    
    # 检测 Codex CLI
    if [ -d "$home/.codex/skills" ] || [ -d "$home/.agents/skills" ]; then
        agents+=("codex")
    fi
    
    # 检测千问办公
    if [ -d "$home/.qwenworkcn/skills" ] || [ -d "$home/.qwen/skills" ]; then
        agents+=("qwen")
    fi
    
    # 检测 WorkBuddy
    if [ -d "$home/.workbuddy/skills" ]; then
        agents+=("workbuddy")
    fi
    
    # 输出检测到的 agents
    printf '%s\n' "${agents[@]}"
}

# ============================================================
# 3. 获取 Agent 的安装目录
# ============================================================

get_agent_global_dir() {
    local agent="$1"
    local home="$HOME"
    
    case "$agent" in
        trae)
            # Trae Code: 优先 ~/.trae/skills，其次 ~/.trae-cn/skills
            if [ -d "$home/.trae/skills" ]; then
                echo "$home/.trae/skills"
            elif [ -d "$home/.trae-cn/skills" ]; then
                echo "$home/.trae-cn/skills"
            fi
            ;;
        codex)
            # Codex CLI: 优先 ~/.codex/skills，其次 ~/.agents/skills
            if [ -d "$home/.codex/skills" ]; then
                echo "$home/.codex/skills"
            elif [ -d "$home/.agents/skills" ]; then
                echo "$home/.agents/skills"
            fi
            ;;
        qwen)
            # 千问办公: 优先 ~/.qwenworkcn/skills，其次 ~/.qwen/skills
            if [ -d "$home/.qwenworkcn/skills" ]; then
                echo "$home/.qwenworkcn/skills"
            elif [ -d "$home/.qwen/skills" ]; then
                echo "$home/.qwen/skills"
            fi
            ;;
        workbuddy)
            # WorkBuddy: ~/.workbuddy/skills
            if [ -d "$home/.workbuddy/skills" ]; then
                echo "$home/.workbuddy/skills"
            fi
            ;;
    esac
}

# ============================================================
# 4. 检测 Agent 是否正在运行
# ============================================================

is_agent_running() {
    local agent="$1"
    
    case "$agent" in
        trae)
            pgrep -f -i "trae" > /dev/null 2>&1 && return 0 || return 1
            ;;
        codex)
            pgrep -f -i "codex" > /dev/null 2>&1 && return 0 || return 1
            ;;
        qwen)
            pgrep -f -i "qwen" > /dev/null 2>&1 && return 0 || return 1
            ;;
        workbuddy)
            pgrep -f -i "workbuddy\|codebuddy" > /dev/null 2>&1 && return 0 || return 1
            ;;
    esac
}

# ============================================================
# 5. 安装 Skill
# ============================================================

install_skill() {
    local source_dir="$1"
    local target_dir="$2"
    local agent="$3"
    local scope="$4"
    
    local skill_target="$target_dir/$SKILL_NAME"
    
    # 检查目标目录是否存在
    if [ ! -d "$target_dir" ]; then
        log_warn "目标目录不存在: $target_dir"
        read -p "是否创建该目录？(y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_error "安装取消"
            return 1
        fi
        mkdir -p "$target_dir"
    fi
    
    # 检查是否已安装
    if [ -d "$skill_target" ]; then
        log_warn "Skill 已存在于: $skill_target"
        read -p "是否覆盖安装？(y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "安装取消"
            return 0
        fi
        rm -rf "$skill_target"
    fi
    
    # 复制文件
    log_info "正在安装到: $skill_target"
    cp -r "$source_dir" "$skill_target"
    
    log_success "Skill 已安装到: $skill_target"
    
    # 检查 Agent 是否运行
    if is_agent_running "$agent"; then
        log_warn "检测到 $agent 正在运行，建议重启后生效"
    fi
    
    return 0
}

# ============================================================
# 6. 验证安装
# ============================================================

verify_installation() {
    local agent="$1"
    local target_dir="$2"
    local skill_path="$target_dir/$SKILL_NAME/SKILL.md"
    
    if [ -f "$skill_path" ]; then
        log_success "验证通过: $skill_path"
        return 0
    else
        log_error "验证失败: $skill_path 不存在"
        return 1
    fi
}

# ============================================================
# 7. 兼容性包装：用 while read 替代 mapfile
# ============================================================

detect_agents_compat() {
    local agents=()
    while IFS= read -r line; do
        [ -n "$line" ] && agents+=("$line")
    done < <(detect_agents)
    
    # 输出为可读格式
    for agent in "${agents[@]}"; do
        echo "$agent"
    done
}

# ============================================================
# 主程序
# ============================================================

main() {
    echo "============================================================"
    echo "  hemo-career-compass 跨平台安装脚本 v${SCRIPT_VERSION}"
    echo "============================================================"
    echo
    
    # 检测操作系统
    OS=$(detect_os)
    log_info "操作系统: $OS"
    
    # 检测脚本所在目录（Skill 源文件目录）
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    SOURCE_DIR="$SCRIPT_DIR"
    
    # 检查源文件是否存在
    if [ ! -f "$SOURCE_DIR/SKILL.md" ]; then
        log_error "未找到 Skill 源文件，请确保此脚本位于 Skill 目录内"
        exit 1
    fi
    
    log_success "Skill 源文件: $SOURCE_DIR"
    echo
    
    # 检测已安装的 Agent
    log_info "正在检测已安装的 AI Agent..."
    
    # 兼容性处理：优先使用 mapfile，降级使用 while read
    DETECTED_AGENTS=()
    if [ -n "${BASH_VERSION:-}" ] && [ "${BASH_VERSINFO[0]}" -ge 4 ]; then
        # bash 4.0+ 支持 mapfile
        while IFS= read -r line; do
            [ -n "$line" ] && DETECTED_AGENTS+=("$line")
        done < <(detect_agents)
    else
        # 旧版 bash 或 sh，使用兼容方式
        while IFS= read -r line; do
            [ -n "$line" ] && DETECTED_AGENTS+=("$line")
        done < <(detect_agents)
    fi
    
    if [ ${#DETECTED_AGENTS[@]} -eq 0 ]; then
        log_warn "未检测到已安装的 AI Agent"
        log_info "支持的 Agent: Trae Code, Codex CLI, 千问办公, WorkBuddy"
        echo
        read -p "是否继续安装？（你可以稍后手动复制到对应目录）(y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_error "安装取消"
            exit 1
        fi
    else
        log_success "检测到以下 Agent:"
        for agent in "${DETECTED_AGENTS[@]}"; do
            local_dir=$(get_agent_global_dir "$agent")
            if is_agent_running "$agent"; then
                echo "  - $agent (运行中) -> $local_dir"
            else
                echo "  - $agent (未运行) -> $local_dir"
            fi
        done
        echo
    fi
    
    # 选择安装目标
    echo "请选择安装目标:"
    echo
    
    local options=()
    local descriptions=()
    
    # 添加已检测到的 Agent
    for agent in "${DETECTED_AGENTS[@]}"; do
        local_dir=$(get_agent_global_dir "$agent")
        options+=("$agent")
        descriptions+=("$agent (全局) -> $local_dir")
    done
    
    # 添加"所有已检测到的 Agent"
    if [ ${#DETECTED_AGENTS[@]} -gt 1 ]; then
        options+=("all")
        descriptions+=("安装到所有已检测到的 Agent")
    fi
    
    # 添加自定义路径
    options+=("custom")
    descriptions+=("自定义安装路径")
    
    # 显示选项
    for i in "${!options[@]}"; do
        echo "$((i+1)). ${descriptions[$i]}"
    done
    
    echo
    read -p "请输入选项编号: " -n 1 -r choice_num
    echo
    
    if ! [[ "$choice_num" =~ ^[0-9]+$ ]] || [ "$choice_num" -lt 1 ] || [ "$choice_num" -gt ${#options[@]} ]; then
        log_error "无效的选项"
        exit 1
    fi
    
    local selected_option="${options[$((choice_num-1))]}"
    
    # 执行安装
    case "$selected_option" in
        all)
            log_info "安装到所有已检测到的 Agent..."
            local all_success=true
            for agent in "${DETECTED_AGENTS[@]}"; do
                local_dir=$(get_agent_global_dir "$agent")
                # 修复：移除 ! ，正确判断返回值
                if install_skill "$SOURCE_DIR" "$local_dir" "$agent" "global"; then
                    :
                else
                    all_success=false
                fi
            done
            if $all_success; then
                log_success "所有 Agent 安装完成"
            else
                log_warn "部分 Agent 安装失败"
            fi
            ;;
        custom)
            read -p "请输入自定义安装路径: " custom_path
            if [ -z "$custom_path" ]; then
                log_error "路径不能为空"
                exit 1
            fi
            install_skill "$SOURCE_DIR" "$custom_path" "custom" "global"
            ;;
        *)
            local_dir=$(get_agent_global_dir "$selected_option")
            if [ -z "$local_dir" ]; then
                log_error "无法获取 $selected_option 的安装目录"
                exit 1
            fi
            install_skill "$SOURCE_DIR" "$local_dir" "$selected_option" "global"
            ;;
    esac
    
    echo
    echo "============================================================"
    log_success "安装完成！"
    echo "============================================================"
    echo
    echo "下一步:"
    echo "1. 重启你的 AI Agent（如果正在运行）"
    echo "2. 输入触发词测试: 「大厂和国企怎么选」"
    echo "3. 如果 AI 以「职业罗盘」身份回应，说明安装成功"
    echo
    echo "如需帮助，请查看 README.md"
    echo
}

main "$@"
