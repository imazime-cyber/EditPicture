@echo off
chcp 65001 >nul
title 파일 이름 일괄 변경 (YYYYMMDD_ 형식)

echo ======================================================
echo  YYYY_MM_DD 형태의 파일명을 YYYYMMDD_ 형태로 변경합니다.
echo ======================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "^
    $files = Get-ChildItem -File; ^
    $count = 0; ^
    foreach ($f in $files) { ^
        if ($f.Name -match '^(\\d{4})_(\\d{2})_(\\d{2})[\\s_]*(.*)$') { ^
            $newName = '{0}{1}{2}_{3}' -f $Matches[1], $Matches[2], $Matches[3], $Matches[4]; ^
            if ($f.Name -ne $newName) { ^
                Write-Host ('[변경] ' + $f.Name + ' -> ' + $newName) -ForegroundColor Green; ^
                Rename-Item -LiteralPath $f.FullName -NewName $newName; ^
                $count++; ^
            } ^
        } ^
    }; ^
    Write-Host ('`n총 ' + $count + '개 파일의 이름이 변경되었습니다.') -ForegroundColor Yellow; ^
"

echo.
echo 작업을 완료했습니다. 아무 키나 누르면 창이 닫힙니다.
pause >nul