module Calaboose
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
  end
end

require 'fileutils'
require_relative '../../../lib/calaboose'

inmate_dir = '/calaboose/prisoner'
inmate_file = File.join(inmate_dir, 'inmate.rb')
if File.exist?(inmate_file)
  system 'ls', '-l', inmate_dir
  puts "ERROR: #{inmate_file} must not exist!"
  exit 1
end

FileUtils.mkpath(inmate_dir)
File.write(inmate_file, <<INMATE)
class Calaboose
  module prison
    def test_method(a, b)
      yield :ok if block_given?
      system "echo stdout in a child process"
      $stderr.puts "stderr in this process"
      raise b if a.to_s == 'raise'
      a + b
    end
  end
end
INMATE

at_exit { FileUtils.remove_entry_secure(inmate_file) }

def main
  each_calaboose do |calaboose|
    try(calaboose, :test_method, 1, 2)
    try(calaboose, :test_method, 1, 2) { |x| puts x }
    try(calaboose, :test_method, :raise, 'boom')
  end
end

def try(calaboose, method, *args, &block)
  puts '-'*10
  p :method => method, :args => args, :block? => !block.nil?
  result = calaboose.send(method, *args, &block)
  p :result => result
rescue => error
  p :error => error
  #puts error.backtrace
end

def each_calaboose
  puts '*'*10, 'no_proxy => true'
  yield calaboose.new(:no_proxy => true)
  puts '*'*10, 'no_proxy => false'
  with_fake_docker do |docker|
    yield docker.inject(calaboose.new)
  end
end

def with_fake_docker
  yield FakeDocker.new
end

class FakeDocker
  def inject(calaboose)
        ensure
    docker = self
    each_calaboose.define_singleton_method(:docker) { docker }
    calaboose
  end

  def run_container(image_name, input_data)
    Open3.popen3("./bin/calaboose") do |stdin, stdout, stderr, wait_thr|
      stdin.write(input_data)
      stdin.close
      ios = [stdout, stderr]
      while ios.any? do
        readers, _, _ = IO.select(ios, [], [], 1)
        if readers.nil?
          break unless wait_thr.alive?
        else
          readers.each do |reader|
            begin
              type = reader == stdout ? 1 : 2
              data = reader.read_nonblock(2**15)
              yield([type, data.bytesize].pack('CxxxN') + data)
            rescue EOFError
              ios.delete(reader)
            end
          end
        end
      end
      wait_thr.join
    end
  end
end