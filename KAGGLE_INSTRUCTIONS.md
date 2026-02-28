# Kaggle Training Instructions

## Step 1: Prepare Dataset for Upload

Create a ZIP file containing only the training dataset:

**Files to include in ZIP:**
```
Offroad_Segmentation_Training_Dataset/
├── Offroad_Segmentation_Training_Dataset/
│   ├── train/
│   │   ├── Color_Images/
│   │   └── Segmentation/
│   └── val/
│       ├── Color_Images/
│       └── Segmentation/
```

**Location:** `C:\Users\Mahesh\Desktop\BWI\Offroad_Segmentation_Training_Dataset`

## Step 2: Upload Dataset to Kaggle

1. Go to: https://www.kaggle.com/datasets
2. Click **"+ New Dataset"**
3. Name it: `offroad-segmentation-dataset`
4. Upload the ZIP file
5. Set visibility to **Private**
6. Click **Create**

## Step 3: Create Kaggle Notebook

1. Go to: https://www.kaggle.com/code
2. Click **"+ New Notebook"**
3. **IMPORTANT:** Enable GPU:
   - Click on **Settings** (right sidebar)
   - Under **Accelerator**, select **GPU T4 x2** or **P100**
4. Add your dataset:
   - Click **"+ Add Data"** (right sidebar)
   - Search for your dataset: `offroad-segmentation-dataset`
   - Click **Add**

## Step 4: Copy Notebook Code

Either:
- **Option A:** Upload `kaggle_notebook.ipynb` directly
- **Option B:** Copy cells from the notebook into Kaggle

## Step 5: Run Training

1. Run all cells in order
2. Training will take approximately **30-45 minutes** with GPU
3. Monitor the progress - you should see IoU improving each epoch

## Step 6: Download Results

After training completes, download these files from `/kaggle/working`:
- `segmentation_head_best.pth` - Best model weights
- `segmentation_head.pth` - Final model weights
- `train_stats/` folder - Training curves and metrics

## Expected Results

With 25 epochs on GPU, you should achieve:
- **Val IoU: 45-55%** (significant improvement from 26% baseline)
- **Val Accuracy: 75-85%**
- **Val Dice: 55-65%**

## Troubleshooting

### "Dataset not found" error
- Check the dataset name matches exactly
- Verify the folder structure inside the ZIP

### "CUDA out of memory" error
- Reduce `BATCH_SIZE` from 8 to 4

### Training is slow
- Ensure GPU is enabled in Settings → Accelerator

## After Training

1. Download `segmentation_head_best.pth`
2. Place it in `C:\Users\Mahesh\Desktop\BWI\Offroad_Segmentation_Scripts\`
3. Run test script locally to evaluate on test images
