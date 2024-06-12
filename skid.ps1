Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Text;

public class Win32 {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool EnumWindows(EnumWindowsProc enumProc, IntPtr lParam);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern int GetWindowTextLength(IntPtr hWnd);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder text, int count);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern int GetWindowThreadProcessId(IntPtr hWnd, out int processId);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SetWindowText(IntPtr hWnd, string text);

    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);
}
"@

# Hàm xử lý từng cửa sổ
$enumFunc = {
    param (
        [System.IntPtr]$hWnd,
        [System.IntPtr]$lParam
    )

    # Lấy PID của cửa sổ
    [int]$pid
    [Win32]::GetWindowThreadProcessId($hWnd, [ref]$pid)

    # Lấy tiêu đề hiện tại của cửa sổ
    $length = [Win32]::GetWindowTextLength($hWnd)
    if ($length -gt 0) {
        $builder = New-Object System.Text.StringBuilder $length + 1
        [Win32]::GetWindowText($hWnd, $builder, $builder.Capacity)
        $currentTitle = $builder.ToString()
        
        # Đặt tiêu đề mới cho cửa sổ
        $newTitle = "ayuly gay & con nung loz"
        [Win32]::SetWindowText($hWnd, $newTitle)
    }
    
    return $true
}

# Lặp qua tất cả các cửa sổ
[Win32]::EnumWindows([Win32+EnumWindowsProc]$enumFunc, [IntPtr]::Zero)

Write-Output "All windows have been retitled."
