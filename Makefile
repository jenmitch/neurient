
ALL += sample-image.pgm

all: $(ALL)

CLEAN += $(ALL)
CLEAN += Melt_electrospun_fibers.jpg
CLEAN += *~
CLEAN += *stack*.mat

clean:
	rm -f $(CLEAN)

EDIT += Makefile
EDIT += *.m

edit:
	kate -n $(EDIT) 2>/dev/null & disown

Melt_electrospun_fibers.jpg:
	wget http://upload.wikimedia.org/wikipedia/commons/3/3b/Melt_electrospun_fibers.jpg

sample-image.pgm: Melt_electrospun_fibers.jpg
	convert $^ -scale 50% $@
