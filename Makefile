
build: site
	./site build

site: site.hs
	ghc --make -threaded $<

.PHONY: build

