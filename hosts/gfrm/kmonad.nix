{...}: {
  services.kmonad = {
    enable = true;
    keyboards.integrated = {
      device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
      defcfg = {
        enable = true;
        fallthrough = true;
      };
      config = ''
        (defsrc
        esc
        grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
        tab    q    w    e    r    t    y    u    i    o    p    [    ]     \
        caps     a    s    d    f    g    h    j    k    l    ;    '      ret
        lsft       z    x    c    v    b    n    m    ,    .    /        rsft
        lctl       lmet lalt           spc            ralt rctl
        )

        (deflayer colemak-dh-ortho
        XX
        grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
        tab    q    w    f    p    b    j    l    u    y    ;    [    ]     \
        esc      a    r    s    t    g    m    n    e    i    o    '      ret
        lsft       z    x    c    d    v    k    h    ,    .    /        rsft
        lctl       lmet lalt           spc            ralt rctl
        )
      '';
    };
  };
}
