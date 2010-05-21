require "open-uri"

def download(template_root, from, to = from.split("/").last)
  file to, open(File.expand_path(File.join(template_root, from))).read
end

def download_and_patch(template_root, from, to)
  if File.exists?(to)
    download(template_root, from, "#{to}.new")
    run "diff -Naur #{to} #{to}.new > #{to}.diff"
    run "patch -p0 < #{to}.diff"
    run "rm #{to}.new #{to}.diff"
  else
    download(template_root, from, to)
  end
end
