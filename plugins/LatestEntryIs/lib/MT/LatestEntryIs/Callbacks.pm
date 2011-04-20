package MT::LatestEntryIs::Callbacks;
use strict;

my $plugin = MT->component( 'LatestEntryIs' );

sub _cb_tp_edit_entry {
    my ( $cb, $app, $param, $tmpl ) = @_;
    if ( my $blog = $app->blog ) {
        my $blog_id = $blog->id;
        my $scope = 'blog:' . $blog_id;
        return unless $plugin->get_config_value( 'is_active', $scope );
        if ( my $pointer_field = $tmpl->getElementById( 'authored_on' ) ) {
            my $nodeset = $tmpl->createElement( 'app:setting', { id => 'latestentryis',
                                                                 label => $plugin->translate( 'Latest entry is' ),
                                                                 label_class => 'no-header',
                                                                 required => 0,
                                                               }
                                              );
            my $innerHTML = <<'MTML';
<__trans_section component="LatestEntryIs">
<__trans phrase="Latest entry is">:<br /><mt:latestentry blog_id="$blog_id"><a href="<mt:var name="script_uri">?__mode=view&amp;_type=<mt:entryclass>&amp;id=<mt:entryid>&amp;blog_id=<mt:blogid>" target="_blank"><mt:entrytitle>(<mt:entrydate format="%Y-%m-%d">)</a><mt:else><__trans phrase="No entry."></mt:latestentry>
</__trans_section>
MTML
            $nodeset->innerHTML( $innerHTML );
            $tmpl->insertAfter( $nodeset, $pointer_field );
        }
    }
}

1;
