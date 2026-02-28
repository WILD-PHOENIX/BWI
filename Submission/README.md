# Duality AI Offroad Semantic Segmentation

## Overview
This project implements a semantic segmentation model for offroad desert environments using DINOv2 as a feature extraction backbone with a custom ConvNeXt-style segmentation head.

## Model Architecture
- **Backbone**: DINOv2 ViT-S/14 (frozen, pre-trained)
- **Segmentation Head**: Custom ConvNeXt-style decoder with:
  - 256-channel stem with BatchNorm and GELU activation
  - Two residual blocks with depthwise separable convolutions
  - 128-channel output block with dropout (0.1)
  - Final 1x1 convolution for 10-class prediction

## Classes (10 total)
| ID | Class Name | Description |
|----|------------|-------------|
| 0 | Background | Default/unknown regions |
| 1 | Trees | Tree vegetation |
| 2 | Lush Bushes | Green, healthy bushes |
| 3 | Dry Grass | Dried grass areas |
| 4 | Dry Bushes | Brown/dried bushes |
| 5 | Ground Clutter | Small debris on ground |
| 6 | Logs | Fallen tree logs |
| 7 | Rocks | Rock formations |
| 8 | Landscape | General terrain |
| 9 | Sky | Sky regions |

## Requirements
- Python 3.10+
- PyTorch 2.0+
- torchvision
- numpy
- PIL/Pillow
- opencv-python
- matplotlib
- tqdm

## Installation

### Option 1: Using Conda (Recommended)
```bash
cd ENV_SETUP
./setup_env.bat
conda activate EDU
```

### Option 2: Manual Installation
```bash
pip install torch torchvision numpy pillow opencv-python matplotlib tqdm
```

## Usage

### Training
```bash
python train_segmentation.py
```

Training parameters (configurable in script):
- Epochs: 25
- Batch size: 8
- Learning rate: 3e-4
- Optimizer: AdamW with weight decay 1e-4
- Scheduler: CosineAnnealingWarmRestarts
- Image size: 266x476

### Testing/Inference
```bash
python test_segmentation.py --model_path segmentation_head.pth --data_dir <path_to_test_images> --output_dir predictions
```

Arguments:
- `--model_path`: Path to trained model weights (default: segmentation_head.pth)
- `--data_dir`: Path to test dataset with Color_Images/ and Segmentation/ folders
- `--output_dir`: Output directory for predictions (default: ./predictions)
- `--batch_size`: Batch size (default: 2)
- `--num_samples`: Number of comparison visualizations to save (default: 5)

### Outputs
The test script generates:
- `masks/`: Raw prediction masks (class IDs 0-9)
- `masks_color/`: Colored RGB visualizations
- `comparisons/`: Side-by-side comparison images
- `evaluation_metrics.txt`: IoU and per-class metrics
- `per_class_metrics.png`: Bar chart of per-class performance

## Dataset Structure
```
dataset/
├── train/
│   ├── Color_Images/
│   │   └── *.png
│   └── Segmentation/
│       └── *.png
├── val/
│   ├── Color_Images/
│   └── Segmentation/
└── test/
    ├── Color_Images/
    └── Segmentation/
```

## Results

### Validation Performance (25 epochs)
| Metric | Value |
|--------|-------|
| Best Val IoU | 46.56% |
| Final Val IoU | 46.30% |
| Final Val Dice | 64.98% |
| Final Val Accuracy | 83.48% |

### Test Performance (Unseen Images)
| Metric | Value |
|--------|-------|
| Mean IoU | 19.61% |
| mAP50 | 17.26% |
| Sky IoU | 93.15% |
| Landscape IoU | 55.77% |
| Trees IoU | 11.74% |
| Dry Grass IoU | 12.50% |

## Files
- `train_segmentation.py`: Training script
- `test_segmentation.py`: Testing/inference script
- `train_kaggle.py`: Kaggle-optimized training script
- `kaggle_notebook.ipynb`: Ready-to-run Kaggle notebook
- `visualize.py`: Mask colorization utility
- `segmentation_head.pth`: Trained model weights
- `ENV_SETUP/`: Environment setup scripts

## Notes
- The model was trained on Kaggle with GPU T4
- For local inference on unsupported GPUs (e.g., RTX 5050), the script automatically uses CPU
- DINOv2 backbone weights are downloaded automatically from torch.hub

## Author
Developed for the Duality AI Offroad Semantic Scene Segmentation Hackathon
