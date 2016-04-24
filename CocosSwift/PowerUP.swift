class PowerUP : CCSprite {
    
    override init(CGImage image: CGImage!, key: String!) {
        super.init(CGImage: image, key: key)
    }
    
    override init(spriteFrame: CCSpriteFrame!) {
        super.init(spriteFrame: spriteFrame)
    }
    
    override init(texture: CCTexture!) {
        super.init(texture: texture)
    }
    
    override init(texture: CCTexture!, rect: CGRect) {
        super.init(texture: texture, rect: rect)
    }
    
    override init(texture: CCTexture!, rect: CGRect, rotated: Bool) {
        super.init(texture: texture, rect: rect, rotated: rotated)
    }
    
    override init(imageNamed imageName: String!) {
        super.init(imageNamed: imageName)
    }
    
    convenience override init() {
        self.init(imageNamed:"powerUP-ipad.png")
        self.contentSize = self.boundingBox().size
        
        self.scale = 0.8
        self.physicsBody = CCPhysicsBody(rect: CGRectMake(0, 0, self.contentSize.width, self.contentSize.height), cornerRadius: 0.0)
        self.physicsBody.type = CCPhysicsBodyType.Kinematic
        self.physicsBody.friction = 1.0
        self.physicsBody.elasticity = 0.1
        self.physicsBody.mass = 100.0
        self.physicsBody.density = 100.0
        self.physicsBody.collisionType = "PowerUP"
        self.physicsBody.collisionCategories = ["PowerUP"]
        self.physicsBody.collisionMask = ["TiroPlayer"]
            
    }
    
    override func onEnter() {
        super.onEnter()
    }
    
    
    deinit {
        // Chamado no momento de desalocacao
    }
}
