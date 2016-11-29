::@echo off
echo {user} > ftp.conf
echo {password} >> ftp.conf
echo bin >> ftp.conf
echo put %1 >> ftp.conf
echo quit >> ftp.conf
ftp -i -v -s:ftp.conf {server}
del ftp.conf