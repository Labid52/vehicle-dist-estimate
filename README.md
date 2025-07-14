# Stereo-Based Car Distance Estimation

This repository implements a stereo vision pipeline for object detection and distance estimation using disparity maps and stereo camera calibration. The code is designed to process stereo images, enhance them adaptively, compute 3D point clouds, detect cars using a trained cascade classifier, and estimate distances to the detected objects. The dataset has not been provided here. Please refer to  auvsi-cv-all  for that. The full link of the repository has been mentioned in next couple of sections. 

---

## 📂 Project Structure

### 🔧 Core Files

| File Name              | Description                                                                         |
| ---------------------- | ----------------------------------------------------------------------------------- |
| `main.m`               | Main script for stereo processing, disparity estimation, and distance calculation.  |
| `returnStereoImages.m` | Function to load stereo image pairs from dataset.                                   |
| `thresholdPC.m`        | Utility to threshold point clouds based on 3D constraints.                          |
| `returnTrainingPath.m` | Utility function for training data path management (not critical to main pipeline). |
| `stereoParams.mat`     | Precomputed stereo calibration parameters.                                          |
| `CarDetector.xml`      | Pre-trained Haar Cascade classifier for car detection.                              |

### 📁 Folders

* `saved_frames/` - Output folder where annotated result images are saved.

> **Dataset Source**: Stereo images and base MATLAB code were obtained from [sseshadr/auvsi-cv-all](https://github.com/sseshadr/auvsi-cv-all)

---

## 🚀 How to Run

1. Ensure you have **MATLAB** installed with the **Computer Vision Toolbox**.
2. Clone or download this repository.
3. Place the image dataset in the `image/` folder.
4. Run `main.m`. The script will:

   * Load and enhance stereo images based on frame-specific masks.
   * Rectify the images using calibration parameters (`stereoParams.mat`).
   * Compute disparity map and reconstruct the 3D scene.
   * Filter the 3D point cloud within a specified distance threshold.
   * Detect vehicles using a trained classifier (`CarDetector.xml`).
   * Estimate the distance to the detected vehicle(s) and annotate the image.
   * Save processed frames to `saved_frames/`.

---

## 📌 Features

* Adaptive image enhancement based on pre-labeled mask index (`Mask1`).
* Manual bounding box overrides for failed automatic detections.
* Accurate distance estimation from disparity-derived 3D point clouds.
* Automatic visualization and output saving.

---

## 📎 Dependencies

* MATLAB R2020b or later (recommended)
* Computer Vision Toolbox

---

## 📜 License & Credits

This project builds upon the dataset and base framework from:
**[sseshadr/auvsi-cv-all](https://github.com/sseshadr/auvsi-cv-all)**

Please refer to their repository for original licensing information and academic references.

---

<img width="1530" height="359" alt="image" src="https://github.com/user-attachments/assets/e4e4c70f-853c-41f7-a308-588492ac3654" />


