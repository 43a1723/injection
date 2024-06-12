Add-Type @"
using System;
using System.Text;
using System.Runtime.InteropServices;

public class Win32 {
    [DllImport("user32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool SetWindowText(IntPtr hWnd, string lpString);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);

    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern int GetWindowTextLength(IntPtr hWnd);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out int lpdwProcessId);
}
"@

$processName = "javaw"
$newTitle = "New Java Window Title"

function Get-WindowTitle($hWnd) {
    $length = [Win32]::GetWindowTextLength($hWnd)
    if ($length -gt 0) {
        $builder = New-Object System.Text.StringBuilder $length
        [void][Win32]::GetWindowText($hWnd, $builder, $builder.Capacity + 1)
        return $builder.ToString()
    }
    return ""
}

function Set-WindowTitle($hWnd, $title) {
    [Win32]::SetWindowText($hWnd, $title) | Out-Null
}

$enumFunc = {
    param (
        [System.IntPtr]$hWnd,
        [System.IntPtr]$lParam
    )
    
    $null = [Win32]::GetWindowThreadProcessId($hWnd, [ref]$pid)
    $process = Get-Process -Id $pid -ErrorAction SilentlyContinue
    if ($process -and $process.ProcessName -eq $processName) {
        Set-WindowTitle $hWnd $newTitle
    }
    
    return $true
}

[Win32]::EnumWindows([Win32+EnumWindowsProc]$enumFunc, [IntPtr]::Zero)
Write-Output "All windows with process name '$processName' have been retitled to '$newTitle'."
