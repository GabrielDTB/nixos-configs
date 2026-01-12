{...}: {
  services.kmonad = {
    enable = true;
    keyboards.integrated = {
      defcfg = {
        enable = true;
        fallthrough = true;
      };
      config = ''
        (defalias
          nav (tap-hold-next-release 200 t (layer-toggle nav))
          ect (tap-hold-next-release 200 esc lctl)
        )

        (defsrc
        esc                                                               del
        grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
        tab    q    w    e    r    t    y    u    i    o    p    [    ]     \
        caps     a    s    d    f    g    h    j    k    l    ;    '      ret
        lsft       z    x    c    v    b    n    m    ,    .    /        rsft
        lctl       lmet lalt           spc            ralt rctl left up right
                                                                     down
        )

        (deflayer colemak-dh-ortho
        esc                                                               del
        grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
        tab    q    w    f    p    b    j    l    u    y    ;    [    ]     \
        @ect     a    r    s    @nav g    m    n    e    i    o    '      ret
        lsft       z    x    c    d    v    k    h    ,    .    /        rsft
        lctl       lmet lalt           spc            ralt rctl left up right
                                                                     down
        )

        (deflayer nav
        _                                                                  _
        _    _    _    _    _    _    _    _    _    _    _    _    _      _
        _      _    _    _    _    _    _    ret  _    _    _    _    _    _
        _        _    _    _    _    _    bspc left down up  right _       _
        _          _    _    _    _    _    del  _    _    _    _          _
        _          _    _              _              _    _    _    _     _
                                                                     _
        )
      '';
    };
  };
}
