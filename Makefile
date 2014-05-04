
build: site
	./site build

site: site.hs
	ghc --make -threaded $<

publish:
	git commit -a
	git push origin
	$(MAKE) -C _site

.PHONY: build publish

