
ALL += neurient.zip

ZIP += *.m
ZIP += sample-image.png

all: $(ALL)

CLEAN += $(ALL)
CLEAN += *~
CLEAN += *stack*.mat

clean:
	rm -f $(CLEAN)

EDIT += Makefile
EDIT += *.m

edit:
	kate -n $(EDIT) 2>/dev/null & disown

sample-image.png: 100305CLF_Ave2\ red\ 5\ 5.tif
	which convert || sudo apt-get install imagemagick
	convert "$^" -colorspace RGB -channel Red -colorspace Gray -auto-level "$@"

neurient_demo: neurient_demo.m sample-image.png
	octave --persist $<

neurient.zip: $(ZIP)
	zip -9 $@ $^
