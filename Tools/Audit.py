from pathlib import Path
import json,re,hashlib
p=Path(__file__).resolve().parents[1]
factory=p.parents[3]
project=p/'SunnyPlume.xcodeproj/project.pbxproj'
s=project.read_text(); ids=set(re.findall(r'\b[A-F0-9]{24}\b',s));collisions=[];scanned=0;bundle_collisions=[]
our_bundles=set(re.findall(r'"PRODUCT_BUNDLE_IDENTIFIER" = "([^"\n]+)"',s))
for other in (factory/'output/concepts15nov').glob('*/*/*.xcodeproj/project.pbxproj'):
 if other==project:continue
 scanned+=1
 other_text=other.read_text(errors="replace")
 for bid in our_bundles:
  if bid in other_text:bundle_collisions.append(str(other.relative_to(factory))+": "+bid)
 found=ids & set(re.findall(r'\b[A-F0-9]{24}\b',other.read_text(errors='replace')))
 if found:collisions.append({'project':str(other.relative_to(factory)),'ids':sorted(found)})
local=json.loads((p/'Resources/Localizable.xcstrings').read_text())['strings']
langs=['en','de','pt-BR','fr']
missing={k:[l for l in langs if l not in v['localizations']] for k,v in local.items() if any(l not in v['localizations'] for l in langs)}
forbidden=[]
for key,value in local.items():
 for lang,t in value['localizations'].items():
  if re.search(r'\b(bet\w*|casino\w*|slot\w*|jackpot\w*|odds)\b',t['stringUnit']['value'],re.I): forbidden.append([key,lang])
leaks=[]
source_files=list((p/'Source').glob('*.swift'))+list((p/'Widget').glob('*.swift'))+list((p/'Checks').glob('*.swift'))+[project]+list((p/'Resources').glob('*.plist'))
for f in source_files:
 if re.search(re.escape(str(Path.home()))+r'|@.*\.com',f.read_text()):leaks.append(str(f.relative_to(p)))
report={'swift_authored_files':len(list((p/'Source').glob('*.swift')))+len(list((p/'Widget').glob('*.swift')))+len(list((p/'Checks').glob('*.swift'))),'uuid_count':len(ids),'other_projects_compared':scanned,'uuid_collisions':collisions,'bundle_collisions':bundle_collisions,'languages':langs,'localization_keys':len(local),'missing_translations':missing,'prohibited_ui_terms':forbidden,'machine_paths_in_shipped_sources':leaks,'requirements_sha256':hashlib.sha256((factory/'concepts15nov/04_chicken_road/01_chicken_cross.md').read_bytes()).hexdigest(),'readme_sha256':hashlib.sha256((factory/'concepts15nov/README.md').read_bytes()).hexdigest()}
(p/'Evidence/StaticAudit.json').write_text(json.dumps(report,indent=2))
print(json.dumps(report,indent=2))
assert not any([collisions,bundle_collisions,missing,forbidden,leaks])
