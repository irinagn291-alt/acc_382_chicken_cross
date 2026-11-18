import Foundation

let kV8 = "group.org.sunnyplume.trail441"
func qL(_ k: String) -> String { NSLocalizedString(k, comment: "") }
func qF(_ k: String, _ n: Int) -> String { String(format:qL(k), n) }

enum vP9 {
 static func z(_ d: Date = Date()) -> String {
  let f=DateFormatter(); f.calendar=Calendar(identifier:.gregorian); f.locale=Locale(identifier:"en_US_POSIX"); f.dateFormat="yyyy-MM-dd"; return f.string(from:d)
 }
 static func h(_ s: String) -> UInt64 { s.utf8.reduce(UInt64(1469598103934665603)) { ($0 ^ UInt64($1)) &* 1099511628211 } }
 static func n(_ d: Date = Date()) -> Date { Calendar.current.date(byAdding:.day,value:1,to:Calendar.current.startOfDay(for:d))! }
 static func p(_ s: String) -> Int { Int(h(s) % 4) }
 static func g(_ s: String) -> Int { 35 + Int(h(s) % 4)*10 }
 static let f=["meadow","orchard","harvest","frost"]
 static func w(_ d: Date = Date()) -> Int { let m=Calendar.current.component(.month,from:d); return m < 3 || m == 12 ? 3 : m < 6 ? 0 : m < 9 ? 1 : 2 }
}

struct nD4: Codable, Equatable { var best=0; var coins=0; var runs=0; var dailyBest=0 }
struct eR2: Codable, Identifiable, Equatable {
 var id=UUID(); var date=Date(); var steps:Int; var coins:Int; var daily:Bool
}
struct pS6: Codable {
 var schema=1; var purse=0; var owned=["ivory"]; var picked="ivory"; var terrain = -1
 var days:[String:nD4]=[:]; var runs:[eR2]=[]; var best=0; var quiet=false
 var reminders=false; var connected=false; var pending=0; var sent=0; var serial=0
 mutating func touch(_ date:Date = Date()) { let k=vP9.z(date); if days[k] == nil { days[k]=nD4() }; if days.count > 45 { for key in days.keys.sorted().dropLast(45) { days.removeValue(forKey:key) } } }
 mutating func step(_ steps:Int, daily:Bool, date:Date = Date()) {
  touch(date); let k=vP9.z(date); days[k]!.best=max(days[k]!.best,steps); if daily { days[k]!.dailyBest=max(days[k]!.dailyBest,steps) }; best=max(best,steps); pending=max(pending,steps)
 }
 mutating func coin(_ date:Date = Date()) { touch(date); purse += 1; days[vP9.z(date)]!.coins += 1 }
 mutating func finish(_ steps:Int, coins:Int, daily:Bool, date:Date = Date()) {
  step(steps,daily:daily,date:date); days[vP9.z(date)]!.runs += 1
  runs.insert(eR2(date:date,steps:steps,coins:coins,daily:daily),at:0)
  let cutoff=Calendar.current.date(byAdding:.day,value:-7,to:date)!
  let champions=runs.filter{$0.date >= cutoff}.sorted{$0.steps > $1.steps}.prefix(20)
  var seen=Set<UUID>();runs=(Array(runs.prefix(150))+champions).filter{seen.insert($0.id).inserted}.sorted{$0.date > $1.date}
 }
 mutating func buy(_ i: Int) -> Bool {
  guard hK3.ids.indices.contains(i) else { return false }; let k=hK3.ids[i]
  if owned.contains(k) { picked=k; return true }
  guard purse >= hK3.costs[i] else {return false}; purse -= hK3.costs[i]; owned.append(k); picked=k; return true
 }
 var day:nD4 { days[vP9.z()] ?? nD4() }
 var week:[eR2] { runs.filter { $0.date >= Calendar.current.dateInterval(of:.weekOfYear,for:Date())!.start }.sorted { $0.steps > $1.steps } }
 static func read(_ u:UserDefaults? = UserDefaults(suiteName:kV8)) -> pS6 {
  guard let b=u?.data(forKey:"plume.record.1"), let p=try? JSONDecoder().decode(pS6.self,from:b), p.schema==1 else {return pS6()}; return p
 }
 func write(_ u:UserDefaults? = UserDefaults(suiteName:kV8)) { if let b=try? JSONEncoder().encode(self) { u?.set(b,forKey:"plume.record.1") } }
}
enum hK3 { static let ids=["ivory","sunny","rose","mint","midnight","ember"]; static let costs=[0,25,60,90,140,200] }

enum lT8: Int { case field,road,river,rail }
struct rW3: Equatable { var x:Double; var length:Double; var pace:Double }
struct aM5 {
 var seed:UInt64; var x=4.0; var row=0; var far=0; var elapsed=0.0; var coins=0; var live=false; var reason=""
 var taken:Set<String>=[]
 func dice(_ r:Int,_ a:UInt64=0) -> UInt64 { var z=seed &+ UInt64(max(0,r)) &* 0x9E3779B97F4A7C15 &+ a; z=(z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9; z=(z ^ (z >> 27)) &* 0x94D049BB133111EB; return z ^ (z >> 31) }
 func lane(_ r:Int) -> lT8 {
  if r < 4 {return .field}; switch r % 14 {case 4,5,6,11:return .road;case 8,9:return .river;case 12:return .rail;default:return .field}
 }
 func block(_ r:Int,_ c:Int) -> Bool { lane(r) == .field && r > 3 && dice(r,UInt64(c+20)) % 15 == 0 }
 func token(_ r:Int) -> Int? { guard r%3==1 else {return nil}; let c = r==1 ? 4 : Int(dice(r,3)%9); return block(r,c) ? nil : c }
 func traffic(_ r:Int,_ t:Double? = nil) -> [rW3] {
  let t=t ?? elapsed; let dir = dice(r,1)%2==0 ? 1.0 : -1.0
  let speed=(0.65+Double(dice(r,2)%6)*0.14+min(Double(r)*0.003,0.6))*dir
  let phase=Double(dice(r,4)%100)/13.0
  switch lane(r) {
  case .road: return (0..<4).map { i in rW3(x: wrap(Double(i)*4.1 + phase + t*speed,16.4)-3,length:1.25,pace:speed) }
  case .river: return (0..<4).map { i in rW3(x:wrap(Double(i)*4.5+phase+t*speed*0.65,18)-4,length:2.9,pace:speed*0.65) }
  case .rail:
   let z=wrap(t+phase,11); return z < 2.0 ? [rW3(x:-8+z*13,length:6.8,pace:13)] : []
  case .field: return []
  }
 }
 func warning(_ r:Int) -> Bool { let ph=Double(dice(r,4)%100)/13; let z=wrap(elapsed+ph,11); return z > 8.7 || z < 2 }
 func wrap(_ v:Double,_ n:Double) -> Double { let r=v.truncatingRemainder(dividingBy:n); return r<0 ? r+n : r }
 func support() -> rW3? { traffic(row).first { x >= $0.x-0.34 && x <= $0.x+$0.length-0.66 } }
 mutating func validate() {
  if x < -0.35 || x > 8.35 { lose("water"); return }
  switch lane(row) {
  case .road,.rail: if traffic(row).contains(where:{ x > $0.x-0.27 && x < $0.x+$0.length+0.27 }) {lose(lane(row) == .rail ? "train" : "traffic")}
  case .river: if support()==nil {lose("water")}
  case .field:break
  }
 }
 mutating func lose(_ s:String) {live=false;reason=s}
 mutating func hop(_ dx:Int,_ dy:Int) -> Bool {
  guard live else {return false}; let nx=x+Double(dx), nr=row+dy
  guard nx >= 0, nx <= 8,nr>=max(0,far-5),!block(nr,Int(nx.rounded())) else {return false}
  x=nx;row=nr;far=max(far,row); validate(); collect(); return true
 }
 mutating func collect() { if live, let c=token(row), abs(x-Double(c)) < 0.55 { let k="\(row):\(c)"; if taken.insert(k).inserted { coins += 1 } } }
 mutating func tick(_ dt:Double) {
  guard live else{return}; let d=max(0,min(dt,0.05)); let raft=support(); elapsed += d
  if lane(row) == .river, let raft {x += raft.pace*d}; validate();collect()
 }
}
