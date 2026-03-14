{ ... }:

let
  theme = import ./theme.nix;
in
{
  xdg.configFile."fsel/config.toml".text = ''
    highlight_color = "${theme.accent}"
    cursor = "▎"
    terminal_launcher = "foot -e"
    rounded_borders = false
    fancy_mode = false
    hard_stop = false

    main_border_color = "${theme.inactive}"
    apps_border_color = "${theme.inactive}"
    input_border_color = "${theme.accent}"
    main_text_color = "${theme.fg}"
    apps_text_color = "${theme.fg}"
    input_text_color = "${theme.fg}"
    pin_color = "${theme.accent}"
    header_title_color = "${theme.accent}"

    [app_launcher]
    match_mode = "fuzzy"
    ranking_mode = "frecency"

    [dmenu]
    items_border_color = "${theme.inactive}"
    items_text_color = "${theme.fg}"
  '';
}
