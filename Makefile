##
# Blog Makefile
#
# @file
# @version 0.1

.PHONY: all publish publish_no_init

all: republish rsync

serve: publish.el
	@echo "Serving..."
	python -m http.server --directory /var/www/ericnorman

dev: publish.el
	@echo "Starting development..."
	while true; do ls ./**/*.* ./*.* | entr -p make publish; done

publish: publish.el
	@echo "Publishing..."
	emacs --batch --load publish.el --funcall en/publish

tangle: publish.el
	@echo "Tangling..."
	emacs --batch --load publish.el --funcall encyclopedia-tangle-files

execute: publish.el
	@echo "Executing all..."
	emacs --batch --load publish.el --funcall encyclopedia-execute-files

republish: publish.el
	@echo "Republishing all files..."
	emacs --batch --load publish.el --funcall en/republish

rsync: publish.el
	@echo "rsyncing published site to hosting..."
	rsync -chavz /var/www/ericnorman/ ericpi:/var/www/html

publish_no_init: publish.el
	@echo "Publishing... with --no-init."
	emacs --batch --no-init --load publish.el --funcall org-publish-all

# clean:
# 	@echo "Cleaning up.."
# 	@rm -rvf *.elc
# 	@rm -rvf public
# 	@rm -rvf ~/.org-timestamps/*


# end
