cd ../ready
FOR %%I IN (*.exe) DO (
	call sendFtp "%%I"
)