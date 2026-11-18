import SwiftUI
import Combine

@main struct rJ6:App {
 @StateObject private var q=cQ7()
 var body:some Scene {WindowGroup {dF2().environmentObject(q).preferredColorScheme(.light)}}
}

struct dF2:View {
 @EnvironmentObject var q:cQ7
 @Environment(\.scenePhase) private var phase
 @Environment(\.accessibilityReduceMotion) private var reduce
 @State var tab=0;@State var settings=false
 private let clock=Timer.publish(every:1/30,on:.main,in:.common).autoconnect()
 var body:some View {
  TabView(selection:$tab) {
   game.tabItem{Label(qL("play"),systemImage:"arrow.up.right")}.tag(0)
   flock.tabItem{Label(qL("flock"),systemImage:"bird.fill")}.tag(1)
   tasks.tabItem{Label(qL("daily"),systemImage:"sun.max.fill")}.tag(2)
   records.tabItem{Label(qL("records"),systemImage:"trophy.fill")}.tag(3)
  }.tint(bY2.ink).onReceive(clock){_ in q.tick()}
  .onChange(of:tab){_,t in if t != 0 {q.pause()}}
  .onChange(of:phase){_,p in if p != .active {q.pause()} else {q.refresh();q.send()}}
  .sheet(isPresented:$settings){pZ8().environmentObject(q)}
  .onOpenURL {url in if url.host=="daily" {tab=2} else if url.host=="flock" {tab=1} else {tab=0}}
 }
 func header(_ title:String,_ sub:String)->some View {
  HStack(alignment:.center){VStack(alignment:.leading,spacing:4){Text(qL(sub)).font(.system(.caption,design:.rounded,weight:.bold)).tracking(1.5).foregroundStyle(.secondary);Text(qL(title)).font(.system(size:30,weight:.heavy,design:.rounded)).minimumScaleFactor(0.7).lineLimit(1)};Spacer();Button {q.pause();settings=true} label:{Image(systemName:"slider.horizontal.3").font(.title3).frame(width:46,height:46).background(.white,in:Circle())}.accessibilityLabel(qL("settings")).accessibilityIdentifier("settings")}.padding(.horizontal,22).padding(.top,14)
 }
 func pill(_ title:String,_ val:String,_ icon:String)->some View {HStack(spacing:7){Image(systemName:icon).foregroundStyle(icon=="circle.fill" ? Color.orange : bY2.ink);VStack(alignment:.leading,spacing:1){Text(qL(title)).font(.system(size:10,weight:.bold,design:.rounded)).foregroundStyle(.secondary);Text(val).font(.system(.title3,design:.rounded,weight:.heavy)).monospacedDigit()}}.frame(maxWidth:.infinity,alignment:.leading).padding(12).background(.white,in:RoundedRectangle(cornerRadius:17))}
 var game:some View {
  VStack(spacing:12) {
   header("Chicken Cross","offlineArcade")
   HStack(spacing:8){pill("steps","\(q.a.far)","arrow.up");pill("best","\(q.b.best)","flag.fill");pill("coins","\(q.b.purse)","circle.fill")}.padding(.horizontal,20)
   GeometryReader {g in
    if g.size.width > 700 && g.size.height < 500 {HStack(spacing:20){board;pad.frame(width:210)}} else {VStack(spacing:10){board;pad}}
   }.padding(.horizontal,20)
  }.padding(.bottom,10).frame(maxWidth:960).frame(maxWidth:.infinity).background(bY2.paper).foregroundStyle(bY2.ink)
 }
 var board:some View {
  sA4(game:q.a,terrain:q.world,hen:hK3.ids.firstIndex(of:q.b.picked) ?? 0,motion:!reduce)
  .contentShape(Rectangle())
  .gesture(DragGesture(minimumDistance:22).onEnded {v in if abs(v.translation.width)>abs(v.translation.height) {q.hop(v.translation.width>0 ? 1 : -1,0)} else {q.hop(0,v.translation.height<0 ? 1 : -1)}})
  .onTapGesture {q.hop(0,1)}
  .overlay(alignment:.top){HStack{Label(qL(vP9.f[q.world]),systemImage:q.daily ? "sun.max.fill" : "leaf.fill").font(.system(.caption,design:.rounded,weight:.bold)).padding(10).background(.white.opacity(0.94),in:Capsule());Spacer();if q.mode=="running" {Button {q.pause()} label:{Image(systemName:"pause.fill").frame(width:40,height:40).background(.white,in:Circle())}.accessibilityLabel(qL("pause")).accessibilityIdentifier("pause")}}.padding(14)}
  .overlay {GeometryReader {g in if q.mode != "running" {if g.size.height<295 {compactIntro} else {intro}}}}
  .clipShape(RoundedRectangle(cornerRadius:26)).overlay(RoundedRectangle(cornerRadius:26).stroke(bY2.ink.opacity(0.08),lineWidth:1))
  .accessibilityElement(children:.contain).accessibilityLabel(qL("gameField"))
  .accessibilityValue(qF("stepsCount",q.a.far)+", "+qL(["laneField","laneRoad","laneRiver","laneRail"][q.a.lane(q.a.row).rawValue]))
  .accessibilityHint(qL("gestureHelp"))
  .accessibilityAction(named:Text(qL("forward"))){q.hop(0,1)}
  .accessibilityAction(named:Text(qL("left"))){q.hop(-1,0)}
  .accessibilityAction(named:Text(qL("right"))){q.hop(1,0)}
 }
 var compactIntro:some View {
  ZStack {bY2.ink.opacity(0.2);HStack(spacing:18){VStack(alignment:.leading,spacing:6){Text(qL(q.mode=="paused" ? "paused" : q.mode=="ended" ? "runOver" : "Chicken Cross")).font(.system(.title3,design:.rounded,weight:.heavy));Text(q.mode=="ended" ? qF("stepsCount",q.a.far) : qL("gestureHelp")).font(.caption)};Spacer(minLength:0);if q.mode=="paused" {Button(qL("resume")){q.resume()}.buttonStyle(mK1(yellow:true)).accessibilityIdentifier("resume");Button(qL("endRun")){q.end("finished")}.font(.caption)} else {Button(qL(q.mode=="ready" ? "startRun" : "again")){q.start(q.mode=="ended" ? q.daily : false)}.buttonStyle(mK1(yellow:true)).accessibilityIdentifier("startRun")}}.padding(18).background(bY2.paper,in:RoundedRectangle(cornerRadius:22)).padding(12)}
 }
 var intro:some View {
  ZStack {
   bY2.ink.opacity(q.mode=="ready" ? 0.06 : 0.30)
   VStack(spacing:12) {
    if q.mode=="ready" {Image(systemName:"sun.max.fill").font(.title).foregroundStyle(.orange);Text(qL("readyTitle")).font(.system(size:32,weight:.heavy,design:.rounded)).multilineTextAlignment(.center);Text(qL("readyHelp")).font(.subheadline).multilineTextAlignment(.center).foregroundStyle(.secondary)}
    else if q.mode=="paused" {Image(systemName:"pause.circle.fill").font(.largeTitle);Text(qL("paused")).font(.system(.title,design:.rounded,weight:.heavy));Text(qL("pauseHelp")).font(.subheadline).foregroundStyle(.secondary)}
    else {Text(qL("runOver")).font(.system(.title2,design:.rounded,weight:.heavy));Text("\(q.a.far)").font(.system(size:48,weight:.heavy,design:.rounded)).monospacedDigit();Text(qF("stepsCount",q.a.far)+" · "+qF("coinsCount",q.a.coins)).font(.caption).foregroundStyle(.secondary);Text(qL(q.a.reason)).font(.subheadline).multilineTextAlignment(.center)}
    if q.mode=="paused" {
     Button(qL("resume")){q.resume()}.buttonStyle(mK1(yellow:true)).accessibilityIdentifier("resume")
     Button(qL("endRun")){q.end("finished")}.font(.subheadline).padding(4)
    } else {
     Button {q.start(q.mode=="ended" ? q.daily : false)} label:{Label(qL(q.mode=="ready" ? "startRun" : "again"),systemImage:"arrow.up.right")}.buttonStyle(mK1(yellow:true)).accessibilityIdentifier("startRun")
     if q.mode=="ready" {Button(qL("tryDaily")){q.start(true)}.font(.system(.subheadline,design:.rounded,weight:.bold)).padding(.vertical,3)}
    }
   }.padding(22).frame(maxWidth:310).background(bY2.paper,in:RoundedRectangle(cornerRadius:26)).shadow(color:.black.opacity(0.13),radius:16,y:8).padding(18)
  }
 }
 var pad:some View {
  VStack(spacing:7){Text(qL("gestureHelp")).font(.system(size:11,weight:.medium,design:.rounded)).foregroundStyle(.secondary).multilineTextAlignment(.center)
   HStack(spacing:10){direction("arrow.left","left",-1,0);direction("arrow.down","back",0,-1);direction("arrow.up","forward",0,1);direction("arrow.right","right",1,0)}
  }.padding(.bottom,4)
 }
 func direction(_ symbol:String,_ key:String,_ dx:Int,_ dy:Int)->some View {
  Button {q.hop(dx,dy)} label:{Image(systemName:symbol).font(.system(size:22,weight:.bold)).frame(maxWidth:.infinity).frame(height:24)}.buttonStyle(mK1(yellow:key=="forward")).disabled(q.mode != "running").accessibilityLabel(qL(key)).accessibilityIdentifier(key)
 }
 var flock:some View {
  ScrollView {VStack(alignment:.leading,spacing:20){header("yourFlock","littlePersonalities")
   HStack{Label(qF("coinsCount",q.b.purse),systemImage:"circle.fill").font(.system(.title3,design:.rounded,weight:.heavy));Spacer();Text(qF("ownedCount",q.b.owned.count)).font(.subheadline).foregroundStyle(.secondary)}.padding(.horizontal,22)
   Text(qL("flockHelp")).font(.subheadline).foregroundStyle(.secondary).padding(.horizontal,22)
   LazyVGrid(columns:[GridItem(.adaptive(minimum:150),spacing:14)],spacing:14){ForEach(0..<6,id:\.self){i in
    let id=hK3.ids[i], owned=q.b.owned.contains(id), picked=q.b.picked==id
    VStack(alignment:.leading,spacing:10){fH8(index:i).frame(height:120).frame(maxWidth:.infinity).background(bY2.hens[i].opacity(0.24),in:RoundedRectangle(cornerRadius:18));Text(qL(id)).font(.system(.headline,design:.rounded));Button {q.buy(i)} label:{HStack{Text(qL(picked ? "selected" : owned ? "choose" : "collect"));Spacer();if !owned {Image(systemName:"circle.fill").foregroundStyle(.orange);Text("\(hK3.costs[i])")} else {Image(systemName:picked ? "checkmark.circle.fill" : "circle")}}.font(.system(.caption,design:.rounded,weight:.bold)).padding(12).background(picked ? bY2.sun : bY2.paper,in:RoundedRectangle(cornerRadius:12))}.accessibilityIdentifier("hen\(i)").accessibilityLabel(qL(id)+", "+qL(picked ? "selected" : owned ? "choose" : "collect")+(owned ? "" : ", \(hK3.costs[i]) "+qL("coins"))).disabled(!owned && q.b.purse<hK3.costs[i])
    }.padding(12).background(.white,in:RoundedRectangle(cornerRadius:23))
   }}.padding(.horizontal,20)
  }.padding(.bottom,28).frame(maxWidth:900).frame(maxWidth:.infinity)}.background(bY2.paper).foregroundStyle(bY2.ink)
 }
 func progress(_ title:String,_ symbol:String,_ value:Int,_ target:Int)->some View {
  HStack(spacing:14){Image(systemName:symbol).font(.title2).frame(width:42,height:50).foregroundStyle(value>=target ? Color.green : bY2.ink);VStack(alignment:.leading,spacing:8){HStack{Text(qL(title)).font(.system(.subheadline,design:.rounded,weight:.bold));Spacer();Text("\(min(value,target)) / \(target)").font(.caption).monospacedDigit()};ProgressView(value:Double(min(value,target)),total:Double(target)).tint(value>=target ? .green : bY2.sun)}}.padding(17).background(.white,in:RoundedRectangle(cornerRadius:21))
 }
 var tasks:some View {
  ScrollView {VStack(alignment:.leading,spacing:16){header("dailyAdventure","freshEveryMorning")
   VStack(alignment:.leading,spacing:12){HStack{Label(qL("todayLocation"),systemImage:"sun.max.fill").font(.caption.bold());Spacer();Text(vP9.n(),style:.timer).font(.caption.monospacedDigit())};Text(qL(vP9.f[vP9.p(vP9.z())])).font(.system(size:34,weight:.heavy,design:.rounded));Text(qL("dailyHelp")).font(.subheadline);Button {q.start(true);tab=0} label:{Label(qL("startDaily"),systemImage:"arrow.up.right")}.buttonStyle(mK1()).accessibilityIdentifier("startDaily")}.padding(22).frame(maxWidth:.infinity,alignment:.leading).background(bY2.sun,in:RoundedRectangle(cornerRadius:26))
   progress("missionDistance","flag.fill",q.b.day.dailyBest,vP9.g(vP9.z()))
   progress("missionCoins","circle.fill",q.b.day.coins,6)
   progress("missionRuns","arrow.triangle.2.circlepath",q.b.day.runs,3)
   Text(qL("locations")).font(.system(.title2,design:.rounded,weight:.heavy)).padding(.top,10)
   Text(qL("seasonsHelp")).font(.subheadline).foregroundStyle(.secondary)
   LazyVGrid(columns:[GridItem(.adaptive(minimum:145))]){ForEach(0..<4,id:\.self){i in Button {q.b.terrain=i;q.flush();q.start(false);tab=0} label:{VStack(alignment:.leading,spacing:10){Image(systemName:["leaf.fill","tree.fill","sun.haze.fill","snowflake"][i]).font(.title).frame(height:48);Text(qL(vP9.f[i])).font(.system(.headline,design:.rounded));Text(qL("explore")).font(.caption)}.frame(maxWidth:.infinity,alignment:.leading).padding(18).background(bY2.grass[i].opacity(0.30),in:RoundedRectangle(cornerRadius:20))}.accessibilityIdentifier("location\(i)")}}
  }.padding(.horizontal,20).padding(.bottom,28).frame(maxWidth:850).frame(maxWidth:.infinity)}.background(bY2.paper).foregroundStyle(bY2.ink)
 }
 var records:some View {
  ScrollView {VStack(alignment:.leading,spacing:18){header("yourRecords","everyHopCounts")
   HStack(spacing:10){pill("allTime","\(q.b.best)","trophy.fill");pill("today","\(q.b.day.best)","sun.max.fill")}
   Rank1bbe7(points:["↑":q.b.best,"☀︎":q.b.day.dailyBest])
   Text(qL("weekRecords")).font(.system(.title2,design:.rounded,weight:.heavy))
   if q.b.week.isEmpty {VStack(spacing:12){Image(systemName:"flag.checkered").font(.largeTitle);Text(qL("noRecords")).multilineTextAlignment(.center)}.frame(maxWidth:.infinity).padding(30).background(.white,in:RoundedRectangle(cornerRadius:22))}
   ForEach(Array(q.b.week.prefix(12).enumerated()),id:\.element.id){idx,r in HStack{Text(String(format:"%02d",idx+1)).font(.system(.title2,design:.rounded,weight:.heavy)).foregroundStyle(.secondary).frame(width:38);VStack(alignment:.leading,spacing:4){Text(qL(r.daily ? "dailyRun" : "freeRun")).font(.headline);Text(r.date,style:.date).font(.caption).foregroundStyle(.secondary)};Spacer();Text("\(r.steps)").font(.system(.title,design:.rounded,weight:.heavy));Image(systemName:"arrow.up").font(.caption)}.padding(17).background(.white,in:RoundedRectangle(cornerRadius:19))}
  }.padding(.horizontal,20).padding(.bottom,28).frame(maxWidth:850).frame(maxWidth:.infinity)}.background(bY2.paper).foregroundStyle(bY2.ink)
 }
}

struct wG3:View {
 let title:String;let action:()->Void
 @State private var show=false;@State private var answer="";@State private var wrong=false
 var body:some View {Button(title){answer="";wrong=false;show=true}.buttonStyle(mK1(yellow:true)).sheet(isPresented:$show){VStack(spacing:22){Image(systemName:"hand.raised.fill").font(.largeTitle);Text(qL("grownUps")).font(.title2.bold());Text(qL("gateHelp")).multilineTextAlignment(.center);Text("7 + 8 = ?").font(.largeTitle.monospacedDigit());TextField(qL("answer"),text:$answer).keyboardType(.numberPad).textFieldStyle(.roundedBorder).frame(width:150).accessibilityIdentifier("gateAnswer");if wrong {Text(qL("tryAgain")).foregroundStyle(.red)};Button(qL("continue")){if answer.trimmingCharacters(in:.whitespaces)=="15" {show=false;DispatchQueue.main.asyncAfter(deadline:.now()+0.4){action()}} else {wrong=true}}.buttonStyle(mK1(yellow:true));Button(qL("cancel")){show=false}}.padding(28).presentationDetents([.medium,.large])}}
}

struct pZ8:View {
 @EnvironmentObject var q:cQ7;@Environment(\.dismiss) var dismiss
 @State private var erase=false
 var body:some View {NavigationStack {Form {
  Section(qL("howTo")){Text(qL("rulesText"));Text(qL("riverHelp"));Text(qL("railHelp"))}
  Section(qL("comfort")){Toggle(qL("haptics"),isOn:Binding(get:{!q.b.quiet},set:{q.b.quiet = !$0;q.flush()}));Picker(qL("location"),selection:Binding(get:{q.b.terrain},set:{q.b.terrain=$0;q.flush()})){Text(qL("seasonal")).tag(-1);ForEach(0..<4,id:\.self){i in Text(qL(vP9.f[i])).tag(i)}}}
  Section(qL("reminders")){Text(qL("remindersHelp")).font(.subheadline);if q.permission=="denied" {Text(qL("notificationsDenied")).foregroundStyle(.secondary);wG3(title:qL("systemSettings")){if let u=URL(string:UIApplication.openSettingsURLString){UIApplication.shared.open(u)}}} else {Toggle(qL("dailyReminders"),isOn:Binding(get:{q.b.reminders},set:{if $0 {q.allow()} else {q.muteReminders()}}))}}
  Section(qL("privacy")){Text(qL("privacyText"));Text(qL("gcPrivacy"));if q.b.connected {Button(qL("disconnect")){q.b.connected=false;q.flush()}}}
  Section {Button(qL("erase"),role:.destructive){erase=true}.confirmationDialog(qL("eraseQuestion"),isPresented:$erase,titleVisibility:.visible){Button(qL("erase"),role:.destructive){q.reset()}}}
  Section {Text("Chicken Cross · 1.1.4 (441)").font(.caption);Text(qL("freeForever")).font(.caption)}
 }.navigationTitle(qL("settings")).toolbar{ToolbarItem(placement:.confirmationAction){Button(qL("done")){dismiss()}}}}}
}

import CryptoKit
private enum Seal1bbe7 {
 struct Slip:Codable {let ids:[String];let picks:[Int];let time:[Int]}
 struct Card:Codable,Identifiable {let id:String;var points:[String:Int];var day:String?;var slip:Slip?;var signed:Bool?}
 struct Packet:Codable {let publicKey:Data;let content:Data;let signature:Data}
 static let prefix="ChickenCross-2/"
 static func owner(_ pub:Data)->String {SHA256.hash(data:pub).map{String(format:"%02x",$0)}.joined()}
 static func pack(_ card:Card,key:Curve25519.Signing.PrivateKey)throws->String {
  let data=try JSONEncoder().encode(card)
  let authenticated=Data(prefix.utf8)+data
  let packet=Packet(publicKey:key.publicKey.rawRepresentation,content:data,signature:try key.signature(for:authenticated))
  return prefix+(try JSONEncoder().encode(packet)).base64EncodedString()
 }
 static func retaining(_ incoming:Card,in history:[Card])->[Card] {
  let normalized = incoming.id.lowercased()
  let others = history.filter { $0.id.lowercased() != normalized }
  let updated = others + [incoming]
  return Array(updated.filter { $0.signed == true }.suffix(80)) +
         Array(updated.filter { $0.signed != true }.suffix(40))
 }
 static func earlier(_ raw:String,allowed:Set<String>)->Card? {
  let older=String(prefix.dropLast(3))+"-1/"
  guard raw.hasPrefix(older),raw.utf8.count<=4000,let data=Data(base64Encoded:String(raw.dropFirst(older.count))),
    let item=try? JSONDecoder().decode(Card.self,from:data),UUID(uuidString:item.id) != nil,!item.points.isEmpty,
    item.points.keys.allSatisfy(allowed.contains),item.points.values.allSatisfy({(0...1000000000).contains($0)}) else{return nil}
  return Card(id:item.id,points:item.points,day:nil,slip:nil,signed:false)
 }
 static func unpack(_ raw:String)throws->Card {
  guard raw.hasPrefix(prefix),raw.utf8.count<=16384,let data=Data(base64Encoded:String(raw.dropFirst(prefix.count))) else{throw CocoaError(.fileReadCorruptFile)}
  let packet=try JSONDecoder().decode(Packet.self,from:data)
  let publicKey=try Curve25519.Signing.PublicKey(rawRepresentation:packet.publicKey)
  guard publicKey.isValidSignature(packet.signature,for:Data(prefix.utf8)+packet.content) else{throw CocoaError(.fileReadCorruptFile)}
  var item=try JSONDecoder().decode(Card.self,from:packet.content)
  guard item.id==owner(packet.publicKey) else{throw CocoaError(.fileReadCorruptFile)}
  item.signed=true;return item
 }
 
}
private struct Rank1bbe7:View {
 typealias Card=Seal1bbe7.Card
 let points:[String:Int]
 
 @AppStorage("org.sunnyplume.trail441.scorecard.signer.v2") private var identity=Data()
 @AppStorage("org.sunnyplume.trail441.scorecard.cards") private var saved=Data()
 @Environment(\.locale) private var locale
 @State private var entry=""
 @State private var invalid=false
  private var words:[String]{let all:[String:[String]]=["en":["Scorecards","Share my scorecard","Paste a scorecard","Add scorecard","You","Invalid scorecard"],"pt":["Placares","Compartilhar placar","Cole um placar","Adicionar placar","Você","Placar inválido"],"de":["Ergebniskarten","Ergebnis teilen","Ergebniskarte einfügen","Ergebnis hinzufügen","Du","Ungültige Ergebniskarte"],"fr":["Feuilles de score","Partager mon score","Coller un score","Ajouter le score","Vous","Score non valide"]];return all[locale.language.languageCode?.identifier ?? "en"] ?? all["en"]!}
 private var captions:[String] {let a:[String:[String]]=["en":["Signed scorecard", "Earlier cards · unverified", "Play a ten-question round to share its answers.", "Score recalculated from ten answers."],"de":["Signierte Ergebniskarte", "Frühere Karten · ungeprüft", "Spiele eine Runde mit zehn Fragen, um die Antworten zu teilen.", "Punktzahl aus zehn Antworten berechnet."],"pt":["Placar assinado", "Placares anteriores · sem verificação", "Jogue uma rodada de dez perguntas para compartilhar as respostas.", "Pontuação recalculada com dez respostas."],"fr":["Carte de score signée", "Anciennes cartes · non vérifiées", "Jouez une manche de dix questions pour partager vos réponses.", "Score recalculé à partir de dix réponses."]];return a[locale.language.languageCode?.identifier ?? "en"] ?? a["en"]!}
 private var cards:[Card]{(try? JSONDecoder().decode([Card].self,from:saved)) ?? []}
 private var day:String {vP9.z()}
 private var key:Curve25519.Signing.PrivateKey?{try? .init(rawRepresentation:identity)}
 private var mine:Card? {guard let key else{return nil};return Card(id:Seal1bbe7.owner(key.publicKey.rawRepresentation),points:points,day:day,slip:nil,signed:true)}
 private var shareText:String? {guard let key,let mine else{return nil};return try? Seal1bbe7.pack(mine,key:key)}
 private func accept(){
  let raw=entry.trimmingCharacters(in:.whitespacesAndNewlines)
  if let legacy=Seal1bbe7.earlier(raw,allowed:Set(points.keys)) {
   saved=(try? JSONEncoder().encode(Seal1bbe7.retaining(legacy,in:cards))) ?? saved;invalid=false;entry="";return
  }
  guard let item=try? Seal1bbe7.unpack(raw),item.id != mine?.id,item.id != key.map({Seal1bbe7.owner($0.publicKey.rawRepresentation)}),!item.points.isEmpty,item.points.keys.allSatisfy({points[$0] != nil}),item.points.values.allSatisfy({(0...1000000000).contains($0)})  else{invalid=true;return}
  var next=item
  if let old=cards.first(where:{$0.id==item.id && $0.signed==true}) {
   for (category, score) in old.points {
    if category == "☀︎", old.day != item.day {if old.day==day {next.day=day;next.points[category]=score};continue}
    next.points[category]=max(next.points[category] ?? 0,score)
   }
  }
  saved=(try? JSONEncoder().encode(Seal1bbe7.retaining(next,in:cards))) ?? saved;invalid=false;entry=""
 }
 var body:some View {VStack(alignment:.leading,spacing:12){
  Label(words[0],systemImage:"person.2").font(.headline)
  ForEach(points.keys.sorted(),id:\.self){category in
   Text(category).font(.caption.bold())
   let entries=([mine].compactMap{$0}+cards.filter{$0.signed==true}).filter{card in card.points[category] != nil && (category != "☀︎" || card.day==day)}
   ForEach(entries.sorted{let a=$0.points[category] ?? 0,b=$1.points[category] ?? 0;return a==b ? $0.id<$1.id:a>b}.prefix(10)){card in
    HStack{Text(card.id==mine?.id ? words[4]:String(card.id.prefix(8)));Spacer();Text(String(card.points[category] ?? 0)).monospacedDigit()}
   }
  }
  if let shareText {ShareLink(item:shareText){Label(words[1],systemImage:"square.and.arrow.up")};Text(captions[0]).font(.caption).foregroundStyle(.secondary)}
  
  if cards.contains(where:{$0.signed != true}){DisclosureGroup(captions[1]){ForEach(cards.filter{$0.signed != true}){card in Text(String(card.id.prefix(8))+" · "+card.points.keys.sorted().map{$0+" "+String(card.points[$0] ?? 0)}.joined(separator:"  "))}}}
  TextField(words[2],text:$entry).textFieldStyle(.roundedBorder).autocorrectionDisabled().textInputAutocapitalization(.never)
  Button(words[3]){accept()}.disabled(entry.isEmpty)
  if invalid{Text(words[5]).foregroundStyle(.secondary).font(.caption)}
 }.onAppear{if key==nil{identity=Curve25519.Signing.PrivateKey().rawRepresentation}}}
}
