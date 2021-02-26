;;; ericnorman.el --- Eric norman configuration -*- lexical-binding: t; -*-

(setq ericnorman/color-names '("bg" "bg-alt"
                               "white" "brightblack0"
                               "brightblack1" "brightblack2"
                               "brightblack3" "brightblack4"
                               "brightblack5" "brightblack6"
                               "black" "fg"
                               "fg-alt" "fg-hc"
                               "red" "orange"
                               "green" "teal"
                               "yellow" "blue"
                               "dark-blue" "magenta"
                               "violet" "cyan"
                               "dark-cyan"))

(setq ericnorman/color-theme-dark
      #s(hash-table
         size 25
         test equal
         data ("bg"           "282c34"
               "bg-alt"       "21242b"
               "white"        "1B2229"
               "brightblack0" "1c1f24"
               "brightblack1" "202328"
               "brightblack2" "23272e"
               "brightblack3" "3f444a"
               "brightblack4" "5B6268"
               "brightblack5" "73797e"
               "brightblack6" "9ca0a4"
               "black"        "DFDFDF"
               "fg"           "bbc2cf"
               "fg-alt"       "5B6268"
               "fg-hc"        "f0f0f0"
               "red"          "ff6c6b"
               "orange"       "da8548"
               "green"        "98be65"
               "teal"         "4db5bd"
               "yellow"       "ECBE7B"
               "blue"         "51afef"
               "dark-blue"    "2257A0"
               "magenta"      "c678dd"
               "violet"       "a9a1e1"
               "cyan"         "46D9FF"
               "dark-cyan"    "5699AF")))

(setq ericnorman/color-theme-light
      #s(hash-table
         size 25
         test equal
         data ("bg"           "fafafa"
               "bg-alt"       "f0f0f0"
               "white"        "f0f0f0"
               "brightblack0" "e7e7e7"
               "brightblack1" "dfdfdf"
               "brightblack2" "c6c7c7"
               "brightblack3" "9ca0a4"
               "brightblack4" "383a42"
               "brightblack5" "202328"
               "brightblack6" "1c1f24"
               "black"        "1b2229"
               "fg"           "383a42"
               "fg-alt"       "c6c7c7"
               "fg-hc"        "0f0f0f"
               "red"          "e45649"
               "orange"       "da8548"
               "green"        "50a14f"
               "teal"         "4db5bd"
               "yellow"       "986801"
               "blue"         "4078f2"
               "dark-blue"    "a0bcf8"
               "magenta"      "a626a4"
               "violet"       "b751b6"
               "cyan"         "0184bc"
               "dark-cyan"    "005478")))

(setq ericnorman/color-themes
      #s(hash-table
         size 2
         test equal
         data ("dark"  ericnorman/color-theme-dark
               "light" ericnorman/color-theme-light)))

(defun ericnorman/get-color (theme color)
  (gethash color (symbol-value (gethash theme ericnorman/color-themes))))

(provide 'ericnorman)
;;; ericnorman.el ends here
