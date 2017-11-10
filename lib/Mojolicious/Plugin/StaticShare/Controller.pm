package Mojolicious::Plugin::StaticShare::Controller;
use Mojo::Base 'Mojolicious::Controller';
use HTTP::AcceptLanguage;
use Mojo::Path;
use Mojo::File qw(path);
#~ use Mojo::Home;
use Mojo::Util qw ( decode encode url_unescape);#encode 
use Time::Piece;# module replaces the standard localtime and gmtime functions with implementations that return objects
use Mojolicious::Types;
use Mojo::Asset::File;

has qw(plugin);
has mime => sub { Mojolicious::Types->new };

sub get {
  my ($c) = @_;
  
  $c->_stash();
  my $file_path = $c->stash('file_path');
  
  return $c->dir($file_path)
    if -d $file_path;
  return $c->file($file_path)
    if -e $file_path;

  $c->render_maybe('Mojolicious-Plugin-StaticShare/not_found', status=>404,)
    or $c->reply->not_found;
}

sub post {
  my ($c) = @_;
  $c->_stash();
  my $file_path = $c->stash('file_path');
  return $c->render(json=>{error=>$c->лок('Cant open directory')})
    unless -w $file_path;
  #~ $c->req->max_message_size(0);
  # Check file size
  return $c->render(json=>{error=>$c->лок('file is too big')}, status=>417)
    if $c->req->is_limit_exceeded;

  

  my $file = $c->req->upload('file');
  my $name = url_unescape($c->param('name') || $file->filename);
  my $to = $file_path->child(encode('UTF-8', $name));
  
  return $c->render(json=>{error=>$c->лок('path is not a directory')})
    unless -d $file_path;
  return $c->render(json=>{error=>$c->лок('file already exists')})
    if -f $to;
  
  $file->asset->move_to($to);
  
  my $url_path = $c->stash('url_path');
  push @{ $url_path->parts }, $name;
  
  $c->render(json=>{ok=> $url_path->to_route});
}

sub _stash {
  my ($c) = @_;
  $c->plugin($c->stash('plugin'));
  my $lang = HTTP::AcceptLanguage->new($c->req->headers->accept_language || 'en;q=0.5');
  $c->stash('language' => $lang);
  $c->stash('title' => $c->лок('Share'));
  $c->stash('pth' => Mojo::Path->new($c->stash('pth'))->leading_slash(1)->trailing_slash(0))
    if $c->stash('pth');
  $c->stash('url_path' => Mojo::Path->new(encode('UTF-8', ($c->plugin->config->{root_url} // '')) . ($c->stash('pth') // '')));
  $c->stash('file_path' => path(url_unescape(($c->plugin->config->{root_dir} // '.') . ($c->stash('pth') // ''))));
}

sub dir {
  my ($c, $path) = @_;
  
  my $ex = Mojo::Exception->new($c->лок(qq{Cant open directory}));
  opendir(my $dir, $path)
    or return $c->render_maybe('Mojolicious-Plugin-StaticShare/exception', status=>500, exception=>$ex) #qq{Can't open directory [$path]: $!})
      || $c->reply->exception($ex);
  
  my $files = $c->stash('files' => [])->stash('files');
  my $dirs = $c->stash('dirs' => [])->stash('dirs');
  
  while (readdir $dir) {
    next
      if $_ eq '.' || $_ eq '..';
    next
      if /^\./;
    
    push @$dirs, decode('UTF-8', $_)
      and next
      if -d "$path/$_" && -w _;
    
    next
      unless -f _;
    
    my @stat = stat "$path/$_";
    
    push @$files, {
      name  => decode('UTF-8', $_),
      size  => $stat[7] || 0,
      #~ type  => $c->plugin->mime->type(  (/\.([0-9a-zA-Z]+)$/)[0] || 'txt' ) || 'application/octet-stream',
      mtime => decode 'UTF-8', localtime( $stat[9] )->strftime, #->to_datetime, #to_string(),
      #~ mode=> $stat[2] & 07777, #-r _,
    };
  }
  closedir $dir;

  return $c->render(ref $c->plugin->config->{render_dir} ? %{$c->plugin->config->{render_dir}} : $c->plugin->config->{render_dir},)
    if $c->plugin->config->{render_dir}; 
  
  unless (defined($c->plugin->config->{render_dir}) && $c->plugin->config->{render_dir} eq 0) {
    $c->render_maybe("Mojolicious-Plugin-StaticShare/$_/dir", handler=>'ep',)
      and return
      for $c->stash('language')->languages;
    
    return $c->render('Mojolicious-Plugin-StaticShare/en/dir', handler=>'ep',);
  }
  
  $c->render_maybe('Mojolicious-Plugin-StaticShare/exception', status=>500,exception=>Mojo::Exception->new(qq{Template rendering for path content not found}))
    or $c->reply->exception();
}

sub file {
  my ($c, $path) = @_;
  
  my $ex = Mojo::Exception->new($c->лок(qq{Permission denied}));
  return $c->render_maybe('Mojolicious-Plugin-StaticShare/exception', status=>500,exception=>$ex)
    || $c->reply->exception($ex)
    unless -r $path;
  
  my $filename = $path->basename;
  
  $c->res->headers->content_disposition($c->param('attachment') ? "attachment; filename=$filename;" : "inline");
  my $type  =$c->mime->type(  ( $path =~ /\.([0-9a-zA-Z]+)$/)[0] || 'txt' ) || $c->mime->type('txt');#'application/octet-stream';
  $c->res->headers->content_type($type);
  $c->reply->asset(Mojo::Asset::File->new(path => $path));
  
}

sub markdown {
  my ($c) = @_;
  
  my $content;# TODO
  
  return $c->plugin->config->{render_markdown}
    ? $c->render(ref $c->plugin->config->{render_markdown} ? %{$c->plugin->config->{render_markdown}} : $c->plugin->config->{render_markdown}, content=>$content,)
    : $c->render('Mojolicious-Plugin-StaticShare/markdown', content=>$content, handler=>'ep',);
  
}

1;