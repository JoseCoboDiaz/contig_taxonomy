# contig_taxonomy

This is a pipeline to make the contigs taxonomic assignment by kraken2 (https://github.com/DerrickWood/kraken2), mmseqs2 (https://github.com/soedinglab/MMseqs2) and diamond (https://github.com/bbuchfink/diamond) approaches using the same database, and finally select the genus level classification if at least 2 of the approaches have the same result. In this case, we have worked with the kraken2-microbial database (https://lomanlab.github.io/mockcommunity/mc_databases.html).

<b>Kraken2 pipeline</b>

	kraken2 --db kraken2-microbial-fatfree/ contigs_ARGs.fna --threads 10 --report report_kraken2.txt --out out_kraken2.txt --memory-mapping

being --threads the number of threads and the --memory-mapping command can be removed if the computeremployed for analyses has enough RAM memory to load the entire database (around 30 GB in our case).

We are going to focus on bacterial contigs, so now we are going to download the bacterial database from RefSeq employed to built the kraken2-microbial database. The obtained .fna file to transform it to aminoacid database of the coding regions by prodigal (https://github.com/hyattpd/Prodigal):

	kraken2 --download-library bacterial
	prodigal -a library_bact.faa -i library.fna -o library_bact_out.txt

<b>Diamond pipeline</b>

Moreover, the ncbi-taxdump folder, needed for mmseqs analysis (see below) contain the names.dmp file, which is going to be usefull to create the table of ID codes from kraken and their taxonomy assignment, by:

	wget ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz
	mkdir taxonomy && tar -xxvf taxdump.tar.gz -C taxonomy
	ruby 00.extract_code_names.rb > code_names_kraken.txt

The following comands are to extract coding regions from input .fna file (to .faa file), create the diamond format database of bacteria aminoacid database, and perform diamond analysis:

	prodigal -a contigs_ARGs.faa -i contigs_ARGs2.fna
	diamond makedb --in library_bact.faa -d bacteria --threads 10
	diamond blastp -q contigs_ARGs.faa -o diamond_contigsARGfaa.txt -p 10 -d kraken_bacteria.dmnd -f 6
	ruby 01.take_first_hit.rb > diamond_firsthit.txt

<b>mmseqs2 pipeline</b>

	conda activate mmseqs2
	mmseqs createdb library.faa bactkrakDB
	ruby tax4mmseqs.rb > mapping_file.txt
	mmseqs createtaxdb bactkrakDB tmp --ncbi-tax-dump ncbi-taxdump –tax-mapping-file mapping_file.txt
	mmseqs createdb contigs_ARGs.faa contigsDB
	mmseqs taxonomy contigsDB mmseqs2/bactkrakDB mmseqs_contigs_tax tmp --tax-lineage 1
	mmseqs createtsv contigsDB mmseqs_contigs_tax mmseqs_contigs_table.txt

<b>Add tax to ouputs and select taxonomy results</b>

The 10.remove_quotation.rb script allows to remove quotation marks from big files, by

	ruby 10. remove_quotation.rb input.txt > output.txt

Before next step, <b>the output file from mmseq2 pipeline has to be sort by coding_regions-contigs names</b>, to avoid problems with this pipeline.

	ruby 11.kraken2_tax.rb kraken_out.txt > kraken_tax.txt
	ruby 12.diamond_tax.rb diamond_out.txt > diamond_tax.txt
	ruby 13.diamond_tax_filt.rb diamond_tax.txt > diamond_tax_filt.txt
	ruby 14.mmseqs_tax_filt.rb mmseqs_tax.txt > mmseqs_tax_filt.txt
	ruby 15.bind_tax.rb
