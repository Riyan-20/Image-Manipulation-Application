# ImageProcessingApp

## Overview
`ImageProcessingApp` is a MATLAB-based graphical user interface (GUI) that allows users to perform essential image manipulation operations. With an intuitive interface, you can easily load images, apply various transformations, and save them in different formats.

## Features

### 1. Load an Image
- Users can browse and load images from their local system.
- Supported formats: `.jpg`, `.png`, `.bmp`, and `.tiff`.
- The loaded image is displayed within the app's UI.

### 2. Save Image
- Save the processed image in the following formats: `.jpg`, `.png`, `.bmp`, or `.tiff`.
- Choose the format using the **Save Format** dropdown.
- Users receive a confirmation message when the image is saved successfully.

### 3. Image Information
- Get detailed information about the loaded image, including:
  - Height and width (in pixels).
  - Number of color channels.
  - Estimated compressed file size in kilobytes (KB).

### 4. Convert to Black & White
- Convert the image to a black and white (binary) format using the **Convert to B&W** button.
- If the image is already grayscale, it is directly converted to binary.

### 5. Crop Image
- Crop the image by specifying the coordinates and dimensions (x, y, width, height).
- The cropped image will be displayed in place of the original image.

### 6. Resize Image
- Resize the image by specifying new dimensions (width and height).
- The resized image replaces the original one.

### 7. Flip Image
- Flip the image either horizontally or vertically using the **Flip Direction** dropdown.
- Options: 
  - Horizontal Flip
  - Vertical Flip

### 8. Combine Images
- Combine two images using two methods:
  - **Side-by-side**: The images are displayed next to each other.
  - **Overlay**: The images are blended together.
  
## How to Use

1. **Load an Image**: Click the **Browse** button and select an image file from your system.
2. **Manipulate the Image**: Choose any of the available options to modify the loaded image:
   - Convert to Black & White
   - Crop, Resize, or Flip the image.
   - Combine the loaded image with another one.
3. **Save the Image**: Once you're done with modifications, click the **Save Image** button, choose the desired format from the dropdown, and save the image to your local system.

## System Requirements
- MATLAB R2020a or later.
- Image Processing Toolbox (optional but recommended for advanced image manipulation).

## Getting Started

1. Clone the repository or download the `ImageProcessingApp.m` file.
2. Open the file in MATLAB.
3. Run the app by typing the following command in the MATLAB Command Window:

   ```matlab
   app = ImageProcessingApp;
