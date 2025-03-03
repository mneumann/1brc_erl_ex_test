#!/usr/bin/env ruby
out_dir = ARGV.first
results_1b = {}
results_50m = {}

Dir.glob(File.join(out_dir, "*.txt")).each do |filename|
  time = nil
  cpu = nil
  mem = nil

  File.read(filename).each_line do |line|
    case line
    when /\A\s+Elapsed \(wall clock\) time \(h:mm:ss or m:ss\):\s+(.+)\n/
      time = $1

    when /\A\s+Percent of CPU this job got:\s+(.+)\n/
      cpu = $1

    when /\A\s+Maximum resident set size \(kbytes\):\s+(.+)\n/
      mem = $1

    else
      p line
    end
  end

  case File.basename(filename).split(".")
  in [contrib, "1B", "txt"]
    results_1b[contrib] = [time, cpu, mem]

  in [contrib, "50M", "txt"]
    results_50m[contrib] = time, cpu, mem
  end
end

keys = results_50m.keys

###
# First let's print the 50M results
###

rows = [
  "| Contributor | Time (50M) | CPU% (50M) | Mem kb (50M) | Comments |",
  "| ----------- | ---------- | ---------- | ------------ | -------- |",
]

template = "| %40s | %10s | %10s | %12s | %9s |"

# Sort keys based on the Time (50M) in ascending order
sorted_keys = keys.sort_by { |key| results_50m[key][0] }

sorted_keys.each do |key|
  time50M, cpu50M, mem50M = *results_50m[key]

  rows.push(template % [key, time50M, cpu50M, mem50M, ""])
end
puts "Here are the 50M Results:"
puts rows

puts ""
puts ""
puts ""

###
# Now let's print the 1B results
###
keys = results_1b.keys

rows = [
  "| Contributor | Time (1B) | CPU% (1B) | Mem kb (1B) | Comments |",
  "| ----------- | ---------- | ---------- | ------------ | -------- |",
]

template = "| %40s | %10s | %10s | %12s | %9s |"

# Sort keys based on the Time (1B) in ascending order
sorted_keys = keys.sort_by { |key| results_1b[key][0] }

sorted_keys.each do |key|
  time1B, cpu1B, mem1B = *results_1b[key]

  rows.push(template % [key, time1B, cpu1B, mem1B, ""])
end
puts "Here are the 1B Results:"
puts rows