#/bin/sh
base_dir=~/mkgmap
srtm_base=$base_dir/dem/
src_dir=`pwd`

while IFS='=' read -r key value
do
    key=$(echo $key | tr '.' '_' )
    eval "${key}='${value}'"
done < "$1"

cd $base_dir

wget -O download/$download_name $download_url

rm -rf $output_dir
mkdir $output_dir
cd $output_dir

cp $src_dir/conf/next.args .
sed -i "s/{family_id}/$family_id/g" next.args
sed -i "s/{instalation_name}/$instalation_name/g" next.args
sed -i "s/{country-name}/$country_name/g" next.args
sed -i "s/{country-abbr}/$country_abbr/g" next.args
sed -i "s/{src_dir}/$src_dir/g" next.args

java -jar ../mkgmap-r3701/mkgmap.jar --family-id=$family_id $src_dir/conf/typfile.txt

java -d64 -XX:MaxHeapSize=7000m -jar ../splitter-r439/splitter.jar --max-nodes=$max_split_nodes --max-areas=512 --mapid=$mapid  --keep-complete=false --description="$description" --mixed $srtm_base$srtm_file ../download/$download_name

java -d64 -XX:MaxHeapSize=7000m -XX:-UseGCOverheadLimit -jar ../mkgmap-r3701/mkgmap.jar --style-file=$src_dir/styles/mystyle -c next.args -c template.args --gmapsupp $family_id*.osm.pbf typfile.typ

sed -i "s/OSM map/$instalation_name/g" osmmap.nsi
sed -i "s/xtypfile.typ/typfile.typ/g" osmmap.nsi
makensis osmmap.nsi

img_name=${instalation_name//[[:space:]]}
[ -f "../ready/$instalation_name.exe" ] && mv "../ready/$instalation_name.exe" "../backup/$instalation_name.exe" || echo "exe file not found"
[ -f "../ready/$img_name.img" ] && mv "../ready/$img_name.img" "../backup/$img_name.img" || echo "img file not found"

mv "$instalation_name.exe" "../ready/$instalation_name.exe"
mv gmapsupp.img ../ready/$img_name.img

cp "../ready/$instalation_name.exe"  ~/maps/
cp ../ready/$img_name.img ~/maps/

cd ../ready
./sendFtp.sh "$instalation_name".exe 
[ $upload_img == 't' ] && ./sendFtp.sh "$img_name".img

