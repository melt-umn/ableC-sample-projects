all: down_on_the_farm parallel_tree_search using_transparent_prefixes using_scoped_keywords

down_on_the_farm:
	cd down_on_the_farm && $(MAKE) -j

parallel_tree_search:
	cd parallel_tree_search && $(MAKE) -j

using_transparent_prefixes:
	cd using_transparent_prefixes && $(MAKE) -j

using_scoped_keywords:
	cd using_scoped_keywords && $(MAKE) -j

type_qualifiers:
	cd type_qualifiers && $(MAKE) -j

clean:
	cd down_on_the_farm && $(MAKE) clean
	cd parallel_tree_search && $(MAKE) clean

.PHONY: all down_on_the_farm parallel_tree_search using_transparent_prefixes using_scoped_keywords type_qualifiers clean
.NOTPARALLEL: # Avoid running multiple Silver builds in parallel
