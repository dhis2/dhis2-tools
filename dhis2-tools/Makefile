deb:
	cd docs; make;
	cd dhis2-tools; debuild -b -us -uc;

clean:
	rm -f dhis2-tools_1.2-*
	rm -rf *~
	cd docs; make clean; cd ..
