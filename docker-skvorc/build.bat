@echo off
REM <summary>
REM Automates authentication, building, and pushing of the custom MeshCentral Docker image.
REM Stops the execution if any of the steps fail.
REM </summary>

set IMAGE_NAME=andrejskvorc/meshcentral
set IMAGE_TAG=caprover

echo =======================================================
echo 0. Checking Docker Hub authentication...
echo =======================================================
docker login

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Docker login failed! Please check your credentials.
    pause
    exit /b %errorlevel%
)
echo.

echo =======================================================
echo 1. Building Docker image: %IMAGE_NAME%:%IMAGE_TAG%
echo =======================================================
REM Ključni korak: penjemo se mapu iznad kako bismo zahvatili cijeli kod!
cd ..
docker build -f docker-skvorc/Dockerfile -t %IMAGE_NAME%:%IMAGE_TAG% .

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Docker build failed! Check the logs above.
    cd docker-skvorc
    pause
    exit /b %errorlevel%
)
echo.

echo =======================================================
echo 2. Pushing Docker image to Docker Hub...
echo =======================================================
docker push %IMAGE_NAME%:%IMAGE_TAG%

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Docker push failed! Make sure you have the right permissions.
    cd docker-skvorc
    pause
    exit /b %errorlevel%
)
echo.

echo =======================================================
echo SUCCESS! Your custom MeshCentral image is now live.
echo =======================================================
REM Vraćamo se nazad u vašu radnu mapu
cd docker-skvorc
pause