package MT::LatestEntryIs::Tags;
use strict;

my $plugin = MT->component( 'LatestEntryIs' );

sub _hdlr_latest_entry {
    my ( $ctx, $args, $cond ) = @_;
    my $app = MT->instance;
    my $blog_id = $args->{ blog_id } || $ctx->stash( 'blog_id' );
    my $tag = lc $ctx->stash( 'tag' );
    my $class = $tag =~ /entry$/ ? 'entry' : 'page';
    my $entry = MT->model( 'entry' )->load( { blog_id => $blog_id,
                                              class => $class,
                                            },
                                            { 'sort' => 'authored_on',
                                              direction => 'descend',
                                              limit => 1,
                                            }
                                          );
    my $res = '';
    if ( $entry ) {
        my $builder = $ctx->stash( 'builder' );
        local $ctx->{ __stash }->{ entry } = $entry;
        local $ctx->{ current_timestamp } = $entry->authored_on;
        return $builder->build( $ctx, $ctx->stash( 'tokens' ), $cond );
    } else {
        return $ctx->_hdlr_pass_tokens_else( @_ );
    }
}

1;
