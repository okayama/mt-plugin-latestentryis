package MT::Plugin::LatestEntryIs;
use strict;
use MT;
use MT::Plugin;
use base qw( MT::Plugin );

our $PLUGIN_NAME = 'LatestEntryIs';
our $PLUGIN_VERSION = '1.0';

my $plugin = new MT::Plugin::LatestEntryIs( {
    id => $PLUGIN_NAME,
    key => lc $PLUGIN_NAME,
    name => $PLUGIN_NAME,
    version => $PLUGIN_VERSION,
    description => "<MT_TRANS phrase='Utility for checking latest entry.'>",
    author_name => 'okayama',
    author_link => 'http://weeeblog.net/',
    l10n_class => 'MT::' . $PLUGIN_NAME . '::L10N',
	blog_config_template => lc $PLUGIN_NAME . '_config_blog.tmpl',
    settings => new MT::PluginSettings( [
        [ 'is_active', { Default => '', Scope => 'blog' } ],
    ] ),
} );
MT->add_plugin( $plugin );

sub init_registry {
    my $plugin = shift;
    $plugin->registry( {
        callbacks => {
            'MT::App::CMS::template_param.edit_entry' => 'MT::' . $PLUGIN_NAME . '::Callbacks::_cb_tp_edit_entry',
        },
        tags => {
            block => {
                LatestEntry => 'MT::' . $PLUGIN_NAME . '::Tags::_hdlr_latest_entry',
                LatestPage => 'MT::' . $PLUGIN_NAME . '::Tags::_hdlr_latest_entry',
            },
        },
    } );
}

1;
