import SwiftUI

enum bY2 {
 static let sun=Color(red:1,green:0.831,blue:0), ink=Color(red:0.12,green:0.16,blue:0.12), paper=Color(red:0.98,green:0.975,blue:0.93)
 static let hens:[Color]=[.white,Color(red:1,green:0.82,blue:0.14),Color(red:1,green:0.64,blue:0.72),Color(red:0.55,green:0.85,blue:0.70),Color(red:0.28,green:0.35,blue:0.51),Color(red:0.95,green:0.48,blue:0.23)]
 static let grass:[Color]=[Color(red:0.50,green:0.71,blue:0.18),Color(red:0.40,green:0.64,blue:0.34),Color(red:0.72,green:0.61,blue:0.23),Color(red:0.76,green:0.85,blue:0.82)]
 static func hen(_ c:inout GraphicsContext,_ p:CGPoint,_ z:CGFloat,_ hue:Color) {
  func oval(_ x:CGFloat,_ y:CGFloat,_ w:CGFloat,_ h:CGFloat,_ color:Color) {c.fill(Path(ellipseIn:CGRect(x:p.x+x*z,y:p.y+y*z,width:w*z,height:h*z)),with:.color(color))}
  oval(-0.37,0.23,0.77,0.2,.black.opacity(0.18))
  for x:CGFloat in [-0.17,0.10] {c.fill(Path(roundedRect:CGRect(x:p.x+x*z,y:p.y+0.17*z,width:0.10*z,height:0.24*z),cornerRadius:0.04*z),with:.color(.orange))}
  oval(-0.33,-0.30,0.68,0.68,hue.opacity(0.80));oval(-0.34,-0.42,0.65,0.67,hue)
  oval(-0.26,-0.17,0.29,0.30,.black.opacity(0.055));oval(-0.27,-0.20,0.27,0.26,hue)
  oval(-0.07,-0.58,0.13,0.22,Color(red:0.96,green:0.26,blue:0.21));oval(0.02,-0.56,0.15,0.18,Color(red:0.96,green:0.26,blue:0.21))
  var beak=Path();beak.move(to:CGPoint(x:p.x+0.26*z,y:p.y-0.24*z));beak.addLine(to:CGPoint(x:p.x+0.49*z,y:p.y-0.11*z));beak.addLine(to:CGPoint(x:p.x+0.26*z,y:p.y-0.04*z));beak.closeSubpath();c.fill(beak,with:.color(Color(red:1,green:0.55,blue:0.26)))
  oval(0.12,-0.29,0.09,0.11,Color(red:0.12,green:0.14,blue:0.14));oval(0.135,-0.28,0.025,0.03,.white)
 }
}

struct fH8:View {
 var index:Int=0
 var body:some View {Canvas {c,s in bY2.hen(&c,CGPoint(x:s.width*0.46,y:s.height*0.55),min(s.width,s.height)*0.95,bY2.hens[max(0,min(5,index))])}.accessibilityHidden(true)}
}
struct sA4:View {
 var game:aM5;var terrain:Int;var hen:Int;var motion:Bool=true
 var body:some View {
  Canvas {c,s in
   let t=s.width/9, base=max(0,game.far-2), n=Int(ceil(s.height/t))+4
   c.fill(Path(CGRect(origin:.zero,size:s)),with:.color(bY2.grass[terrain]))
   func y(_ r:Int)->CGFloat {s.height-CGFloat(r-base+2)*t}
   func rect(_ x:CGFloat,_ y:CGFloat,_ w:CGFloat,_ h:CGFloat,_ color:Color,_ radius:CGFloat=0) {c.fill(Path(roundedRect:CGRect(x:x,y:y,width:w,height:h),cornerRadius:radius),with:.color(color))}
   for r in max(0,base-2)...(base+n) {
    let yy=y(r), type=game.lane(r), grass=bY2.grass[terrain]
    switch type {
    case .field:
     rect(0,yy-t/2,s.width,t,grass)
     for col in 0..<9 {
      let xx=CGFloat(col)*t
      if (r+col)%2==0 {rect(xx,yy-t/2,t,t,.white.opacity(0.035))}
      if game.block(r,col) {
       rect(xx+t*0.25,yy+t*0.05,t*0.50,t*0.27,.black.opacity(0.14),t*0.15)
       rect(xx+t*0.44,yy-t*0.10,t*0.12,t*0.35,Color(red:0.45,green:0.32,blue:0.16),t*0.04)
       c.fill(Path(ellipseIn:CGRect(x:xx+t*0.12,y:yy-t*0.48,width:t*0.76,height:t*0.72)),with:.color(terrain==2 ? Color.orange : Color(red:0.22,green:0.46,blue:0.20)))
       c.fill(Path(ellipseIn:CGRect(x:xx+t*0.20,y:yy-t*0.45,width:t*0.54,height:t*0.42)),with:.color(.white.opacity(terrain==3 ? 0.65 : 0.09)))
      } else if (r*7+col*3)%13==0 {
       for i in 0..<3 {rect(xx+t*0.28+CGFloat(i)*t*0.10,yy+t*0.14,t*0.035,t*0.12,.black.opacity(0.13),t*0.02)}
      }
     }
    case .road:
     rect(0,yy-t/2,s.width,t,Color(red:0.19,green:0.21,blue:0.22))
     rect(0,yy-t/2,s.width,2,.black.opacity(0.18))
     for col in 0..<9 {rect(CGFloat(col)*t+t*0.18,yy-1,t*0.40,2,.white.opacity(0.25),1)}
    case .river:
     rect(0,yy-t/2,s.width,t,Color(red:0.21,green:0.62,blue:0.73))
     for col in 0..<12 {let drift=CGFloat(game.elapsed.truncatingRemainder(dividingBy:4))*t*0.2;rect(CGFloat(col)*t-drift,yy-t*0.28,t*0.35,2,.white.opacity(0.24),1);rect(CGFloat(col)*t+drift,yy+t*0.22,t*0.21,2,.white.opacity(0.18),1)}
    case .rail:
     rect(0,yy-t/2,s.width,t,Color(red:0.56,green:0.53,blue:0.43))
     for col in 0..<18 {rect(CGFloat(col)*t/2,yy-t*0.35,t*0.15,t*0.70,Color(red:0.30,green:0.28,blue:0.24),2)}
     for off:CGFloat in [-0.24,0.24] {rect(0,yy+t*off,s.width,3,Color(white:0.75),1)}
     for col in [0,8] {c.fill(Path(ellipseIn:CGRect(x:CGFloat(col)*t+t*0.3,y:yy-t*0.1,width:t*0.22,height:t*0.22)),with:.color(game.warning(r) ? .red : bY2.sun))}
    }
    if let col=game.token(r),!game.taken.contains("\(r):\(col)") {
     let xx=(CGFloat(col)+0.5)*t
     c.fill(Path(ellipseIn:CGRect(x:xx-t*0.15,y:yy-t*0.10,width:t*0.30,height:t*0.30)),with:.color(.black.opacity(0.13)))
     c.fill(Path(ellipseIn:CGRect(x:xx-t*0.15,y:yy-t*0.21,width:t*0.30,height:t*0.30)),with:.color(bY2.sun))
     c.stroke(Path(ellipseIn:CGRect(x:xx-t*0.095,y:yy-t*0.16,width:t*0.19,height:t*0.19)),with:.color(.orange),lineWidth:1.5)
    }
    for (i,v) in game.traffic(r).enumerated() {
     let xx=(CGFloat(v.x)+0.5)*t, ww=CGFloat(v.length)*t
     if type == .river {
      rect(xx,yy-t*0.27+4,ww,t*0.62,.black.opacity(0.17),t*0.15);rect(xx,yy-t*0.32,ww,t*0.61,Color(red:0.63,green:0.39,blue:0.21),t*0.13)
      for line in 0..<3 {rect(xx+t*0.15,yy-t*0.20+CGFloat(line)*t*0.17,ww-t*0.3,1,.black.opacity(0.17),1)}
      c.stroke(Path(ellipseIn:CGRect(x:xx+ww-t*0.27,y:yy-t*0.21,width:t*0.19,height:t*0.40)),with:.color(.black.opacity(0.18)),lineWidth:2)
     } else {
      let tint:Color = type == .rail ? Color(red:0.98,green:0.60,blue:0.22) : [Color(red:0.97,green:0.80,blue:0.16),Color(red:0.91,green:0.42,blue:0.36),Color(red:0.41,green:0.69,blue:0.75)][(r+i)%3]
      for off:CGFloat in [-0.35,0.24] {rect(xx+ww*0.16,yy+t*off,ww*0.17,t*0.14,Color(white:0.10),t*0.03);rect(xx+ww*0.68,yy+t*off,ww*0.17,t*0.14,Color(white:0.10),t*0.03)}
      rect(xx,yy-t*0.29+4,ww,t*0.64,.black.opacity(0.20),t*0.12);rect(xx,yy-t*0.32,ww,t*0.61,tint,t*0.12)
      if type == .rail {for j in 0..<6 {rect(xx+CGFloat(j)*t+0.1*t,yy-t*0.20,t*0.60,t*0.40,Color(white:0.25),t*0.06)}}
      else {rect(xx+ww*0.30,yy-t*0.24,ww*0.40,t*0.44,Color(red:0.22,green:0.33,blue:0.36),t*0.06);rect(xx+ww*0.32,yy-t*0.21,ww*0.36,t*0.08,.white.opacity(0.28),2)}
      rect(xx+ww*0.93,yy-t*0.22,t*0.05,t*0.11,Color(white:0.97),2)
     }
    }
   }
   let xx=(CGFloat(game.x)+0.5)*t, yy=y(game.row), bob=motion && game.live ? CGFloat(sin(game.elapsed*10))*1.3 : 0
   bY2.hen(&c,CGPoint(x:xx,y:yy+bob),t*0.86,bY2.hens[hen])
  }
  .clipped()
 }
}

struct mK1:ButtonStyle {
 var yellow=false
 func makeBody(configuration:Configuration)->some View {configuration.label.font(.system(.headline,design:.rounded)).foregroundStyle(bY2.ink).padding(.vertical,14).padding(.horizontal,18).frame(minHeight:48).background(yellow ? bY2.sun : .white,in:RoundedRectangle(cornerRadius:18)).overlay(RoundedRectangle(cornerRadius:18).stroke(bY2.ink.opacity(0.08),lineWidth:1)).scaleEffect(configuration.isPressed ? 0.97 : 1).opacity(configuration.isPressed ? 0.8 : 1)}
}
