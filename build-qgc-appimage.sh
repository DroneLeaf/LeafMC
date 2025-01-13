#!/bin/bash

# Install dependencies
sudo apt-get update && sudo apt-get install -y \
    build-essential \
    cmake \
    git \
    qtbase5-dev \
    qtdeclarative5-dev \
    qtpositioning5-dev \
    qtlocation5-dev \
    qtmultimedia5-dev \
    qtquickcontrols2-5-dev \
    libqt5svg5-dev \
    libqt5charts5-dev \
    libqt5serialport5-dev \
    qml-module-qtquick2 \
    qml-module-qtquick-controls2 \
    qml-module-qtquick-dialogs \
    qml-module-qtlocation \
    qml-module-qtpositioning \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    pkg-config

# Create and enter build directory
mkdir -p buildAppImage
cd buildAppImage

# Configure with CMake
cmake .. -DCMAKE_BUILD_TYPE=Release

# Build using all available cores
cmake --build . --parallel $(nproc)

# Create AppDir structure for AppImage
mkdir -p AppDir/usr/bin
mkdir -p AppDir/usr/lib
mkdir -p AppDir/usr/share/applications
mkdir -p AppDir/usr/share/icons/hicolor/256x256/apps

# Copy executable
cp QGroundControl AppDir/usr/bin/

# Create desktop entry
cat > AppDir/usr/share/applications/QGroundControl.desktop << EOF
[Desktop Entry]
Name=QGroundControl
Comment=Ground Control Station
Exec=QGroundControl
Icon=QGroundControl
Type=Application
Categories=Utility;
EOF

# Copy icon
cp ../resources/icons/droneLeaf.png AppDir/usr/share/icons/hicolor/256x256/apps/QGroundControl.png

# Download and use linuxdeployqt
wget -c "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
chmod +x linuxdeployqt-continuous-x86_64.AppImage
./linuxdeployqt-continuous-x86_64.AppImage AppDir/usr/share/applications/QGroundControl.desktop \
    -qmldir=../src \
    -bundle-non-qt-libs \
    -extra-plugins=platforms,imageformats,position,geoservices

# Download appimagetool
wget -c "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
chmod +x appimagetool-x86_64.AppImage

# Create AppImage
./appimagetool-x86_64.AppImage AppDir QGroundControl.AppImage

cd ..
rm -rf buildAppImage

echo "Build complete! AppImage created as QGroundControl.AppImage"