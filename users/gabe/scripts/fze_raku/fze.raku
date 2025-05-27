#!/usr/bin/env raku

sub MAIN($dir = '.') {
    my $editor = %*ENV<EDITOR>;
    
    # Configure fzf options
    my $fzf_height    = '40%';
    my $fzf_layout    = '--reverse --border';
    my $preview_style = '--color=always --style=numbers --line-range :500';
    
    # Build the pipeline
    my $grep = run(
        'rga', '--files', '--hidden', '--glob', '!.git/*', $dir,
        :out,
    );
    
    my $find = run(
        'fzf', 
        '--height', $fzf_height,
        |$fzf_layout.words,
        '--preview', "bat $preview_style {}",
        :in($grep.out :close),
        :out
    );
    
    # Get selected file and clean up
    my $file = $find.out.slurp:close.trim;
    
    # Open selected file if any
    if $file.IO.e {
        run $editor, $file;
    }
    else {
        note "No file selected";
        exit 1;
    }
}
