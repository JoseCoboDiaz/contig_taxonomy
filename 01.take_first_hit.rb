
seq=''

aa=File.open("diamond_contigsARGfaa.txt").each_line do |line|
line.chomp!
if line.split("\t")[0]!=seq
puts line
seq=line.split("\t")[0]
end
end
aa.close
