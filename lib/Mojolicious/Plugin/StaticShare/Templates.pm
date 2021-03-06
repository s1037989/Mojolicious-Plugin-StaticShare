package Mojolicious::Plugin::StaticShare::Templates;
use utf8;

=pod

=encoding utf8

Доброго всем

=head1 Mojolicious::Plugin::StaticShare::Templates

¡ ¡ ¡ ALL GLORY TO GLORIA ! ! !

=head1 NAME

Mojolicious::Plugin::StaticShare::Templates - internal defaults templates.

=head1 TEMPLATES

=head2 layouts/Mojolicious-Plugin-StaticShare/main.html.ep

One main layout.

=head2 Mojolicious-Plugin-StaticShare/header.html.ep

One included header for templates.

=head2 Mojolicious-Plugin-StaticShare/dir.html.ep

Template for render dir content: subdirs, files, markdown index file.

=head2 Mojolicious-Plugin-StaticShare/markdown.html.ep

Template for render parsed content of markdown files.

=head2 Mojolicious-Plugin-StaticShare/pod.html.ep

Template for render parsed content of Perl pod files(.pod, .pl, .pm).

=head2 Mojolicious-Plugin-StaticShare/not_found.html.ep

Template for render 404.

=head2 Mojolicious-Plugin-StaticShare/exception.html.ep

Template for render 500.

=head2 Mojolicious-Plugin-StaticShare/edit.html.ep

File content editor (with ace.js)

=cut
1;
__DATA__

@@ layouts/Mojolicious-Plugin-StaticShare/main.html.ep
<!DOCTYPE html>
<html>
<head>
<title><%= stash('title') || i18n 'Share'  %></title>


%# http://realfavicongenerator.net
<link rel="apple-touch-icon" sizes="152x152" href="/apple-touch-icon.png">
<link rel="icon" type="image/png" href="/favicon-32x32.png" sizes="32x32">
<link rel="icon" type="image/png" href="/favicon-16x16.png" sizes="16x16">
<link rel="manifest" href="/manifest.json">
<link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5">
<meta name="theme-color" content="#ffffff">

<link href="/static-share/css/main.css" rel="stylesheet">

<style type="text/css" media="screen">

% if (stash('pod')) {
pre {
  background-color: #fafafa;
  border: 1px solid #c1c1c1;
  border-radius: 3px;
  font-size: 100%;
  padding: 1em;
}

:not(pre) > code {
  background-color: rgba(0, 0, 0, 0.04);
  border-radius: 3px;
  font-size: 0.9em;
  padding: 0.3em;
}

% }

</style>

<meta name="app:name" content="<%= stash('app:name') // 'Mojolicious::Plugin::StaticShare' %>">
%#<meta name="app:version" content="<%= stash('app:version') // 0.01 %>">
<meta name="url:version" content="<%= stash('app:version') // 0.01 %>">

</head>
<body class="white">

%= include 'Mojolicious-Plugin-StaticShare/header';

<main><div class="container clearfix"><%= stash('content') || content %></div></main>

<script src="/mojo/jquery/jquery.js"></script>
<script src="/static-share/js/jquery.ui.widget.js"></script>
<script src="/static-share/js/jquery.fileupload.js"></script>
<script src="/static-share/js/velocity.min.js"></script>
<script src="/static-share/js/modal.js"></script>
<script src="/static-share/js/dropdown.js"></script>
<script src="/static-share/js/main.js"></script>

% if (param('edit')) {
<script src="/static-share/js/ace.js" type="text/javascript" charset="utf-8"></script>
% }

%= javascript begin
  ///console.log('Доброго всем!! ALL GLORY TO GLORIA');
% end

</body>
</html>

@@ Mojolicious-Plugin-StaticShare/dir.html.ep
% layout 'Mojolicious-Plugin-StaticShare/main';

<div class="row show-on-ready" style="display:none;"><%#= @$dirs || @$files ? '' : 'style="min-height: calc(80vh);" ' %>
% if (@$dirs || $c->is_admin) {
<div class="dirs-col col s6" style="">

% if ($c->is_admin) {
<div class="chip right card000 lime lighten-5 btn-panel" style="">
  <a href="javascript:" class="block000 btn-flat hide renames" style="padding:0 0.5rem;"><svg xmlns="http://www.w3.org/2000/svg" class="icon icon15 black-fill"  viewBox="0 0 26 26"><use xlink:href="/static-share/fonts/icons.svg#rename" /></svg></a>
  <a href="javascript:" class="block000 btn-flat hide del-dirs" style="padding:0 0.5rem;"><svg xmlns="http://www.w3.org/2000/svg" class="icon icon15 red-fill fill-lighten-1" viewBox="0 0 50 50"><use xlink:href="/static-share/fonts/icons.svg#dir-delete" /></svg></a>
  <a id="add-dir" href="javascript:" class="block000 btn-flat" style="padding:0 0.5rem;">
    <svg xmlns="http://www.w3.org/2000/svg" class="icon icon15 lime-fill fill-darken-4" viewBox="0 0 50 50"><use xlink:href="/static-share/fonts/icons.svg#add-dir" /></svg>
    <!--span class="lime-text text-darken-4"><%= i18n 'Add dir' %></span-->
  </a>
</div>

% }

<h2 class="lime-text text-darken-4 center000">
%#  <svg xmlns="http://www.w3.org/2000/svg" class="icon icon15 lime-fill fill-darken-4"  viewBox="0 0 30 30"><use xlink:href="/static-share/fonts/icons.svg#folder" /></svg>
%# <%= i18n 'Down' %>
  <svg xmlns="http://www.w3.org/2000/svg" class="icon icon15 lime-fill fill-darken-4" viewBox="0 0 50 50"><use xlink:href="/static-share/fonts/icons.svg#down-right-round" /></svg>
  <span class=""><%= i18n 'Dirs' %></span>
  <sup class="chip lime lighten-5" style="padding:0.3rem;"><%= scalar @$dirs %></sup>
</h2>

<div class="progress progress-dir white" style="margin:0; padding:0;">
    <div class="determinate lime" style="width: 0%"></div>
</div>

<div class="<%= stash('index') ? 'scroll-50vh' : 'scroll-75vh' %> card"><table class="dirs" style="">
  <thead class="hide">
    <tr class="new-dir lime darken-4" style="border-bottom: 1px solid #e0e0e0;"><!-- template new folder -->
      <td style="width:1%;">
        <svg xmlns="http://www.w3.org/2000/svg" class="icon icon12 lime-fill fill-lighten-5" style="margin:0 0.5rem;" viewBox="0 0 50 50"><use xlink:href="/static-share/fonts/icons.svg#add-dir" /></svg>
      </td>
      <td style="">
        <div class="input-field">
          <input type="text" name="dir-name" class="" style="width:100%;" placeholder="<%= i18n 'new dir name'%>" >
        </div>
        <a class="lime-text text-lighten-5 dir hide" style="display:block;"></a>
        <div class="red-text error"></div>
      </td>
      <td class="action" style="width:1%;">
        <a href="javascript:" _href="<%= $url_path->to_route %>" class="save-dir">
          <svg xmlns="http://www.w3.org/2000/svg" class="icon icon12 lime-fill fill-lighten-5" viewBox="0 0 26 26"><use xlink:href="/static-share/fonts/icons.svg#upload" /></svg>
        </a>
      </td>
      <td class="chb" style="width:1%;">
        <input type="checkbox" name="dir-check" style="margin: 0 0.5rem;">
      </td>
    </tr>
  </thead>
  <tbody>
  % for my $dir (sort  @$dirs) {
  % my $url = $url_path->clone->merge($dir)->trailing_slash(1)->to_route;
    <tr class="dir lime lighten-5" style="border-bottom: 1px solid #e0e0e0;">
      <td style="width:1%;">
        <svg xmlns="http://www.w3.org/2000/svg" class="icon icon12 lime-fill fill-darken-4" style="margin:0 0.5rem;" viewBox="0 0 30 30"><use xlink:href="/static-share/fonts/icons.svg#folder" /></svg>
      </td>
      <td style="">
        <div class="input-field hide">
           <input type="text" name="dir-name" class="" style="width:100%;" placeholder="<%= i18n 'new dir name'%>" value="<%== $dir %>">
        </div>
        <a href="<%= $url %>" class="lime-text text-darken-4 dir" style="display:block;"><%== $dir %></a>
        <div class="red-text error"></div>
      </td>
      <td class="action" style="width:1%;">
        <a href="javascript:" _href="<%= $url %>" class="save-dir hide">
          <svg xmlns="http://www.w3.org/2000/svg" class="icon icon12 lime-fill fill-darken-4" viewBox="0 0 26 26"><use xlink:href="/static-share/fonts/icons.svg#upload" /></svg>
        </a>
      </td>
      <td class="chb" style="width:1%;">
% if ($c->is_admin) { # delete dir
          <input type="checkbox" name="dir-check" style="margin: 0 0.5rem;">
% }
      </td>
    </tr>
  % }
  </tbody>
</table></div>

</div>
% }

% if (@$files || $c->is_admin || $c->public_uploads) {
<div class="files-col col s6" style="">

% if ($c->is_admin || $c->public_uploads) {
<div class="chip right card000 light-blue lighten-5 btn-panel" style="">
  <a href="javascript:" class="block000 btn-flat hide renames" style="padding:0 0.5rem;"><svg xmlns="http://www.w3.org/2000/svg" class="icon icon15 black-fill"  viewBox="0 0 26 26"><use xlink:href="/static-share/fonts/icons.svg#rename" /></svg></a>
  <a href="javascript:" class="block000 btn-flat hide del-files" style="padding:0 0.5rem;"><svg xmlns="http://www.w3.org/2000/svg" class="icon icon15 red-fill fill-lighten-1"  viewBox="0 0 26 26"><use xlink:href="/static-share/fonts/icons.svg#file-delete" /></svg></a>
  <label for="fileupload" class="block000 btn-flat" style="padding:0 0.5rem;">
    <svg xmlns="http://www.w3.org/2000/svg" class="icon icon15 light-blue-fill fill-darken-1" viewBox="0 0 26 26"><use xlink:href="/static-share/fonts/icons.svg#add-item" /></svg>
    <!--span class="blue-text"><%= i18n 'Add uploads'%></span-->
  </label>
  <input id="fileupload" style="display:none;" type="file" name="file" data-url="<%= $url_path->clone->trailing_slash(0) %>" multiple>
  
</div>

% }

<h2 class="light-blue-text text-darken-2 center000">
  <%= i18n 'Files'%>
  <sup class="chip light-blue lighten-5" style="padding:0.3rem;"><%= scalar @$files %></sup>
</h2>

<div class="progress progress-file white" style="margin:0; padding:0;">
    <div class="determinate blue" style="width: 0%"></div>
</div>

<div class="<%= stash('index') ? 'scroll-50vh' : 'scroll-75vh' %> card"><table class="striped files light-blue lighten-5" style="">
%#<thead>
%#  <tr>
%#    <th class="name"><%= i18n 'Name'%></th>
%#    <th class="action" style="width:1%;"></th>
%#    <th class="size center"><%= i18n 'Size'%></th>
%#    <!--th class="type">Type</th-->
%#    <th class="mtime center"><%= i18n 'Last Modified'%></th>
%#  </tr>
%#</thead>
<thead class="hide">
  <tr class="light-blue" style="border-bottom: 1px solid #e0e0e0;"><!--- new upload file template -->
    <td class="chb" style="width:1%;">
      <input type="checkbox" name="file-check" class="" style="margin:0 0.5rem;">
    </td>
    <td class="name" style="">
      <a class="file-view hide"></a>
      <input type="text" name="file-name" value="" class="" style="width:100%;">
      <div class="red-text error"></div>
    </td>
    <td class="action" style="width:1%;">
      <a href="" class="file-download hide" style="padding:0.1rem;"><svg xmlns="http://www.w3.org/2000/svg" class="icon icon12 light-blue-fill fill-darken-1" style="height:1.2rem;" viewBox="0 0 26 26"><use xlink:href="/static-share/fonts/icons.svg#download" /></svg></a>
      <a href="javascript:" _href="" class="file-rename hide" style="padding:0.1rem;"><svg xmlns="http://www.w3.org/2000/svg" class="icon icon12" viewBox="0 0 26 26"><use xlink:href="/static-share/fonts/icons.svg#upload" /></svg></a>
      <a href="javascript:" class="file-upload"><svg xmlns="http://www.w3.org/2000/svg" class="icon icon12 white-fill" viewBox="0 0 26 26"><use xlink:href="/static-share/fonts/icons.svg#upload" /></svg></a>
    </td>
    <td class="size right-align fs8" style="width:1%;"></td>
    <!--td class="type"></td-->
    <td class="mtime right-align fs8" style=""></td>
  </tr>
</thead>
<tbody>
  % for my $file (sort { $a->{name} cmp $b->{name} } @$files) {
  % my $href = $url_path->clone->merge($file->{name})->to_route;
  <tr class="" style="border-bottom: 1px solid #e0e0e0;">
    <td class="chb" style="width:1%;">
% if ($c->is_admin) {
      <input type="checkbox" name="file-check"  class="" style="margin:0 0.5rem;">
% }
    </td>

    <td class="name" style="">
      <a href="<%= $href %>" class="file-view"><%== $file->{name} %></a>
      <input type="text" name="file-name" value="<%== $file->{name} %>" class="hide" style="width:100%;">
      <div class="red-text error hide"></div>
    </td>
    <td class="action" style="width:1%;">
      <a href="<%= $href %>?attachment=1" class="file-download" style="padding:0.1rem;"><svg xmlns="http://www.w3.org/2000/svg" class="icon icon12 light-blue-fill fill-darken-1" style000="height:1.2rem;" viewBox="0 0 26 26"><use xlink:href="/static-share/fonts/icons.svg#download" /></svg></a>
      
% if ($c->is_admin) {
      <a href="<%= $href %>?edit=1" class="file-edit hide" style="padding:0.1rem;"><svg xmlns="http://www.w3.org/2000/svg" class="icon icon12 light-blue-fill fill-darken-1" style000="height:1.2rem;" viewBox="0 0 252 252"><use xlink:href="/static-share/fonts/icons.svg#edit-file" /></svg></a>
% }

      <a href="javascript:" _href="<%= $href %>" class="file-rename hide" style="padding:0.1rem;"><svg class="icon icon12" viewBox="0 0 26 26"><use xlink:href="/static-share/fonts/icons.svg#upload" /></svg></a>

    </td>
    <td class="size right-align fs8" style="width:1%;"><%= $file->{size} %></td>
    <!--td class="type"><%= $file->{type} %></td-->
    <td class="mtime right-align fs8" style=""><%= $file->{mtime} %></td>
  </tr>
  % }
</tbody>
</table></div>

</div><!-- col files -->
% }
</div><!-- row -->

% if (stash 'index') {
  <h4 class="right-align grey-text" title="<%= i18n 'below to the end' %>"><%= stash 'index' %></h4>
% }
% if (stash('markdown') || stash('pod')) {
  <div class="card index-file show-on-ready" style="display:none;"><%== stash('markdown') || stash('pod') || '' %></div>
% }

%= include 'Mojolicious-Plugin-StaticShare/confirm-modal';

<div id="footer">
  Powered by
  <a href="http://mojolicious.org">
    <picture>
      <img class="logo" src="/mojo/logo-black.png" srcset="/mojo/logo-black-2x.png 2x" alt="Mojolicious logo">
    </picture>
  </a>
</div>

@@ Mojolicious-Plugin-StaticShare/header.html.ep

<header class="container clearfix">

% if ($c->is_admin && $c->plugin->config->{admin_nav}) {
  <%== ref($c->plugin->config->{admin_nav}) eq 'CODE' ? $c->plugin->config->{admin_nav}($c) : $c->plugin->config->{admin_nav} %>
% }

<h1>
  % if (param 'edit') {
  <%= i18n 'Edit'%>
  % } else {
  <%= i18n 'Index of'%>
  % }

% unless (@{$url_path->parts}) {
  <a href="<%= $url_path %>" class="chip grey-text grey lighten-4"><%= i18n 'root' %></a>
% }
% my $con;
% for my $part (@{$url_path->parts}) {
%   $con .="/$part";
  <a href="<%= $con %>" class="chip card maroon-text maroon lighten-5"><%= $part %></a>
% }

% if ($c->plugin->root_url->to_route ne $url_path->to_route) {
  <a href="<%= $url_path->clone->trailing_slash(0)->to_dir %>" class="btn-flat000 chip right nowrap" style="">
    <svg xmlns="http://www.w3.org/2000/svg" class="icon icon15 maroon-fill" viewBox="0 0 50 50"><use xlink:href="/static-share/fonts/icons.svg#up-left-round" /></svg>
    <span class="maroon-text"><%= i18n 'Up'%></span>
  </a>
% }

</h1>
<hr />
</header>


@@ Mojolicious-Plugin-StaticShare/markdown.html.ep
% layout 'Mojolicious-Plugin-StaticShare/main' unless layout;
<%== stash('markdown') || stash('content') || 'none content' %>

@@ Mojolicious-Plugin-StaticShare/pod.html.ep
% layout 'Mojolicious-Plugin-StaticShare/main' unless layout;
<%== stash('pod') || stash('content') || 'none content' %>

@@ Mojolicious-Plugin-StaticShare/not_found.html.ep
% layout 'Mojolicious-Plugin-StaticShare/main';
<h2 class="red-text">404 <%= i18n 'Not found'%></h2>

@@ Mojolicious-Plugin-StaticShare/exception.html.ep
% layout 'Mojolicious-Plugin-StaticShare/main';
% title i18n 'Error';

<h2 class="red-text">500 <%= i18n 'Error'%></h2>

% if(my $msg = $exception && $exception->message) {
%   utf8::decode($msg);
    <h3 id="error" style="white-space:pre;" class="red-text"><%= $msg %></h3>
% }


@@ Mojolicious-Plugin-StaticShare/confirm-modal.html.ep
<!-- Modal Structure -->
<div id="confirm-modal" class="modal bottom-sheet modal-fixed-footer">
  <div class="modal-header hide">
    <h2 class="red-text del-files"><span><%= i18n 'Confirm to delete these files' %></span><sup class="chip red lighten-5" style="padding:0.3rem;"></sup></h2>
    <h2 class="red-text del-dirs"><span><%= i18n 'Confirm to delete these dirs' %></span><sup class="chip red lighten-5" style="padding:0.3rem;"></sup></h2>
    <h2 class="red-text foo">Foo header</h2>
  </div>
  <div class="modal-content"></div>
  <div class="modal-footer green lighten-5">
    <a href="javascript:" class="modal-action modal-close green-text waves-effect waves-green btn-flat">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon15 green-fill" viewBox="0 0 50 50"><use xlink:href="/static-share/fonts/icons.svg#confirm" /></svg>
      <%= i18n 'I AM SURE' %>
    </a>
  </div>
</div>

@@ Mojolicious-Plugin-StaticShare/edit.html.ep
% layout 'Mojolicious-Plugin-StaticShare/main';

<div class="show-on-ready" style="display:none;">
  <pre id="editor"><%= $edit %></pre>
</div>


<div class="right-align action">
  <span class="green-text success hide"><%= i18n 'Success saved'%></span>
  <span class="red-text fail hide"><%= i18n 'Success saved'%></span>
  
  <a href="javascript:" _href="<%= $url_path->clone->trailing_slash(0)->to_route %>" class="save btn-flat blue-text">
    <svg xmlns="http://www.w3.org/2000/svg" class="icon icon15 blue-fill" viewBox="0 0 24 24"><use xlink:href="/static-share/fonts/icons.svg#save" /></svg>
    <span><%= i18n 'Save'%></span>
  </a>
  
</div>