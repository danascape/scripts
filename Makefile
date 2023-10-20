check-scripts:
	while read -r script; do shellcheck --exclude=SC1090,SC1091 $$script; done < files

execute-shfmt:
	while read -r script; do shfmt -ln=bash -fn -ci -sr -w $$script; done < files

.PHONY: check-scripts
