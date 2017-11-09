package Mojolicious::Plugin::StaticShare;
use Mojo::Base 'Mojolicious::Plugin';
use Mojo::File qw(path);

our $VERSION = '0.01';

has qw(config);

sub register {
  my ($self, $app, $args) = @_;
  $self->config($args);
  
  require Mojolicious::Plugin::StaticShare::Templates
    and push @{$app->renderer->classes}, __PACKAGE__."::Templates"
    and push @{$app->static->paths}, path(__FILE__)->sibling('StaticShare')->child('static')  #->dirname.'/StaticShare/static' # #__PACKAGE__."::Static"
    unless defined($args->{render_dir}) && $args->{render_dir} eq 0
          && defined($args->{render_markdown}) && $args->{render_markdown} eq 0;
  #~ warn path(__FILE__)->dirname.'/StaticShare/static';
  #~ warn "$_ => $INC{$_}" for sort keys %INC;
  
  $args->{root_url} ||= '';
  $args->{root_url}  =~ s|/$||;
  #~ utf8::decode($args->{root_url});
  
  my $route = "$args->{root_url}/*pth";
  my $r = $app->routes;
  $r->get($args->{root_url})->to(namespace=>__PACKAGE__, controller=>"Controller", action=>'get', pth=>'', plugin=>$self)->name('Plugin-StaticShare-ROOT');#cb => sub { $self->get(@_) },
  $r->post($args->{root_url})->to(namespace=>__PACKAGE__, controller=>"Controller", action=>'post', pth=>'', plugin=>$self)->name('Plugin-StaticShare-ROOT-POST');
  $r->get($route)->to(namespace=>__PACKAGE__, controller=>"Controller", action=>'get', plugin=>$self )->name('Plugin-StaticShare-GET');
  $r->post($route)->to(namespace=>__PACKAGE__, controller=>"Controller", action=>'post', plugin=>$self )->name('Plugin-StaticShare-POST');

  $app->helper(лок => sub { &лок(@_) });
  
  return $app;
}

my %loc = (
  'ru-ru'=>{
    'Not found'=>"Не найдено",
    'Disabled index of'=>"Заблокирован вывод содержания",
    'Share'=>'Обзор',
    'Index of'=>'Содержание',
    'Dirs'=>'Каталоги',
    'Files'=>'Файлы',
    'Name'=>'Название файла',
    'Size'=>'Размер',
    'Last Modified'=>'Дата изменения',
    'Up'=>'Выше',
    'Add uploads'=>'Добавить файлы',
    'root path'=>"корень",
    'Uploading'=>'Загружается',
    
  },
);
sub лок {# helper
  my ($c, $str, $lang) = @_;
  #~ $lang //= $c->stash('language');
  my $loc;
  for ($c->stash('language')->languages) {
    return $str
      if /en/;
    $loc = $loc{$_} || $loc{lc $_} || $loc{lc "$_-$_"}
      and last;
  }
  return $loc->{$str} || $loc->{lc $str} || $str
    if $loc;
  return $str;
}


1;
=pod

=encoding utf8

Доброго всем

=head1 Mojolicious::Plugin::StaticShare

¡ ¡ ¡ ALL GLORY TO GLORIA ! ! !

=head1 NAME

Mojolicious::Plugin::StaticShare - browse, upload, copy, move, delete static files/dirs.

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('StaticShare', <options>);

  # Mojolicious::Lite
  plugin 'StaticShare', <options>;
  
  # oneliner
  > perl -MMojolicious::Lite -E 'plugin("StaticShare", root_url=>"/my/share",)->start' daemon


=head1 DESCRIPTION

This plugin for share static files/dirs and has two interfaces: public and admin:

=head2 Public interface

Can browse and put files if name not exists.

=head2 Admin interface

Can copy, move, delete files/dirs

Place param C<< admin=<admin_pass option> >> to any url inside B<root_url> option (see below).

=head1 OPTIONS

=head2 root_dir

Absolute or relative file system path root directory. Defaults to '.'.

  root_dir => '/mnt/usb',
  root_dir => 'here', 

=head2 root_url

This prefix to url path. Defaults to '/'.

  root_url => '/', # mean route '/*path'
  root_url => '', # mean also route '/*path'
  root_url => '/my/share', # mean route '/my/share/*path'

See L<Mojolicious::Guides::Routing#Wildcard-placeholders>.

=head2 admin_pass

Admin password (be sure https) for admin tasks. None defaults.

  admin_pass => '$%^!!9nes--', # 

Signin to admin interface C< https://myhost/my/share/foo/bar?admin=$%^!!9nes-- >

=head2 render_dir

Template path, format, handler, etc  which render directory index. Defaults to builtin things.

  render_dir => 'foo/dir_index', 
  render_dir => {template => 'foo/my_directory_index', foo=>...},
  # Disable directory index
  render_dir => 0,
  

=head2 render_markdown

Same as B<render_dir> but for markdown files. Defaults to builtin things.

  render_markdown =>  'foo/markdown',
  render_markdown => {template => 'foo/markdown', foo=>...},
  # Disable markdown
  render_markdown => 0,


=head1 METHODS

L<Mojolicious::Plugin::StaticShare> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious::Plugin::Directory>

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicious.org>.

=head1 AUTHOR

Михаил Че (Mikhail Che), C<< <mche[-at-]cpan.org> >>

=head1 BUGS / CONTRIBUTING

Please report any bugs or feature requests at L<https://github.com/mche/Mojolicious-Plugin-StaticShare/issues>. Pull requests also welcome.

=head1 COPYRIGHT

Copyright 2017 Mikhail Che.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
