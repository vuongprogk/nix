{ inputs, system, ... }:

let
  bamboo = inputs.ibus-bamboo.packages."${system}".default;
in
{
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = [
      bamboo
    ];
  };
}
