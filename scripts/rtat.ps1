# rtat - remote tmux attach over SSH. PowerShell port of profile.d/60-tmux.sh.
#
# Usage:   rtat <session> [server]    server defaults to $env:RTAT_DEFAULT_SERVER
# Needs:   OpenSSH on PATH, tmux on the remote host, ~/.ssh/config for completion.
#
# Install (once, per user):
#   Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
#
# Add to $PROFILE:
#   $env:RTAT_DEFAULT_SERVER = "yourserver.example.com"
#   . "C:\path\to\linux-config\scripts\rtat.ps1"
#
# Reload:  . $PROFILE
#
# Windows Terminal shortcuts:
#   Ctrl+Tab / Ctrl+Shift+Tab   next / previous tab
#   F11  (or Alt+Enter)         toggle fullscreen
function rtat {
    param(
        [Parameter(Mandatory, Position = 0)][string]$Session,
        [Parameter(Position = 1)][string]$Server = $env:RTAT_DEFAULT_SERVER
    )

    if (-not $Server) {
        throw "No server given and \$env:RTAT_DEFAULT_SERVER is not set."
    }

    $esc = [char]27
    $previousTitle = $Host.UI.RawUI.WindowTitle
    Write-Host "$esc]0;$Session$esc\" -NoNewline

    try {
        $existing = ssh -t $Server tmux list-sessions 2>$null |
                    ForEach-Object { ($_ -split ':')[0] } |
                    Where-Object { $_ -eq $Session }

        if ($existing) {
            ssh -t $Server tmux -u attach-session -t $Session
        } else {
            ssh -t $Server tmux -u new-session -d -s $Session
            ssh -t $Server tmux -u attach-session -t $Session
        }
    } finally {
        Write-Host "$esc]0;$previousTitle$esc\" -NoNewline
    }
}

function Get-SshConfigHosts {
    $configPath = Join-Path $HOME '.ssh\config'
    if (-not (Test-Path $configPath)) { return @() }

    Get-Content $configPath |
        Where-Object { $_ -match '^\s*Host\s+(.+)$' } |
        ForEach-Object {
            ($Matches[1] -split '\s+') |
                Where-Object { $_ -and $_ -notmatch '[*?]' }
        }
}

Register-ArgumentCompleter -CommandName rtat -ParameterName Server -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    Get-SshConfigHosts |
        Where-Object { $_ -like "$wordToComplete*" } |
        Sort-Object -Unique |
        ForEach-Object {
            [System.Management.Automation.CompletionResult]::new(
                $_, $_, 'ParameterValue', $_)
        }
}

Register-ArgumentCompleter -CommandName rtat -ParameterName Session -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    $server = if ($fakeBoundParameters.ContainsKey('Server')) {
        $fakeBoundParameters['Server']
    } else {
        $env:RTAT_DEFAULT_SERVER
    }
    if (-not $server) { return }

    ssh -o BatchMode=yes -o ConnectTimeout=2 -t $server tmux list-sessions 2>$null |
        ForEach-Object { ($_ -split ':')[0] } |
        Where-Object { $_ -like "$wordToComplete*" } |
        ForEach-Object {
            [System.Management.Automation.CompletionResult]::new(
                $_, $_, 'ParameterValue', $_)
        }
}
