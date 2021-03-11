
#blastn -query seqs_concatenated.fasta -db ResFinder -out blastn_AR_reads.txt -outfmt '6 std stitle' -max_target_seqs 100 -perc_identity 90 -num_threads 10

name=''
hkrak={}

aa=File.open("code_names_kraken.txt").each_line do |line|	#REPORT
line.chomp!
#6	Azorhizobium
hkrak[line.split("\t")[0]]=line.split("\t")[1].split("\s")[0]
end
aa.close


bb=File.open(ARGV[0]).each_line do |line|
line.chomp!
#ANP_131_NODE_1000_length_4153_cov_561.712543_2	kraken:taxid|2099583|NZ_CP030287.1_7937	86.2	268	37	0	1	268	44	311	8.0e-140	504.6
	if line.split("\t")[0]!=name
	puts "#{line}\t#{hkrak[line.split("\|")[1]]}"
	name=line.split("\t")[0]
	end
end
bb.close
