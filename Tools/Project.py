from pathlib import Path
import json, uuid, plistlib
p=Path(__file__).resolve().parents[1]
def plist(path,data): (p/path).write_bytes(plistlib.dumps(data,sort_keys=False))
common={'CFBundleDevelopmentRegion':'en','CFBundleExecutable':'$(EXECUTABLE_NAME)','CFBundleIdentifier':'$(PRODUCT_BUNDLE_IDENTIFIER)','CFBundleInfoDictionaryVersion':'6.0','CFBundleName':'$(PRODUCT_NAME)','CFBundleShortVersionString':'$(MARKETING_VERSION)','CFBundleVersion':'$(CURRENT_PROJECT_VERSION)'}
plist('Resources/PlumeInfo.plist',{**common,'CFBundleDisplayName':'Chicken Cross','CFBundlePackageType':'APPL','LSRequiresIPhoneOS':True,'UIApplicationSupportsIndirectInputEvents':True,'UILaunchScreen':{'UIColorName':'LaunchTint'},'UISupportedInterfaceOrientations':['UIInterfaceOrientationPortrait','UIInterfaceOrientationLandscapeLeft','UIInterfaceOrientationLandscapeRight'],'UISupportedInterfaceOrientations~ipad':['UIInterfaceOrientationPortrait','UIInterfaceOrientationPortraitUpsideDown','UIInterfaceOrientationLandscapeLeft','UIInterfaceOrientationLandscapeRight'],'UIBackgroundModes':['remote-notification'],'NSSupportsLiveActivities':False,'CFBundleURLTypes':[{'CFBundleURLName':'org.sunnyplume.trail441.route','CFBundleURLSchemes':['sunnyplume']}],'ITSAppUsesNonExemptEncryption':False})
plist('Widget/DawnInfo.plist',{**common,'CFBundleDisplayName':'Chicken Cross','CFBundlePackageType':'XPC!','NSExtension':{'NSExtensionPointIdentifier':'com.apple.widgetkit-extension'}})
plist('Resources/PlumeRights.entitlements',{'com.apple.security.application-groups':['group.org.sunnyplume.trail441'],'com.apple.developer.game-center':True,'aps-environment':'development'})
plist('Widget/DawnRights.entitlements',{'com.apple.security.application-groups':['group.org.sunnyplume.trail441']})
a=p/'Resources/PlumeAssets.xcassets'
(a/'Contents.json').write_text(json.dumps({'info':{'author':'xcode','version':1}}))
(a/'FeatherMark.appiconset/Contents.json').write_text(json.dumps({'images':[{'filename':'FeatherMark.png','idiom':'universal','platform':'ios','size':'1024x1024'}],'info':{'author':'xcode','version':1}}))
(a/'LaunchTint.colorset').mkdir(exist_ok=True)
(a/'LaunchTint.colorset/Contents.json').write_text(json.dumps({'colors':[{'idiom':'universal','color':{'color-space':'srgb','components':{'red':'0.980','green':'0.975','blue':'0.930','alpha':'1.000'}}}],'info':{'author':'xcode','version':1}}))
obj={}
def add(isa,**kw):
 k=uuid.uuid4().hex[:24].upper();obj[k]={'isa':isa,**kw};return k
refs={}
files={'Source/PlumeLedger.swift':'sourcecode.swift','Source/AsphaltLoop.swift':'sourcecode.swift','Source/CrossingCanvas.swift':'sourcecode.swift','Source/SunnyShell.swift':'sourcecode.swift','Widget/DawnTiles.swift':'sourcecode.swift','Checks/CrossingChecks.swift':'sourcecode.swift','Resources/Localizable.xcstrings':'text.json.xcstrings','Resources/InfoPlist.xcstrings':'text.json.xcstrings','Resources/PrivacyInfo.xcprivacy':'text.xml','Resources/PlumeAssets.xcassets':'folder.assetcatalog','Resources/PlumeInfo.plist':'text.plist.xml','Resources/PlumeRights.entitlements':'text.plist.entitlements','Widget/DawnInfo.plist':'text.plist.xml','Widget/DawnRights.entitlements':'text.plist.entitlements'}
for path,kind in files.items(): refs[path]=add('PBXFileReference',lastKnownFileType=kind,path=path,sourceTree='<group>')
products=add('PBXGroup',children=[],name='Products',sourceTree='<group>')
group=add('PBXGroup',children=list(refs.values())+[products],sourceTree='<group>')
configs=['DawnDebug','GoldenRelease']
def config_list(settings,kind='target'):
 cs=[]
 for config in configs:
  s=settings.copy()
  if kind=='project': s.update({'SWIFT_OPTIMIZATION_LEVEL':'-Onone' if config==configs[0] else '-O','DEBUG_INFORMATION_FORMAT':'dwarf' if config==configs[0] else 'dwarf-with-dsym','ENABLE_TESTABILITY':'YES' if config==configs[0] else 'NO','SWIFT_ACTIVE_COMPILATION_CONDITIONS':'DEBUG' if config==configs[0] else ''})
  cs.append(add('XCBuildConfiguration',buildSettings=s,name=config))
 return add('XCConfigurationList',buildConfigurations=cs,defaultConfigurationIsVisible=0,defaultConfigurationName='GoldenRelease')
base={'IPHONEOS_DEPLOYMENT_TARGET':'18.2','SDKROOT':'iphoneos','SWIFT_VERSION':'5.0','CLANG_ENABLE_MODULES':'YES','CLANG_ENABLE_OBJC_ARC':'YES','SWIFT_STRICT_CONCURRENCY':'targeted','SWIFT_EMIT_LOC_STRINGS':'NO','GCC_C_LANGUAGE_STANDARD':'gnu17','ALWAYS_SEARCH_USER_PATHS':'NO','ENABLE_USER_SCRIPT_SANDBOXING':'YES','CLANG_WARN_DOCUMENTATION_COMMENTS':'YES','CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER':'YES','COPY_PHASE_STRIP':'NO'}
project_config=config_list(base,'project')
resources=['Resources/Localizable.xcstrings','Resources/InfoPlist.xcstrings','Resources/PrivacyInfo.xcprivacy']
common_settings={'TARGETED_DEVICE_FAMILY':'1,2','SUPPORTED_PLATFORMS':'iphoneos iphonesimulator','MARKETING_VERSION':'1.1.4','CURRENT_PROJECT_VERSION':'441','CODE_SIGN_STYLE':'Automatic','DEVELOPMENT_TEAM':'','ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS':'NO','SUPPORTS_MACCATALYST':'NO','SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD':'NO','SUPPORTS_XR_DESIGNED_FOR_IPHONE_IPAD':'NO','LD_RUNPATH_SEARCH_PATHS':['$(inherited)','@executable_path/Frameworks'],'LOCALIZATION_PREFERS_STRING_CATALOGS':'YES','STRING_CATALOG_GENERATE_SYMBOLS':'NO'}
def target(name,ptype,ext,sources,res,settings,deps=None):
 product=add('PBXFileReference',explicitFileType={'app':'wrapper.application','appex':'wrapper.app-extension','xctest':'wrapper.cfbundle'}[ext],includeInIndex=0,path=name+'.'+ext,sourceTree='BUILT_PRODUCTS_DIR');obj[products]['children'].append(product)
 phases=[]
 for isa,paths in [('PBXSourcesBuildPhase',sources),('PBXFrameworksBuildPhase',[]),('PBXResourcesBuildPhase',res)]:
  f=[add('PBXBuildFile',fileRef=refs[x]) for x in paths]
  phases.append(add(isa,buildActionMask=2147483647,files=f,runOnlyForDeploymentPostprocessing=0))
 t=add('PBXNativeTarget',buildConfigurationList=config_list({**common_settings,'PRODUCT_NAME':name,**settings}),buildPhases=phases,buildRules=[],dependencies=deps or [],name=name,productName=name,productReference=product,productType=ptype)
 return t,product
w,wp=target('DawnTile','com.apple.product-type.app-extension','appex',['Source/PlumeLedger.swift','Source/CrossingCanvas.swift','Widget/DawnTiles.swift'],resources,{'PRODUCT_BUNDLE_IDENTIFIER':'org.sunnyplume.trail441.dawn','INFOPLIST_FILE':'Widget/DawnInfo.plist','CODE_SIGN_ENTITLEMENTS':'Widget/DawnRights.entitlements','APPLICATION_EXTENSION_API_ONLY':'YES','SKIP_INSTALL':'YES','LD_RUNPATH_SEARCH_PATHS':['$(inherited)','@executable_path/Frameworks','@executable_path/../../Frameworks']})
main,mp=target('SunnyPlume','com.apple.product-type.application','app',[x for x in files if x.startswith('Source/')],resources+['Resources/PlumeAssets.xcassets'],{'PRODUCT_BUNDLE_IDENTIFIER':'org.sunnyplume.trail441','INFOPLIST_FILE':'Resources/PlumeInfo.plist','CODE_SIGN_ENTITLEMENTS':'Resources/PlumeRights.entitlements','ASSETCATALOG_COMPILER_APPICON_NAME':'FeatherMark','SKIP_INSTALL':'NO'})
prj=add('PBXProject',attributes={'BuildIndependentTargetsInParallel':'YES','LastUpgradeCheck':'2720','ORGANIZATIONNAME':'Sunny Plume Workshop','TargetAttributes':{main:{'CreatedOnToolsVersion':'27.2','SystemCapabilities':{'com.apple.GameCenter':{'enabled':1},'com.apple.ApplicationGroups.iOS':{'enabled':1},'com.apple.Push':{'enabled':1}}},w:{'CreatedOnToolsVersion':'27.2','SystemCapabilities':{'com.apple.ApplicationGroups.iOS':{'enabled':1}}}}},buildConfigurationList=project_config,compatibilityVersion='Xcode 14.0',developmentRegion='en',hasScannedForEncodings=0,knownRegions=['en','de','pt-BR','fr','Base'],mainGroup=group,productRefGroup=products,projectDirPath='',projectRoot='',targets=[main,w])
def dependency(a,b):
 proxy=add('PBXContainerItemProxy',containerPortal=prj,proxyType=1,remoteGlobalIDString=b,remoteInfo=obj[b]['name']);obj[a]['dependencies'].append(add('PBXTargetDependency',target=b,targetProxy=proxy))
dependency(main,w)
embed=add('PBXBuildFile',fileRef=wp,settings={'ATTRIBUTES':['RemoveHeadersOnCopy']})
obj[main]['buildPhases'].append(add('PBXCopyFilesBuildPhase',buildActionMask=2147483647,dstPath='',dstSubfolderSpec=13,files=[embed],name='Embed Dawn Tile',runOnlyForDeploymentPostprocessing=0))
unit,up=target('PlumeChecks','com.apple.product-type.bundle.unit-test','xctest',['Checks/CrossingChecks.swift','Widget/DawnTiles.swift'],[],{'PRODUCT_BUNDLE_IDENTIFIER':'org.sunnyplume.verification441','GENERATE_INFOPLIST_FILE':'YES','TEST_HOST':'$(BUILT_PRODUCTS_DIR)/SunnyPlume.app/SunnyPlume','BUNDLE_LOADER':'$(TEST_HOST)','SWIFT_ACTIVE_COMPILATION_CONDITIONS':'$(inherited) CC_WIDGET_CHECKS'})
ui,uip=target('PathChecks','com.apple.product-type.bundle.ui-testing','xctest',['Checks/CrossingChecks.swift'],[],{'PRODUCT_BUNDLE_IDENTIFIER':'org.sunnyplume.journey441','GENERATE_INFOPLIST_FILE':'YES','TEST_TARGET_NAME':'SunnyPlume','SWIFT_ACTIVE_COMPILATION_CONDITIONS':'$(inherited) CC_UI_CHECKS'})
dependency(unit,main);dependency(ui,main);obj[prj]['targets'] += [unit,ui]
def out(v,level=0):
 if isinstance(v,dict):return '{\n'+''.join('\t'*(level+1)+json.dumps(str(k))+' = '+out(val,level+1)+';\n' for k,val in v.items())+'\t'*level+'}'
 if isinstance(v,list):return '( '+', '.join(out(x,level) for x in v)+' )'
 if isinstance(v,int):return str(v)
 return json.dumps(v,ensure_ascii=False)
proj=p/'SunnyPlume.xcodeproj';proj.mkdir(exist_ok=True)
(proj/'project.pbxproj').write_text('// !$*UTF8*$!\n'+out({'archiveVersion':1,'classes':{},'objectVersion':56,'objects':obj,'rootObject':prj})+'\n')
shared=proj/'xcshareddata/xcschemes';shared.mkdir(parents=True,exist_ok=True)
def buildref(t,prod):return f'<BuildableReference BuildableIdentifier="primary" BlueprintIdentifier="{t}" BuildableName="{obj[prod]["path"]}" BlueprintName="{obj[t]["name"]}" ReferencedContainer="container:SunnyPlume.xcodeproj"/>'
scheme=f'''<?xml version="1.0" encoding="UTF-8"?><Scheme LastUpgradeVersion="2720" version="1.7"><BuildAction parallelizeBuildables="YES" buildImplicitDependencies="YES"><BuildActionEntries><BuildActionEntry buildForTesting="YES" buildForRunning="YES" buildForProfiling="YES" buildForArchiving="YES" buildForAnalyzing="YES">{buildref(main,mp)}</BuildActionEntry></BuildActionEntries></BuildAction><TestAction buildConfiguration="DawnDebug" selectedDebuggerIdentifier="Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier="Xcode.IDEFoundation.Launcher.LLDB" shouldUseLaunchSchemeArgsEnv="YES"><Testables><TestableReference skipped="NO">{buildref(unit,up)}</TestableReference><TestableReference skipped="NO">{buildref(ui,uip)}</TestableReference></Testables></TestAction><LaunchAction buildConfiguration="DawnDebug" selectedDebuggerIdentifier="Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier="Xcode.IDEFoundation.Launcher.LLDB" launchStyle="0" useCustomWorkingDirectory="NO" ignoresPersistentStateOnLaunch="NO" debugDocumentVersioning="YES" debugServiceExtension="internal" allowLocationSimulation="NO"><BuildableProductRunnable runnableDebuggingMode="0">{buildref(main,mp)}</BuildableProductRunnable></LaunchAction><ProfileAction buildConfiguration="GoldenRelease" shouldUseLaunchSchemeArgsEnv="YES" savedToolIdentifier="" useCustomWorkingDirectory="NO" debugDocumentVersioning="YES"><BuildableProductRunnable runnableDebuggingMode="0">{buildref(main,mp)}</BuildableProductRunnable></ProfileAction><AnalyzeAction buildConfiguration="DawnDebug"/><ArchiveAction buildConfiguration="GoldenRelease" revealArchiveInOrganizer="YES"/></Scheme>'''
(shared/'Sunfoot.xcscheme').write_text(scheme)
print('Generated',len(obj),'unique objects;',main)
