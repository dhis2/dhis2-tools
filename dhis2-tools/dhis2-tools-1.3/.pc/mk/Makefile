install:
	cd docs; make;
	for subd in backups lib  logs  temp  webapps; do \
		echo 'creating subd'; \
		mkdir -p ./pkg/usr/share/dhis2-tools/skel/$subd; \
	done	
