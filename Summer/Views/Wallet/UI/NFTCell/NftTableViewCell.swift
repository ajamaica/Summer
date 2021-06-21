//
//  NftTableViewCell.swift
//  Summer
//
//  Created by Arturo Jamaica on 2021/06/20.
//

import UIKit
import ARKit
import SceneKit.ModelIO
import SceneKit

struct NftTableViewCellViewModel {
    let nft: NFT
}

class NftTableViewCell: UITableViewCell {

    @IBOutlet weak var scnView: SCNView!
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    private var viewModel: NftTableViewCellViewModel?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setViewModel(_ viewModel: NftTableViewCellViewModel){
        self.viewModel = viewModel
        self.titleLabel.text = viewModel.nft.name
        self.descriptionLabel.text = "\(viewModel.nft.type)"
        setNFTView(nft: viewModel.nft)
    }
    
    // TODO : This is a stub. 
    func setNFTView(nft: NFT){
        switch nft.type {
        case .usdz:
            let mdlAsset = MDLAsset(url: nft.url)
            let scene = SCNScene(mdlAsset: mdlAsset)
            let ambientLightNode = SCNNode()
            ambientLightNode.light = SCNLight()
            ambientLightNode.light!.type = .ambient
            ambientLightNode.light!.color = UIColor.white
            scnView.scene = scene
            scnView.allowsCameraControl = true
            scnView.scene!.rootNode.addChildNode(ambientLightNode)
            scnView.frame = canvasView.bounds
            scnView.backgroundColor = .clear
            self.canvasView.insertSubview(scnView, at: 0)
        case .gif:
            let plane = SCNPlane(width: 2, height: 2)

            let bundleURL = Bundle.main.url(forResource: "solana_bot", withExtension: "gif")
            let animation : CAKeyframeAnimation = createGIFAnimation(url: bundleURL!)!
            let layer = CALayer()
            layer.bounds = CGRect(x: 0, y: 0, width: 900, height: 900)

            layer.add(animation, forKey: "contents")
            let tempView = UIView.init(frame: CGRect(x: 0, y: 0, width: 900, height: 900))
            tempView.layer.bounds = CGRect(x: -450, y: -450, width: tempView.frame.size.width, height: tempView.frame.size.height)
            tempView.layer.addSublayer(layer)

            let newMaterial = SCNMaterial()
            newMaterial.isDoubleSided = true
            newMaterial.diffuse.contents = tempView.layer
            plane.materials = [newMaterial]
            let node = SCNNode(geometry: plane)
            node.name = "engineGif"
            node.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 1)))
            let scene = SCNScene()
            scnView.scene = scene
            scnView.scene?.rootNode.addChildNode(node)
            scnView.allowsCameraControl = true
            scnView.backgroundColor = .clear
            self.canvasView.insertSubview(scnView, at: 0)
        }
        
    }
    
    func createGIFAnimation(url:URL) -> CAKeyframeAnimation? {

        guard let src = CGImageSourceCreateWithURL(url as CFURL, nil) else { return nil }
        let frameCount = CGImageSourceGetCount(src)

        // Total loop time
        var time : Float = 0

        // Arrays
        var framesArray = [AnyObject]()
        var tempTimesArray = [NSNumber]()

        // Loop
        for i in 0..<frameCount {

            // Frame default duration
            var frameDuration : Float = 0.1;

            let cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(src, i, nil)
            guard let framePrpoerties = cfFrameProperties as? [String:AnyObject] else {return nil}
            guard let gifProperties = framePrpoerties[kCGImagePropertyGIFDictionary as String] as? [String:AnyObject]
                else { return nil }

            // Use kCGImagePropertyGIFUnclampedDelayTime or kCGImagePropertyGIFDelayTime
            if let delayTimeUnclampedProp = gifProperties[kCGImagePropertyGIFUnclampedDelayTime as String] as? NSNumber {
                frameDuration = delayTimeUnclampedProp.floatValue
            } else {
                if let delayTimeProp = gifProperties[kCGImagePropertyGIFDelayTime as String] as? NSNumber {
                    frameDuration = delayTimeProp.floatValue
                }
            }

            // Make sure its not too small
            if frameDuration < 0.011 {
                frameDuration = 0.100;
            }

            // Add frame to array of frames
            if let frame = CGImageSourceCreateImageAtIndex(src, i, nil) {
                tempTimesArray.append(NSNumber(value: frameDuration))
                framesArray.append(frame)
            }

            // Compile total loop time
            time = time + frameDuration
        }

        var timesArray = [NSNumber]()
        var base : Float = 0
        for duration in tempTimesArray {
            timesArray.append(NSNumber(value: base))
            base += ( duration.floatValue / time )
        }

        // From documentation of 'CAKeyframeAnimation':
        // the first value in the array must be 0.0 and the last value must be 1.0.
        // The array should have one more entry than appears in the values array.
        // For example, if there are two values, there should be three key times.
        timesArray.append(NSNumber(value: 1.0))

        // Create animation
        let animation = CAKeyframeAnimation(keyPath: "contents")

        animation.beginTime = AVCoreAnimationBeginTimeAtZero
        animation.duration = CFTimeInterval(time)
        animation.repeatCount = Float.greatestFiniteMagnitude;
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.values = framesArray
        animation.keyTimes = timesArray
        //animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.calculationMode = CAAnimationCalculationMode.discrete

        return animation;
    }
    
    
}


