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
* Read the image.

The image I will be using is a page of the manga [ブラックジャックによろしく](https://densho810.com/free/)
![Image 1](/images/image1.jpg)

* Clean the image

For this step I'm applying multiple CIFilters. The speech bubbles should be really obvious after this step.
![Image 2](/images/image2.png)

* Detect Contours

A `VNDetectContoursRequest` seems to be doing a great job of detecting contours
![Image 3](/images/image3.jpg)

TODO:
*  Filter contours to discard unreasonable contours. Some Python/OpenCV code can be found [here](https://github.com/damishshah/comic-book-reader/blob/5cd9e77d86c7803d3df796838a4e43fce068707f/comic_book_reader.py#L46-L47). Need to investigate it and port it if useful.
* After having the most probable speech bubbles identified, it should be easy to split and mask the image to get the individual bubble using Core Graphics.
