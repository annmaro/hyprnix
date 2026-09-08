{ config, pkgs, ... }:

{
  home-manager.sharedModules = [
    (_: {
      home.packages = [ pkgs.rmpc ];

      xdg.configFile."rmpc/config.ron".text = ''
        #![enable(implicit_some)]
        (
          address: "127.0.0.1:6600",
          theme: Some("catppuccin"),
          tabs: [
            (
                name: "Queue",
                pane: Split(
                    direction: Horizontal,
                    panes: [(size: "60%", pane: Pane(Queue)), (size: "40%", pane: Pane(AlbumArt))],
                ),
            ),
            (
                name: "Directories",
                pane: Pane(Directories),
            ),
            (
                name: "Artists",
                pane: Pane(Artists),
            ),
            (
                name: "Album Artists",
                pane: Pane(AlbumArtists),
            ),
            (
                name: "Albums",
                pane: Pane(Albums),
            ),
            (
                name: "Playlists",
                pane: Pane(Playlists),
            ),
            (
                name: "Search",
                pane: Pane(Search),
            ),
          ]
        )
      '';

      xdg.configFile."rmpc/themes/catppuccin.ron".text = ''
        #![enable(implicit_some)]
        #![enable(unwrap_newtypes)]
        #![enable(unwrap_variant_newtypes)]
        (
            default_album_art_path: None,
            draw_borders: false,
            show_song_table_header: false,
            symbols: (song: "🎵", dir: "📁", playlist: "🎼", marker: "\u{e0b0}"),
            layout: Split(
                direction: Vertical,
                panes: [
                    (
                        pane: Pane(Header),
                        size: "1",
                    ),
                    (
                        pane: Pane(TabContent),
                        size: "100%",
                    ),
                    (
                        pane: Pane(ProgressBar),
                        size: "1",
                    ),
                ],
            ),
            progress_bar: (
                symbols: ["", "", "⭘", " ", " "],
                track_style: (bg: "#1e2030"),
                elapsed_style: (fg: "#c6a0f6", bg: "#1e2030"),
                thumb_style: (fg: "#c6a0f6", bg: "#1e2030"),
            ),
            scrollbar: (
                symbols: ["│", "█", "▲", "▼"],
                track_style: (),
                ends_style: (),
                thumb_style: (fg: "#b7bdf8"),
            ),
            browser_column_widths: [20, 38, 42],
            text_color: "#cad3f5",
            background_color: "#24273a",
            header_background_color: "#1e2030",
            modal_background_color: None,
            modal_backdrop: false,
            tab_bar: (active_style: (fg: "black", bg: "#c6a0f6", modifiers: "Bold"), inactive_style: ()),
            borders_style: (fg: "#6e738d"),
            highlighted_item_style: (fg: "#c6a0f6", modifiers: "Bold"),
            current_item_style: (fg: "black", bg: "#b7bdf8", modifiers: "Bold"),
            highlight_border_style: (fg: "#b7bdf8"),
            song_table_format: [
                (
                    prop: (kind: Property(Artist), style: (fg: "#b7bdf8"), default: (kind: Text("Unknown"))),
                    width: "50%",
                    alignment: Right,
                ),
                (
                    prop: (kind: Text("-"), style: (fg: "#b7bdf8"), default: (kind: Text("Unknown"))),
                    width: "1",
                    alignment: Center,
                ),
                (
                    prop: (kind: Property(Title), style: (fg: "#7dc4e4"), default: (kind: Text("Unknown"))),
                    width: "50%",
                ),
            ],
            header: (
                rows: [
                    (
                        left: [
                            (kind: Text("["), style: (fg: "#b7bdf8", modifiers: "Bold")),
                            (kind: Property(Status(State)), style: (fg: "#b7bdf8", modifiers: "Bold")),
                            (kind: Text("]"), style: (fg: "#b7bdf8", modifiers: "Bold"))
                        ],
                        center: [
                            (kind: Property(Song(Artist)), style: (fg: "#eed49f", modifiers: "Bold"), default: (kind: Text("Unknown"), style: (fg: "#eed49f", modifiers: "Bold"))),
                            (kind: Text(" - ")),
                            (kind: Property(Song(Title)), style: (fg: "#7dc4e4", modifiers: "Bold"), default: (kind: Text("No Song"), style: (fg: "#7dc4e4", modifiers: "Bold")))
                        ],
                        right: [
                            (kind: Text("Vol: "), style: (fg: "#b7bdf8", modifiers: "Bold")),
                            (kind: Property(Status(Volume)), style: (fg: "#b7bdf8", modifiers: "Bold")),
                            (kind: Text("% "), style: (fg: "#b7bdf8", modifiers: "Bold"))
                        ]
                    )
                ],
            ),
        )
      '';
    })
  ];
}
