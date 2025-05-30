#!/bin/bash

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "ImageMagick is not installed. Installing..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install imagemagick
    else
        sudo apt-get install imagemagick
    fi
fi

# Check if WebP tools are installed
if ! command -v cwebp &> /dev/null; then
    echo "WebP tools are not installed. Installing..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install webp
    else
        sudo apt-get install webp
    fi
fi

# Create optimized directory if it doesn't exist
mkdir -p assets/optimized

# Function to optimize an image
optimize_image() {
    local input_file=$1
    local filename=$(basename "$input_file")
    local name="${filename%.*}"
    
    echo "Optimizing $filename..."
    
    # Create WebP versions with different sizes
    cwebp -q 80 "$input_file" -o "assets/optimized/${name}.webp"
    cwebp -q 80 -resize 800 0 "$input_file" -o "assets/optimized/${name}-medium.webp"
    cwebp -q 80 -resize 400 0 "$input_file" -o "assets/optimized/${name}-small.webp"
    
    # Create optimized JPEG versions with different sizes
    convert "$input_file" -strip -quality 85 -resize "1200x>" "assets/optimized/${name}.jpg"
    convert "$input_file" -strip -quality 85 -resize "800x>" "assets/optimized/${name}-medium.jpg"
    convert "$input_file" -strip -quality 85 -resize "400x>" "assets/optimized/${name}-small.jpg"
    
    # Create thumbnail version
    convert "$input_file" -strip -quality 85 -resize "200x>" "assets/optimized/${name}-thumb.jpg"
    
    # Create AVIF version (if supported)
    if command -v avifenc &> /dev/null; then
        avifenc -q 80 "$input_file" "assets/optimized/${name}.avif"
    fi
}

# Optimize profile image
optimize_image "assets/profile.png"

# Optimize gallery images
for img in assets/art*.png; do
    if [ -f "$img" ]; then
        optimize_image "$img"
    fi
done

echo "Image optimization complete!" 