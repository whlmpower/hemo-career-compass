# ============================================================
# hemo-career-compass 一键安装脚本 (PowerShell)
# 支持：Trae Code / Codex CLI / Claude Code / 千问办公 / WorkBuddy
# 支持：Windows 10/11
# ============================================================

$ErrorActionPreference = 'Stop'
$skillName = 'hemo-career-compass'
$zipUrl = 'https://github.com/whlmpower/hemo-career-compass/archive/refs/heads/main.zip'
$tempDir = Join-Path $env:TEMP "$skillName-install"
$zipPath = Join-Path $env:TEMP "$skillName.zip"

Write-Host "============================================================"
Write-Host "  hemo-career-compass 一键安装脚本"
Write-Host "============================================================"
Write-Host ""

# 1. 清理并下载
Write-Host "[INFO] 正在从 GitHub 下载..."
if (Test-Path $tempDir) { Remove-Item -Recurse -Force $tempDir }
if (Test-Path $zipPath) { Remove-Item -Force $zipPath }

try {
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing
    Expand-Archive -Path $zipPath -DestinationPath $tempDir -Force
} catch {
    Write-Host "[ERROR] 下载失败: $_"
    exit 1
}
Write-Host "[SUCCESS] 下载并解压完成"
Write-Host ""

# 2. 找到项目目录
$repoDir = Get-ChildItem $tempDir -Directory | Select-Object -First 1
if (-not $repoDir) {
    Write-Host "[ERROR] 解压后未找到项目文件"
    exit 1
}

$sourceDir = Join-Path $repoDir.FullName $skillName
if (-not (Test-Path $sourceDir)) {
    $sourceDir = $repoDir.FullName
}

# 3. 检测已安装的 Agent
Write-Host "[INFO] 正在检测已安装的 AI Agent..."

$userProfile = $env:USERPROFILE
$targets = @()

if (Test-Path "$userProfile\.trae\skills") { $targets += "$userProfile\.trae\skills" }
if (Test-Path "$userProfile\.trae-cn\skills") { $targets += "$userProfile\.trae-cn\skills" }
if (Test-Path "$userProfile\.codex\skills") { $targets += "$userProfile\.codex\skills" }
if (Test-Path "$userProfile\.agents\skills") { $targets += "$userProfile\.agents\skills" }
if (Test-Path "$userProfile\.claude\skills") { $targets += "$userProfile\.claude\skills" }
if (Test-Path "$userProfile\.qwenworkcn\skills") { $targets += "$userProfile\.qwenworkcn\skills" }
if (Test-Path "$userProfile\.qwen\skills") { $targets += "$userProfile\.qwen\skills" }
if (Test-Path "$userProfile\.workbuddy\skills") { $targets += "$userProfile\.workbuddy\skills" }

if ($targets.Count -eq 0) {
    Write-Host "[WARN] 未检测到已安装的 AI Agent"
    Write-Host "支持的 Agent: Trae Code, Codex CLI, Claude Code, 千问办公, WorkBuddy"
    Write-Host ""
    $continue = Read-Host "是否继续安装？(你可以稍后手动复制到对应目录) (y/n)"
    if ($continue -ne "y") {
        Write-Host "[ERROR] 安装取消"
        Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
        Remove-Item -Force $zipPath -ErrorAction SilentlyContinue
        exit 1
    }
} else {
    Write-Host "[SUCCESS] 检测到以下 Agent:"
    foreach ($target in $targets) {
        Write-Host "  - $target"
    }
    Write-Host ""
}

# 4. 安装到所有检测到的目录
foreach ($target in $targets) {
    $dest = Join-Path $target $skillName
    if (Test-Path $dest) {
        Write-Host "[WARN] 已存在: $dest，正在覆盖..."
        Remove-Item -Recurse -Force $dest
    }
    Copy-Item -Recurse -Force $sourceDir $dest
    Write-Host "[SUCCESS] 已安装到: $dest"
}

# 5. 清理临时文件
Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
Remove-Item -Force $zipPath -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "============================================================"
Write-Host "  安装完成！"
Write-Host "============================================================"
Write-Host ""
Write-Host "下一步:"
Write-Host "1. 重启你的 AI Agent（如果正在运行）"
Write-Host "2. 输入触发词测试: 「大厂和国企怎么选」"
Write-Host "3. 如果 AI 以「职业罗盘」身份回应，说明安装成功"
Write-Host ""
Write-Host "如需帮助，请查看 README.md"
Write-Host ""
