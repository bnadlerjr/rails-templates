require "open-uri"

def download(from, to = from.split("/").last)
  file to, open(File.expand_path(File.join("../", from))).read
end

def download_and_patch(from, to)
  if File.exists?(to)
    download(from, "#{to}.new")
    run "diff -Naur #{to} #{to}.new > #{to}.diff"
    run "patch -p0 < #{to}.diff"
    run "rm #{to}.new #{to}.diff"
  else
    download(from, to)
  end
end
