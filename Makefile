
build: site
	./site build
	$(MAKE) -C _site

site: site.hs
	ghc --make -threaded $<

publish:
	git commit -a
	git push origin

.PHONY: build publish

