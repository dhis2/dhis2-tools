build:
	for subd in backups lib  logs  temp  webapps; do \
		mkdir -p ./usr/share/dhis2-tools/skel/$$subd; \
	done	
	
	mkdir -p ./var/lib/dhis2;
	mkdir -p ./var/log/dhis2;

	#perimissions
	find ./usr -type d -exec chmod 0755 {} \;
	find ./usr -type f -exec chmod 0644 {} \;
