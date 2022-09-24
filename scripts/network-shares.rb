#!/usr/bin/env ruby
# Mount configured shares via CIFS or SSHFS
# Steen Hegelund
# Time-Stamp: 2022-Sep-24 19:10
#

require 'optparse'
require 'yaml'

$cmdoptions = {}
cfgfile = File.expand_path('~/.config/ruby/network-shares.yaml')
if !File.exist?(cfgfile)
    puts "Could not find #{cfgfile}"
    exit(1)
end

def get_system_mounts(shares)
  shares.each do |_name, config|
    config['systemmounts'] = {}
    next unless config['mounts']
    config['mounts'].each do |name|
      config['systemmounts'][name] = '-'
    end
  end
  resp = `mount`.split("\n")
  resp.each do |line|
    item = /\S+ on (\S+)/.match(line)
    next if item.nil?
    shares.each do |_name, config|
      next unless config['mounts']
      config['mounts'].each do |lname|
        ldir = File.expand_path(File.join(config['local'], lname))
        next unless item[1] == ldir
        config['systemmounts'][lname] = "-> #{item[1]}"
      end
    end
  end
end

def show_folders(config)
  config['mounts'].each do |name|
    case config['type']
    when 'cifs'
      rdir = "#{config['remote']}/#{name}"
    when 'sshfs'
      rdir = "#{config['options']['username']}@#{config['remote']}:#{name}"
    else
      puts "\"#{config['type']}\" mounts not supported"
      break
    end
    puts "%-20s: %-60s %s" % [name, rdir, config['systemmounts'][name]]
  end
end

def create_folders(config, mname = nil)
  config['mounts'].each do |name|
    next if mname && mname != name
    ldir = File.expand_path(File.join(config['local'], name))
    unless Dir.exist?(ldir)
      puts "creating local folder #{ldir}"
      puts "mkdir -p #{ldir}" if $cmdoptions[:verbose]
      %x(`mkdir -p #{ldir}`)
    end
  end
end

def mount_folders(config, mname = nil)
  case config['type']
  when 'cifs'
    options = ''
    config['options'].each do |key, value|
      if value
        options += "#{key}=#{value},"
      else
        options += "#{key},"
      end
    end
    options.chomp!(',')
    config['mounts'].each do |name|
      next if mname && mname != name
      ldir = File.expand_path(File.join(config['local'], name))
      rdir = "#{config['remote']}/#{name}"
      puts "mounting folder #{ldir}"
      puts "sudo mount -t cifs #{rdir} #{ldir} -o #{options}" if $cmdoptions[:verbose]
      %x(`sudo mount -t cifs #{rdir} #{ldir} -o #{options}`)
    end
  when 'sshfs'
    config['mounts'].each do |name|
      next if mname && mname != name
      rdir = "#{config['options']['username']}@#{config['remote']}:#{name}"
      ldir = File.expand_path(File.join(config['local'], name))
      puts "mounting folder #{ldir}"
      puts "sshfs #{rdir} #{ldir}" if $cmdoptions[:verbose]
      %x(`sshfs #{rdir} #{ldir}`)
    end
  else
    puts "\"#{config['type']}\" mounts not supported"
  end
end

def unmount_folders(config, mname = nil)
  config['mounts'].each do |name|
    next if mname && mname != name
    next if config['systemmounts'][name] == '-'
    ldir = File.expand_path(File.join(config['local'], name))
    puts "unmounting folder #{ldir}"
    puts "umount #{ldir}" if $cmdoptions[:verbose]
    %x(`sudo umount #{ldir}`)
  end
end

opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename(__FILE__)} [options]

    The default is to show the list of configured shares

Options:"
  opts.on('-v', '--verbose', 'Show actions') do |d|
    $cmdoptions[:verbose] = d
  end
  opts.on('-m', '--mount', 'Mount all listed shares') do |d|
    $cmdoptions[:mount] = d
  end
  opts.on('-u', '--unmount', 'Unmount all listed shares') do |d|
    $cmdoptions[:unmount] = d
  end
  opts.on('-o', '--mountnamed NAME', 'Mount named share') do |d|
    $cmdoptions[:mountnamed] = d
  end
  opts.on('-n', '--unmountnamed NAME', 'Unmount named share') do |d|
    $cmdoptions[:unmountnamed] = d
  end
  opts.on('-h', '--help', 'Show this message') do
    puts opts
    exit
  end
end

opt_parser.parse!(ARGV)

shares = YAML.safe_load(File.read(cfgfile))

if $cmdoptions[:mountnamed]
  shares.each do |_name, config|
    next if config['mounts'].nil?
    create_folders(config, $cmdoptions[:mountnamed])
    mount_folders(config, $cmdoptions[:mountnamed])
  end
  exit
end

if $cmdoptions[:mount]
  shares.each do |_name, config|
    next if config['mounts'].nil?
    create_folders(config)
    mount_folders(config)
  end
  exit
end

get_system_mounts(shares)

if $cmdoptions[:unmountnamed]
  shares.each do |_name, config|
    next if config['mounts'].nil?
    unmount_folders(config, $cmdoptions[:unmountnamed])
  end
  exit
end

if $cmdoptions[:unmount]
  shares.each do |_name, config|
    next if config['mounts'].nil?
    unmount_folders(config)
  end
  exit
end

shares.each do |_name, config|
  next if config['mounts'].nil?
  show_folders(config)
end
