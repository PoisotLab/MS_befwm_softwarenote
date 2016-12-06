FILE=befwm_software
SOURCE=$(FILE).md
BIB=$(FILE).json
TEMPLATE=draft# alt. value: preprint
MODEL=.plmt/templates/$(TEMPLATE).tex
EXT=pdf
MARKED= ./.plmt/temp.md
PFLAGS= --variable=$(TEMPLATE) --filter pandoc-citeproc
OUTPUT= $(FILE)_$(TEMPLATE).$(EXT)

TABLES = $(wildcard tables/*.md)
TABLESLATEX = $(TABLES:.md=.tex)

PHONY: all

all: $(OUTPUT)

clean:
	rm $(MARKED)

$(BIB): $(SOURCE)
	node plmt/index.js $(SOURCE)

$(MARKED): $(SOURCE) $(TABLESLATEX)
	node .plmt/critic.js $< .plmt/tmp1
	node .plmt/figures.js .plmt/tmp1 .plmt/tmp2
	node .plmt/tables.js .plmt/tmp2 $@
	rm .plmt/tmp*

$(OUTPUT): $(MARKED)
	pandoc $< -o $@ $(PFLAGS) --template $(MODEL) metadata.yaml --bibliography $(BIB) --csl .plmt/plab.csl
	-@rm $(MARKED)
	-@rm tables/*tex

tables/%.tex: tables/%.md
	pandoc $< -o $@
