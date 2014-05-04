
build: site
	./site build

site: site.hs
	ghc --make -threaded $<

publish:
	$(MAKE) build
	git commit -a
	git push origin
	$(MAKE) -C _site

test: build
	./site watch

.PHONY: build publish test

