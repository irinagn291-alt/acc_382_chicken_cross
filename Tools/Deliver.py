from pathlib import Path
import zipfile,json,hashlib
p=Path(__file__).resolve().parents[1]
files=[]
for folder in ['Source','Widget','Resources','Checks','Tools','SunnyPlume.xcodeproj']:
 for f in (p/folder).rglob('*'):
  if f.is_file() and not any(x in f.parts for x in ['xcuserdata','__pycache__']): files.append(f)
if (p/'REPORT.txt').exists():files.append(p/'REPORT.txt')
with zipfile.ZipFile(p/'Artifacts/ChickenCross-Source.zip','w',zipfile.ZIP_DEFLATED) as z:
 for f in files:z.write(f,Path('ChickenCross')/f.relative_to(p))
manifest={str(f.relative_to(p)):hashlib.sha256(f.read_bytes()).hexdigest() for f in files}
(p/'Evidence/SourceSHA256.json').write_text(json.dumps(manifest,indent=2))
print('Source package:',len(files),'files')
