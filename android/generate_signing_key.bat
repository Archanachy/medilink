@echo off
REM Android Production Signing Key Generation Script for Windows

setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "KEYSTORE_PATH=%SCRIPT_DIR%medilink.keystore"
set "VALIDITY=10000"

echo ======================================
echo MediLink Android Signing Key Generator
echo ======================================
echo.

REM Check if keystore already exists
if exist "%KEYSTORE_PATH%" (
    echo WARNING: Keystore already exists at: %KEYSTORE_PATH%
    set /p REGEN="Do you want to regenerate it? (y/n): "
    if /i not "!REGEN!"=="y" (
        echo Aborted. Using existing keystore.
        exit /b 0
    )
)

REM Validate keytool availability
where keytool >nul 2>nul
if errorlevel 1 (
    echo ERROR: keytool not found. Please ensure Java Development Kit (JDK) is installed.
    exit /b 1
)

echo Generating production signing key...
echo.
echo Please enter the following information:
echo.

REM Collect user information
set /p FIRST_NAME="First name (e.g., 'MediLink'): "
set /p LAST_NAME="Last name (e.g., 'Healthcare'): "
set /p ORGANIZATION="Organization (e.g., 'Archana'): "
set /p CITY="City: "
set /p STATE="State/Province: "
set /p COUNTRY="Country Code (e.g., 'US'): "

REM Note: Windows batch cannot easily handle password input securely
REM For secure password entry, consider using PowerShell
echo.
set /p KEYSTORE_PASSWORD="Keystore password (min 6 chars): "
set /p KEY_PASSWORD="Key password (min 6 chars): "

REM Create the DN (Distinguished Name)
set "DN=CN=%FIRST_NAME% %LAST_NAME%,OU=%ORGANIZATION%,L=%CITY%,ST=%STATE%,C=%COUNTRY%"

echo.
echo Generating keystore with the following details:
echo   Keystore: %KEYSTORE_PATH%
echo   Alias: medilink_key
echo   Validity: %VALIDITY% days
echo   DN: %DN%
echo.

REM Generate the keystore
keytool -genkey -v ^
    -keystore "%KEYSTORE_PATH%" ^
    -keyalg RSA ^
    -keysize 2048 ^
    -validity %VALIDITY% ^
    -alias "medilink_key" ^
    -storepass "%KEYSTORE_PASSWORD%" ^
    -keypass "%KEY_PASSWORD%" ^
    -dname "%DN%"

if errorlevel 1 (
    echo ERROR: Failed to generate keystore!
    exit /b 1
)

REM Update key.properties file
echo.
echo Updating key.properties file...

(
    echo # Android Keystore Configuration
    echo storeFile=medilink.keystore
    echo storePassword=%KEYSTORE_PASSWORD%
    echo keyAlias=medilink_key
    echo keyPassword=%KEY_PASSWORD%
) > "%SCRIPT_DIR%key.properties"

echo.
echo SUCCESS: Keystore generation completed!
echo.
echo Files created:
echo   - Keystore: %KEYSTORE_PATH%
echo   - Config: %SCRIPT_DIR%key.properties
echo.
echo Security reminder:
echo   1. Never commit key.properties or medilink.keystore to version control
echo   2. Keep key.properties in a secure location
echo   3. For CI/CD, use environment variables
echo.
echo SHA-1 Fingerprint:
keytool -list -v -keystore "%KEYSTORE_PATH%" -storepass "%KEYSTORE_PASSWORD%"

endlocal
