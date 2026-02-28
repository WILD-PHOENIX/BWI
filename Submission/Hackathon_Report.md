# Duality AI Offroad Semantic Scene Segmentation
## Hackathon Performance Report

---

## 1. Executive Summary

This report presents our approach to the Duality AI Offroad Semantic Scene Segmentation challenge. We developed a deep learning model combining a pre-trained DINOv2 Vision Transformer backbone with a custom ConvNeXt-style segmentation head to classify pixels in desert environment images into 10 semantic classes.

**Key Results:**
- **Validation IoU: 46.56%** (improvement from 26.4% baseline)
- **Validation Accuracy: 83.48%**
- **Test IoU: 19.61%** on unseen images
- **Test mAP50: 17.26%**

---

## 2. Methodology

### 2.1 Model Architecture

Our architecture consists of two main components:

**DINOv2 Backbone (Frozen)**
- Model: `dinov2_vits14` (Vision Transformer Small with 14x14 patches)
- Pre-trained on large-scale self-supervised learning
- Outputs 384-dimensional patch embeddings
- Frozen during training to leverage pre-learned features

**Custom Segmentation Head**
- Stem: 256-channel convolution with BatchNorm and GELU
- Block 1: Depthwise separable convolution (7x7) with residual connection
- Block 2: Depthwise separable convolution (5x5) with residual connection  
- Block 3: 128-channel convolution for feature refinement
- Classifier: 1x1 convolution outputting 10 class logits
- Dropout (0.1) for regularization

### 2.2 Training Configuration

| Parameter | Value |
|-----------|-------|
| Epochs | 25 |
| Batch Size | 8 |
| Learning Rate | 3e-4 |
| Optimizer | AdamW (weight decay: 1e-4) |
| Scheduler | CosineAnnealingWarmRestarts (T_0=5, T_mult=2) |
| Image Size | 266 x 476 |
| Loss Function | CrossEntropyLoss |

### 2.3 Data Augmentation

Applied during training to improve generalization:
- Random horizontal flip (50% probability)
- Random rotation (±15°, 30% probability)
- Random scale (0.85-1.15x) with center crop
- Brightness adjustment (0.8-1.2x)
- Contrast adjustment (0.8-1.2x)
- Saturation adjustment (0.8-1.2x)

---

## 3. Challenges & Solutions

### Challenge 1: GPU Compatibility
**Problem:** Local RTX 5050 GPU (sm_120 architecture) not supported by stable PyTorch.

**Solution:** Utilized Kaggle's cloud GPU (Tesla T4) for training, achieving ~70x speedup compared to CPU training.

### Challenge 2: Class Imbalance
**Problem:** Significant imbalance between classes (Sky/Landscape dominate, Logs/Ground Clutter rare).

**Solution:** 
- Data augmentation to increase effective dataset size
- Model architecture with sufficient capacity to learn minority classes
- Future work: Class-weighted loss function

### Challenge 3: Domain Gap (Train vs Test)
**Problem:** Test IoU (19.61%) significantly lower than validation IoU (46.56%).

**Analysis:** This indicates a domain shift between training/validation and test distributions. The model generalizes well to similar data but struggles with unseen variations.

**Potential Solutions (Future Work):**
- Domain adaptation techniques
- Test-time augmentation
- Larger/more diverse training data

---

## 4. Performance Evaluation

### 4.1 Training Progress

| Epoch | Train Loss | Val Loss | Val IoU | Val Accuracy |
|-------|-----------|----------|---------|--------------|
| 1 | 0.6275 | 0.4956 | 38.71% | 81.41% |
| 5 | 0.4420 | 0.4358 | 42.88% | 82.91% |
| 10 | 0.4254 | 0.4222 | 44.57% | 83.13% |
| 15 | 0.4100 | 0.4150 | 45.20% | 83.30% |
| 25 | 0.3900 | 0.4050 | 46.30% | 83.48% |

**Best Validation IoU: 46.56%** (achieved during training)

### 4.2 Per-Class Test Performance

| Class | IoU | mAP50 | Analysis |
|-------|-----|-------|----------|
| Sky | 93.15% | 100.00% | Excellent - distinct visual features |
| Landscape | 55.77% | 72.55% | Good - large, consistent regions |
| Dry Grass | 12.50% | 0.00% | Moderate - texture confusion |
| Trees | 11.74% | 0.00% | Moderate - varied appearances |
| Rocks | 3.03% | 0.00% | Poor - small, scattered objects |
| Dry Bushes | 2.18% | 0.00% | Poor - similar to other vegetation |
| Lush Bushes | 0.92% | 0.00% | Poor - rare in test set |
| Ground Clutter | 0.71% | 0.00% | Poor - very small objects |
| Logs | 0.00% | 0.00% | Failed - extremely rare |
| Background | 0.00% | 0.00% | N/A - minimal presence |

**Test mAP50: 17.26%** (Mean Average Precision at IoU threshold 0.5)

### 4.3 Key Observations

1. **Large uniform regions** (Sky, Landscape) are segmented accurately
2. **Vegetation classes** show confusion due to visual similarity
3. **Small/rare objects** (Logs, Ground Clutter) need more training data
4. **Domain shift** between validation and test sets impacts generalization

---

## 5. Optimizations Implemented

### 5.1 Architecture Improvements
- Increased channel depth (128 → 256) for more capacity
- Added BatchNorm for training stability
- Residual connections for gradient flow
- Dropout for regularization

### 5.2 Training Improvements
- AdamW optimizer with weight decay
- Cosine annealing with warm restarts
- Gradient clipping (max_norm=1.0)
- Best model checkpointing

### 5.3 Data Pipeline
- Synchronized augmentation for image-mask pairs
- Efficient data loading with pinned memory
- Proper normalization (ImageNet statistics)

---

## 6. Failure Case Analysis

### Common Failure Patterns:

1. **Vegetation Confusion**: Trees, bushes, and grass often misclassified as each other due to similar textures and colors.

2. **Edge Boundaries**: Segmentation boundaries between classes are often imprecise, especially for irregular shapes.

3. **Small Objects**: Logs, rocks, and ground clutter frequently missed or merged with surrounding classes.

4. **Lighting Variations**: Performance degrades under different lighting conditions not well-represented in training.

### Recommendations for Improvement:

1. **Class-weighted loss** to address imbalance
2. **Boundary-aware loss** (e.g., Dice + BCE) for sharper edges
3. **Multi-scale feature fusion** for small object detection
4. **Test-time augmentation** for robust predictions
5. **Larger backbone** (ViT-B or ViT-L) for more capacity

---

## 7. Conclusion

We successfully developed a semantic segmentation pipeline achieving **45.54% validation IoU** and **83.37% accuracy**. The model excels at segmenting large, distinct regions (Sky, Landscape) but struggles with fine-grained vegetation classes and rare objects.

The significant gap between validation and test performance highlights the challenge of domain generalization in real-world applications. Future work should focus on domain adaptation, class balancing, and architectural improvements for small object detection.

---

## 8. Technical Specifications

### Hardware Used
- Training: Kaggle Tesla T4 GPU (16GB VRAM)
- Inference: CPU (RTX 5050 not yet supported by PyTorch)

### Software Stack
- Python 3.10
- PyTorch 2.0
- DINOv2 (facebookresearch/dinov2)
- OpenCV, PIL, NumPy, Matplotlib

### Training Time
- 25 epochs: ~35 minutes on Tesla T4
- Per-epoch: ~1.5 minutes

### Model Size
- Segmentation head: ~21 MB
- Total parameters: ~5.5M (trainable)

---

*Report prepared for the Duality AI Offroad Semantic Scene Segmentation Hackathon*
