deb:
	cd docs; make; cd ..;
	for subd in backups lib  logs  temp  webapps; do \
	  mkdir -p ./pkg/usr/share/dhis2-tools/skel/$$subd; \
	done    
        
	mkdir -p ./pkg/var/lib/dhis2;

	#permissions
	find ./pkg/usr -type d -exec chmod 0755 {} \;
	find ./pkg/usr -type f -exec chmod 0644 {} \;


clean:
	cd docs; make clean; cd ..
	for subd in backups lib  logs  temp  webapps; do \
	   rm -rf ./pkg/usr/share/dhis2-tools/skel/$$subd; \
	done    
        
	rm -rf ./pkg/var/lib/dhis2;

	#perimissions
	find ./pkg/usr -type d -exec chmod 0755 {} \;
	find ./pkg/usr -type f -exec chmod 0644 {} \;
