# Detect speech bubbles in Swift
The idea with this project is to try to detect speech bubbles on comics/mangas using Swift. Especially using [Vision](https://developer.apple.com/documentation/vision), [Core Image](https://developer.apple.com/documentation/coreimage) and [Core Graphics](https://developer.apple.com/documentation/coregraphics).

## Steps
1. Read the image
2. Clean the image
3. Detect contours
4. Filter contours to discard unreasonable contours
5. Use the contours bounds to clip the image and the contour poligon path to mask the invers of the speech bubble.

After that, the image should be ready for OCR

## Progress
#### Read the Image.
The image I will be using is a page of the manga [ブラックジャックによろしく](https://densho810.com/free/)

<img src="/images/image1.jpg" width="400">

#### Clean the Image
For this step I'm applying multiple CIFilters. The speech bubbles should be really obvious after this step.

<img src="/images/image2.png" width="400">

#### Detect Contours
A `VNDetectContoursRequest` seems to be doing a great job of detecting contours

<img src="/images/image3.jpg" width="400">

#### Filter Contours
Filter contours that have an area of at least 0.004, and no bigger than 0.4 and that have a proportion of area/perimeter of at least 0.02

<img src="/images/image4.jpg" width="400">

#### Clean the Images
With the contours identified, it's possible to crop and mask individual bubbles. To help on cleaning the bubble border, the path is stroked with white color.

<img src="/images/bubble1.jpg" width="100"><img src="/images/bubble2.jpg" width="100"><img src="/images/bubble3.jpg" width="100"><img src="/images/bubble4.jpg" width="100"><img src="/images/bubble5.jpg" width="100"><img src="/images/bubble6.jpg" width="100"><img src="/images/bubble7.jpg" width="100">

TODO:
* It's possible that some contours inside contours aren't being checked.


## Resources
* https://heartbeat.fritz.ai/new-in-ios-14-vision-contour-detection-68fd5849816e
* https://developer.apple.com/videos/play/wwdc2020/10673
* https://www.thepythoncode.com/article/contour-detection-opencv-python
* https://github.com/damishshah/comic-book-reader
