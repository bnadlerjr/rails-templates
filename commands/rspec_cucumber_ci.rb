@commands.pre_bundle do
  file "bin/ci", <<-CODE
#!/usr/bin/env bash
time (./bin/rspec && ./bin/cucumber)
CODE

  run "chmod +x ./bin/ci"
end
