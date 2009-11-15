require 'metric_fu'

MetricFu::Configuration.run do |config|
  config.metrics = [:churn, :stats, :flog, :flay, :reek, :roodi, :rcov]
  
  # Uncomment next line if ImageMagick, RMagick & Gruff are not installed
  #config.graphs  = []
  
  config.flay    = { :dirs_to_flay  => ['app', 'lib'] }
  config.flog    = { :dirs_to_flog  => ['app', 'lib'] }
  config.reek    = { :dirs_to_reek  => ['app', 'lib'] }
  config.roodi   = { :dirs_to_roodi => ['app', 'lib'] }
  config.churn   = { :start_date    => "1 year ago", :minimum_churn_count => 10}
  config.rcov    = { :test_files    => ['test/**/*_test.rb'],
                     :rcov_opts     => [
                       "--sort coverage", "--no-html", "--text-coverage", "--no-color", "--profile", 
                       "--rails", "--exclude /gems/,/Library/,spec", "-Itest"
                     ]
                   }
end