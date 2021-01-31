import UIKit
import Vision
import CoreImage.CIFilterBuiltins

// Load demo image
let path = Bundle.main.path(forResource: "image", ofType: "jpg")!
let image = UIImage(contentsOfFile: path)!

// Save a cgImage reference for easier proccessing
let cgImage = image.cgImage!

// Create a CIImage to apply filters
let sourceImage = CIImage(cgImage: cgImage)

// Threshhold, black and white
let filter = CIFilter.colorThreshold()

// Close. Min + Max to remove noise
let filter2 = CIFilter.morphologyRectangleMinimum()
let filter3 = CIFilter.morphologyRectangleMaximum()

// One more minimum to make edges bigger
let filter4 = CIFilter.morphologyRectangleMinimum()

filter.inputImage = sourceImage
filter2.inputImage = filter.outputImage
filter3.inputImage = filter2.outputImage
filter4.inputImage = filter3.outputImage
let pImage = filter4.outputImage!

// Initialize the contour request
let contourRequest = VNDetectContoursRequest()
contourRequest.revision = VNDetectContourRequestRevision1
//contourRequest.contrastAdjustment = 1

let requestHandler = VNImageRequestHandler(ciImage: pImage, options: [:])
try! requestHandler.perform([contourRequest])
let observation = contourRequest.results?.first as! VNContoursObservation

// This are juts some arbitrary values found by trial and error

// Minimum area to filter small contours
let minimumArea = 0.004

// Maximum area to filter really big contours like a full panel
let maximumArea = 0.4

// Minimum ratio to penalize contours that are too concave
let minimumRatio = 0.02
var contours = [VNContour]()

for topContour in observation.topLevelContours {
    for contour in topContour.childContours {
        var area: Double = 0
        try? VNGeometryUtils.calculateArea(&area, for: contour, orientedArea: false)

        var perimeter: Double = 0
        try? VNGeometryUtils.calculatePerimeter(&perimeter, for: contour)

        let ratio = area/perimeter
        if area > minimumArea && area < maximumArea && ratio > minimumRatio {
            contours.append(contour)
        }
    }
}

// Render the contours on top of the original image
let size = CGSize(width: image.size.width, height: image.size.height)
let renderer = UIGraphicsImageRenderer(size: size)
let renderedImage = renderer.image { context in
    let renderingContext = context.cgContext
    let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height)
    renderingContext.concatenate(flipVertical)

    renderingContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

    renderingContext.scaleBy(x: size.width, y: size.height)
    renderingContext.setLineWidth(5.0 / size.width)
    renderingContext.setStrokeColor(UIColor.red.cgColor)
    for contour in contours {
        renderingContext.addPath(contour.normalizedPath)
    }
    renderingContext.strokePath()
}
