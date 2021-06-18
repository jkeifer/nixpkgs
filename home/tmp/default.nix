{ ... }: {
  home.file.tmp = {
    source = ./skel;
    recursive = true;
  };
  targets.darwin.defaults."com.apple.screencapture".location = "~/tmp/screenshots";
}
