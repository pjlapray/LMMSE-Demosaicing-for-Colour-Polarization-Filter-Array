# Demosaicing-CPFA-LMMSE
This code allow you to demosaic a colour and polarimetric image from a filter array sensor with the Linear Minimum Mean Square Error demosaicing algorithm. The default arrangement is the QuadBayer polarization pattern from the SONY IMX250 MYR sensor. The specific arrangement can be adapted in the code if needed.
The LMMSE demosaicing algorithm is a learning-based technique. The initial training (matrix 'D_matrix.mat' in Data folder) is done with the data used in the publication (training with 12 images from the Wen et al. database). If using the code, please cite these publications:
  1- Dumoulin R., Lapray P.-J., Thomas J.-B., Farup I., Impact of training data on LMMSE demosaicing for Colour-Polarization Filter Array, submitted to SITIS conference, 2022. (update when published).
  2- Spote A., Lapray P.-J., Thomas J.-B., Farup I., Joint demosaicing of colour and polarisation from filter arrays, In 29th Color and Imaging Conference Final Program and Proceedings 2021, Society for Imaging Science and Technology, 2021.

<img src="https://user-images.githubusercontent.com/10449075/187774705-afb79148-763f-4ad9-8a7b-b14b20292b44.png" width=25%>

Two scripts are provided as demonstration:
   - The script to use for demosaicing with the furbished pre-trained matrix D is "Script_LMMSE_Demosaicing".
   - If you may want to retrain the demosaicing matrix with your own specific data, use the Script named "Script_LMMSE_training.m". Please use the same image structure as in "Data/Dataset".

The "Data" folder contains a mosaiced image, a matrix used for demosaicing, along woth a dataset in case of retraining matrix D with the script "Script_LMMSE_training.m".

The "Function" folder contains Matlab functions needed for retraining.
