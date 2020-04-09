# MWE - IgBLAST AIRR Crash

My calls to `igblastn -outfmt 19 ...` crash with very specific input queries
and database sequences, but not with others and not with other output formats.
Why?

Relevant lines from `make`:

    ncbi-igblast-1.15.0/bin/igblastn -germline_db_V database/stub_HV.fasta -germline_db_D database/stub_HD.fasta -germline_db_J database/stub_HJ.fasta -query fails.fasta -outfmt 19
    Warning: Auxilary data file could not be found
    WORKER: T5 BATCH # 1 EXCEPTION: basic_string::substr: __pos (which is 30) > this->size() (which is 9)
    Makefile:21: recipe for target 'demo_fmt_19' failed
    make: *** [demo_fmt_19] Segmentation fault (core dumped)

**Answer: I need `-parse_seqids` when running makeblastdb.** (Thanks NLM Support.)
