{ lib, config, pkgs, ... }:
with lib;
let
    cfg = config.modules.firefox;

in {
    options.modules.firefox = { enable = mkEnableOption "firefox"; };

    config = mkIf cfg.enable {
        programs.firefox = {
            enable = true;

            # Install extensions from NUR
            profiles.ace.extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
                decentraleyes
                ublock-origin
                clearurls
                sponsorblock
                h264ify
                df-youtube
            ];

            # Privacy about:config settings
            profiles.ace = {
                settings = {
                    # Privacy and security
                    "browser.send_pings" = false;
                    "browser.urlbar.speculativeConnect.enabled" = false;
                    "dom.event.clipboardevents.enabled" = false;
                    "media.navigator.enabled" = false;
                    "network.cookie.cookieBehavior" = 1;
                    "network.http.referer.XOriginPolicy" = 2;
                    "network.http.referer.XOriginTrimmingPolicy" = 2;
                    "beacon.enabled" = false;
                    "browser.safebrowsing.downloads.remote.enabled" = false;
                    "network.IDN_show_punycode" = true;
                    "geo.enabled" = false;
                    "privacy.firstparty.isolate" = true;
                    "network.http.sendRefererHeader" = 0;

                    # Disable telemetry
                    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
                    "browser.ping-centre.telemetry" = false;
                    "browser.tabs.crashReporting.sendReport" = false;
                    "devtools.onboarding.telemetry.logged" = false;
                    "toolkit.telemetry.enabled" = false;
                    "toolkit.telemetry.unified" = false;
                    "toolkit.telemetry.server" = "";

                    # Disable Pocket and recommendations
                    "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
                    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
                    "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
                    "browser.newtabpage.activity-stream.showSponsored" = false;
                    "extensions.pocket.enabled" = false;

                    # Disable prefetching and features
                    "network.dns.disablePrefetch" = true;
                    "network.prefetch-next" = false;
                    "pdfjs.enableScripting" = false;
                    "identity.fxaccounts.enabled" = false;

                    # UI and behavior
                    "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
                    "app.shield.optoutstudies.enabled" = false;
                    "dom.security.https_only_mode_ever_enabled" = true;
                    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                    "browser.toolbars.bookmarks.visibility" = "never";
                    "browser.uidensity" = 1;
                    "media.autoplay.enabled" = false;
                    "toolkit.zoomManager.zoomValues" = ".8,.90,.95,1,1.1,1.2";

                    # Search and suggestions
                    "browser.search.suggest.enabled" = true;
                    "browser.urlbar.shortcuts.bookmarks" = false;
                    "browser.urlbar.shortcuts.history" = false;
                    "browser.urlbar.shortcuts.tabs" = false;
                    "browser.urlbar.suggest.bookmark" = false;
                    "browser.urlbar.suggest.engines" = false;
                    "browser.urlbar.suggest.history" = true;
                    "browser.urlbar.suggest.openpage" = true;
                    "browser.urlbar.suggest.topsites" = false;

                    # Security
                    "security.ssl.require_safe_negotiation" = true;
                };

                # userChome.css to make it look better
                userChrome = "
                    * { 
                        box-shadow: none !important;
                        border: 0px solid !important;
                    }

                    #tabbrowser-tabs {
                        --user-tab-rounding: 8px;
                    }

                    .tab-background {
                        border-radius: var(--user-tab-rounding) var(--user-tab-rounding) 0px 0px !important; /* Connected */
                        margin-block: 1px 0 !important; /* Connected */
                    }
                    #scrollbutton-up, #scrollbutton-down { /* 6/10/2021 */
                        border-top-width: 1px !important;
                        border-bottom-width: 0 !important;
                    }

                    .tab-background:is([selected], [multiselected]):-moz-lwtheme {
                        --lwt-tabs-border-color: rgba(0, 0, 0, 0.5) !important;
                        border-bottom-color: transparent !important;
                    }
                    [brighttext='true'] .tab-background:is([selected], [multiselected]):-moz-lwtheme {
                        --lwt-tabs-border-color: rgba(255, 255, 255, 0.5) !important;
                        border-bottom-color: transparent !important;
                    }

                    /* Container color bar visibility */
                    .tabbrowser-tab[usercontextid] > .tab-stack > .tab-background > .tab-context-line {
                        margin: 0px max(calc(var(--user-tab-rounding) - 3px), 0px) !important;
                    }

                    #TabsToolbar, #tabbrowser-tabs {
                        --tab-min-height: 29px !important;
                    }
                    #main-window[sizemode='true'] #toolbar-menubar[autohide='true'] + #TabsToolbar, 
                    #main-window[sizemode='true'] #toolbar-menubar[autohide='true'] + #TabsToolbar #tabbrowser-tabs {
                        --tab-min-height: 30px !important;
                    }
                    #scrollbutton-up,
                    #scrollbutton-down {
                        border-top-width: 0 !important;
                        border-bottom-width: 0 !important;
                    }

                    #TabsToolbar, #TabsToolbar > hbox, #TabsToolbar-customization-target, #tabbrowser-arrowscrollbox  {
                        max-height: calc(var(--tab-min-height) + 1px) !important;
                    }
                    #TabsToolbar-customization-target toolbarbutton > .toolbarbutton-icon, 
                    #TabsToolbar-customization-target .toolbarbutton-text, 
                    #TabsToolbar-customization-target .toolbarbutton-badge-stack,
                    #scrollbutton-up,#scrollbutton-down {
                        padding-top: 7px !important;
                        padding-bottom: 6px !important;
                    }
                ";
            };
        };
    };
}
