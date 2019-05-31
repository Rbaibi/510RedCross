# 510 Red Cross Challenge
2nd edition of  Hackathon for Good


## OPTIMIZING DISASTER IMPACT ANALYSIS WITH GROUND MEASUREMENTS     
Problem: Analysts, using satellite imagery are capable of quickly assessing damage, flood extents, wildfire extent and more. However, to make these algorithms more reliable and trustworthy they need to be provided with very local data coming from the disaster affected area. These data can be used to feed the analysis or verify its accuracy. 

Current systems for data collection in humanitarian context exist, but are still quite difficult to set up (e.g. Open Data Kit, Open Map Kit). Or they don’t work properly offline, because background maps and satellite data are not cached for offline use. Also some are not very intuitive, meaning that volunteers who collect data need to be trained, which is a time consuming activity in the midst of a disaster. Briefings on how to collect data and where, is usually not part of the existing data collection applications, and need to be sent separately to volunteers. There is no means to reimburse volunteers directly for their costs of traveling to an area where data needs to be collected, nor feedback systems to allow volunteers to provide feedback about the data collection mission.

 Outcome: We are hoping to develop a universal data collection app for volunteers (crowdsourcing app), that is intuitive, well guided, quick, offline and able to collect data points (usually geolocation + status) during a disaster. 

 Volunteers should be able to receive data collection missions for a number of disasters:

-       Flood extent (flooded, no flood, flood border). Same for wildfires

-       Damage to buildings (no damage, slight damage, severe damage, completely destroyed)

-       Locations of e.g. landslides or other localized disasters.

Datasets & Algorithms: We can show examples of e.g. Flood Extent analysis and Damage Assessments as an intro to the Hackathon. But the datasets are not per say necessary to do the work.

Deep Learning Resources
If you are developing a deep neural network based solution, you can use the free GPUs provided by either Google Colab or Kaggle. Here are the instructions for both:

Google Colab:
Go to Google Colab and start a new notebook. You can use the instructions in this notebook to upload your datasets and work on them in Colab. When you need to use GPUs to train your models, switch GPU on under Edit --> Notebook settings. This notebook shows you an example of training a model built in TensorFlow using a GPU.

Kaggle:
Go to Kaggle and create a user profile. Then, go to Kernels --> New Kernel. A blank notebook opens up, and you can write your code in here. You will see on the right side of the notebook an option to turn on the GPU. On the top right side of your notebook, you will see a symbol that looks like a cloud with an arrow on it. You can click on this to upload your data to Kaggle.

Other options:
If you have a Google Cloud, or Amazon Web Services, or Paperspace account, etc, you can use one of these to train your models.
