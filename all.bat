echo '---------------------------------- START -----------------------------------------'
call build.bat conf\bulgaria.props > ../logs/bulgaria.log
call build.bat conf\greece.props > ../logs/greece.log
call build.bat conf\albania.props > ../logs/albania.log
call build.bat conf\makedonia.props > ../logs/makedonia.log
call build.bat conf\romania.props > ../logs/romania.log
call build.bat conf\montenegro.props > ../logs/montenegro.log
call build.bat conf\bih.props > ../logs/bih.log
call build.bat conf\kosovo.props > ../logs/kosovo.log
call build.bat conf\serbia.props > ../logs/serbia.log
echo '----------------------------------- END -----------------------------------------'