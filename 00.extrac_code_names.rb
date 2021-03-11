
aa=File.open("taxonomy/names.dmp").each_line do |line|
line.chomp!
if line =~ /scientific name/
puts "#{line.split("\t")[0]}\t#{line.split("\t")[2]}"
end
end
aa.close
