require 'open-uri'
  
def download(from, to = from.split("/").last)
  file to, open("http://github.com/thethirdswitch/rails-templates/raw/master/metric_fu/#{from}").read
end

ABOUT = <<-CODE
\n
|---------------------------------------------------------------------------------|
 Rails template for setting up metric_fu.

  * Creates / overwrites metric_fu.rake
|---------------------------------------------------------------------------------|
CODE

if yes?(ABOUT + "\ncontinue?(y/n)")
  gem 'relevance-rcov', :environment => :test, :lib => 'rcov'
  gem 'ruby-prof', :environment => :test
  gem 'jscruggs-metric_fu', :environment => :test, :lib => 'metric_fu'
  gem 'reek', :environment => :test
  gem 'roodi', :environment => :test

  download "metric_fu.rake", "lib/tasks/metric_fu.rake"
end