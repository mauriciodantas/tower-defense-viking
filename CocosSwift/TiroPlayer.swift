func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class TiroPlayer : CCSprite {
    
    var posicaoTiro:CGPoint!
    private var velocidadeArremesso:CGFloat = 700
    
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
    
    convenience init(posicaoTiro:CGPoint) {
        self.init(imageNamed:"tiro-ipad.png")
         self.contentSize = self.boundingBox().size
        
        self.scale = 0.8
        self.physicsBody = CCPhysicsBody(rect: CGRectMake(0, 0, self.contentSize.width, self.contentSize.height), cornerRadius: 0.0)
        self.physicsBody.type = CCPhysicsBodyType.Kinematic
        self.physicsBody.friction = 1.0
        self.physicsBody.elasticity = 0.1
        self.physicsBody.mass = 100.0
        self.physicsBody.density = 100.0
        self.physicsBody.collisionType = "TiroPlayer"
        self.physicsBody.collisionCategories = ["TiroPlayer"]
        self.physicsBody.collisionMask = ["PirataPeixe","PirataPerneta"]
        self.posicaoTiro=posicaoTiro
    }
    
    override func onEnter() {
        super.onEnter()
    }
    
    
    
    func movaMe(){
    
        let posicaoFinalTiro = self.calcularPosicaoFinalTiro(self.position, pontoTiro: self.posicaoTiro)
        
        let distancia = self.calcularDistanciaEntrePontos(self.position, p2:posicaoFinalTiro)
        
        let tempo = self.calcularTempoTrajetoria(distancia)
        
        let actions: [CCAction] = [CCActionMoveTo.actionWithDuration(tempo, position: posicaoFinalTiro) as! CCAction,
                                   CCActionCallBlock.actionWithBlock({ () -> Void in
                                    self.removeFromParentAndCleanup(true)
                                   }) as! CCAction]
        
        self.runAction(CCActionSequence.actionWithArray(actions) as! CCAction)
    
    }
    
    func calcularDistanciaEntrePontos(p1: CGPoint, p2: CGPoint) -> CGFloat {
        let xDist:CGFloat = (p2.x - p1.x);
        let yDist:CGFloat = (p2.y - p1.y);
        let distance:CGFloat = sqrt((xDist * xDist) + (yDist * yDist));
        return distance
    }
    
    func calcularTempoTrajetoria(distancia:CGFloat) -> Double {
        let tempo:CGFloat = distancia / self.velocidadeArremesso
        return Double.init(tempo)
    }
    
    func calcularAngulo(p1:CGPoint,p2:CGPoint ) -> Float {
        let deltaX = p1.x - p2.x;
        let deltaY = p1.y - p2.y;
        
        let angle = atan2f(Float(deltaY), Float(deltaX));
        return Float(270.0) - CC_RADIANS_TO_DEGREES(angle);
    }
    
    func calcularPosicaoFinalTiro(pontoJogador:CGPoint, pontoTiro:CGPoint) -> CGPoint{
        let offset = pontoTiro - pontoJogador
        let direction = offset.normalized()
        let shootAmount = direction * 1000
        let realDest = shootAmount + pontoTiro
        return realDest
    }

    
    deinit {
        // Chamado no momento de desalocacao
    }
}
