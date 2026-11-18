import SwiftUI
import WidgetKit
import UserNotifications

@MainActor final class cQ7: ObservableObject {
 @Published var b=pS6.read()
 @Published var a=aM5(seed:44)
 @Published var mode="ready"
 @Published var daily=false
 @Published var note=""
 @Published var permission="checking"
 @Published var panel:UIViewController?
 var began=Date();private var turnover=vP9.n(); private var last=Date.distantPast; private var submitting=false
 var world:Int { daily ? vP9.p(vP9.z(began)) : (b.terrain < 0 ? vP9.w() : b.terrain) }
 init() { b.touch(); flush(); refresh(); if b.connected {login()} }
 func flush() { b.write(); WidgetCenter.shared.reloadTimelines(ofKind:"SunnyPlume.Dawn") }
 func refresh() {
  b.touch(); if (mode=="running" || mode=="paused") && vP9.z(began) != vP9.z() {end("dayEnded")};turnover=vP9.n();flush()
  Task { let s=await UNUserNotificationCenter.current().notificationSettings(); permission=s.authorizationStatus == .denied ? "denied" : (s.authorizationStatus == .authorized || s.authorizationStatus == .provisional ? "allowed" : "off"); if b.reminders && permission == "allowed" { await reminders() } }
 }
 func start(_ d:Bool) {
  if mode=="paused" || mode=="running" {end("finished")}
  b.serial += 1; daily=d; began=Date()
  a=aM5(seed:d ? vP9.h(vP9.z()) : vP9.h("\(Date().timeIntervalSince1970):\(b.serial)")); a.live=true
  mode="running"; last=Date.distantPast; flush()
 }
 func hop(_ x:Int,_ y:Int) {
  guard mode=="running",Date().timeIntervalSince(last)>0.115 else {return}; last=Date()
  let old=a.coins; let moved=a.hop(x,y)
  if moved && !b.quiet { UIImpactFeedbackGenerator(style:.light).impactOccurred(intensity:0.5) }
  accept(old)
 }
 func tick() {
  if Date() >= turnover {refresh()}
  guard mode=="running" else{return}; let old=a.coins; a.tick(0.0333333333); accept(old)
 }
 private func accept(_ coins:Int) {
  var changed=false
  if a.coins>coins {for _ in coins..<a.coins {b.coin(began)};changed=true}
  if a.far > (b.days[vP9.z(began)]?.best ?? 0) || (daily && a.far > (b.days[vP9.z(began)]?.dailyBest ?? 0)) { b.step(a.far,daily:daily,date:began); changed=true }
  if !a.live {end(a.reason)} else if changed {flush()}
 }
 func pause() {if mode=="running" {mode="paused"}}
 func resume() {if mode=="paused" {mode="running";last=Date()}}
 func end(_ reason:String) {
  guard mode=="running" || mode=="paused" else{return}; a.live=false;a.reason=reason;mode="ended"
  b.finish(a.far,coins:a.coins,daily:daily,date:began);flush();send()
  UIAccessibility.post(notification:.announcement,argument:qL(reason))
  if !b.quiet {UINotificationFeedbackGenerator().notificationOccurred(.warning)}
 }
 func buy(_ i:Int) {if b.buy(i) {flush()} else {note=qL("needCoins")}}
 func login() {}
 func send() {}
 func board() {}
 func allow() {
  Task { do {let ok=try await UNUserNotificationCenter.current().requestAuthorization(options:[.alert,.sound]); b.reminders=ok; permission=ok ? "allowed" : "denied";if ok {await reminders()};flush()} catch {note=qL("notificationError")} }
 }
 func reminders() async {
  let center=UNUserNotificationCenter.current();center.removePendingNotificationRequests(withIdentifiers:["dawn.place","dawn.tasks"])
  guard b.reminders else{return}
  for (key,hour) in [("place",9),("tasks",18)] {
   let c=UNMutableNotificationContent();c.title=qL("Chicken Cross");c.body=qL(key=="place" ? "notifyPlace" : "notifyTasks");c.sound = .default
   var d=DateComponents(); d.hour=hour;d.minute=0
   try? await center.add(UNNotificationRequest(identifier:"dawn.\(key)",content:c,trigger:UNCalendarNotificationTrigger(dateMatching:d,repeats:true)))
  }
 }
 func muteReminders() {b.reminders=false;UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:["dawn.place","dawn.tasks"]);flush()}
 func reset() {note="";b=pS6();a=aM5(seed:44);mode="ready";daily=false;muteReminders();flush()}
}


