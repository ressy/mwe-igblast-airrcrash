SHELL = /bin/bash

VERSION ?= 1.15.0
URL = ftp://ftp.ncbi.nih.gov/blast/executables/igblast/release/LATEST/ncbi-igblast-$(VERSION)-x64-linux.tar.gz
INSTALL = ncbi-igblast-$(VERSION)
IGBLASTN = ncbi-igblast-$(VERSION)/bin/igblastn
MAKEBLASTDB = ncbi-igblast-$(VERSION)/bin/makeblastdb

all: demo_fmt_19

$(IGBLASTN):
	wget $(URL)
	tar xzf $(notdir $(URL))
	# I tried IGDATA but it doesn't seem to work for me in 1.15.0.
	ln -sf $(INSTALL)/internal_data .

VDJ = database/stub_HV.fasta.nhr database/stub_HD.fasta.nhr database/stub_HJ.fasta.nhr

# fails
demo_fmt_19: $(VDJ) $(IGBLASTN)
	$(IGBLASTN) -germline_db_V database/stub_HV.fasta -germline_db_D database/stub_HD.fasta -germline_db_J database/stub_HJ.fasta -query fails.fasta -outfmt 19

# works
demo_fmt_7: $(VDJ) $(IGBLASTN)
	$(IGBLASTN) -germline_db_V database/stub_HV.fasta -germline_db_D database/stub_HD.fasta -germline_db_J database/stub_HJ.fasta -query fails.fasta -outfmt 19

# works
demo_fmt_19_alt: $(VDJ) $(IGBLASTN)
	$(IGBLASTN) -germline_db_V database/stub_HV.fasta -germline_db_D database/stub_HD.fasta -germline_db_J database/stub_HJ.fasta -query works.fasta -outfmt 19

# works
demo_fmt_7_alt: $(VDJ) $(IGBLASTN)
	$(IGBLASTN) -germline_db_V database/stub_HV.fasta -germline_db_D database/stub_HD.fasta -germline_db_J database/stub_HJ.fasta -query works.fasta -outfmt 19

%.fasta.nhr: %.fasta $(IGBLASTN)
	$(MAKEBLASTDB) -dbtype nucl -parse_seqids -in $<

clean:
	rm -f database/stub_H{V,D,J}.fasta.{ndb,nhr,nin,not,nsq,ntf,nto}
	rm -f internal_data
	rm -f $(notdir $(URL))
	rm -rf $(INSTALL)
