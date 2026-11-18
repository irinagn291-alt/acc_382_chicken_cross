import WidgetKit
import SwiftUI
#if CC_WIDGET_CHECKS
@testable import SunnyPlume
#endif

struct tD6:TimelineEntry {var date:Date;var state:pS6}
struct lV1:TimelineProvider {
 func placeholder(in context:Context)->tD6 {tD6(date:Date(),state:pS6())}
 func getSnapshot(in context:Context,completion:@escaping(tD6)->Void){completion(tD6(date:Date(),state:pS6.read()))}
 func getTimeline(in context:Context,completion:@escaping(Timeline<tD6>)->Void){
  let now=Date(),p=pS6.read();var entries=[tD6(date:now,state:p)]
  for n in 0..<7 {if let d=Calendar.current.date(byAdding:.day,value:n,to:vP9.n(now)){entries.append(tD6(date:d,state:p))}}
  completion(Timeline(entries:entries,policy:.after(vP9.n(now))))
 }
}
struct qW9:View {
 @Environment(\.widgetFamily) var fromSystem
 var entry:tD6
 var forced:WidgetFamily?=nil
 var family:WidgetFamily {forced ?? fromSystem}
 var day:nD4 {entry.state.days[vP9.z(entry.date)] ?? nD4()}
 var goal:Int {vP9.g(vP9.z(entry.date))}
 var ranks:[eR2] {entry.state.runs.filter{$0.date >= Calendar.current.dateInterval(of:.weekOfYear,for:entry.date)!.start}.sorted{$0.steps > $1.steps}}
 var body:some View {
  Group {
   switch family {
   case .accessoryInline: Text(qL("daily")+": "+qL(vP9.f[vP9.p(vP9.z(entry.date))]))
   case .accessoryCircular: Gauge(value:Double(min(day.dailyBest,goal)),in:0...Double(goal)){Image(systemName:"sun.max.fill")} currentValueLabel:{Text("\(day.dailyBest)")}.gaugeStyle(.accessoryCircular)
   case .accessoryRectangular: VStack(alignment:.leading,spacing:4){Label(qL("dailyAdventure"),systemImage:"sun.max.fill").font(.headline);HStack{Text(qL("endsIn"));Text(vP9.n(entry.date),style:.timer).monospacedDigit()}.font(.caption);ProgressView(value:Double(min(day.dailyBest,goal)),total:Double(goal))}
   case .systemSmall: VStack(alignment:.leading,spacing:4){Text(qL("todayBest")).font(.system(.caption,design:.rounded,weight:.bold));HStack(alignment:.center){Text("\(day.best)").font(.system(size:50,weight:.heavy,design:.rounded)).minimumScaleFactor(0.6);Spacer();fH8(index:hK3.ids.firstIndex(of:entry.state.picked) ?? 0).frame(width:52,height:63)};Text(qL("steps")).font(.caption);Spacer(minLength:0);Label("Chicken Cross",systemImage:"arrow.up.right").font(.system(size:10,weight:.bold,design:.rounded)).opacity(0.7)}
   case .systemMedium: medium
   default: VStack(alignment:.leading,spacing:13){medium;Divider();HStack{VStack(alignment:.leading,spacing:3){Text(qL("locations")).font(.caption.bold());Text(qL(vP9.f[vP9.w(entry.date)])).font(.system(.title3,design:.rounded,weight:.heavy))};Spacer();Image(systemName:["leaf.fill","tree.fill","sun.haze.fill","snowflake"][vP9.w(entry.date)]).font(.title)};HStack(spacing:3){ForEach(0..<6,id:\.self){i in fH8(index:i).frame(maxWidth:.infinity).frame(height:40).opacity(entry.state.owned.contains(hK3.ids[i]) ? 1 : 0.20)}};HStack{Text(qF("ownedCount",entry.state.owned.count));Spacer();Text(qL("weekRecords"))}.font(.system(size:10,weight:.bold,design:.rounded));HStack{ForEach(Array(ranks.prefix(3).enumerated()),id:\.element.id){i,r in Text("\(i+1).  \(r.steps)").font(.system(.subheadline,design:.rounded,weight:.bold));Spacer()};if ranks.isEmpty {Text(qL("noRecordsShort")).font(.caption)}}}
   }
  }
  .foregroundStyle(family == .accessoryInline || family == .accessoryRectangular || family == .accessoryCircular ? Color.primary : bY2.ink)
  .containerBackground(for:.widget){bY2.sun}
  .widgetURL(URL(string:family == .systemSmall ? "sunnyplume://play" : "sunnyplume://daily"))
 }
 var medium:some View {HStack(spacing:14){VStack(alignment:.leading,spacing:7){Label(qL("dailyAdventure"),systemImage:"sun.max.fill").font(.system(.caption,design:.rounded,weight:.bold));Text(qL(vP9.f[vP9.p(vP9.z(entry.date))])).font(.system(.title2,design:.rounded,weight:.heavy)).minimumScaleFactor(0.7).lineLimit(1);ProgressView(value:Double(min(day.dailyBest,goal)),total:Double(goal)).tint(bY2.ink);Text("\(min(day.dailyBest,goal)) / \(goal) "+qL("steps")).font(.caption.monospacedDigit())};Spacer(minLength:0);fH8(index:hK3.ids.firstIndex(of:entry.state.picked) ?? 0).frame(width:58,height:78)}}
}
#if !CC_WIDGET_CHECKS
@main
#endif
struct pW4:Widget {
 var body:some WidgetConfiguration {StaticConfiguration(kind:"SunnyPlume.Dawn",provider:lV1()){entry in qW9(entry:entry)}.configurationDisplayName(qL("Chicken Cross")).description(qL("widgetDescription")).supportedFamilies([.systemSmall,.systemMedium,.systemLarge,.accessoryRectangular,.accessoryCircular,.accessoryInline])}
}
