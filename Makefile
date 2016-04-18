SOURCE=ms.md
HTML=ms.html
TYPE=preprint# alt. value: preprint
TITLE=befwm
MARKED= plmt/$(TITLE)_temp.md
PFLAGS= --variable=$(TYPE) --filter pandoc-citeproc
OUTPUT= $(TITLE)_$(TYPE)_version.pdf
BIB=default.json

PHONY: all prepare

prepare:
	chmod +x plmt/*.{sh,py}
	mkdir -p figures

all: prepare $(OUTPUT)

clean:
	rm $(MARKED)
	rm plmt/bib.keys

$(BIB): plmt/bib.keys
	chmod +x plmt/generatebib.py
	./plmt/generatebib.py
	cat $@ | json_reformat > tmp.json
	mv tmp.json $@

plmt/bib.keys: $(MARKED)
	grep @[a-zA-Z0-9_:]* $< -oh --color=never | sort  | uniq | sed 's/@//g' > $@

$(MARKED): $(SOURCE)
	# Removes critic marks
	./plmt/critic.sh $< $@
	# Get yaml
	grep -Pzo '\-\-\-\n((.+)\n)+\-\-\-' $@ > paper.yaml
	# Replaces figures marks
	./plmt/figures.py $@ paper.yaml $(TYPE)
	mv $@_NEW $@
	# Remove yaml
	rm paper.yaml

$(OUTPUT): $(MARKED)
	pandoc $< -o $@ $(PFLAGS) --template plmt/plmt.tex
	rm $(MARKED)

