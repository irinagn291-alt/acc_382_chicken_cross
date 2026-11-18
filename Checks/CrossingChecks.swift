import XCTest
#if CC_UI_CHECKS
final class wT4:XCTestCase {
 @MainActor func shot(_ name:String) {let a=XCTAttachment(screenshot:XCUIApplication().screenshot());a.name=name;a.lifetime = .keepAlways;add(a)}
 @MainActor func testJourney() {
  let app=XCUIApplication();app.launchArguments=["-AppleLanguages","(en)","-AppleLocale","en_US"];app.launch()
  XCTAssertTrue(app.buttons["startRun"].waitForExistence(timeout:12));shot("01-ready")
  app.buttons["startRun"].tap();app.buttons["forward"].tap();shot("02-running");app.buttons["pause"].tap()
  XCTAssertTrue(app.buttons["resume"].exists);shot("02-paused")
  app.buttons["Finish this run"].tap();XCTAssertTrue(app.buttons["startRun"].exists);shot("03-result")
  app.tabBars.buttons["Flock"].tap();XCTAssertTrue(app.buttons["hen0"].waitForExistence(timeout:4));XCTAssertFalse(app.buttons["hen1"].isEnabled);shot("04-flock")
  app.tabBars.buttons["Daily"].tap();XCTAssertTrue(app.buttons["startDaily"].waitForExistence(timeout:4));shot("05-daily")
  app.buttons["startDaily"].tap();XCTAssertTrue(app.buttons["pause"].exists);app.buttons["forward"].tap();app.buttons["pause"].tap();app.buttons["Finish this run"].tap()
  app.tabBars.buttons["Records"].tap();XCTAssertTrue(app.staticTexts["This week’s best runs"].waitForExistence(timeout:5));shot("06-records")
  app.buttons["settings"].tap();XCTAssertTrue(app.staticTexts["How to cross"].waitForExistence(timeout:4));shot("07-rules");app.buttons["Done"].tap()
  app.terminate();app.launch();app.tabBars.buttons["Records"].tap();XCTAssertTrue(app.staticTexts["Free run"].firstMatch.waitForExistence(timeout:5));shot("08-persisted")
 }
 @MainActor func testLocalizedScreens() {
  for (lang,title,tab) in [("de","Deine kleine Schar","Schar"),("fr","Votre petit poulailler","Poules"),("pt-BR","Seu pequeno bando","Bando")] {
   let app=XCUIApplication();app.launchArguments=["-AppleLanguages","(\(lang))","-AppleLocale",lang];app.launch();app.tabBars.buttons[tab].tap();XCTAssertTrue(app.staticTexts[title].waitForExistence(timeout:8));shot("locale-\(lang)");app.terminate()
  }
 }
 @MainActor func testReminderDenial() {
  let app=XCUIApplication();app.launchArguments=["-AppleLanguages","(en)","-AppleLocale","en_US"];app.launch();app.buttons["settings"].tap()
  let toggle=app.switches["Remind me each day"]
  for _ in 0..<6 {if toggle.exists && toggle.isHittable {break};app.swipeUp()}
  XCTAssertTrue(toggle.exists);toggle.tap()
  let alert=XCUIApplication(bundleIdentifier:"com.apple.springboard").alerts.firstMatch
  XCTAssertTrue(alert.waitForExistence(timeout:6))
  let deny=alert.buttons.matching(NSPredicate(format:"label == %@ OR label == %@", "Don’t Allow", "Don't Allow")).firstMatch
  XCTAssertTrue(deny.exists);deny.tap()
  XCTAssertTrue(app.staticTexts["Reminders are disabled in system settings. All game features still work."].waitForExistence(timeout:5));shot("09-notifications-denied")
  app.buttons["Done"].tap();app.tabBars.buttons["Play"].tap();app.buttons["startRun"].tap();XCTAssertTrue(app.buttons["pause"].exists);app.buttons["pause"].tap()
 }
}
#else
#if !CC_CORE_HOST
import SwiftUI
import WidgetKit
#endif
@testable import SunnyPlume
final class yN8:XCTestCase {
 func testSeedAndLanes() {
  let a=aM5(seed:100),b=aM5(seed:100),c=aM5(seed:101)
  XCTAssertEqual((0..<90).map{a.dice($0)},(0..<90).map{b.dice($0)});XCTAssertNotEqual(a.dice(7),c.dice(7))
  XCTAssertEqual(a.lane(4),.road);XCTAssertEqual(a.lane(8),.river);XCTAssertEqual(a.lane(12),.rail)
  for r in 0..<150 {for t in [0.0,1.0,8.5,30.0] {XCTAssertEqual(a.traffic(r,t),b.traffic(r,t))}}
 }
 func testCoinAndBoundaries() {
  var a=aM5(seed:1);a.live=true;XCTAssertTrue(a.hop(0,1));XCTAssertEqual(a.coins,1);XCTAssertTrue(a.hop(0,-1));XCTAssertTrue(a.hop(0,1));XCTAssertEqual(a.coins,1)
  a.row=0;a.x=0;XCTAssertFalse(a.hop(-1,0));XCTAssertFalse(a.hop(0,-1));XCTAssertEqual(a.x,0)
  a.far=15;a.row=10;XCTAssertFalse(a.hop(0,-1))
 }
 func testCarsTrainsWater() {
  var a=aM5(seed:14);a.live=true;a.row=4;a.x=a.traffic(4).first{$0.x>=0 && $0.x<7}!.x+0.4;a.validate();XCTAssertFalse(a.live);XCTAssertEqual(a.reason,"traffic")
  a=aM5(seed:14);a.live=true;a.row=8;a.x=8
  while a.support() != nil {a.x -= 0.3};a.validate();XCTAssertFalse(a.live);XCTAssertEqual(a.reason,"water")
  a=aM5(seed:14);a.row=8;a.live=true
  let log=a.traffic(8).first{$0.x>0 && $0.x<7}!
  a.x=log.x+1;let old=a.x;a.tick(0.03);XCTAssertTrue(a.live);XCTAssertEqual(a.x,old+log.pace*0.03,accuracy:0.00001)
  a=aM5(seed:14);a.row=12;a.live=true
  for i in 0..<400 {a.elapsed=Double(i)*0.03;if let tr=a.traffic(12).first,tr.x>=0 && tr.x<7 {a.x=tr.x+0.3;XCTAssertTrue(a.warning(12));a.validate();break}}
  XCTAssertFalse(a.live);XCTAssertEqual(a.reason,"train")
 }
 func testTreeBlocksAndWrap() {
  var a=aM5(seed:2);a.live=true
  var found=false
  for r in 4..<100 {for c in 1..<8 where a.block(r,c) {a.row=r;a.far=r;a.x=Double(c-1);XCTAssertFalse(a.hop(1,0));found=true;break};if found {break}}
  XCTAssertTrue(found);XCTAssertEqual(a.wrap(-1,10),9);XCTAssertEqual(a.wrap(20,10),0)
 }
 func testPurchaseAndStorage() {
  var p=pS6();XCTAssertFalse(p.buy(2));XCTAssertEqual(p.owned,["ivory"])
  p.purse=100;XCTAssertTrue(p.buy(2));XCTAssertEqual(p.purse,40);XCTAssertEqual(p.picked,"rose");XCTAssertTrue(p.buy(2));XCTAssertEqual(p.purse,40);XCTAssertFalse(p.buy(-1));XCTAssertFalse(p.buy(6))
  let u=UserDefaults(suiteName:"plume.tests.\(UUID())")!;p.write(u);let read=pS6.read(u);XCTAssertEqual(read.purse,40);XCTAssertEqual(read.owned,p.owned)
  u.set(Data("broken".utf8),forKey:"plume.record.1");XCTAssertEqual(pS6.read(u).purse,0)
 }
 func testDailyRollover() {
  let today=Date(),tomorrow=vP9.n(today).addingTimeInterval(1)
  var p=pS6();p.step(30,daily:true,date:today);p.coin(today);p.finish(30,coins:1,daily:true,date:today)
  p.touch(tomorrow);XCTAssertEqual(p.days[vP9.z(tomorrow)]!,nD4());XCTAssertEqual(p.days[vP9.z(today)]!.dailyBest,30);XCTAssertEqual(p.best,30)
  XCTAssertNotEqual(vP9.h(vP9.z(today)),vP9.h(vP9.z(tomorrow)));XCTAssertTrue((35...65).contains(vP9.g(vP9.z())))
 }
 func testHistoryRetention() {
  var p=pS6();for i in 0..<180 {p.finish(i,coins:0,daily:false)};XCTAssertEqual(p.runs.count,150);XCTAssertEqual(p.best,179);XCTAssertEqual(p.day.runs,180)
 }
 func testWeeklyChampionsSurvive() {
  var p=pS6();p.finish(999,coins:0,daily:false);for _ in 0..<200 {p.finish(1,coins:0,daily:false)}
  XCTAssertEqual(p.week.first?.steps,999);XCTAssertLessThanOrEqual(p.runs.count,170)
 }
 #if !CC_CORE_HOST
 @MainActor func testWidgetFamiliesRender() {
  for (family,size) in [(WidgetFamily.systemSmall,CGSize(width:170,height:170)),(.systemMedium,CGSize(width:360,height:170)),(.systemLarge,CGSize(width:360,height:380)),(.accessoryRectangular,CGSize(width:170,height:80)),(.accessoryCircular,CGSize(width:80,height:80)),(.accessoryInline,CGSize(width:300,height:30))] {
   let v=qW9(entry:tD6(date:Date(),state:pS6()),forced:family).frame(width:size.width,height:size.height)
   let renderer=ImageRenderer(content:v);renderer.scale=2
   XCTAssertNotNil(renderer.uiImage)
   if let image=renderer.uiImage {let a=XCTAttachment(image:image);a.name="widget-\(family)";a.lifetime = .keepAlways;add(a)}
  }
 }
 #endif
}
#endif
