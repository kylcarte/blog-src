
build: site
	./site build
	$(MAKE) -C _site

site: site.hs
	ghc --make -threaded $<

.PHONY: build

