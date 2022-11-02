# Demosaicing-CPFA-LMMSE
This script allow you to demosaic a colour and polarimetric image from a filter array sensor with the Linear Minimum Mean Square Error demosaicing algorithm. The default arrangement is the QuadBayer polarization pattern from the SONY IMX250 MYR sensor. The specific arrangement can be adapted in the code if needed.

<img src="https://user-images.githubusercontent.com/10449075/187774705-afb79148-763f-4ad9-8a7b-b14b20292b44.png" width=25%>

The Data folder contains a mosaiced image and a matrix used for demosaicing.

The Function folder contains 2 Matlab functions used to demosaic.

A script is provided as a demonstration.

The LMMSE demosaicing algorithm is a learning-based technique. The training is done with the data used in this publication (training with 12 images from the Wen et al. database). If using the code, please cite :
  - Dumoulin R., Lapray P.-J., Thomas J.-B., Farup I.,  Impact of training data on LMMSE demosaicing for Colour-Polarization Filter Array, submitted to SITIS conference, 2022. (update when published).
  
