#/bin/sh
base_dir=~/mkgmap
srtm_base=$base_dir/dem
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
sed -i "s/{country-name}/${country_name}/g" next.args
sed -i "s/{country-abbr}/${country_abbr}/g" next.args
sed -i "s/{src_dir}/$src_dir/g" next.args

java -jar ../mkgmap-r3701/mkgmap.jar --family-id=$family_id $src_dir/conf/typfile.txt