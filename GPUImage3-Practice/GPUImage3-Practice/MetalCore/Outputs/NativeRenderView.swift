import Foundation
import MetalKit

public class NativeRenderView: MTKView, ImageConsumer {
    
    public let sources = SourceContainer()
    public let maximumInputs: UInt = 1
    var currentTexture: Texture?
    var renderPipelineState:MTLRenderPipelineState!
    
    public override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: sharedContext.device)
        
        commonInit()
    }
    
    public required init(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        framebufferOnly = false
        autoResizeDrawable = true
        
        self.device = sharedContext.device
        
        renderPipelineState = generateRenderPipelineState(vertexFunctionName: FunctionName.OneInputVertex,
                                                          fragmentFunctionName: FunctionName.PassthroughFragment)
        
        enableSetNeedsDisplay = false
        isPaused = true
    }
    
    public func newTextureAvailable(_ texture:Texture, fromSourceIndex:UInt) {
        self.drawableSize = CGSize(width: texture.texture.width, height: texture.texture.height)
        currentTexture = texture
        self.draw()
    }
    
    public override func draw(_ rect:CGRect) {
        if let currentDrawable = self.currentDrawable,
            let imageTexture = currentTexture {
            let commandBuffer = sharedContext.commandQueue.makeCommandBuffer()
            
            let outputTexture = Texture(texture: currentDrawable.texture)
            commandBuffer?.renderQuad(pipelineState: renderPipelineState, inputTextures: [0:imageTexture], outputTexture: outputTexture)
            
            commandBuffer?.present(currentDrawable)
            commandBuffer?.commit()
        }
    }
}


