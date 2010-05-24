root = ENV['LOCATION'] || "~/Dev/rails-templates"
require File.expand_path(File.join(root, "lib/utility"))

about = <<-CODE
\n
|-----------------------------------------------------------------------------|
 Standard Rails template. Uses HAML and SASS for templating/CSS (haml must be
 in $PATH).

 IMPORTANT: This template overwrites several files and is meant to be run on a 
            fresh app.
|-----------------------------------------------------------------------------|
CODE

if yes?(about + "\ncontinue?(y/n)")

  run "rm public/index.html"
  run "rm public/favicon.ico"
  run "rm README"
  run "rm public/images/rails.png"
  run "cp config/database.yml config/database.yml.sample"
  run "haml --rails ."

  # Layouts
  download root, 'standard/application.html.haml',
    'app/views/layouts/application.html.haml'

  # Stylesheets
  file 'public/stylesheets/reset.css', <<-CODE
  /* Reset */
  html, body, div, span, object, iframe, h1, h2, h3, h4, h5, h6, p, blockquote, pre, a, abbr, acronym, address, code, del, dfn, em, img, q, dl, dt, dd, ol, ul, li, fieldset, form, label, legend, table, caption, tbody, tfoot, thead, tr, th, td {margin:0;padding:0;border:0;font-weight:inherit;font-style:inherit;font-size:100%;font-family:inherit;vertical-align:baseline;}
  body {line-height:1.5;}
  table {border-collapse:separate;border-spacing:0;}
  caption, th, td {text-align:left;font-weight:normal;}
  table, td, th {vertical-align:middle;}
  blockquote:before, blockquote:after, q:before, q:after {content:"";}
  blockquote, q {quotes:"" "";}
  a img {border:none;}
  CODE

  file 'public/stylesheets/layout.css', <<-CODE
  /* 2 column fixed width layout -- 1024px */

  #container { width:1024px; margin:0 auto; background:#fff; }
  #header { padding:10px 10px 0px 10px; background:#fff;}
  #content { float:left; width:734px; margin-left:10px; margin-right:2px; padding:10px; background:#ccc; }
  .sidebar { float:right; width:226px; margin-left:2px; margin-right:10px; margin-bottom:10px; padding:10px; background:#999; }
  #footer { clear:both; padding:5px 10px; background:#fff; }

  #pri-nav { padding:0; margin:0px 0px 5px 10px; }
  #pri-nav li { display:inline; }
  #pri-nav li a { text-decoration:none; padding:15px 10px; }
  #pri-nav li a img { vertical-align:middle; }
  #pri-nav li a:hover { background-color:#ccc; }
  #pri-nav li a.active { background:url('../images/current.gif') no-repeat 50% 120%; }

  #utility { position:absolute; right:140px; top:10px; }
  #utility li { display: inline; }
  #utility li:before { content:"| "; }
  #utility li:first-child:before { content:""; }
  CODE

  file 'public/stylesheets/type.css', <<-CODE
  /* Typography */
  html {font-size:100.01%;}
  body {font-size:75%;color:#222;background:#fff;font-family:"Helvetica Neue", Arial, Helvetica, sans-serif;}
  h1, h2, h3, h4, h5, h6 {font-weight:normal;color:#111;}
  h1 {font-size:3em;line-height:1;margin-bottom:0.5em;}
  h2 {font-size:2em;margin-bottom:0.75em;}
  h3 {font-size:1.5em;line-height:1;margin-bottom:1em;}
  h4 {font-size:1.2em;line-height:1.25;margin-bottom:1.25em;}
  h5 {font-size:1em;font-weight:bold;margin-bottom:1.5em;}
  h6 {font-size:1em;font-weight:bold;}
  h1 img, h2 img, h3 img, h4 img, h5 img, h6 img {margin:0;}
  p {margin:0 0 1.5em;}
  p img.left {float:left;margin:1.5em 1.5em 1.5em 0;padding:0;}
  p img.right {float:right;margin:1.5em 0 1.5em 1.5em;}
  a:focus, a:hover {color:#000;}
  a {color:#009;text-decoration:underline;}
  blockquote {margin:1.5em;color:#666;font-style:italic;}
  strong {font-weight:bold;}
  em, dfn {font-style:italic;}
  dfn {font-weight:bold;}
  sup, sub {line-height:0;}
  abbr, acronym {border-bottom:1px dotted #666;}
  address {margin:0 0 1.5em;font-style:italic;}
  del {color:#666;}
  pre {margin:1.5em 0;white-space:pre;}
  pre, code, tt {font:1em 'andale mono', 'lucida console', monospace;line-height:1.5;}
  li ul, li ol {margin:0;}
  ul, ol {margin:0 1.5em 1.5em 0;padding-left:3.333em;}
  ul {list-style-type:disc;}
  ol {list-style-type:decimal;}
  dl {margin:0 0 1.5em 0;}
  dl dt {font-weight:bold;}
  dd {margin-left:1.5em;}
  table {margin-bottom:1.4em;width:100%;}
  th {font-weight:bold;}
  thead th {background:#c3d9ff;}
  th, td, caption {padding:4px 10px 4px 5px;}
  tr.even td {background:#e5ecf9;}
  tfoot {font-style:italic;}
  caption {background:#eee;}
  .small {font-size:.8em;margin-bottom:1.875em;line-height:1.875em;}
  .large {font-size:1.2em;line-height:2.5em;margin-bottom:1.25em;}
  .hide {display:none;}
  .quiet {color:#666;}
  .loud {color:#000;}
  .highlight {background:#ff0;}
  .added {background:#060;color:#fff;}
  .removed {background:#900;color:#fff;}
  .first {margin-left:0;padding-left:0;}
  .last {margin-right:0;padding-right:0;}
  .top {margin-top:0;padding-top:0;}
  .bottom {margin-bottom:0;padding-bottom:0;}
  .center {text-align:center;}
  CODE
end
