#!/usr/bin/env ruby

require "optparse"
require "streamio-ffmpeg"

def extract_frames(input_file, start_time, end_time, fps, output_name)
  movie = FFMPEG::Movie.new(input_file)

  options = {
    seek_time: start_time,
    duration: end_time.to_i - start_time.to_i,
    resolution: "1920x1080",
    video_frame_rate: fps,
    validate: false,
    output: "#{output_name}-%03d.png"
  }

  transcoder = movie.transcode(nil, options)
  transcoder.run

  puts "Done!"
end

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: extract_frames.rb [options]"

  opts.on("-i", "--input INPUT_FILE", "Input file") do |v|
    options[:input] = v
  end

  opts.on("-s", "--start START_TIME", "Start time (in seconds)") do |v|
    options[:start] = v
  end

  opts.on("-e", "--end END_TIME", "End time (in seconds)") do |v|
    options[:end] = v
  end

  opts.on("-f", "--fps FPS", "Frames per second") do |v|
    options[:fps] = v
  end

  opts.on("-o", "--output OUTPUT_NAME", "Output file name") do |v|
    options[:output] = v
  end
end.parse!

input_file = options[:input]
start_time = options[:start]
end_time = options[:end]
fps = options[:fps]
output_name = options[:output]

if !input_file || !start_time || !end_time || !fps || !output_name
  puts "Error: Missing required option(s)."
  puts
  puts OptionParser.new.help
  exit
end

extract_frames(input_file, start_time, end_time, fps, output_name)
