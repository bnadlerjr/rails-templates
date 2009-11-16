ABOUT = <<-CODE
\n
|---------------------------------------------------------------------------------|
 Standard Rails template.

 IMPORTANT: This template overwrites several files and is meant to be run on a 
            fresh app.
|---------------------------------------------------------------------------------|
CODE

if yes?(ABOUT + "\ncontinue?(y/n)")

  run "rm public/index.html"
  run "rm public/favicon.ico"
  run "rm README"
  run "rm public/images/rails.png"
  run "cp config/database.yml config/database.yml.sample"

  # Layouts
  file 'app/views/layouts/application.html.erb', <<-CODE
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

  <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
  <head>
  	<title><%= yield(:title) || 'INSERT PAGE TITLE!!' %></title>
  	<%= stylesheet_link_tag :all, :cache => true %>
  	<%= javascript_include_tag :all, :cache => true %>
  </head>

  <body>
  	<div id="container">
  		<div id="header">
  			<h1>Site ID</h1>
  			<ol id="pri-nav">
  				<li>
  					<% link_to("#", :class => "active large") do %>
  					<%= image_tag("icon_home.png") %>
  					Home
  					<% end -%>
  				</li>
  				<li>
  					<% link_to("#", :class => "large") do %>
  					<%= image_tag("icon_pie_chart.png") %>
  					Item 2
  					<% end -%>
  				</li>
  				<li>
  					<% link_to("#", :class => "large") do %>
  					<%= image_tag("icon_email.png") %>
  					Item 3
  					<% end -%>
  				</li>
				<% admin_only do -%>
  				<li>
  					<% link_to(users_path, :class => "large") do %>
  					<%= image_tag("icon_user.png") %>
  					Manage Users
  					<% end -%>
  				</li>
				<% end -%>
  			</ol>
  			<ol id="utility">
				<% anonymous_only do -%>
				<li><%= link_to "Login", login_path %></li>
				<% end -%>
				<% authenticated_only do -%>
				<li><%= link_to h(current_user.email), user_path(current_user) %></li>
				<li><%= link_to "Logout", logout_path, :method => :delete %></li>
				<% end -%>
  				<li><%= link_to "Help", "#", :class => 'highlight' %></li>
  			</ol>
  		</div>

  		<div id="content" class="rounded">
  			<h2><%= yield(:title) || 'INSERT PAGE TITLE!!' %></h2>
  			<%= yield %>
  		</div>

  		<div id="sidebar-wrapper">
  			<div id="search" class="sidebar rounded">
  				Search
  			</div>
  			<ol id="sec-nav" class="sidebar rounded">
  				<li class="active"><%= link_to "Sub 1", "#" %></li>
  				<li><%= link_to "Sub 2", "#" %></li>
  				<li><%= link_to "Sub 3", "#" %></li>
  			</ol>

  			<div class="sidebar rounded">
  				<% flash.each do |key, msg| -%>
  					<%= content_tag :p, msg, :class => key %>
  				<% end -%>
  				<%= yield(:sec_content) || '<p>Secondary content.</p>' %>
  			</div>
  		</div>

  		<div id="footer">
  			<hr/>
  			<p class="quiet small center">Footer text goes here.</p>
  		</div>
  	</div>
  </body>
  </html>
  CODE

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

  # Javascripts
  file 'public/javascripts/application.js', <<-CODE
  Event.observe(window, 'load', function() {
  	// Rounds all corners of any element with a class of 'rounded'
  	$$('.rounded').each(function(item) { new Effect.Corner(item, "round 15px"); });
  });
  CODE

  file 'public/javascripts/corners.js', <<-CODE
  /*
   * Prototype/Scriptaculous corner plugin version 0.1 (6/29/2007)
   *
   * Based on the jQuery corner plugin version 1.7 (1/26/2007)
   *
   * Dual licensed under the MIT and GPL licenses:
   *   http://www.opensource.org/licenses/mit-license.php
   *   http://www.gnu.org/licenses/gpl.html
   */

  /**
   * The Effect.Corner class provides a simple way of styling DOM elements.  
   *
   * Effect.Corner constructor takes two arguments:  new Effect.Corner(element, "effect corners width")
   *
   *   effect:  The name of the effect to apply, such as round or bevel. 
   *            If you don't specify an effect, rounding is used.
   *
   *   corners: The corners can be one or more of top, bottom, tr, tl, br, or bl. 
   *            By default, all four corners are adorned. 
   *
   *   width:   The width specifies the width of the effect; in the case of rounded corners this 
   *            will be the radius of the width. 
   *            Specify this value using the px suffix such as 10px, and yes it must be pixels.
   *
   * For more details see: http://methvin.com/jquery/jq-corner.html
   * For a full demo see:  http://malsup.com/jquery/corner/
   *
   *
   * @example new Effect.Corner(element);
   * @desc Create round, 10px corners 
   *
   * @example new Effect.Corner(element, "25px");
   * @desc Create round, 25px corners 
   *
   * @name corner
   * @type scriptaculous
   * @author Ilia Lobsanov (first name @ last name dot com)
   */
  Effect.Corner = Class.create();
  Object.extend(Object.extend(Effect.Corner.prototype, Effect.Base.prototype), {
      hex2: function (s) {
          var s = parseInt(s).toString(16);
          return ( s.length < 2 ) ? '0'+s : s;
      },
      gpc: function (node) {
          for ( ; node && node.nodeName.toLowerCase() != 'html'; node = node.parentNode  ) {
              var v = Element.getStyle(node, 'backgroundColor');
              if ( v.indexOf('rgb') >= 0 ) { 
                  rgb = v.match(/\d+/g); 
                  return '#'+ this.hex2(rgb[0]) + this.hex2(rgb[1]) + this.hex2(rgb[2]);
              }
              if ( v && v != 'transparent' )
                  return v;
          }
          return '#ffffff';
      },
      getW: function (i) {
          switch(this.fx) {
          case 'round':  return Math.round(this.width*(1-Math.cos(Math.asin(i/this.width))));
          case 'cool':   return Math.round(this.width*(1+Math.cos(Math.asin(i/this.width))));
          case 'sharp':  return Math.round(this.width*(1-Math.cos(Math.acos(i/this.width))));
          case 'bite':   return Math.round(this.width*(Math.cos(Math.asin((this.width-i-1)/this.width))));
          case 'slide':  return Math.round(this.width*(Math.atan2(i,this.width/i)));
          case 'jut':    return Math.round(this.width*(Math.atan2(this.width,(this.width-i-1))));
          case 'curl':   return Math.round(this.width*(Math.atan(i)));
          case 'tear':   return Math.round(this.width*(Math.cos(i)));
          case 'wicked': return Math.round(this.width*(Math.tan(i)));
          case 'long':   return Math.round(this.width*(Math.sqrt(i)));
          case 'sculpt': return Math.round(this.width*(Math.log((this.width-i-1),this.width)));
          case 'dog':    return (i&1) ? (i+1) : this.width;
          case 'dog2':   return (i&2) ? (i+1) : this.width;
          case 'dog3':   return (i&3) ? (i+1) : this.width;
          case 'fray':   return (i%2)*this.width;
          case 'notch':  return this.width; 
          case 'bevel':  return i+1;
          }
      },
      initialize: function(element, o) {
          element = $(element);
          o = (o||"").toLowerCase();
          var keep = /keep/.test(o);                       // keep borders?
          var cc = ((o.match(/cc:(#[0-9a-f]+)/)||[])[1]);  // corner color
          var sc = ((o.match(/sc:(#[0-9a-f]+)/)||[])[1]);  // strip color
          this.width = parseInt((o.match(/(\d+)px/)||[])[1]) || 10; // corner width
          var re = /round|bevel|notch|bite|cool|sharp|slide|jut|curl|tear|fray|wicked|sculpt|long|dog3|dog2|dog/;
          this.fx = ((o.match(re)||['round'])[0]);
          var edges = { T:0, B:1 };
          var opts = {
              TL:  /top|tl/.test(o),       TR:  /top|tr/.test(o),
              BL:  /bottom|bl/.test(o),    BR:  /bottom|br/.test(o)
          };
          if ( !opts.TL && !opts.TR && !opts.BL && !opts.BR )
              opts = { TL:1, TR:1, BL:1, BR:1 };
          var strip = document.createElement('div');
          strip.style.overflow = 'hidden';
          strip.style.height = '1px';
          strip.style.backgroundColor = sc || 'transparent';
          strip.style.borderStyle = 'solid';
          var pad = {
              T: parseInt(Element.getStyle(element,'paddingTop'))||0,     R: parseInt(Element.getStyle(element,'paddingRight'))||0,
              B: parseInt(Element.getStyle(element,'paddingBottom'))||0,  L: parseInt(Element.getStyle(element,'paddingLeft'))||0
          };

          if ( /MSIE/.test(navigator.userAgent) ) element.style.zoom = 1; // force 'hasLayout' in IE
          if (!keep) element.style.border = 'none';
          strip.style.borderColor = cc || this.gpc(element.parentNode);
          var cssHeight = Element.getHeight(element);

          for (var j in edges) {
              var bot = edges[j];
              strip.style.borderStyle = 'none '+(opts[j+'R']?'solid':'none')+' none '+(opts[j+'L']?'solid':'none');
              var d = document.createElement('div');
              var ds = d.style;

              bot ? element.appendChild(d) : element.insertBefore(d, element.firstChild);

              if (bot && cssHeight != 'auto') {
                  if (Element.getStyle(element,'position') == 'static')
                      element.style.position = 'relative';
                  ds.position = 'absolute';
                  ds.bottom = ds.left = ds.padding = ds.margin = '0';
                  if (/MSIE/.test(navigator.userAgent))
                      ds.setExpression('width', 'this.parentNode.offsetWidth');
                  else
                      ds.width = '100%';
              }
              else {
                  ds.margin = !bot ? '-'+pad.T+'px -'+pad.R+'px '+(pad.T-this.width)+'px -'+pad.L+'px' : 
                                      (pad.B-this.width)+'px -'+pad.R+'px -'+pad.B+'px -'+pad.L+'px';                
              }

              for (var i=0; i < this.width; i++) {
                  var w = Math.max(0,this.getW(i));
                  var e = strip.cloneNode(false);
                  e.style.borderWidth = '0 '+(opts[j+'R']?w:0)+'px 0 '+(opts[j+'L']?w:0)+'px';
                  bot ? d.appendChild(e) : d.insertBefore(e, d.firstChild);
              }
          }
      }
  });
  CODE
end