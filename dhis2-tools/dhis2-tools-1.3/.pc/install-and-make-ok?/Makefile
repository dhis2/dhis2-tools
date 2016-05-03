build:
	cd docs; make;
	for subd in backups lib  logs  temp  webapps; do \
		mkdir -p ./usr/share/dhis2-tools/skel/$$subd; \
	done	
	
	#perimissions
	find ./usr -type d -exec chmod 0755 {} \;
	find ./usr -type f -exec chmod 0644 {} \;
	
	echo 'makefile done';
