#!/bin/bash

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "ImageMagick is not installed. Please install it first."
    echo "On macOS: brew install imagemagick"
    echo "On Ubuntu: sudo apt-get install imagemagick"
    exit 1
fi

# Create assets directory if it doesn't exist
mkdir -p assets

# Generate favicon files from profile-transparent.png
PROFILE_IMG="assets/profile-transparent.png"
if [ ! -f "$PROFILE_IMG" ]; then
  PROFILE_IMG="assets/profile.png"
fi

echo "Generating favicon files..."

# Generate PNG favicons
convert "$PROFILE_IMG" -resize 16x16 assets/favicon-16x16.png
convert "$PROFILE_IMG" -resize 32x32 assets/favicon-32x32.png
convert "$PROFILE_IMG" -resize 180x180 assets/apple-touch-icon.png
convert "$PROFILE_IMG" -resize 192x192 assets/android-chrome-192x192.png
convert "$PROFILE_IMG" -resize 512x512 assets/android-chrome-512x512.png

# Generate ICO file (combines 16x16 and 32x32)
convert assets/favicon-16x16.png assets/favicon-32x32.png assets/favicon.ico

# Generate Safari pinned tab SVG
convert "$PROFILE_IMG" -resize 512x512 -background none -gravity center -extent 512x512 assets/safari-pinned-tab.svg

echo "Favicon files generated successfully!" 