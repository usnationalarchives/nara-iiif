desc "Generate keys suitable for SECRET_KEY_BASE"
task :secrets do

  def key_from_urandom
    [IO.read("/dev/urandom", 64)].pack("m*").tr("=+/\n","").slice(0, 64)
  end

  puts "SECRET_KEY_BASE=#{key_from_urandom}"

end
