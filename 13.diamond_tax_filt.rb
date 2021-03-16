
#blastn -query seqs_concatenated.fasta -db ResFinder -out blastn_AR_reads.txt -outfmt '6 std stitle' -max_target_seqs 100 -perc_identity 90 -num_threads 10

name=''
tax=[]
good=[]

out=ARGV[0].gsub(".txt","")
out1=File.new("#{out}_perfect.txt","w")
out2=File.new("#{out}_problems.txt","w")



aa=File.open(ARGV[0]).each_line do |line|
line.chomp!
#ANP_131_NODE_1000_length_4153_cov_561.712543_2	kraken:taxid|2099583|NZ_CP030287.1_7937	86.2	268	37	0	1	268	44	311	8.0e-140	504.6	Pseudomonas
if line =~ /^(\S+)\_\d+\s+/
	if $1 != name
		if tax.uniq.length == 1
		out1.puts "#{name}\t#{tax[0]}"
		good << name
	 	else
		tax.uniq.each {|x| if tax.count(x)*100/tax.length > 90	# this value can be changed to be more restrictive or less, as you prefer
			out1.puts "#{name}\t#{x}"
			good << name
			end}
		end
	name = $1
	tax = []		
	tax << line.split("\t")[12]
	else
	tax << line.split("\t")[12]
	end
end
end
aa.close

### This part is to avoid lose the information of last contig
	if tax.uniq.length == 1
		out1.puts "#{name}\t#{tax[0]}"
		good << name
	 	else
		tax.uniq.each {|x| if tax.count(x)*100/tax.length > 90
			out1.puts "#{name}\t#{x}"
			good << name
			end}
	end


### This part is to write the output with contigs no taxnomically assigned, for further manual revision
name=''

bb=File.open(ARGV[0]).each_line do |line|
line.chomp!
if line =~ /^(\S+)\_\d+\s+/
	if good.include?($1)==false
		if $1 != name
		name = $1
		out2.puts "\n"
		out2.puts line
		else
		out2.puts line
		end
	end
end
end
bb.close

