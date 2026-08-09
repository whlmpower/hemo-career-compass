@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================================
:: hemo-career-compass 跨平台安装脚本 (Windows)
:: 支持：Trae Code / Codex CLI / 千问办公 / WorkBuddy
:: 支持：Windows 10/11
:: ============================================================

set SCRIPT_VERSION=1.0.0
set SKILL_NAME=hemo-career-compass

:: ============================================================
:: 工具函数
:: ============================================================

:log_info
    echo [INFO] %~1
    goto :eof

:log_success
    echo [SUCCESS] %~1
    goto :eof

:log_warn
    echo [WARN] %~1
    goto :eof

:log_error
    echo [ERROR] %~1
    goto :eof

:: ============================================================
:: 1. 获取用户目录
:: ============================================================

set USER_HOME=%USERPROFILE%

:: ============================================================
:: 2. 检测已安装的 AI Agent
:: ============================================================

:detect_agents
    setlocal
    set agents=
    
    :: 检测 Trae Code
    if exist "%USER_HOME%\.trae\skills" (
        call :add_agent "trae" "%USER_HOME%\.trae\skills"
    ) else if exist "%USER_HOME%\.trae-cn\skills" (
        call :add_agent "trae" "%USER_HOME%\.trae-cn\skills"
    )
    
    :: 检测 Codex CLI
    if exist "%USER_HOME%\.codex\skills" (
        call :add_agent "codex" "%USER_HOME%\.codex\skills"
    ) else if exist "%USER_HOME%\.agents\skills" (
        call :add_agent "codex" "%USER_HOME%\.agents\skills"
    )
    
    :: 检测 Claude Code
    if exist "%USER_HOME%\.claude\skills" (
        call :add_agent "claude" "%USER_HOME%\.claude\skills"
    )
    
    :: 检测千问办公
    if exist "%USER_HOME%\.qwenworkcn\skills" (
        call :add_agent "qwen" "%USER_HOME%\.qwenworkcn\skills"
    ) else if exist "%USER_HOME%\.qwen\skills" (
        call :add_agent "qwen" "%USER_HOME%\.qwen\skills"
    )
    
    :: 检测 WorkBuddy
    if exist "%USER_HOME%\.workbuddy\skills" (
        call :add_agent "workbuddy" "%USER_HOME%\.workbuddy\skills"
    )
    
    endlocal & set AGENTS=!agents!
    goto :eof

:add_agent
    if defined agents (
        set agents=%agents%;%~1;%~2
    ) else (
        set agents=%~1;%~2
    )
    goto :eof

:: ============================================================
:: 3. 检测 Agent 是否正在运行
:: ============================================================

:is_agent_running
    set agent=%~1
    tasklist /FI "IMAGENAME eq *%agent%*" 2>NUL | find /I /N "%agent%" >NUL
    if %ERRORLEVEL% EQU 0 (
        exit /B 0
    ) else (
        exit /B 1
    )

:: ============================================================
:: 4. 安装 Skill
:: ============================================================

:install_skill
    set source_dir=%~1
    set target_dir=%~2
    set agent=%~3
    set scope=%~4
    
    set skill_target=%target_dir%\%SKILL_NAME%
    
    :: 检查目标目录是否存在
    if not exist "%target_dir%" (
        call :log_warn "目标目录不存在: %target_dir%"
        set /p create_dir="是否创建该目录？(y/n) "
        if /I not "!create_dir!"=="y" (
            call :log_error "安装取消"
            exit /B 1
        )
        mkdir "%target_dir%"
    )
    
    :: 检查是否已安装
    if exist "%skill_target%" (
        call :log_warn "Skill 已存在于: %skill_target%"
        set /p overwrite="是否覆盖安装？(y/n) "
        if /I not "!overwrite!"=="y" (
            call :log_info "安装取消"
            exit /B 0
        )
        rmdir /S /Q "%skill_target%"
    )
    
    :: 复制文件
    call :log_info "正在安装到: %skill_target%"
    xcopy /E /I /H /Y "%source_dir%\*" "%skill_target%\" >nul
    
    call :log_success "Skill 已安装到: %skill_target%"
    
    :: 检查 Agent 是否运行
    call :is_agent_running "%agent%"
    if %ERRORLEVEL% EQU 0 (
        call :log_warn "检测到 %agent% 正在运行，建议重启后生效"
    )
    
    exit /B 0

:: ============================================================
:: 5. 辅助函数：添加选项
:: ============================================================

:add_option
    if defined options (
        set options=%options%;%~1
        set descriptions=%descriptions%;%~2
    ) else (
        set options=%~1
        set descriptions=%~2
    )
    goto :eof

:: ============================================================
:: 主程序
:: ============================================================

echo ============================================================
echo   hemo-career-compass 跨平台安装脚本 v%SCRIPT_VERSION%
echo ============================================================
echo.

:: 获取脚本所在目录
set SCRIPT_DIR=%~dp0
set SOURCE_DIR=%SCRIPT_DIR%

:: 检查源文件
if not exist "%SOURCE_DIR%SKILL.md" (
    call :log_error "未找到 Skill 源文件，请确保此脚本位于 Skill 目录内"
    pause
    exit /B 1
)

call :log_success "Skill 源文件: %SOURCE_DIR%"
echo.

:: 检测已安装的 Agent
call :log_info "正在检测已安装的 AI Agent..."

call :detect_agents

if "%AGENTS%"=="" (
    call :log_warn "未检测到已安装的 AI Agent"
    call :log_info "支持的 Agent: Trae Code, Codex CLI, 千问办公, WorkBuddy"
    echo.
    set /p continue="是否继续安装？（你可以稍后手动复制到对应目录）(y/n) "
    if /I not "!continue!"=="y" (
        call :log_error "安装取消"
        pause
        exit /B 1
    )
) else (
    call :log_success "检测到以下 Agent:"
    :: 直接解析 AGENTS 字符串显示
    for %%a in (%AGENTS%) do (
        echo   - %%a
    )
    echo.
)

:: 选择安装目标
echo 请选择安装目标:
echo.

set options=
set descriptions=

:: 解析检测到的 Agent（每个 agent 存储为 name;path）
for %%a in (%AGENTS%) do (
    for /f "tokens=1,2 delims=;" %%i in ("%%a") do (
        call :add_option "%%i" "%%i (全局)"
    )
)

:: 添加"所有已检测到的 Agent"
set agent_count=0
for %%a in (%AGENTS%) do set /a agent_count+=1
if !agent_count! gtr 1 (
    call :add_option "all" "安装到所有已检测到的 Agent"
)

:: 添加自定义路径
call :add_option "custom" "自定义安装路径"

:: 显示选项
set i=0
for %%d in (%descriptions%) do (
    set /a i+=1
    echo !i!. %%d
)

echo.
set /p choice_num="请输入选项编号: "

:: 验证输入
for /f "delims=" %%c in ("!choice_num!") do set choice_num=%%c
if "!choice_num!"=="" (
    call :log_error "无效的选项"
    pause
    exit /B 1
)

:: 获取选中项
set selected_option=
set i=0
for %%o in (%options%) do (
    set /a i+=1
    if "!i!"=="!choice_num!" set selected_option=%%o
)

if "!selected_option!"=="" (
    call :log_error "无效的选项"
    pause
    exit /B 1
)

:: 执行安装
if "!selected_option!"=="all" (
    call :log_info "安装到所有已检测到的 Agent..."
    set all_success=true
    for %%a in (%AGENTS%) do (
        for /f "tokens=1,2 delims=;" %%i in ("%%a") do (
            call :install_skill "%SOURCE_DIR%" "%%j" "%%i" "global"
            if !ERRORLEVEL! neq 0 set all_success=false
        )
    )
    if !all_success! (
        call :log_success "所有 Agent 安装完成"
    ) else (
        call :log_warn "部分 Agent 安装失败"
    )
) else if "!selected_option!"=="custom" (
    set /p custom_path="请输入自定义安装路径: "
    if "!custom_path!"=="" (
        call :log_error "路径不能为空"
        pause
        exit /B 1
    )
    call :install_skill "%SOURCE_DIR%" "!custom_path!" "custom" "global"
) else (
    :: 查找对应 Agent 的目录
    set target_dir=
    for %%a in (%AGENTS%) do (
        for /f "tokens=1,2 delims=;" %%i in ("%%a") do (
            if "%%i"=="!selected_option!" set target_dir=%%j
        )
    )
    
    if "!target_dir!"=="" (
        call :log_error "无法获取 !selected_option! 的安装目录"
        pause
        exit /B 1
    )
    
    call :install_skill "%SOURCE_DIR%" "!target_dir!" "!selected_option!" "global"
)

echo.
echo ============================================================
call :log_success "安装完成！"
echo ============================================================
echo.
echo 下一步:
echo 1. 重启你的 AI Agent（如果正在运行）
echo 2. 输入触发词测试: 「大厂和国企怎么选」
echo 3. 如果 AI 以「职业罗盘」身份回应，说明安装成功
echo.
echo 如需帮助，请查看 README.md
echo.
pause
