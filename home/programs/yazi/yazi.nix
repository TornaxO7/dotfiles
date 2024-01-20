{

  manager = {
    ratio = [ 1 4 3 ];
    sort_by = "alphabetical";
    sort_sensitive = true;
    sort_reverse = false;
    sort_dir_first = true;
    linemode = "size";
    show_hidden = false;
    show_symlink = true;
  };

  preview = {
    tab_size = 2;
    max_width = 600;
    max_height = 900;
    cache_dir = "";
    ueberzug_scale = 1;
    ueberzug_offset = [ 0 0 0 0 ];
  };

  opener = {
    pdf = [
      {
        exec = "evince $1";
        block = false;
        orphan = true;
      }
    ];

    edit = [
      {
        exec = "$EDITOR $@";
        block = true;
        for = "unix";
      }
    ];

    open = [
      {
        exec = "xdg-open $@";
        desc = "Open";
        for = "linux";
      }
    ];

    extract = [
      {
        exec = "ouch d $1";
        desc = "Extract here";
        for = "unix";
      }
    ];
  };

  open.rules = [
    {
      name = "*/";
      use = [ "edit" "open" "reveal" ];
    }

    { mime = "text/*"; use = [ "edit" "reveal" ]; }
    { mime = "image/*"; use = [ "open" "reveal" ]; }
    { mime = "video/*"; use = [ "play" "reveal" ]; }
    { mime = "audio/*"; use = [ "play" "reveal" ]; }
    { mime = "inode/x-empty"; use = [ "edit" "reveal" ]; }

    { mime = "application/json"; use = [ "edit" "reveal" ]; }
    { mime = "*/javascript"; use = [ "edit" "reveal" ]; }

    { mime = "application/zip"; use = [ "extract" "reveal" ]; }
    { mime = "application/gzip"; use = [ "extract" "reveal" ]; }
    { mime = "application/x-tar"; use = [ "extract" "reveal" ]; }
    { mime = "application/x-bzip"; use = [ "extract" "reveal" ]; }
    { mime = "application/x-bzip2"; use = [ "extract" "reveal" ]; }
    { mime = "application/x-7z-compressed"; use = [ "extract" "reveal" ]; }
    { mime = "application/x-rar"; use = [ "extract" "reveal" ]; }
    { mime = "application/xz"; use = [ "extract" "reveal" ]; }

    { mime = "application/pdf"; use = [ "pdf" ]; }

    {
      mime = "*";
      use = [ "open" "reveal" ];
    }
  ];

  tasks = {
    micro_workers = 10;
    macro_workers = 25;
    bizarre_retry = 5;
    image_alloc = 536870912; # 512MB
    image_bound = [ 0 0 ];
    suppress_preload = false;
  };

  plugin.preloaders = [
    {
      name = "*";
      cond = "!mime";
      exec = "mime";
      multi = true;
      prio = "high";
    }
    # Image
    {
      mime = "image/vnd.djvu";
      exec = "noop";
    }
    {
      mime = "image/*";
      exec = "image";
    }
    # Video
    {
      mime = "video/*";
      exec = "video";
    }
    # PDF
    {
      mime = "application/pdf";
      exec = "pdf";
    }
  ];

  previewers = [
    {
      name = "*/";
      exec = "folder";
      sync = true;
    }
    # Code
    {
      mime = "text/*";
      exec = "code";
    }
    { mime = "*/xml"; exec = "code"; }
    { mime = "*/javascript"; exec = "code"; }
    { mime = "*/x-wine-extension-ini"; exec = "code"; }
    # JSON
    {
      mime = "application/json";
      exec = "json";
    }
    # Image
    { mime = "image/vnd.djvu"; exec = "noop"; }
    { mime = "image/*"; exec = "image"; }
    # Video
    { mime = "video/*"; exec = "video"; }
    # PDF
    { mime = "application/pdf"; exec = "pdf"; }
    # Archive
    {
      mime = "application/zip";
      exec = "ouch l";
    }
    { mime = "application/gzip"; exec = "ouch l"; }
    { mime = "application/x-tar"; exec = "ouch l"; }
    { mime = "application/x-bzip"; exec = "ouch l"; }
    { mime = "application/x-bzip2"; exec = "ouch l"; }
    { mime = "application/x-7z-compressed"; exec = "ouch l"; }
    { mime = "application/x-rar"; exec = "ouch l"; }
    { mime = "application/xz"; exec = "ouch l"; }
    # Fallback
    {
      name = "*";
      exec = "file";
    }
  ];

  input = {

    # cd
    cd_title = "Change directory:";
    cd_origin = "center";
    # cd_offset = [ 0 2 50 3 ];

    # create
    create_title = "Create:";
    create_origin = "center";
    # create_offset = [ 0 2 50 3 ];

    # rename
    rename_title = "Rename:";
    rename_origin = "center";
    # rename_offset = [ 0 1 50 3 ];

    # trash
    trash_title = "Move {n} selected file{s} to trash? (y/N)";
    trash_origin = "center";
    # trash_offset = [ 0 2 50 3 ];

    # delete
    delete_title = "Delete {n} selected file{s} permanently? (y/N)";
    delete_origin = "center";
    # delete_offset = [ 0 2 50 3 ];

    # filter
    filter_title = "Filter:";
    filter_origin = "center";
    # filter_offset = [ 0 2 50 3 ];

    # find
    find_title = [ "Find next:" "Find previous:" ];
    find_origin = "center";
    # find_offset = [ 0 2 50 3 ];

    # search
    search_title = "Search:";
    search_origin = "center";
    # search_offset = [ 0 2 50 3 ];

    # shell
    shell_title = [ "Shell:" "Shell (block):" ];
    shell_origin = "center";
    # shell_offset = [ 0 2 50 3 ];

    # overwrite
    overwrite_title = "Overwrite an existing file? (y/N)";
    overwrite_origin = "center";
    # overwrite_offset = [ 0 2 50 3 ];

    # quit
    quit_title = "{n} task{s} running  sure to quit? (y/N)";
    quit_origin = "center";
    # quit_offset = [ 0 2 50 3 ];
  };


  select = {
    open_title = "Open with:";
    open_origin = "hovered";
    open_offset = [ 0 1 50 7 ];
  };

  log.enabled = false;
}
