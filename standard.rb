require_relative "lib/commands"

@commands = Commands.new

%w(rspec cucumber rspec_cucumber_ci letter_opener bullet heroku devise gimlet).each do |cmd|
  apply File.join(File.dirname(__FILE__), "commands", "#{cmd}.rb")
end

@commands.execute(:pre_bundle)
after_bundle { @commands.execute(:post_bundle) }
