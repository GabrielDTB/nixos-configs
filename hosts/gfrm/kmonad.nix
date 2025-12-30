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
        (defalias
          a_a (tap-hold-next-release 200 a lalt)
          c_r (tap-hold-next-release 200 r lctl)
          s_s (tap-hold-next-release 200 s lsft)
          m_g (tap-hold-next-release 200 g lmet)
          m_m (tap-hold-next-release 200 m lmet)
          s_e (tap-hold-next-release 200 e lsft)
          c_i (tap-hold-next-release 200 i lctl)
          a_o (tap-hold-next-release 200 o lalt)
          nav (tap-hold-next-release 200 t (layer-toggle nav))
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
        XX                                                                 XX
        grv  1    2    3    4    5    6    7    8    9    0    -    =      XX
        tab    q    w    f    p    b    j    l    u    y    ;    [    ]     \
        esc      @a_a @c_r @s_s @nav @m_g @m_m n    @s_e @c_i @a_o '       XX
        XX         z    x    c    d    v    k    h    ,    .    /          XX
        XX         XX   XX             spc            XX   XX   XX   XX    XX
                                                                     XX
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
