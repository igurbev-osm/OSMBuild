@echo Started: %date% %time%
SET base_dir=C:/Users/Ivan/Documents/mkgmap/
SET srtm_base=E:/Srtm2Osm/
SET src_dir=%cd%

for /f "delims=" %%x in (%1) do (set "%%x")

cd %base_dir%

wget -O download/%download_name% %download_url%

if %errorlevel% neq 0 exit /b %errorlevel%

rd /S /Q %output_dir%
mkdir %output_dir%
cd %output_dir%

copy %src_dir%\conf\next.args .
sed -i "s/{family_id}/%family_id%/g" next.args
sed -i "s/{instalation_name}/%instalation_name%/g" next.args
sed -i "s/{country-name}/%country-name%/g" next.args
sed -i "s/{country-abbr}/%country-abbr%/g" next.args
sed -i "s/{src_dir}/"%src_dir%"/g" next.args

java -jar ../mkgmap-r3701/mkgmap.jar --family-id=%family_id% %src_dir%\conf\typfile.txt
if %errorlevel% neq 0 exit /b %errorlevel%

java -XX:MaxHeapSize=1256m -jar ../splitter-r439/splitter.jar --max-nodes=3000000 --max-areas=300 --mapid=%mapid%  --keep-complete=false --description="%description%" --mixed %srtm_base%%srtm_file% ../download/%download_name%
if %errorlevel% neq 0 exit /b %errorlevel%

java -XX:MaxHeapSize=1256m -jar ../mkgmap-r3701/mkgmap.jar --style-file=%src_dir%/styles/mystyle -c next.args -c template.args --gmapsupp %family_id%*.osm.pbf typfile.typ
if %errorlevel% neq 0 exit /b %errorlevel%

sed -i "s/OSM map/%instalation_name%/g" osmmap.nsi
sed -i "s/xtypfile.typ/typfile.typ/g" osmmap.nsi
makensis osmmap.nsi
if %errorlevel% neq 0 exit /b %errorlevel%

IF EXIST "..\ready\%instalation_name%.exe" (
	move "..\ready\%instalation_name%.exe" "..\backup\%instalation_name%.exe"
) 
move "%instalation_name%.exe" "..\ready\%instalation_name%.exe"

set img_name=%instalation_name: =%
ren gmapsupp.img %img_name%.img
IF EXIST "..\ready\%img_name%.img" (
	move "..\ready\%img_name%.img" "..\backup\%img_name%.img"
)
move "%img_name%.img" "..\ready\%img_name%.img"

cd ..
rd /S /Q %output_dir%

cd ready
call sendFtp "%instalation_name%.exe"

IF "%upload-img%" == "t" (
	call sendFtp "%img_name%.img"
)

cd %src_dir%

@echo End: %date% %time%