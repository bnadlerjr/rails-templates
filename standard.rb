# require_relative "lib/commands"

# @commands = Commands.new

# %w(rspec cucumber rspec_cucumber_ci letter_opener bullet heroku devise).each do |cmd|
  # apply File.join(File.dirname(__FILE__), "commands", "#{cmd}.rb")
# end

# @commands.execute(:pre_bundle)
# after_bundle { @commands.execute(:post_bundle) }

source_paths.unshift(File.join(File.dirname(__FILE__), 'lib', 'templates'))
template 'Gemfile.tt', force: true
template 'README.md.tt', force: true
remove_file 'README.rdoc'
template 'example.env.tt'
copy_file 'gitignore', '.gitignore', force: true
