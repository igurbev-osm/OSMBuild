SET base_dir=C:/Users/Ivan/Documents/mkgmap/
SET src_dir=%cd%

for /f "delims=" %%x in (%1) do (set "%%x")

cd %base_dir%

wget -O download/%download_name% %download_url%

del /F /S /Q %output_dir%
mkdir %output_dir%
cd %output_dir%

copy %src_dir%\conf\next.args .
sed -i "s/{family_id}/%family_id%/g" next.args
sed -i "s/{instalation_name}/%instalation_name%/g" next.args
sed -i "s/{country-name}/%country-name%/g" next.args
sed -i "s/{country-abbr}/%country-abbr%/g" next.args
sed -i "s/{src_dir}/"%src_dir%"/g" next.args

java -jar ../mkgmap-r3701/mkgmap.jar --family-id=%family_id% %src_dir%\conf\typfile.txt
::../srtm2osm.exe -bounds1 41.1330000 22.3410000 44.2650000 28.6690000 -cat 400 100 -large -corrxy 0.0005 0.0006 -step 10 -o %srtm_file%
java -Xmx1500m -XX:MaxHeapSize=1024m -jar ../splitter-r439/splitter.jar --max-nodes=1600000 --max-areas=512 --mapid=%mapid%  --keep-complete=false --description="%description%" --mixed ../Srtm2Osm/%srtm_file% ../download/%download_name%
java -Xmx1024m -jar ../mkgmap-r3701/mkgmap.jar --style-file=%src_dir%/styles/mystyle -c next.args -c template.args %family_id%*.osm.pbf typfile.typ

sed -i "s/OSM map/%instalation_name%/g" osmmap.nsi
sed -i "s/xtypfile.typ/typfile.typ/g" osmmap.nsi
makensis osmmap.nsi

cd %src_dir%
